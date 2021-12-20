package com.ts.bindid.bindid_flutter_plugin.util;

import android.util.Base64;
import android.util.Log;

import java.util.Arrays;

public class JWT {

    private final static String TAG = JWT.class.getSimpleName();

    /**
     * Parse the ID token received from BindID to obtain information about the user
     *
     * @param authToken
     * @return
     */
    static public String parse(String authToken){
        try {
            String[] segments = authToken.split("\\.");
            if (segments.length < 2) {
                Log.e(TAG, "parse: segment is too short! token: " + authToken + ". segments: "+ Arrays.asList(segments).toString());
                return null;
            }
            String base64String = segments[1];
            int requiredLength = (int)(4 * Math.ceil(base64String.length() / 4.0));
            int nbrPaddings = requiredLength - base64String.length();

            if (nbrPaddings > 0) {
                base64String = base64String + "====".substring(0, nbrPaddings);
            }

            base64String = base64String.replace("-", "+");
            base64String = base64String.replace("_", "/");

            byte[] data = Base64.decode(base64String, Base64.DEFAULT);

            String text;
            text = new String(data, "UTF-8");
            return text;
        } catch (Exception e) {
            Log.e(TAG, "parse: failed at "+e.getMessage());
        }
        return null;
    }

}
