/**
 * Keeps track of a logged in user. Contains configuration options for the
 * {@link DropboxAPI}.
 */
public interface Session {

    /**
     * Returns the app key and secret.
     */
    AppKeyPair getAppKeyPair();

    /**
     * Returns the currently logged in user's access token and secret.
     */
    AccessTokenPair getAccessTokenPair();

    /**
     * Returns what Dropbox access type to use (currently app folder or entire
     * Dropbox).
     */
    AccessType getAccessType();

    /**
     * Returns the locale to use. Must not return null. Currently, this is used
     * for user-facing messages that are returned by the API. You should not
     * cache this value, but instead get it every time from the system in case
     * the locale changes.
     */
    //Locale getLocale();

    /**
     * Returns whether or not this session has a user's access token and
     * secret.
     */
    boolean isLinked();

    /**
     * Unlinks the session by removing any stored access token and secret.
     */
    void unlink();

    /**
     * OAuth signs the request with the currently-set tokens and secrets.
     *
     * @param request an {@link HttpRequest}.
     */
    void sign(HttpRequest request);

    /**
     * Will be called every time a request is made to Dropbox, in case the
     * proxy changes between requests. Return null if you do not want to use
     * a proxy, or a {@link ProxyInfo} object with a host and optionally a
     * port set.
     */
    ProxyInfo getProxyInfo();

    /**
     * Will be called every time a request is made to Dropbox, in case you want
     * to use a new client every time. However, it's highly recommended to
     * create a client once and reuse it to take advantage of connection reuse.
     */
    Http getHttpClient();

    /**
     * Will be called every time right before a request is sent to Dropbox. It
     * should set the socket and connection timeouts on the request if you want
     * to override the default values. This is abstracted out to cope with
     * signature changes in the Apache HttpClient libraries.
     */
    void setRequestTimeout(HttpRequest request);

    /**
     * Returns the Dropbox API server. Changing this will break things.
     */
    String getAPIServer();

    /**
     * Returns the Dropbox content server. Changing this will break things.
     */
    String getContentServer();

    /**
     * Returns the Dropbox web server. Changing this will break things.
     */
    String getWebServer();

    

    
}