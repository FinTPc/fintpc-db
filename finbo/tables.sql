--
-- PostgreSQL database dump
--

-- Dumped from database version 10.5
-- Dumped by pg_dump version 10.1

-- Started on 2020-03-11 18:36:14

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 12 (class 2615 OID 183380)
-- Name: finbo; Type: SCHEMA; Schema: -; Owner: finbo
--

CREATE SCHEMA finbo;


ALTER SCHEMA finbo OWNER TO finbo;

SET search_path = finbo, pg_catalog;

--
-- TOC entry 446 (class 1255 OID 183395)
-- Name: editedtxabort(); Type: FUNCTION; Schema: finbo; Owner: finbo
--

SET default_tablespace = '';

SET default_with_oids = true;

--
-- TOC entry 333 (class 1259 OID 183381)
-- Name: editedtransactions; Type: TABLE; Schema: finbo; Owner: postgres
--

CREATE TABLE editedtransactions (
    id integer NOT NULL,
    correlationid character varying(32),
    payload text,
    status integer,
    userid integer
);


ALTER TABLE editedtransactions OWNER TO postgres;

SET default_with_oids = false;

--
-- TOC entry 334 (class 1259 OID 183389)
-- Name: manualtransactions; Type: TABLE; Schema: finbo; Owner: finbo
--

CREATE TABLE manualtransactions (
    id integer NOT NULL,
    payload text,
    userid integer,
    status integer
);


ALTER TABLE manualtransactions OWNER TO finbo;

--
-- TOC entry 4236 (class 0 OID 183381)
-- Dependencies: 333
-- Data for Name: editedtransactions; Type: TABLE DATA; Schema: finbo; Owner: postgres
--

--
-- TOC entry 4101 (class 2606 OID 183388)
-- Name: editedtransactions editedtransactions_pkey; Type: CONSTRAINT; Schema: finbo; Owner: postgres
--

ALTER TABLE ONLY editedtransactions
    ADD CONSTRAINT editedtransactions_pkey PRIMARY KEY (id);


--
-- TOC entry 4242 (class 0 OID 0)
-- Dependencies: 12
-- Name: finbo; Type: ACL; Schema: -; Owner: finbo
--

GRANT USAGE ON SCHEMA finbo TO finuiuser;


--
-- TOC entry 4243 (class 0 OID 0)
-- Dependencies: 333
-- Name: editedtransactions; Type: ACL; Schema: finbo; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE editedtransactions TO finuiuser;


--
-- TOC entry 4244 (class 0 OID 0)
-- Dependencies: 334
-- Name: manualtransactions; Type: ACL; Schema: finbo; Owner: finbo
--

GRANT SELECT,INSERT,UPDATE ON TABLE manualtransactions TO finuiuser;


-- Completed on 2020-03-11 18:36:14

--
-- PostgreSQL database dump complete
--

