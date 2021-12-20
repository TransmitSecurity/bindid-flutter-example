package com.ts.bindid.bindid_flutter_plugin.util

import android.content.Context
import android.util.Log
import com.transmitsecurity.bindid_flutter.R
import org.json.JSONObject
import java.text.DateFormat
import java.text.SimpleDateFormat
import java.util.*
import com.ts.bindid.util.cast

/**
 * Created by Ran Stone on 23/06/2021.
 */

data class TokenItem(val name: String, val value: String) {
}

class TokenData(token: String) {

    companion object {
        private val TAG = TokenData::javaClass.name
    }

    private val json: JSONObject = JSONObject(token)

    var userID: String? = null
    var userAlias: String? = null
    var phoneNumber: String? = null
    var emailAddress: String? = null
    var userRegisteredOn: String? = null
    var userFirstSeen: String? = null
    var userFirstConfirmed: String? = null
    var userLastSeen: String? = null
    var userLastSeenByNetwork: String? = null
    var totalProvidersThatConfirmedUser: String? = null
    var authenticatingDeviceRegistered: String? = null
    var authenticatingDeviceFirstSeen: String? = null
    var authenticatingDeviceConfirmed: String? = null
    var authenticatingDeviceLastSeen: String? = null
    var authenticatingDeviceLastSeenByNetwork: String? = null
    var totalKnownDevices: String? = null

    init {
        val format = SimpleDateFormat("MMM d, yyyy HH:mm a")

        userID = json.opt("sub")?.toString()
        userAlias = json.opt("bindid_alias")?.toString() ?: "Not Set"
        phoneNumber = json.opt("phone_number")?.toString()
        emailAddress = json.opt("email")?.toString() ?: "Not Set"
        authenticatingDeviceConfirmed = json.opt("acr.ts.bindid.app_bound_cred")?.toString() ?: "No"

        // Network Info
        json.optJSONObject("bindid_network_info")?.let { json ->
            userRegisteredOn = json.optString("user_registration_time")
            userLastSeenByNetwork = json.optString("user_last_seen")
            totalKnownDevices = json.opt("device_count")?.toString() ?: "0"
            authenticatingDeviceLastSeenByNetwork =
                when(json.optString("authenticating_device_last_seen")){
                    "null" -> null
                    else -> json.optString("authenticating_device_last_seen")
                }
            totalProvidersThatConfirmedUser = json.opt("confirmed_capp_count")?.toString() ?: "0"
            authenticatingDeviceRegistered =
                json.optString("authenticating_device_registration_time")
        }

        // BindID Info
        json.optJSONObject("bindid_info")?.let { json ->
            userFirstSeen = json.opt("capp_first_login")?.toDateString(format)
            userFirstConfirmed = json.opt("capp_first_confirmed_login")?.toDateString(format)
            userLastSeen = json.opt("capp_last_login")?.toDateString(format)
            authenticatingDeviceFirstSeen =
                json.opt("capp_first_login_from_authenticating_device")?.toDateString(format)
            authenticatingDeviceLastSeen =
                json.opt("capp_last_login_from_authenticating_device")?.toDateString(format)
        }
    }


    fun getTokens(context: Context): List<TokenItem> {
        R.string.xm_bindid_biometric_title
        val list = mutableListOf<TokenItem>()
        userID?.let { list.add(TokenItem("User ID", it)) }
        list.add(TokenItem("User Alias", userAlias ?: "Not Set"))
        phoneNumber?.let { list.add(TokenItem("Phone Number", it)) }
        emailAddress?.let { list.add(TokenItem("Email Address", it)) }
        userRegisteredOn?.let { list.add(TokenItem("User Registered on", it)) }
        userFirstSeen?.let { list.add(TokenItem("User First Seen", it)) }
        userFirstConfirmed?.let { list.add(TokenItem("User First Confirmed", it)) }
        userLastSeen?.let { list.add(TokenItem("User Last Seen", it)) }
        userLastSeenByNetwork?.let { list.add(TokenItem("User Last Seen by Network", it)) }
        list.add(TokenItem("Total Providers that Confirmed User", totalProvidersThatConfirmedUser ?: "0"))
        authenticatingDeviceRegistered?.let { list.add(TokenItem("Authenticating Device Registered", it)) }
        authenticatingDeviceFirstSeen?.let { list.add(TokenItem("Authenticating Device First Seen", it)) }
        list.add(TokenItem("Authenticating Device Confirmed", authenticatingDeviceConfirmed ?: "No"))
        authenticatingDeviceLastSeen?.let { list.add(TokenItem("Authenticating Device Last Seen", it)) }
        authenticatingDeviceLastSeenByNetwork?.let { list.add(TokenItem("Authenticating Device Last Seen by Network", it)) }
        list.add(TokenItem("Total Known Devices", totalKnownDevices ?: "0"))
        return list
    }

    fun Long.toDate(): Date {
        return Date(this * 1000L)
    }

    fun Number.toDateString(format: DateFormat = SimpleDateFormat("MMM d, yyyy HH:mm a")): String {
        return format.format(this.toLong().toDate())
    }

    fun Any.toDateString(format: DateFormat = SimpleDateFormat("MMM d, yyyy HH:mm a")): String? {
        return this.cast<Number>()?.let { it.toDateString(format) }
    }
}
