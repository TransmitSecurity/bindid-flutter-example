package com.transmitsecurity.bindid_flutter

import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull
import com.nimbusds.jose.crypto.RSASSAVerifier
import com.nimbusds.jose.jwk.RSAKey
import com.nimbusds.jwt.SignedJWT
import com.ts.bindid.*
import com.ts.bindid.bindid_flutter_plugin.util.TokenData
import com.ts.bindid.util.ObservableFuture
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import okhttp3.*
import okio.IOException
import org.json.JSONException
import org.json.JSONObject

class MainActivity: FlutterActivity() {

    private val CHANNEL = "bindid_flutter_bridge"

    private lateinit var host: String

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            // Note: this method is invoked on the main thread.
            when (call.method) {
                "initBindId" -> initBindID(call, result)
                "authenticate" -> authenticate(call, result)
                else -> result.notImplemented()
            }
        }
    }

    /**
     * Configure the BindID SDK with your client ID, and to work with the BindID sandbox environment
     */
    private fun initBindID(@NonNull call: MethodCall, @NonNull flutterResult: MethodChannel.Result){
        host =  call.argument<String>("bindid_host")
            ?: return flutterResult.error("MISSING_PARAM", "Missing bindid_host", JSONObject())
        val clientID =  call.argument<String>("bindid_client_id")
            ?: return flutterResult.error("MISSING_PARAM", "Missing bindid_client_id", JSONObject())

        XmBindIdSdk.getInstance().initialize(
            XmBindIdConfig.create(
            context,
            XmBindIdServerEnvironment.createWithUrl(host),
            clientID
        )).addListener(object : ObservableFuture.Listener<Boolean, XmBindIdError> {
            override fun onComplete(result: Boolean) {
                flutterResult.success("bindid_init_done")
            }

            override fun onReject(error: XmBindIdError) {
                flutterResult.error(error.code.toString(), "SDK initialize error", "")
            }
        })
    }

    /**
     * Authenticate the user
     */
    private fun authenticate(@NonNull call: MethodCall, @NonNull flutterResult: MethodChannel.Result) {
        val redirectURI =  call.argument<String>("bindid_redirect_uri")
            ?: return flutterResult.error("MISSING_PARAM", "Missing bindid_redirect_uri", JSONObject())

        XmBindIdSdk.getInstance().authenticate(
            XmBindIdAuthenticationRequest.create(redirectURI).apply {
                this.usePkce = true
                this.scope = listOf(XmBindIdScopeType.OpenId, XmBindIdScopeType.Email, XmBindIdScopeType.NetworkInfo)
            })
            .addListener(object : ObservableFuture.Listener<XmBindIdResponse?, XmBindIdError?> {
                override fun onComplete(xmBindIdResponse: XmBindIdResponse) {
                    // Do when using PKCE
                    exchange(xmBindIdResponse, flutterResult)
                }

                override fun onReject(error: XmBindIdError) {
                    flutterResult.error(error.code.toString(), "SDK authenticate error", error.message)
                }
            })
    }

    /**
     * Exchange the authentication response for the ID and access token using a PKCE token exchange
     */
    private fun exchange(response: XmBindIdResponse, @NonNull flutterResult: MethodChannel.Result) {
        XmBindIdSdk.getInstance().exchangeToken(
            XmBindIdExchangeTokenRequest.create(response)
        ).addListener(object : ObservableFuture.Listener<XmBindIdExchangeTokenResponse, XmBindIdError?> {
            override fun onComplete(tokenResponse: XmBindIdExchangeTokenResponse) {
                // Validate the tokenResponse
                // 1. get publicKey from BindID server
                // 2. validate JWT
                fetchBindIDPublicKey(object : IFetchBindIDPublicKeyListener {
                    override fun onResponse(publicKey: String?) {
                        try {
                            val isValid = SignedJWT.parse(tokenResponse.idToken)
                                .verify(RSASSAVerifier(RSAKey.parse(publicKey)))

                            if(isValid){
                                // When connected to your company's backend, send the ID and
                                // access tokens to be processed
                                sendTokenToServer(tokenResponse.accessToken, tokenResponse.idToken)

                                // Get the JWT token to display it in a user friendly format
                                val signedJWT = SignedJWT.parse(tokenResponse.idToken)
                                val jsonData: String = signedJWT.payload.toString()
                                val tokenData = TokenData(jsonData)
                                val tokenItemsList = tokenData.getTokens(context)

                                // Set the JWT token data for Flutter response
                                val tokenItems = HashMap<String, Any>()
                                for (item in tokenItemsList){
                                    tokenItems[item.name] = item.value
                                }

                                Handler(Looper.getMainLooper()).post {
                                    flutterResult.success(tokenItems)
                                }


                            } else {
                                flutterResult.error(XmBindIdErrorCode.InvalidResponse.name, "Invalid JWT signature", "")
                            }
                        } catch (e: Exception){
                            flutterResult.error(XmBindIdErrorCode.InvalidResponse.name, "Invalid JWT exception", "")
                        }
                    }

                    override fun onFailure(error: String?) {
                        flutterResult.error(XmBindIdErrorCode.InvalidResponse.name, error ?: "Invalid JWT signature", "")
                    }

                })
            }

            override fun onReject(error: XmBindIdError) {
                flutterResult.error(error.code.toString(), error.message, "")
            }
        })

    }

    // sendTokenToServer should send the ID and access tokens received upon successful authentication
    // to your backend server, where it will be processed
    fun sendTokenToServer(one: String?, two: String?) {
        // Add code to send the ID and access token to your application server here
    }

    private interface IFetchBindIDPublicKeyListener {
        fun onResponse(publicKey: String?)
        fun onFailure(error: String?)
    }

    /**
     * Fetch the public key from the BindID jwks endpoint
     * @param listener
     */
    private fun fetchBindIDPublicKey(listener: IFetchBindIDPublicKeyListener) {
        val client = OkHttpClient()
        val url = "$host/jwks"
        val request: Request = Request.Builder()
            .url(url)
            .build()
        client.newCall(request).enqueue(object : Callback {
            @Throws(IOException::class)
            override fun onResponse(call: Call, response: Response) {
                // Serialize the response and convert it to an array of key objects
                val responseData = response.body!!.string()
                var json: JSONObject? = null
                try {
                    json = JSONObject(responseData)
                    val keys = if (json.has("keys")) json.getJSONArray("keys") else null

                    // Find the key that contains the "sig" value in the "use" key. Return the publicKey in it
                    for (i in 0 until keys!!.length()) {
                        val key = keys.getJSONObject(i)
                        if (key["use"] == "sig") {
                            listener.onResponse(key.toString())
                            return
                        }
                    }
                    listener.onFailure("No signature key in publicKey")

                } catch (e: JSONException) {
                    listener.onFailure(e.message)
                }
            }

            override fun onFailure(call: Call, e: IOException) {
                listener.onFailure(e.message)
            }
        })
    }

}
