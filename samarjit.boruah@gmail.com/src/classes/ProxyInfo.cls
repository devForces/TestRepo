/**
     * Describes a proxy.
     */
    public class ProxyInfo {
        /** The address of the proxy. */
        public final String host;

        /** The port of the proxy, or -1 to use the default port. */
        public final Integer port;

        /**
         * Creates a proxy info.
         *
         * @param host the host to use without a protocol (required).
         * @param port the port to use, or -1 for default port.
         */
        public ProxyInfo(String host, Integer port) {
            this.host = host;
            this.port = port;
        }

        /**
         * Creates a proxy info using the default port.
         *
         * @param host the host to use without a protocol (required).
         */
        public ProxyInfo(String host) {
            this(host, -1);
        }
    }