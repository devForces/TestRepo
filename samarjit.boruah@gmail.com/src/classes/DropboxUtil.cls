public class DropboxUtil{

public static String buildURL(String host, Integer apiVersion,
            String target, String[] params) {
        if (!target.startsWith('/')) {
            target = '/' + target;
        }

        try {
            // We have to encode the whole line, then remove + and / encoding
            // to get a good OAuth URL.
            target = '/' + apiVersion + target;
            target = EncodingUtil.urlEncode(target, 'UTF-8');
            target = target.replace('%2F', '/');

            if (params != null && params.size() > 0) {
                target += '?' + urlencode(params);
            }

            // These substitutions must be made to keep OAuth happy.
            target = target.replace('+', '%20').replace('*', '%2A');
        } catch (Exception uce) {
            return null;
        }

        return 'https://' + host + ':443' + target;
    }
    
    /**
     * URL encodes an array of parameters into a query string.
     */
    private static String urlencode(String[] params) {
        if (Math.mod(params.size(), 2) != 0) {
            //throw new IllegalArgumentException("Params must have an even number of elements.");
            return null;
        }

        String result = '';
        try {
            boolean firstTime = true;
            for (Integer i = 0; i < params.size(); i += 2) {
                if (params[i + 1] != null) {
                    if (firstTime) {
                        firstTime = false;
                    } else {
                        result += '&';
                    }
                    result += EncodingUtil.urlEncode(params[i], 'UTF-8') + '='
                    + EncodingUtil.urlEncode(params[i + 1], 'UTF-8');
                }
            }
            result.replace('*', '%2A');
        } catch (Exception e) {
            return null;
        }
        return result;
    }

}