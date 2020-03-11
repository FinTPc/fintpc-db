--
-- PostgreSQL database dump
--

-- Dumped from database version 10.5
-- Dumped by pg_dump version 10.1

-- Started on 2020-03-11 18:41:25

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 17 (class 2615 OID 62486)
-- Name: fincfg; Type: SCHEMA; Schema: -; Owner: fincfg
--

CREATE SCHEMA fincfg;


ALTER SCHEMA fincfg OWNER TO fincfg;

SET search_path = fincfg, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = true;

--
-- TOC entry 231 (class 1259 OID 62757)
-- Name: idgenlist; Type: TABLE; Schema: fincfg; Owner: fincfg
--

CREATE TABLE idgenlist (
    tabcolname character varying(35) NOT NULL,
    idvalue integer
);


ALTER TABLE idgenlist OWNER TO fincfg;

--
-- TOC entry 232 (class 1259 OID 62760)
-- Name: messagetypes; Type: TABLE; Schema: fincfg; Owner: fincfg
--

CREATE TABLE messagetypes (
    messagetype character varying(50) NOT NULL,
    friendlyname character varying(50) NOT NULL,
    displayorder integer,
    storage character varying(35) NOT NULL,
    businessarea character varying(100) NOT NULL,
    reportingstorage character varying(35),
    parentmessagetype character varying(35)
);


ALTER TABLE messagetypes OWNER TO fincfg;

SET default_with_oids = false;

--
-- TOC entry 233 (class 1259 OID 62763)
-- Name: nonbussdayscalendar; Type: TABLE; Schema: fincfg; Owner: fincfg
--

CREATE TABLE nonbussdayscalendar (
    nonbusinessdate date NOT NULL,
    description character varying(50)
);


ALTER TABLE nonbussdayscalendar OWNER TO fincfg;

SET default_with_oids = true;

--
-- TOC entry 310 (class 1259 OID 183083)
-- Name: params; Type: TABLE; Schema: fincfg; Owner: fincfg
--

CREATE TABLE params (
    name character varying(35) NOT NULL,
    value character varying(300),
    description character varying(50),
    category character varying(35),
    id integer,
    code character varying(30)
);


ALTER TABLE params OWNER TO fincfg;

SET default_with_oids = false;

--
-- TOC entry 234 (class 1259 OID 62832)
-- Name: queuemessagegroups; Type: TABLE; Schema: fincfg; Owner: fincfg
--

CREATE TABLE queuemessagegroups (
    messagetype character varying(35) NOT NULL,
    routingkeyword1 character varying(35),
    routingkeyword2 character varying(35),
    routingkeyword3 character varying(35),
    routingkeyword4 character varying(35),
    routingkeyword5 character varying(35)
);


ALTER TABLE queuemessagegroups OWNER TO fincfg;

SET default_with_oids = true;

--
-- TOC entry 235 (class 1259 OID 62835)
-- Name: queuemessagetrxheader; Type: TABLE; Schema: fincfg; Owner: fincfg
--

CREATE TABLE queuemessagetrxheader (
    routingkeywordname character varying(50) NOT NULL,
    label character varying(50),
    displayorder integer,
    messagetype character varying(50) NOT NULL,
    contenttype character varying(100)
);


ALTER TABLE queuemessagetrxheader OWNER TO fincfg;

SET default_with_oids = false;

--
-- TOC entry 236 (class 1259 OID 62838)
-- Name: queues; Type: TABLE; Schema: fincfg; Owner: fincfg
--

CREATE TABLE queues (
    id integer NOT NULL,
    name character varying(50),
    label character varying(50),
    queuetypeid integer,
    priority integer DEFAULT 50,
    description character varying(100),
    holdstatus integer NOT NULL,
    exitpoint integer NOT NULL,
    maxtrxonbatch integer,
    messagetypesbusinessarea character varying(100),
    category character varying(100)
);


ALTER TABLE queues OWNER TO fincfg;

SET default_with_oids = true;

--
-- TOC entry 237 (class 1259 OID 62842)
-- Name: queuetypes; Type: TABLE; Schema: fincfg; Owner: fincfg
--

CREATE TABLE queuetypes (
    id integer NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE queuetypes OWNER TO fincfg;

SET default_with_oids = false;

--
-- TOC entry 238 (class 1259 OID 62845)
-- Name: reportingtxstates; Type: TABLE; Schema: fincfg; Owner: fincfg
--

CREATE TABLE reportingtxstates (
    status character varying(100) NOT NULL,
    description character varying(200),
    id integer NOT NULL
);


ALTER TABLE reportingtxstates OWNER TO fincfg;

SET default_tablespace = fincfgtbs;

SET default_with_oids = true;

--
-- TOC entry 239 (class 1259 OID 62848)
-- Name: reportmessagecriteria; Type: TABLE; Schema: fincfg; Owner: postgres; Tablespace: fincfgtbs
--

CREATE TABLE reportmessagecriteria (
    id integer NOT NULL,
    label character varying(100),
    displayorder integer,
    messagetypesbusinessarea character varying(100),
    type character varying(30),
    datasource character varying(500),
    field character varying(50),
    masterlabel character varying(100)
);


ALTER TABLE reportmessagecriteria OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 62854)
-- Name: reportmessageresults; Type: TABLE; Schema: fincfg; Owner: fincfg; Tablespace: fincfgtbs
--

CREATE TABLE reportmessageresults (
    id integer NOT NULL,
    label character varying(100),
    field character varying(50),
    displayorder integer,
    messagetypesbusinessarea character varying(100),
    defaultfield integer,
    fieldtype character varying(100)
);


ALTER TABLE reportmessageresults OWNER TO fincfg;

--
-- TOC entry 241 (class 1259 OID 62857)
-- Name: roles; Type: TABLE; Schema: fincfg; Owner: postgres; Tablespace: fincfgtbs
--

CREATE TABLE roles (
    id integer NOT NULL,
    name character varying(100),
    category character varying(100),
    userdefined integer,
    listofactions character varying(200)
);


ALTER TABLE roles OWNER TO postgres;

SET default_tablespace = '';

--
-- TOC entry 242 (class 1259 OID 62860)
-- Name: routingkeywordmaps; Type: TABLE; Schema: fincfg; Owner: fincfg
--

CREATE TABLE routingkeywordmaps (
    routingkeywordid integer NOT NULL,
    tag character varying(500) NOT NULL,
    messagetype character varying(35) NOT NULL,
    selector character varying(11) NOT NULL,
    id integer NOT NULL
);


ALTER TABLE routingkeywordmaps OWNER TO fincfg;

--
-- TOC entry 243 (class 1259 OID 62866)
-- Name: routingkeywords; Type: TABLE; Schema: fincfg; Owner: fincfg
--

CREATE TABLE routingkeywords (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    comparer character varying(200) NOT NULL,
    selector character varying(200),
    description character varying(200),
    selectoriso character varying(200)
);


ALTER TABLE routingkeywords OWNER TO fincfg;

SET default_with_oids = false;

--
-- TOC entry 244 (class 1259 OID 62872)
-- Name: routingrules; Type: TABLE; Schema: fincfg; Owner: fincfg
--

CREATE TABLE routingrules (
    id integer NOT NULL,
    queueid integer NOT NULL,
    routingschemaid integer NOT NULL,
    sequence integer,
    ruletype integer,
    description character varying(70),
    messagecondition character varying(500),
    functioncondition character varying(500),
    metadatacondition character varying(500),
    action character varying(500)
);


ALTER TABLE routingrules OWNER TO fincfg;

--
-- TOC entry 245 (class 1259 OID 62878)
-- Name: routingrulesactions; Type: TABLE; Schema: fincfg; Owner: fincfg
--

CREATE TABLE routingrulesactions (
    id integer NOT NULL,
    label character varying(100),
    displayorder integer,
    type character varying(30),
    datasource character varying(500)
);


ALTER TABLE routingrulesactions OWNER TO fincfg;

SET default_with_oids = true;

--
-- TOC entry 246 (class 1259 OID 62884)
-- Name: routingschemas; Type: TABLE; Schema: fincfg; Owner: fincfg
--

CREATE TABLE routingschemas (
    name character varying(10) NOT NULL,
    description character varying(250),
    active integer DEFAULT 1,
    id integer NOT NULL,
    timelimitid1 integer NOT NULL,
    timelimitid2 integer NOT NULL,
    sessioncode character varying(10),
    visible character varying(1)
);


ALTER TABLE routingschemas OWNER TO fincfg;

--
-- TOC entry 247 (class 1259 OID 62887)
-- Name: servicemaps; Type: TABLE; Schema: fincfg; Owner: fincfg
--

CREATE TABLE servicemaps (
    name character varying(30),
    id integer NOT NULL,
    status integer NOT NULL,
    lastsessionid integer,
    heartbeatinterval integer NOT NULL,
    lastheartbeat timestamp(6) without time zone,
    version character varying(255),
    partner character varying(255),
    servicetype integer,
    ioidentifier integer,
    exitpoint character varying(300),
    sessionid character varying(26),
    duplicatecheck integer,
    duplicatequeue character varying(50),
    duplicatemap character varying(50),
    duplicatenotificationqueue character varying(50),
    delayednotificationqueue character varying(50)
);


ALTER TABLE servicemaps OWNER TO fincfg;

--
-- TOC entry 248 (class 1259 OID 62893)
-- Name: timelimits; Type: TABLE; Schema: fincfg; Owner: fincfg
--

CREATE TABLE timelimits (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    cutoff timestamp without time zone NOT NULL
);


ALTER TABLE timelimits OWNER TO fincfg;

--
-- TOC entry 311 (class 1259 OID 183099)
-- Name: txtemplates; Type: TABLE; Schema: fincfg; Owner: fincfg
--

CREATE TABLE txtemplates (
    id integer NOT NULL,
    configid integer NOT NULL,
    name character varying(50),
    entity character varying(100),
    userid integer,
    type integer
);


ALTER TABLE txtemplates OWNER TO fincfg;

--
-- TOC entry 312 (class 1259 OID 183106)
-- Name: txtemplatesconfig; Type: TABLE; Schema: fincfg; Owner: fincfg
--

CREATE TABLE txtemplatesconfig (
    id integer NOT NULL,
    messagetype character varying(20) NOT NULL,
    validationxsd text,
    type character varying(100),
    entityxpath character varying(100)
);


ALTER TABLE txtemplatesconfig OWNER TO fincfg;

--
-- TOC entry 314 (class 1259 OID 183125)
-- Name: txtemplatesconfigdetailed; Type: TABLE; Schema: fincfg; Owner: fincfg
--

CREATE TABLE txtemplatesconfigdetailed (
    configid integer NOT NULL,
    fieldxpath character varying(100),
    pattern character varying(100),
    fieldvalue character varying(50),
    fieldtype character varying(50),
    mandatory boolean DEFAULT false,
    fieldvisibility integer,
    fieldlabel character varying(50),
    fieldid integer,
    optionid integer,
    id integer NOT NULL,
    editable boolean DEFAULT false
);


ALTER TABLE txtemplatesconfigdetailed OWNER TO fincfg;

SET default_with_oids = false;

--
-- TOC entry 313 (class 1259 OID 183120)
-- Name: txtemplatesconfigoptions; Type: TABLE; Schema: fincfg; Owner: fincfg
--

CREATE TABLE txtemplatesconfigoptions (
    id integer NOT NULL,
    name character varying(50),
    description character varying(200),
    datasource character varying(50)
);


ALTER TABLE txtemplatesconfigoptions OWNER TO fincfg;

SET default_with_oids = true;

--
-- TOC entry 315 (class 1259 OID 183144)
-- Name: txtemplatesdetailed; Type: TABLE; Schema: fincfg; Owner: fincfg
--

CREATE TABLE txtemplatesdetailed (
    templateid integer NOT NULL,
    fieldid integer,
    value character varying(100),
    id integer NOT NULL
);


ALTER TABLE txtemplatesdetailed OWNER TO fincfg;

SET default_tablespace = fincfgtbs;

--
-- TOC entry 316 (class 1259 OID 183159)
-- Name: txtemplatesgroups; Type: TABLE; Schema: fincfg; Owner: fincfg; Tablespace: fincfgtbs
--

CREATE TABLE txtemplatesgroups (
    id integer NOT NULL,
    templateid integer,
    groupid integer,
    name character varying(50),
    userid integer
);


ALTER TABLE txtemplatesgroups OWNER TO fincfg;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 249 (class 1259 OID 62896)
-- Name: useractioncodes; Type: TABLE; Schema: fincfg; Owner: fincfg
--

CREATE TABLE useractioncodes (
    useractionid integer NOT NULL,
    code character varying(20),
    label character varying(20),
    description character varying(100),
    id integer NOT NULL
);


ALTER TABLE useractioncodes OWNER TO fincfg;

--
-- TOC entry 250 (class 1259 OID 62899)
-- Name: useractionmaps; Type: TABLE; Schema: fincfg; Owner: fincfg
--

CREATE TABLE useractionmaps (
    id integer NOT NULL,
    queuetypeid integer,
    useractionid integer,
    messagetype character varying(50)
);


ALTER TABLE useractionmaps OWNER TO fincfg;

--
-- TOC entry 251 (class 1259 OID 62902)
-- Name: useractions; Type: TABLE; Schema: fincfg; Owner: fincfg
--

CREATE TABLE useractions (
    id integer NOT NULL,
    name character varying(20) NOT NULL,
    label character varying(20),
    currentmessage integer,
    selectedmessage integer,
    groupmessage integer,
    priority integer,
    location character varying(15),
    codeselection integer,
    function character varying(200),
    detailsinput integer
);


ALTER TABLE useractions OWNER TO fincfg;

SET default_tablespace = fincfgtbs;

SET default_with_oids = true;

--
-- TOC entry 252 (class 1259 OID 62905)
-- Name: userdefinedroles; Type: TABLE; Schema: fincfg; Owner: fincfg; Tablespace: fincfgtbs
--

CREATE TABLE userdefinedroles (
    roleid integer NOT NULL,
    messagetype character varying(100),
    internalentityname character varying(35),
    id integer NOT NULL
);


ALTER TABLE userdefinedroles OWNER TO fincfg;

--
-- TOC entry 253 (class 1259 OID 62908)
-- Name: userrolesmaps; Type: TABLE; Schema: fincfg; Owner: postgres; Tablespace: fincfgtbs
--

CREATE TABLE userrolesmaps (
    id integer NOT NULL,
    userid integer,
    roleid integer,
    action character varying(35) NOT NULL
);


ALTER TABLE userrolesmaps OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 62911)
-- Name: users; Type: TABLE; Schema: fincfg; Owner: fincfg; Tablespace: fincfgtbs
--

CREATE TABLE users (
    id integer NOT NULL,
    username character varying(100),
    email character varying(100)
);


ALTER TABLE users OWNER TO fincfg;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 255 (class 1259 OID 62914)
-- Name: versions; Type: TABLE; Schema: fincfg; Owner: fincfg
--

CREATE TABLE versions (
    servicename character varying(50) NOT NULL,
    name character varying(50) NOT NULL,
    version character varying(100) NOT NULL,
    hash character varying(100),
    machine character varying(50)
);


ALTER TABLE versions OWNER TO fincfg;


--
-- TOC entry 4135 (class 2606 OID 84989)
-- Name: idgenlist PK_IDGEN_TCN; Type: CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY idgenlist
    ADD CONSTRAINT "PK_IDGEN_TCN" PRIMARY KEY (tabcolname);


--
-- TOC entry 4137 (class 2606 OID 84991)
-- Name: messagetypes PK_MT_MSGTYPE; Type: CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY messagetypes
    ADD CONSTRAINT "PK_MT_MSGTYPE" PRIMARY KEY (messagetype);


--
-- TOC entry 4141 (class 2606 OID 84993)
-- Name: nonbussdayscalendar PK_NBDC_NBD; Type: CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY nonbussdayscalendar
    ADD CONSTRAINT "PK_NBDC_NBD" PRIMARY KEY (nonbusinessdate);


--
-- TOC entry 4203 (class 2606 OID 183087)
-- Name: params PK_PARAMS_NAME; Type: CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY params
    ADD CONSTRAINT "PK_PARAMS_NAME" PRIMARY KEY (name);


--
-- TOC entry 4144 (class 2606 OID 85021)
-- Name: queuemessagetrxheader PK_QMSGTXHDR_FNMSGT; Type: CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY queuemessagetrxheader
    ADD CONSTRAINT "PK_QMSGTXHDR_FNMSGT" PRIMARY KEY (routingkeywordname, messagetype);


--
-- TOC entry 4146 (class 2606 OID 85023)
-- Name: queues PK_Q_QID; Type: CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY queues
    ADD CONSTRAINT "PK_Q_QID" PRIMARY KEY (id);


--
-- TOC entry 4165 (class 2606 OID 85025)
-- Name: routingkeywordmaps PK_RKM_MAPID; Type: CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY routingkeywordmaps
    ADD CONSTRAINT "PK_RKM_MAPID" PRIMARY KEY (id);


--
-- TOC entry 4167 (class 2606 OID 85027)
-- Name: routingkeywords PK_RK_KEYWORDID; Type: CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY routingkeywords
    ADD CONSTRAINT "PK_RK_KEYWORDID" PRIMARY KEY (id);


SET default_tablespace = fincfgtbs;

--
-- TOC entry 4161 (class 2606 OID 85029)
-- Name: roles PK_ROLES_RID; Type: CONSTRAINT; Schema: fincfg; Owner: postgres; Tablespace: fincfgtbs
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT "PK_ROLES_RID" PRIMARY KEY (id);


SET default_tablespace = '';

--
-- TOC entry 4171 (class 2606 OID 85031)
-- Name: routingrules PK_RR_GUID; Type: CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY routingrules
    ADD CONSTRAINT "PK_RR_GUID" PRIMARY KEY (id);


--
-- TOC entry 4177 (class 2606 OID 85033)
-- Name: routingschemas PK_RS_SCHEMAGUID; Type: CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY routingschemas
    ADD CONSTRAINT "PK_RS_SCHEMAGUID" PRIMARY KEY (id);


--
-- TOC entry 4181 (class 2606 OID 85035)
-- Name: servicemaps PK_SM_SERVID; Type: CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY servicemaps
    ADD CONSTRAINT "PK_SM_SERVID" PRIMARY KEY (id);


--
-- TOC entry 4185 (class 2606 OID 85037)
-- Name: timelimits PK_TL_GUID; Type: CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY timelimits
    ADD CONSTRAINT "PK_TL_GUID" PRIMARY KEY (id);


--
-- TOC entry 4199 (class 2606 OID 85039)
-- Name: userrolesmaps PK_URM_ID; Type: CONSTRAINT; Schema: fincfg; Owner: postgres
--

ALTER TABLE ONLY userrolesmaps
    ADD CONSTRAINT "PK_URM_ID" PRIMARY KEY (id);


--
-- TOC entry 4191 (class 2606 OID 85041)
-- Name: useractionmaps PK_USRAM_MAPID; Type: CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY useractionmaps
    ADD CONSTRAINT "PK_USRAM_MAPID" PRIMARY KEY (id);


--
-- TOC entry 4193 (class 2606 OID 85043)
-- Name: useractions PK_USRA_AID; Type: CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY useractions
    ADD CONSTRAINT "PK_USRA_AID" PRIMARY KEY (id);


SET default_tablespace = fincfgtbs;

--
-- TOC entry 4201 (class 2606 OID 85045)
-- Name: users PK_USR_USERID; Type: CONSTRAINT; Schema: fincfg; Owner: fincfg; Tablespace: fincfgtbs
--

ALTER TABLE ONLY users
    ADD CONSTRAINT "PK_USR_USERID" PRIMARY KEY (id);


--
-- TOC entry 4139 (class 2606 OID 85051)
-- Name: messagetypes UK_MT_MGT; Type: CONSTRAINT; Schema: fincfg; Owner: fincfg; Tablespace: fincfgtbs
--

ALTER TABLE ONLY messagetypes
    ADD CONSTRAINT "UK_MT_MGT" UNIQUE (messagetype);


SET default_tablespace = '';

--
-- TOC entry 4169 (class 2606 OID 85065)
-- Name: routingkeywords UK_RK_KEYWORD; Type: CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY routingkeywords
    ADD CONSTRAINT "UK_RK_KEYWORD" UNIQUE (name);


--
-- TOC entry 4163 (class 2606 OID 85067)
-- Name: roles UK_ROLES_NAME; Type: CONSTRAINT; Schema: fincfg; Owner: postgres
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT "UK_ROLES_NAME" UNIQUE (name);


--
-- TOC entry 4173 (class 2606 OID 85071)
-- Name: routingrules UK_RR_QIDSEQ; Type: CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY routingrules
    ADD CONSTRAINT "UK_RR_QIDSEQ" UNIQUE (queueid, sequence);


--
-- TOC entry 4179 (class 2606 OID 85073)
-- Name: routingschemas UK_RS_NAME; Type: CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY routingschemas
    ADD CONSTRAINT "UK_RS_NAME" UNIQUE (name);


--
-- TOC entry 4183 (class 2606 OID 85075)
-- Name: servicemaps UK_SM_NAME; Type: CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY servicemaps
    ADD CONSTRAINT "UK_SM_NAME" UNIQUE (name);


--
-- TOC entry 4187 (class 2606 OID 85077)
-- Name: timelimits UK_TL_LNAME; Type: CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY timelimits
    ADD CONSTRAINT "UK_TL_LNAME" UNIQUE (name);


--
-- TOC entry 4213 (class 2606 OID 183133)
-- Name: txtemplatesconfigdetailed UK_TXTCONFDET_FIELDID; Type: CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY txtemplatesconfigdetailed
    ADD CONSTRAINT "UK_TXTCONFDET_FIELDID" UNIQUE (fieldid);


--
-- TOC entry 4205 (class 2606 OID 183105)
-- Name: txtemplates UK_TXTEMPLATES_NAME; Type: CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY txtemplates
    ADD CONSTRAINT "UK_TXTEMPLATES_NAME" UNIQUE (name);


--
-- TOC entry 4195 (class 2606 OID 85081)
-- Name: useractions UK_USRA_ANAME; Type: CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY useractions
    ADD CONSTRAINT "UK_USRA_ANAME" UNIQUE (name);


--
-- TOC entry 4157 (class 2606 OID 85083)
-- Name: reportmessagecriteria pk_repcrit_id; Type: CONSTRAINT; Schema: fincfg; Owner: postgres
--

ALTER TABLE ONLY reportmessagecriteria
    ADD CONSTRAINT pk_repcrit_id PRIMARY KEY (id);


--
-- TOC entry 4155 (class 2606 OID 85085)
-- Name: reportingtxstates pk_reptxst_id; Type: CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY reportingtxstates
    ADD CONSTRAINT pk_reptxst_id PRIMARY KEY (id);


SET default_tablespace = fincfgtbs;

--
-- TOC entry 4159 (class 2606 OID 85087)
-- Name: reportmessageresults pk_rptmsgres_id; Type: CONSTRAINT; Schema: fincfg; Owner: fincfg; Tablespace: fincfgtbs
--

ALTER TABLE ONLY reportmessageresults
    ADD CONSTRAINT pk_rptmsgres_id PRIMARY KEY (id);


SET default_tablespace = '';

--
-- TOC entry 4175 (class 2606 OID 85089)
-- Name: routingrulesactions pk_rractions_id; Type: CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY routingrulesactions
    ADD CONSTRAINT pk_rractions_id PRIMARY KEY (id);


--
-- TOC entry 4197 (class 2606 OID 85091)
-- Name: userdefinedroles pk_udr_id; Type: CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY userdefinedroles
    ADD CONSTRAINT pk_udr_id PRIMARY KEY (id);


SET default_tablespace = findatatbs;

--
-- TOC entry 4189 (class 2606 OID 85093)
-- Name: useractioncodes pk_usractcodes_id; Type: CONSTRAINT; Schema: fincfg; Owner: fincfg; Tablespace: findatatbs
--

ALTER TABLE ONLY useractioncodes
    ADD CONSTRAINT pk_usractcodes_id PRIMARY KEY (id);


SET default_tablespace = '';

--
-- TOC entry 4151 (class 2606 OID 85095)
-- Name: queuetypes queuetypes_pkey; Type: CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY queuetypes
    ADD CONSTRAINT queuetypes_pkey PRIMARY KEY (id);


--
-- TOC entry 4207 (class 2606 OID 183103)
-- Name: txtemplates txtemplates_pkey; Type: CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY txtemplates
    ADD CONSTRAINT txtemplates_pkey PRIMARY KEY (id);


--
-- TOC entry 4209 (class 2606 OID 183113)
-- Name: txtemplatesconfig txtemplatesconfig_pkey; Type: CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY txtemplatesconfig
    ADD CONSTRAINT txtemplatesconfig_pkey PRIMARY KEY (id);


--
-- TOC entry 4215 (class 2606 OID 183131)
-- Name: txtemplatesconfigdetailed txtemplatesconfigdetailed_pkey; Type: CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY txtemplatesconfigdetailed
    ADD CONSTRAINT txtemplatesconfigdetailed_pkey PRIMARY KEY (id);


--
-- TOC entry 4211 (class 2606 OID 183124)
-- Name: txtemplatesconfigoptions txtemplatesconfigoptions_pkey; Type: CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY txtemplatesconfigoptions
    ADD CONSTRAINT txtemplatesconfigoptions_pkey PRIMARY KEY (id);


--
-- TOC entry 4217 (class 2606 OID 183148)
-- Name: txtemplatesdetailed txtemplatesdetailed_pkey; Type: CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY txtemplatesdetailed
    ADD CONSTRAINT txtemplatesdetailed_pkey PRIMARY KEY (id);


--
-- TOC entry 4153 (class 2606 OID 85097)
-- Name: queuetypes typename_uniq; Type: CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY queuetypes
    ADD CONSTRAINT typename_uniq UNIQUE (name);


--
-- TOC entry 4149 (class 2606 OID 86110)
-- Name: queues uk_q_name; Type: CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY queues
    ADD CONSTRAINT uk_q_name UNIQUE (name);


SET default_tablespace = fincfgtbs;

--
-- TOC entry 4147 (class 1259 OID 85188)
-- Name: test; Type: INDEX; Schema: fincfg; Owner: fincfg; Tablespace: fincfgtbs
--

CREATE UNIQUE INDEX test ON fincfg.queues USING btree (queuetypeid, messagetypesbusinessarea) WITH (fillfactor='100') WHERE (queuetypeid = 3);


SET default_tablespace = '';

--
-- TOC entry 4142 (class 1259 OID 85189)
-- Name: uk_qmg_mt; Type: INDEX; Schema: fincfg; Owner: fincfg
--

CREATE UNIQUE INDEX uk_qmg_mt ON fincfg.queuemessagegroups USING btree (messagetype);


--
-- TOC entry 4218 (class 2606 OID 85244)
-- Name: queuemessagegroups FK_QMSGGRP_MT_MT; Type: FK CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY queuemessagegroups
    ADD CONSTRAINT "FK_QMSGGRP_MT_MT" FOREIGN KEY (messagetype) REFERENCES messagetypes(messagetype);


--
-- TOC entry 4219 (class 2606 OID 85249)
-- Name: queues FK_Q_QTYPES_QTYPEID; Type: FK CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY queues
    ADD CONSTRAINT "FK_Q_QTYPES_QTYPEID" FOREIGN KEY (queuetypeid) REFERENCES queuetypes(id);


--
-- TOC entry 4220 (class 2606 OID 85254)
-- Name: routingkeywordmaps FK_RKM_MT_MSGTYPE; Type: FK CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY routingkeywordmaps
    ADD CONSTRAINT "FK_RKM_MT_MSGTYPE" FOREIGN KEY (messagetype) REFERENCES messagetypes(messagetype);


--
-- TOC entry 4221 (class 2606 OID 85259)
-- Name: routingkeywordmaps FK_RKM_RK_KID; Type: FK CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY routingkeywordmaps
    ADD CONSTRAINT "FK_RKM_RK_KID" FOREIGN KEY (routingkeywordid) REFERENCES routingkeywords(id) ON DELETE CASCADE;


--
-- TOC entry 4222 (class 2606 OID 85264)
-- Name: routingrules FK_RR_Q_QID; Type: FK CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY routingrules
    ADD CONSTRAINT "FK_RR_Q_QID" FOREIGN KEY (queueid) REFERENCES queues(id);


--
-- TOC entry 4223 (class 2606 OID 85269)
-- Name: routingrules FK_RR_RS_SCHEMAGUID; Type: FK CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY routingrules
    ADD CONSTRAINT "FK_RR_RS_SCHEMAGUID" FOREIGN KEY (routingschemaid) REFERENCES routingschemas(id);


--
-- TOC entry 4224 (class 2606 OID 85274)
-- Name: routingschemas FK_RS_TL_START; Type: FK CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY routingschemas
    ADD CONSTRAINT "FK_RS_TL_START" FOREIGN KEY (timelimitid1) REFERENCES timelimits(id);


--
-- TOC entry 4225 (class 2606 OID 85279)
-- Name: routingschemas FK_RS_TL_STOP; Type: FK CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY routingschemas
    ADD CONSTRAINT "FK_RS_TL_STOP" FOREIGN KEY (timelimitid2) REFERENCES timelimits(id);


--
-- TOC entry 4234 (class 2606 OID 183134)
-- Name: txtemplatesconfigdetailed FK_TXTCONFDET_CONFIGID; Type: FK CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY txtemplatesconfigdetailed
    ADD CONSTRAINT "FK_TXTCONFDET_CONFIGID" FOREIGN KEY (configid) REFERENCES txtemplatesconfig(id);


--
-- TOC entry 4235 (class 2606 OID 183139)
-- Name: txtemplatesconfigdetailed FK_TXTCONFDET_OPTIONID; Type: FK CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY txtemplatesconfigdetailed
    ADD CONSTRAINT "FK_TXTCONFDET_OPTIONID" FOREIGN KEY (optionid) REFERENCES txtemplatesconfigoptions(id);


--
-- TOC entry 4233 (class 2606 OID 183114)
-- Name: txtemplatesconfig FK_TXTCONF_MSGTYPE; Type: FK CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY txtemplatesconfig
    ADD CONSTRAINT "FK_TXTCONF_MSGTYPE" FOREIGN KEY (messagetype) REFERENCES messagetypes(messagetype);


--
-- TOC entry 4236 (class 2606 OID 183149)
-- Name: txtemplatesdetailed FK_TXTEMPLATESDET_TEMPLATEID; Type: FK CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY txtemplatesdetailed
    ADD CONSTRAINT "FK_TXTEMPLATESDET_TEMPLATEID" FOREIGN KEY (templateid) REFERENCES txtemplates(id);


--
-- TOC entry 4228 (class 2606 OID 85284)
-- Name: userdefinedroles FK_UDR_IENT_ENAME; Type: FK CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY userdefinedroles
    ADD CONSTRAINT "FK_UDR_IENT_ENAME" FOREIGN KEY (internalentityname) REFERENCES finlist.internalentities(name);


--
-- TOC entry 4229 (class 2606 OID 85289)
-- Name: userdefinedroles FK_UDR_MT_MT; Type: FK CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY userdefinedroles
    ADD CONSTRAINT "FK_UDR_MT_MT" FOREIGN KEY (messagetype) REFERENCES messagetypes(messagetype);


--
-- TOC entry 4230 (class 2606 OID 85294)
-- Name: userdefinedroles FK_UDR_R_ROLEID; Type: FK CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY userdefinedroles
    ADD CONSTRAINT "FK_UDR_R_ROLEID" FOREIGN KEY (roleid) REFERENCES roles(id);


--
-- TOC entry 4231 (class 2606 OID 85304)
-- Name: userrolesmaps FK_URM_R_RID; Type: FK CONSTRAINT; Schema: fincfg; Owner: postgres
--

ALTER TABLE ONLY userrolesmaps
    ADD CONSTRAINT "FK_URM_R_RID" FOREIGN KEY (roleid) REFERENCES roles(id) ON DELETE CASCADE;


--
-- TOC entry 4232 (class 2606 OID 85314)
-- Name: userrolesmaps FK_URM_USR_UID; Type: FK CONSTRAINT; Schema: fincfg; Owner: postgres
--

ALTER TABLE ONLY userrolesmaps
    ADD CONSTRAINT "FK_URM_USR_UID" FOREIGN KEY (userid) REFERENCES users(id) ON DELETE CASCADE;


--
-- TOC entry 4226 (class 2606 OID 85319)
-- Name: useractionmaps FK_USRAM_QT_QTYPEID; Type: FK CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY useractionmaps
    ADD CONSTRAINT "FK_USRAM_QT_QTYPEID" FOREIGN KEY (queuetypeid) REFERENCES queuetypes(id);


--
-- TOC entry 4227 (class 2606 OID 85324)
-- Name: useractionmaps FK_USRAM_USRA_AID; Type: FK CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY useractionmaps
    ADD CONSTRAINT "FK_USRAM_USRA_AID" FOREIGN KEY (useractionid) REFERENCES useractions(id);


--
-- TOC entry 4238 (class 2606 OID 183162)
-- Name: txtemplatesgroups fk_txt_txtg_id; Type: FK CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY txtemplatesgroups
    ADD CONSTRAINT fk_txt_txtg_id FOREIGN KEY (templateid) REFERENCES txtemplates(id) ON DELETE CASCADE;


--
-- TOC entry 4237 (class 2606 OID 183154)
-- Name: txtemplatesdetailed fk_txtemplates_fieldid; Type: FK CONSTRAINT; Schema: fincfg; Owner: fincfg
--

ALTER TABLE ONLY txtemplatesdetailed
    ADD CONSTRAINT fk_txtemplates_fieldid FOREIGN KEY (fieldid) REFERENCES txtemplatesconfigdetailed(id);


--
-- TOC entry 4409 (class 0 OID 0)
-- Dependencies: 17
-- Name: fincfg; Type: ACL; Schema: -; Owner: fincfg
--

GRANT USAGE ON SCHEMA fincfg TO finuiuser;
GRANT USAGE ON SCHEMA fincfg TO findata;


--
-- TOC entry 4410 (class 0 OID 0)
-- Dependencies: 456
-- Name: getlastbusinessday(date, integer); Type: ACL; Schema: fincfg; Owner: fincfg
--

GRANT ALL ON FUNCTION getlastbusinessday(indate date, innoofdays integer) TO findata;


--
-- TOC entry 4411 (class 0 OID 0)
-- Dependencies: 434
-- Name: getqueueid(character varying); Type: ACL; Schema: fincfg; Owner: fincfg
--

GRANT ALL ON FUNCTION getqueueid(inqueuename character varying) TO findata;


--
-- TOC entry 4412 (class 0 OID 0)
-- Dependencies: 231
-- Name: idgenlist; Type: ACL; Schema: fincfg; Owner: fincfg
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE idgenlist TO finuiuser;


--
-- TOC entry 4413 (class 0 OID 0)
-- Dependencies: 232
-- Name: messagetypes; Type: ACL; Schema: fincfg; Owner: fincfg
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE messagetypes TO finuiuser;


--
-- TOC entry 4414 (class 0 OID 0)
-- Dependencies: 233
-- Name: nonbussdayscalendar; Type: ACL; Schema: fincfg; Owner: fincfg
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE nonbussdayscalendar TO finuiuser;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE nonbussdayscalendar TO findata;


--
-- TOC entry 4415 (class 0 OID 0)
-- Dependencies: 310
-- Name: params; Type: ACL; Schema: fincfg; Owner: fincfg
--

GRANT SELECT ON TABLE params TO finuiuser;
GRANT SELECT ON TABLE params TO findata;


--
-- TOC entry 4416 (class 0 OID 0)
-- Dependencies: 234
-- Name: queuemessagegroups; Type: ACL; Schema: fincfg; Owner: fincfg
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE queuemessagegroups TO finuiuser;
GRANT SELECT ON TABLE queuemessagegroups TO findata;


--
-- TOC entry 4417 (class 0 OID 0)
-- Dependencies: 235
-- Name: queuemessagetrxheader; Type: ACL; Schema: fincfg; Owner: fincfg
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE queuemessagetrxheader TO finuiuser;


--
-- TOC entry 4418 (class 0 OID 0)
-- Dependencies: 236
-- Name: queues; Type: ACL; Schema: fincfg; Owner: fincfg
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE queues TO finuiuser;
GRANT SELECT ON TABLE queues TO findata;
GRANT SELECT ON TABLE queues TO fintrack;


--
-- TOC entry 4419 (class 0 OID 0)
-- Dependencies: 237
-- Name: queuetypes; Type: ACL; Schema: fincfg; Owner: fincfg
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE queuetypes TO finuiuser;


--
-- TOC entry 4420 (class 0 OID 0)
-- Dependencies: 238
-- Name: reportingtxstates; Type: ACL; Schema: fincfg; Owner: fincfg
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE reportingtxstates TO finuiuser;


--
-- TOC entry 4421 (class 0 OID 0)
-- Dependencies: 239
-- Name: reportmessagecriteria; Type: ACL; Schema: fincfg; Owner: postgres
--

GRANT SELECT ON TABLE reportmessagecriteria TO finuiuser;


--
-- TOC entry 4422 (class 0 OID 0)
-- Dependencies: 240
-- Name: reportmessageresults; Type: ACL; Schema: fincfg; Owner: fincfg
--

GRANT SELECT ON TABLE reportmessageresults TO finuiuser;


--
-- TOC entry 4423 (class 0 OID 0)
-- Dependencies: 241
-- Name: roles; Type: ACL; Schema: fincfg; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE roles TO finuiuser;


--
-- TOC entry 4424 (class 0 OID 0)
-- Dependencies: 242
-- Name: routingkeywordmaps; Type: ACL; Schema: fincfg; Owner: fincfg
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE routingkeywordmaps TO finuiuser;


--
-- TOC entry 4425 (class 0 OID 0)
-- Dependencies: 243
-- Name: routingkeywords; Type: ACL; Schema: fincfg; Owner: fincfg
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE routingkeywords TO finuiuser;


--
-- TOC entry 4426 (class 0 OID 0)
-- Dependencies: 244
-- Name: routingrules; Type: ACL; Schema: fincfg; Owner: fincfg
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE routingrules TO finuiuser;
GRANT SELECT ON TABLE routingrules TO fintrack;


--
-- TOC entry 4427 (class 0 OID 0)
-- Dependencies: 245
-- Name: routingrulesactions; Type: ACL; Schema: fincfg; Owner: fincfg
--

GRANT SELECT ON TABLE routingrulesactions TO finuiuser;


--
-- TOC entry 4428 (class 0 OID 0)
-- Dependencies: 246
-- Name: routingschemas; Type: ACL; Schema: fincfg; Owner: fincfg
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE routingschemas TO finuiuser;
GRANT SELECT ON TABLE routingschemas TO fintrack;


--
-- TOC entry 4429 (class 0 OID 0)
-- Dependencies: 247
-- Name: servicemaps; Type: ACL; Schema: fincfg; Owner: fincfg
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE servicemaps TO finuiuser;
GRANT SELECT ON TABLE servicemaps TO fintrack;


--
-- TOC entry 4430 (class 0 OID 0)
-- Dependencies: 248
-- Name: timelimits; Type: ACL; Schema: fincfg; Owner: fincfg
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE timelimits TO finuiuser;


--
-- TOC entry 4431 (class 0 OID 0)
-- Dependencies: 311
-- Name: txtemplates; Type: ACL; Schema: fincfg; Owner: fincfg
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE txtemplates TO finuiuser;


--
-- TOC entry 4432 (class 0 OID 0)
-- Dependencies: 312
-- Name: txtemplatesconfig; Type: ACL; Schema: fincfg; Owner: fincfg
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE txtemplatesconfig TO finuiuser;


--
-- TOC entry 4433 (class 0 OID 0)
-- Dependencies: 314
-- Name: txtemplatesconfigdetailed; Type: ACL; Schema: fincfg; Owner: fincfg
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE txtemplatesconfigdetailed TO finuiuser;


--
-- TOC entry 4434 (class 0 OID 0)
-- Dependencies: 313
-- Name: txtemplatesconfigoptions; Type: ACL; Schema: fincfg; Owner: fincfg
--

GRANT SELECT ON TABLE txtemplatesconfigoptions TO finuiuser;


--
-- TOC entry 4435 (class 0 OID 0)
-- Dependencies: 315
-- Name: txtemplatesdetailed; Type: ACL; Schema: fincfg; Owner: fincfg
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE txtemplatesdetailed TO finuiuser;


--
-- TOC entry 4436 (class 0 OID 0)
-- Dependencies: 316
-- Name: txtemplatesgroups; Type: ACL; Schema: fincfg; Owner: fincfg
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE txtemplatesgroups TO finuiuser;


--
-- TOC entry 4437 (class 0 OID 0)
-- Dependencies: 249
-- Name: useractioncodes; Type: ACL; Schema: fincfg; Owner: fincfg
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE useractioncodes TO finuiuser;


--
-- TOC entry 4438 (class 0 OID 0)
-- Dependencies: 250
-- Name: useractionmaps; Type: ACL; Schema: fincfg; Owner: fincfg
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE useractionmaps TO finuiuser;


--
-- TOC entry 4439 (class 0 OID 0)
-- Dependencies: 251
-- Name: useractions; Type: ACL; Schema: fincfg; Owner: fincfg
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE useractions TO finuiuser;


--
-- TOC entry 4440 (class 0 OID 0)
-- Dependencies: 252
-- Name: userdefinedroles; Type: ACL; Schema: fincfg; Owner: fincfg
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE userdefinedroles TO finuiuser;


--
-- TOC entry 4441 (class 0 OID 0)
-- Dependencies: 253
-- Name: userrolesmaps; Type: ACL; Schema: fincfg; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE userrolesmaps TO finuiuser;


--
-- TOC entry 4442 (class 0 OID 0)
-- Dependencies: 254
-- Name: users; Type: ACL; Schema: fincfg; Owner: fincfg
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE users TO finuiuser;


--
-- TOC entry 4443 (class 0 OID 0)
-- Dependencies: 255
-- Name: versions; Type: ACL; Schema: fincfg; Owner: fincfg
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE versions TO finuiuser;


--
-- TOC entry 2261 (class 826 OID 85494)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: fincfg; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA fincfg REVOKE ALL ON TABLES  FROM postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA fincfg GRANT SELECT ON TABLES  TO finuiuser;


-- Completed on 2020-03-11 18:41:26

--
-- PostgreSQL database dump complete
--

