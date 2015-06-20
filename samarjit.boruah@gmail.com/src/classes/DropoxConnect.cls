public class DropoxConnect{

static String oauth_version='1.0';
static String oauth_signature_method='PLAINTEXT';
static String oauth_consumer_key='klviqj2h0mswmqf';
static String oauth_signature='wq8ctk0f8g3fwsh';
static String access_type='app_folder';
static String oauth_nonce;


static String oauth_token_secret;
static String oauth_token;

public static void requestToken(){
    DateTime current = System.now();
    String timeInMili = String.valueOf(current.getTime()/1000);
    oauth_nonce = String.valueOf(Crypto.getRandomLong());
    Http h = new http();
    HttpRequest req = new HttpRequest();
    req.setEndpoint('https://api.dropbox.com/1/oauth/request_token');
    req.setMethod('POST');
    req.setHeader('Authorization','OAuth oauth_version="'+oauth_version+'", oauth_signature_method="'+oauth_signature_method+'", oauth_consumer_key="'+EncodingUtil.urlEncode(oauth_consumer_key, 'UTF-8')+'", oauth_signature="'+EncodingUtil.urlEncode(oauth_signature, 'UTF-8')+'&", access_type="'+access_type+'", oauth_timestamp="'+timeInMili+'", oauth_nonce="'+oauth_nonce+'"');
    
    HttpResponse res = h.send(req);
    Map<String, String> responseMap = DropoxConnect.parseAsQueryString(res);
    oauth_token_secret = responseMap.get('oauth_token_secret');
    oauth_token = responseMap.get('oauth_token');
    
    system.debug(responseMap );
    system.debug(res.getBody());
    
    String[] args = new String[] {'oauth_token', oauth_token};
    
    String url = DropboxUtil.buildURL('www.dropbox.com',1, '/oauth/authorize', args);
    system.debug(url );
    Http h1 = new http();
    HttpRequest req1 = new HttpRequest();
    req1.setEndpoint(url);
    req1.setMethod('POST');
    req1.setHeader('Authorization','OAuth oauth_version="'+oauth_version+'", oauth_signature_method="'+oauth_signature_method+'", oauth_consumer_key="'+EncodingUtil.urlEncode(oauth_consumer_key, 'UTF-8')+'", oauth_signature="'+EncodingUtil.urlEncode(oauth_signature, 'UTF-8')+'&'+EncodingUtil.urlEncode(oauth_token_secret, 'UTF-8')+'", access_type="'+access_type+'", oauth_timestamp="'+timeInMili+'", oauth_nonce="'+oauth_nonce+'", oauth_token="'+oauth_token+'"');
    HttpResponse res1 = h1.send(req1);
    system.debug(res1.getBody());
    
    DropboxTokens__c dtoken = new DropboxTokens__c (Name='oauth_token_secret');
    dtoken.value__c = oauth_token_secret;
    DropboxTokens__c dtoken1 = new DropboxTokens__c (Name='oauth_token');
    dtoken1.value__c = oauth_token;
    List<DropboxTokens__c > dtokenList = new List<DropboxTokens__c>();
    dtokenList.add(dtoken);
    dtokenList.add(dtoken1);
    insert(dtokenList);
    
    
    
    
    /*current = System.now();
    timeInMili = String.valueOf(current.getTime()/1000);
    oauth_nonce = String.valueOf(Crypto.getRandomLong());
    url = DropboxUtil.buildURL('api.dropbox.com',1, '/oauth/access_token', args);
    Http h2 = new http();
    HttpRequest req2 = new HttpRequest();
    req2.setEndpoint(url);
    req2.setMethod('POST');
    String Authorization = 'OAuth oauth_version="1.0", oauth_signature_method="PLAINTEXT", oauth_consumer_key="'+EncodingUtil.urlEncode(oauth_consumer_key, 'UTF-8')+'", oauth_token="'+oauth_token+'", oauth_signature="'+EncodingUtil.urlEncode(oauth_signature+'&'+oauth_token_secret, 'UTF-8')+'", oauth_timestamp="'+timeInMili+'", oauth_nonce="'+oauth_nonce+'"';
    req2.setHeader('Authorization',Authorization);
    HttpResponse res2 = h2.send(req2);
    system.debug(res2.getBody());
    */
    
}


public static void accessToken(){
    DateTime  current = System.now();
    String timeInMili = String.valueOf(current.getTime()/1000);
    oauth_nonce = String.valueOf(Crypto.getRandomLong());
    oauth_token = DropboxTokens__c.getValues('oauth_token').Value__c;
    oauth_token_secret = DropboxTokens__c.getValues('oauth_token_secret').Value__c;
    String[] args = new String[] {'oauth_token', oauth_token};
    String url = DropboxUtil.buildURL('api.dropbox.com',1, '/oauth/access_token', args );
    Http h2 = new http();
    HttpRequest req2 = new HttpRequest();
    req2.setEndpoint(url);
    req2.setMethod('POST');
    
    String Authorization = 'OAuth oauth_version="1.0", oauth_signature_method="PLAINTEXT", oauth_consumer_key="'+EncodingUtil.urlEncode(oauth_consumer_key, 'UTF-8')+'", oauth_token="'+oauth_token+'", oauth_signature="'+EncodingUtil.urlEncode(oauth_signature+'&'+oauth_token_secret, 'UTF-8')+'", oauth_timestamp="'+timeInMili+'", oauth_nonce="'+oauth_nonce+'"';
    req2.setHeader('Authorization',Authorization);
    HttpResponse res2 = h2.send(req2);
    system.debug(res2.getBody());

}






public static Map<String, String> parseAsQueryString(HttpResponse response){

String responseBody = response.getBody();

List<String> responseBodyList = responseBody.split('&');
Map<String,String> result = new Map<String,String>();
for(String nameValue:responseBodyList){
    String[] parts = nameValue.split('=');
    result.put(parts[0],parts[1]);
}

return result;
}


    
}