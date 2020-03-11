
--
-- TOC entry 15 (class 2615 OID 62485)
-- Name: finauth; Type: SCHEMA; Schema: -; Owner: finauth
--

CREATE SCHEMA finauth;


ALTER SCHEMA finauth OWNER TO finauth;

SET search_path = finauth, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 225 (class 1259 OID 62703)
-- Name: oauth_access_token; Type: TABLE; Schema: finauth; Owner: finauth
--

CREATE TABLE oauth_access_token (
    token_id character varying(255),
    token bytea,
    authentication_id character varying(255) NOT NULL,
    user_name character varying(255),
    client_id character varying(255),
    authentication bytea,
    refresh_token character varying(255)
);


ALTER TABLE oauth_access_token OWNER TO finauth;

--
-- TOC entry 226 (class 1259 OID 62709)
-- Name: oauth_approvals; Type: TABLE; Schema: finauth; Owner: finauth
--

CREATE TABLE oauth_approvals (
    "userId" character varying(255),
    "clientId" character varying(255),
    scope character varying(255),
    status character varying(10),
    "expiresAt" timestamp without time zone,
    "lastModifiedAt" timestamp without time zone
);


ALTER TABLE oauth_approvals OWNER TO finauth;

--
-- TOC entry 227 (class 1259 OID 62715)
-- Name: oauth_client_details; Type: TABLE; Schema: finauth; Owner: finauth
--

CREATE TABLE oauth_client_details (
    client_id character varying(255) NOT NULL,
    resource_ids character varying(255),
    client_secret character varying(255),
    scope character varying(255),
    authorized_grant_types character varying(255),
    web_server_redirect_uri character varying(255),
    authorities character varying(255),
    access_token_validity integer,
    refresh_token_validity integer,
    additional_information character varying(4096),
    autoapprove character varying(255),
    endpoint_rights text
);


ALTER TABLE oauth_client_details OWNER TO finauth;

--
-- TOC entry 228 (class 1259 OID 62721)
-- Name: oauth_client_token; Type: TABLE; Schema: finauth; Owner: finauth
--

CREATE TABLE oauth_client_token (
    token_id character varying(255),
    token bytea,
    authentication_id character varying(255) NOT NULL,
    user_name character varying(255),
    client_id character varying(255)
);


ALTER TABLE oauth_client_token OWNER TO finauth;

--
-- TOC entry 229 (class 1259 OID 62727)
-- Name: oauth_code; Type: TABLE; Schema: finauth; Owner: finauth
--

CREATE TABLE oauth_code (
    code character varying(255),
    authentication bytea
);


ALTER TABLE oauth_code OWNER TO finauth;

--
-- TOC entry 230 (class 1259 OID 62733)
-- Name: oauth_refresh_token; Type: TABLE; Schema: finauth; Owner: finauth
--

CREATE TABLE oauth_refresh_token (
    token_id character varying(255),
    refresh_token bytea,
    authentication bytea
);


ALTER TABLE oauth_refresh_token OWNER TO finauth;
