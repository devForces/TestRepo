/**
 * <p>
 * Holds a user's access token and secret.
 * </p>
 */
public virtual class AccessTokenPair extends TokenPair {

    // Do not change.
    private static final long serialVersionUID = -5526503075188547139L;

    public AccessTokenPair(String key, String secret) {
        super(key, secret);
    }
}