/**
 * Keeps track of a logged in user and contains configuration options for the
 * {@link DropboxAPI}. This is a base class to use for creating your own
 * {@link Session}s.
 */
public abstract class AbstractSession implements Session {

    private static final String API_SERVER = 'api.dropbox.com';
    private static final String CONTENT_SERVER = 'api-content.dropbox.com';
    private static final String WEB_SERVER = 'www.dropbox.com';

    /** How long connections are kept alive. */
    private static final Integer KEEP_ALIVE_DURATION_SECS = 20;

    /** How often the monitoring thread checks for connections to close. */
    private static final Integer KEEP_ALIVE_MONITOR_INTERVAL_SECS = 5;

    /** The default timeout for client connections. */
    private static final Integer DEFAULT_TIMEOUT_MILLIS = 30000; // 30 seconds

    private final AccessType accessType;
    private final AppKeyPair appKeyPair;
    private AccessTokenPair accessTokenPair = null;

    private Http client = null;

    /**
     * Creates a new session with the given app key and secret, and access
     * type. The session will not be linked because it has no access token pair.
     */
    public AbstractSession(AppKeyPair appKeyPair, AccessType type) {
        this(appKeyPair, type, null);
    }

    /**
     * Creates a new session with the given app key and secret, and access
     * type. The session will be linked to the account corresponding to the
     * given access token pair.
     */
    public AbstractSession(AppKeyPair appKeyPair, AccessType type,
            AccessTokenPair accessTokenPair) {
        if (appKeyPair == null) throw new IllegalArgumentException('"appKeyPair" must be non-null');
        if (type == null) throw new IllegalArgumentException('"type" must be non-null');

        this.appKeyPair = appKeyPair;
        this.accessType = type;
        this.accessTokenPair = accessTokenPair;
    }

    /**
     * Links the session with the given access token and secret.
     */
    public void setAccessTokenPair(AccessTokenPair accessTokenPair) {
        if (accessTokenPair == null) throw new IllegalArgumentException('"accessTokenPair" must be non-null');
        this.accessTokenPair = accessTokenPair;
    }

    
    public AppKeyPair getAppKeyPair() {
        return appKeyPair;
    }

    
    public AccessTokenPair getAccessTokenPair() {
        return accessTokenPair;
    }

    
    public AccessType getAccessType() {
        return accessType;
    }

    /**
     * {@inheritDoc}
     * <br/><br/>
     * The default implementation always returns {@code Locale.ENLISH}, but you
     * are highly encouraged to localize your application and return the system
     * locale instead. Note: as of the time this was written, Dropbox supports
     * the de, en, es, fr, and ja locales - if you use a locale other than
     * these, messages will be returned in English. However, it is good
     * practice to pass along the correct locale as we will add more languages
     * in the future.
     */
    
    

    
    public boolean isLinked() {
        return accessTokenPair != null;
    }

    
    public void unlink() {
        accessTokenPair = null;
    }

    /**
     * Signs the request by using's OAuth's HTTP header authorization scheme
     * and the PLAINTEXT signature method.  As such, this should only be used
     * over secure connections (i.e. HTTPS).  Using this over regular HTTP
     * connections is completely insecure.
     *
     * @see Session#sign
     */
    
    public void sign(HttpRequest request) {
        request.setHeader('Authorization',
                buildOAuthHeader(this.appKeyPair, this.accessTokenPair));
    }

    private static String buildOAuthHeader(AppKeyPair appKeyPair,
            AccessTokenPair signingTokenPair) {
        String buf = '';
        buf=+'OAuth oauth_version="1.0"';
        buf=+', oauth_signature_method="PLAINTEXT"';
        buf=+', oauth_consumer_key="'+encode(appKeyPair.key)+'"';

        /*
         * TODO: This is hacky.  The 'signingTokenPair' is null only in auth
         * step 1, when we acquire a request token.  We really should have two
         * different buildOAuthHeader functions for the two different
         * situations.
         */
        String sig;
        if (signingTokenPair != null) {
            buf=+', oauth_token="'+encode(signingTokenPair.key)+'"';
            sig = encode(appKeyPair.secret) + '&'
                    + encode(signingTokenPair.secret);
        } else {
            sig = encode(appKeyPair.secret) + '&';
        }
        buf=+', oauth_signature="'+sig+'"';

        // Note: Don't need nonce or timestamp since we do everything over SSL.
        return buf;
    }

    private static String encode(String s) {
        try {
            return EncodingUtil.urlEncode(s, 'UTF-8');
        } catch (Exception ex) {
            //AssertionError ae = new AssertionError('UTF-8 isn\'t available');
            //ae.initCause(ex);
            throw ex;
        }
    }

    /**
     * {@inheritDoc}
     * <br/><br/>
     * The default implementation always returns null.
     */
    
    public ProxyInfo getProxyInfo() {
        return null;
    }

    /**
     * {@inheritDoc}
     * <br/><br/>
     * The default implementation does all of this and more, including using
     * a connection pool and killing connections after a timeout to use less
     * battery power on mobile devices. It's unlikely that you'll want to
     * change this behavior.
     */
    
    public Http getHttpClient() {
        if (client == null) {
            

            client = new Http();
        }

        return client;
    }

    /**
     * {@inheritDoc}
     * <br/><br/>
     * The default implementation always sets a 30 second timeout.
     */
    
    public void setRequestTimeout(HttpRequest request) {
        request.setTimeout(DEFAULT_TIMEOUT_MILLIS);
        
    }

    
    public String getAPIServer() {
        return API_SERVER;
    }

    
    public String getContentServer() {
        return CONTENT_SERVER;
    }

    
    public String getWebServer() {
        return WEB_SERVER;
    }

    

    
}