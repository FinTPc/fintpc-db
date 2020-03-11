--
-- PostgreSQL database dump
--

-- Dumped from database version 10.5
-- Dumped by pg_dump version 10.1

-- Started on 2020-03-11 18:50:08

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 16 (class 2615 OID 62488)
-- Name: finlist; Type: SCHEMA; Schema: -; Owner: finlist
--

CREATE SCHEMA finlist;


ALTER SCHEMA finlist OWNER TO finlist;

SET search_path = finlist, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 276 (class 1259 OID 63239)
-- Name: banks; Type: TABLE; Schema: finlist; Owner: finlist
--

CREATE TABLE banks (
    name character varying(35) NOT NULL,
    bic character varying NOT NULL,
    address character varying(70),
    country character varying(2) NOT NULL
);


ALTER TABLE banks OWNER TO finlist;

SET default_tablespace = finlisttbs;

--
-- TOC entry 277 (class 1259 OID 63245)
-- Name: externalaccounts; Type: TABLE; Schema: finlist; Owner: finlist; Tablespace: finlisttbs
--

CREATE TABLE externalaccounts (
    id integer NOT NULL,
    currency character varying(3) NOT NULL,
    accountnumber character varying(35) NOT NULL,
    bankbic character varying(8) NOT NULL,
    description character varying(70),
    locked character(1),
    defaultaccount character(1),
    otherdetails character varying(70),
    externalentityname character varying(35) NOT NULL
);


ALTER TABLE externalaccounts OWNER TO finlist;

--
-- TOC entry 278 (class 1259 OID 63248)
-- Name: externalentities; Type: TABLE; Schema: finlist; Owner: finlist; Tablespace: finlisttbs
--

CREATE TABLE externalentities (
    name character varying(35) NOT NULL,
    id integer,
    address character varying(70),
    city character varying(35),
    country character varying(2),
    fiscalcode character varying NOT NULL,
    email character varying(35),
    maxamount numeric(17,2)
);


ALTER TABLE externalentities OWNER TO finlist;

SET default_with_oids = true;

--
-- TOC entry 280 (class 1259 OID 63254)
-- Name: internalentities; Type: TABLE; Schema: finlist; Owner: finlist; Tablespace: finlisttbs
--

CREATE TABLE internalentities (
    name character varying(35) NOT NULL,
    id integer,
    address character varying(70),
    city character varying(35),
    country character varying(2),
    fiscalcode character varying NOT NULL,
    disabled integer
);


ALTER TABLE internalentities OWNER TO finlist;

--
-- TOC entry 302 (class 1259 OID 135666)
-- Name: externalinternalentities; Type: VIEW; Schema: finlist; Owner: finlist
--

CREATE VIEW externalinternalentities AS
 SELECT DISTINCT en.name
   FROM ( SELECT externalentities.name
           FROM externalentities
        UNION
         SELECT internalentities.name
           FROM internalentities) en;


ALTER TABLE externalinternalentities OWNER TO finlist;

SET default_with_oids = false;

--
-- TOC entry 279 (class 1259 OID 63251)
-- Name: internalaccounts; Type: TABLE; Schema: finlist; Owner: finlist; Tablespace: finlisttbs
--

CREATE TABLE internalaccounts (
    id integer NOT NULL,
    currency character varying(3) NOT NULL,
    accountnumber character varying(35) NOT NULL,
    bankbic character varying(8) NOT NULL,
    description character varying(70),
    locked character(1),
    defaultaccount character(1),
    otherdetails character varying(70),
    internalentityname character varying(35) NOT NULL,
    resourceid character varying(50)
);


ALTER TABLE internalaccounts OWNER TO finlist;

SET default_tablespace = '';

--
-- TOC entry 4105 (class 2606 OID 85165)
-- Name: banks PK_BANKS_BIC; Type: CONSTRAINT; Schema: finlist; Owner: finlist
--

ALTER TABLE ONLY banks
    ADD CONSTRAINT "PK_BANKS_BIC" PRIMARY KEY (bic);


--
-- TOC entry 4107 (class 2606 OID 85167)
-- Name: externalaccounts pk_extaccount_id; Type: CONSTRAINT; Schema: finlist; Owner: finlist
--

ALTER TABLE ONLY externalaccounts
    ADD CONSTRAINT pk_extaccount_id PRIMARY KEY (id);


--
-- TOC entry 4113 (class 2606 OID 85169)
-- Name: internalaccounts pk_intacc_id; Type: CONSTRAINT; Schema: finlist; Owner: finlist
--

ALTER TABLE ONLY internalaccounts
    ADD CONSTRAINT pk_intacc_id PRIMARY KEY (id);


SET default_tablespace = finlisttbs;

--
-- TOC entry 4108 (class 1259 OID 95127)
-- Name: uk_eal_enamedefac; Type: INDEX; Schema: finlist; Owner: finlist; Tablespace: finlisttbs
--

CREATE UNIQUE INDEX uk_eal_enamedefac ON finlist.externalaccounts USING btree (externalentityname, defaultaccount) WHERE (defaultaccount = 'Y'::bpchar);


SET default_tablespace = '';

--
-- TOC entry 4109 (class 1259 OID 85192)
-- Name: uk_extacct_acc; Type: INDEX; Schema: finlist; Owner: finlist
--

CREATE UNIQUE INDEX uk_extacct_acc ON finlist.externalaccounts USING btree (accountnumber);


SET default_tablespace = finlisttbs;

--
-- TOC entry 4110 (class 1259 OID 85502)
-- Name: uk_extent_fsc; Type: INDEX; Schema: finlist; Owner: finlist; Tablespace: finlisttbs
--

CREATE UNIQUE INDEX uk_extent_fsc ON finlist.externalentities USING btree (fiscalcode);


SET default_tablespace = '';

--
-- TOC entry 4111 (class 1259 OID 85194)
-- Name: uk_extent_name; Type: INDEX; Schema: finlist; Owner: finlist
--

CREATE UNIQUE INDEX uk_extent_name ON finlist.externalentities USING btree (name);


SET default_tablespace = finlisttbs;

--
-- TOC entry 4114 (class 1259 OID 98998)
-- Name: uk_ial_enamedefac; Type: INDEX; Schema: finlist; Owner: finlist; Tablespace: finlisttbs
--

CREATE UNIQUE INDEX uk_ial_enamedefac ON finlist.internalaccounts USING btree (internalentityname, defaultaccount) WHERE (defaultaccount = 'Y'::bpchar);


SET default_tablespace = '';

--
-- TOC entry 4115 (class 1259 OID 85195)
-- Name: uk_intacct_acc; Type: INDEX; Schema: finlist; Owner: finlist
--

CREATE UNIQUE INDEX uk_intacct_acc ON finlist.internalaccounts USING btree (accountnumber);


--
-- TOC entry 4116 (class 1259 OID 85506)
-- Name: uk_intent_fisccode; Type: INDEX; Schema: finlist; Owner: finlist
--

CREATE UNIQUE INDEX uk_intent_fisccode ON finlist.internalentities USING btree (fiscalcode);


--
-- TOC entry 4117 (class 1259 OID 85197)
-- Name: uk_intent_name; Type: INDEX; Schema: finlist; Owner: finlist
--

CREATE UNIQUE INDEX uk_intent_name ON finlist.internalentities USING btree (name);


--
-- TOC entry 4118 (class 2606 OID 85449)
-- Name: externalaccounts FK_EXTACC_BANKS_BIC; Type: FK CONSTRAINT; Schema: finlist; Owner: finlist
--

ALTER TABLE ONLY externalaccounts
    ADD CONSTRAINT "FK_EXTACC_BANKS_BIC" FOREIGN KEY (bankbic) REFERENCES banks(bic);


--
-- TOC entry 4119 (class 2606 OID 85454)
-- Name: externalaccounts FK_EXTACC_EXTENT_ENT; Type: FK CONSTRAINT; Schema: finlist; Owner: finlist
--

ALTER TABLE ONLY externalaccounts
    ADD CONSTRAINT "FK_EXTACC_EXTENT_ENT" FOREIGN KEY (externalentityname) REFERENCES externalentities(name) ON DELETE CASCADE;


--
-- TOC entry 4120 (class 2606 OID 85459)
-- Name: internalaccounts FK_INTACC_BAKS_BIC; Type: FK CONSTRAINT; Schema: finlist; Owner: finlist
--

ALTER TABLE ONLY internalaccounts
    ADD CONSTRAINT "FK_INTACC_BAKS_BIC" FOREIGN KEY (bankbic) REFERENCES banks(bic);


--
-- TOC entry 4121 (class 2606 OID 85464)
-- Name: internalaccounts FK_INTACC_INTENT_ENT; Type: FK CONSTRAINT; Schema: finlist; Owner: finlist
--

ALTER TABLE ONLY internalaccounts
    ADD CONSTRAINT "FK_INTACC_INTENT_ENT" FOREIGN KEY (internalentityname) REFERENCES internalentities(name) ON DELETE CASCADE;


--
-- TOC entry 4265 (class 0 OID 0)
-- Dependencies: 16
-- Name: finlist; Type: ACL; Schema: -; Owner: finlist
--

GRANT USAGE ON SCHEMA finlist TO finuiuser;


--
-- TOC entry 4266 (class 0 OID 0)
-- Dependencies: 276
-- Name: banks; Type: ACL; Schema: finlist; Owner: finlist
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE banks TO finuiuser;


--
-- TOC entry 4267 (class 0 OID 0)
-- Dependencies: 277
-- Name: externalaccounts; Type: ACL; Schema: finlist; Owner: finlist
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE externalaccounts TO finuiuser;


--
-- TOC entry 4268 (class 0 OID 0)
-- Dependencies: 278
-- Name: externalentities; Type: ACL; Schema: finlist; Owner: finlist
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE externalentities TO finuiuser;


--
-- TOC entry 4269 (class 0 OID 0)
-- Dependencies: 280
-- Name: internalentities; Type: ACL; Schema: finlist; Owner: finlist
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE internalentities TO finuiuser;


--
-- TOC entry 4270 (class 0 OID 0)
-- Dependencies: 302
-- Name: externalinternalentities; Type: ACL; Schema: finlist; Owner: finlist
--

GRANT SELECT ON TABLE externalinternalentities TO finuiuser;


--
-- TOC entry 4271 (class 0 OID 0)
-- Dependencies: 279
-- Name: internalaccounts; Type: ACL; Schema: finlist; Owner: finlist
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE internalaccounts TO finuiuser;


-- Completed on 2020-03-11 18:50:09

--
-- PostgreSQL database dump complete
--

