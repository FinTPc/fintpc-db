
SET default_tablespace = '';

SET default_with_oids = true;

--
-- TOC entry 256 (class 1259 OID 62928)
-- Name: batchjobs; Type: TABLE; Schema: findata; Owner: findata
--

CREATE TABLE batchjobs (
    initialbatchid character varying(35) NOT NULL,
    userid integer NOT NULL,
    messagecount integer NOT NULL,
    amount character varying(20) NOT NULL,
    batchid character varying(35) NOT NULL,
    currentmessagecount integer NOT NULL,
    status integer NOT NULL,
    insertdate timestamp without time zone NOT NULL,
    routingpoint character varying(50) NOT NULL,
    reason character varying(500),
    finalamount numeric(20,2),
    batchtype character varying(50),
    batchuid character varying(32)
);


ALTER TABLE batchjobs OWNER TO findata;

--
-- TOC entry 257 (class 1259 OID 62937)
-- Name: batchrequests; Type: TABLE; Schema: findata; Owner: findata
--

CREATE TABLE batchrequests (
    groupkey character varying(100),
    batchuid character varying(35),
    id integer DEFAULT nextval(('findata.batchrequests_requestid_seq'::text)::regclass) NOT NULL,
    userid integer
);


ALTER TABLE batchrequests OWNER TO findata;

--
-- TOC entry 258 (class 1259 OID 62941)
-- Name: batchrequests_requestid_seq; Type: SEQUENCE; Schema: findata; Owner: findata
--

CREATE SEQUENCE batchrequests_requestid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE batchrequests_requestid_seq OWNER TO findata;

--
-- TOC entry 259 (class 1259 OID 62950)
-- Name: commbatchseq; Type: SEQUENCE; Schema: findata; Owner: findata
--

CREATE SEQUENCE commbatchseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9999
    CACHE 1;


ALTER TABLE commbatchseq OWNER TO findata;

--
-- TOC entry 260 (class 1259 OID 62952)
-- Name: entryqueue; Type: TABLE; Schema: findata; Owner: findata
--

CREATE TABLE entryqueue (
    id character varying(30) NOT NULL,
    payload text NOT NULL,
    batchid character varying(35),
    correlationid character varying(30) NOT NULL,
    requestorservice character varying(30) NOT NULL,
    responderservice character varying(30),
    requesttype character varying(30) NOT NULL,
    priority integer DEFAULT 5,
    holdstatus integer DEFAULT 0 NOT NULL,
    sequence integer DEFAULT 0 NOT NULL,
    feedback character varying(40),
    sessionid character varying(30),
    status integer DEFAULT 1,
    queuename character varying(35),
    ioidentifier character(1) DEFAULT 'U'::bpchar NOT NULL
);


ALTER TABLE entryqueue OWNER TO findata;

--
-- TOC entry 261 (class 1259 OID 62963)
-- Name: feedbackagg; Type: TABLE; Schema: findata; Owner: findata
--

CREATE TABLE feedbackagg (
    requestorservice character varying(50),
    mqid character varying(100),
    correlationid character varying(30),
    interfacecode character varying(10),
    networkcode character varying(10),
    correspondentcode character varying(10),
    applicationcode character varying(10),
    payload text,
    swiftmir character varying(30),
    insertdate timestamp without time zone DEFAULT now(),
    batchid character varying(35),
    batchsequence integer,
    reference character varying(35),
    osession character varying(10),
    isession character varying(10),
    issuer character varying,
    obatchid character varying(35),
    backofficecode character varying(10),
    externalid character varying(35),
    sourcefilename character varying(255),
    destinationfilename character varying(255),
    operationdetails character varying(140)
);


ALTER TABLE feedbackagg OWNER TO findata;

SET default_with_oids = false;

--
-- TOC entry 262 (class 1259 OID 62970)
-- Name: history; Type: TABLE; Schema: findata; Owner: findata
--

CREATE TABLE history (
    id character varying(30) NOT NULL,
    payload text NOT NULL,
    batchid character varying(35),
    correlationid character varying(30) NOT NULL,
    sessionid character varying(30),
    requestorservice character varying(30) NOT NULL,
    responderservice character varying(30),
    requesttype character varying(30) NOT NULL,
    priority integer DEFAULT 5 NOT NULL,
    holdstatus integer DEFAULT 1 NOT NULL,
    sequence integer DEFAULT 0,
    insertdate timestamp without time zone,
    feedback character varying(40)
);


ALTER TABLE history OWNER TO findata;

--
-- TOC entry 263 (class 1259 OID 62979)
-- Name: messagehashes; Type: TABLE; Schema: findata; Owner: findata
--

CREATE TABLE messagehashes (
    servicename character varying(35) NOT NULL,
    routedmessageid character varying(30) NOT NULL,
    hash character varying(32) NOT NULL,
    insertdate timestamp without time zone NOT NULL,
    receivingorder integer DEFAULT 1 NOT NULL
);


ALTER TABLE messagehashes OWNER TO findata;

SET default_tablespace = findatatbs;

SET default_with_oids = true;

--
-- TOC entry 265 (class 1259 OID 63046)
-- Name: mtbktocstmrdbtcdttab; Type: TABLE; Schema: findata; Owner: findata; Tablespace: findatatbs
--

CREATE TABLE mtbktocstmrdbtcdttab (
    correlationid character varying(30) NOT NULL,
    messagetype character varying(50) NOT NULL,
    valuedate character varying(6),
    amount character varying(50),
    currency character varying(3),
    accountnumber character varying(35) NOT NULL,
    statementnumber character varying(18),
    statementreference character varying(35) NOT NULL,
    openbalancedate character varying(6),
    closebalancedate character varying(6),
    trxmark character varying(5),
    name character varying(140),
    remittanceinfo character varying(500),
    CONSTRAINT ch_accno_notempty CHECK (((accountnumber)::text <> ''::text))
);


ALTER TABLE mtbktocstmrdbtcdttab OWNER TO findata;

SET default_tablespace = '';

--
-- TOC entry 264 (class 1259 OID 62986)
-- Name: routedmessages; Type: TABLE; Schema: findata; Owner: findata
--

CREATE TABLE routedmessages (
    id character varying(30) NOT NULL,
    correlationid character varying(30),
    insertdate timestamp without time zone DEFAULT now(),
    ack integer DEFAULT 0,
    messagetype character varying(50),
    currentqueue integer,
    sender character varying(70),
    receiver character varying(70),
    reference character varying(35) NOT NULL,
    requestorservice character varying(35),
    responderservice character varying(35),
    userid integer,
    amount character varying(50),
    updatedate timestamp without time zone DEFAULT now(),
    entity character varying(35),
    ioidentifier character(1) DEFAULT 'U'::bpchar NOT NULL,
    paymentid character varying(50)
);


ALTER TABLE routedmessages OWNER TO findata;

--
-- TOC entry 304 (class 1259 OID 172616)
-- Name: mtbktocstmrdbtcdtview; Type: VIEW; Schema: findata; Owner: findata
--

CREATE VIEW mtbktocstmrdbtcdtview AS
 SELECT eq.id,
    rm.messagetype,
    rm.sender,
    rm.receiver,
    rm.reference,
    rm.requestorservice,
    rm.insertdate,
    mt.accountnumber,
    mt.trxmark,
    mt.currency,
    mt.valuedate,
    to_number(
        CASE
            WHEN (rtrim((mt.amount)::text) IS NULL) THEN '0,00'::text
            WHEN (rtrim((mt.amount)::text) = ''::text) THEN '0,00'::text
            WHEN (rtrim((mt.amount)::text) = ','::text) THEN '0,00'::text
            ELSE replace(rtrim((mt.amount)::text), ','::text, '.'::text)
        END, 'FM99999999999999999D99'::text) AS amount,
    eq.queuename,
    eq.payload,
    rm.entity
   FROM ((( SELECT routedmessages.messagetype,
            routedmessages.sender,
            routedmessages.receiver,
            routedmessages.reference,
            routedmessages.correlationid,
            routedmessages.insertdate,
            routedmessages.requestorservice,
            routedmessages.entity
           FROM routedmessages
          WHERE ((routedmessages.currentqueue IS NOT NULL) AND ((routedmessages.messagetype)::text = 'BkToCstmrDbtCdtNtfctn'::text))) rm
     LEFT JOIN ( SELECT mtbktocstmrdbtcdttab.correlationid,
            mtbktocstmrdbtcdttab.accountnumber,
            mtbktocstmrdbtcdttab.trxmark,
            mtbktocstmrdbtcdttab.currency,
            mtbktocstmrdbtcdttab.valuedate,
            mtbktocstmrdbtcdttab.amount
           FROM mtbktocstmrdbtcdttab) mt ON (((rm.correlationid)::text = (mt.correlationid)::text)))
     LEFT JOIN ( SELECT entryqueue.id,
            entryqueue.correlationid,
            entryqueue.queuename,
            entryqueue.payload
           FROM entryqueue) eq ON (((mt.correlationid)::text = (eq.correlationid)::text)));


ALTER TABLE mtbktocstmrdbtcdtview OWNER TO findata;

--
-- TOC entry 266 (class 1259 OID 63057)
-- Name: mtcdttrfinitnothrtab; Type: TABLE; Schema: findata; Owner: findata
--

CREATE TABLE mtcdttrfinitnothrtab (
    correlationid character varying(30) NOT NULL,
    messagetype character varying(50),
    endtoendid character varying(35),
    dbtcustomername character varying(70),
    dbtaccount character varying(35),
    orderingbank character varying(12),
    amount character varying(50),
    currency character varying(3),
    valuedate character varying(6),
    accountingcode character varying(35),
    locationcode character varying(35),
    budgetcode character varying(35),
    cdtcustomername character varying(70),
    cdtaccount character varying(35),
    beneficiarybank character varying(12),
    remittanceinfo character varying(140)
);


ALTER TABLE mtcdttrfinitnothrtab OWNER TO findata;

--
-- TOC entry 309 (class 1259 OID 173814)
-- Name: mtcdttrfinitnothrview; Type: VIEW; Schema: findata; Owner: findata
--

CREATE VIEW mtcdttrfinitnothrview AS
 SELECT eq.id,
    rm.messagetype,
    rm.sender,
    rm.receiver,
    rm.reference,
    rm.requestorservice,
    rm.insertdate,
    mt.orderingbank,
    mt.dbtaccount,
    mt.endtoendid,
    mt.cdtcustomername,
    mt.beneficiarybank,
    mt.cdtaccount,
    mt.currency,
    mt.valuedate,
    to_char(to_number(
        CASE
            WHEN (rtrim((mt.amount)::text) IS NULL) THEN '0,00'::text
            WHEN (rtrim((mt.amount)::text) = ''::text) THEN '0,00'::text
            WHEN (rtrim((mt.amount)::text) = ','::text) THEN '0,00'::text
            ELSE replace(rtrim((mt.amount)::text), ','::text, '.'::text)
        END, 'FM99999999999999999D99'::text), '9999999999999D99'::text) AS amount,
    eq.queuename,
    eq.payload,
    rm.entity
   FROM ((( SELECT routedmessages.messagetype,
            routedmessages.sender,
            routedmessages.receiver,
            routedmessages.reference,
            routedmessages.correlationid,
            routedmessages.insertdate,
            routedmessages.requestorservice,
            routedmessages.entity
           FROM routedmessages
          WHERE ((routedmessages.currentqueue IS NOT NULL) AND ((routedmessages.messagetype)::text = 'CstmrCdtTrfInitnOthr'::text))) rm
     LEFT JOIN ( SELECT mtcdttrfinitnothrtab.correlationid,
            mtcdttrfinitnothrtab.orderingbank,
            mtcdttrfinitnothrtab.dbtaccount,
            mtcdttrfinitnothrtab.endtoendid,
            mtcdttrfinitnothrtab.cdtcustomername,
            mtcdttrfinitnothrtab.beneficiarybank,
            mtcdttrfinitnothrtab.cdtaccount,
            mtcdttrfinitnothrtab.currency,
            mtcdttrfinitnothrtab.valuedate,
            mtcdttrfinitnothrtab.amount
           FROM mtcdttrfinitnothrtab) mt ON (((rm.correlationid)::text = (mt.correlationid)::text)))
     LEFT JOIN ( SELECT entryqueue.id,
            entryqueue.correlationid,
            entryqueue.queuename,
            entryqueue.payload
           FROM entryqueue) eq ON (((mt.correlationid)::text = (eq.correlationid)::text)));


ALTER TABLE mtcdttrfinitnothrview OWNER TO findata;

--
-- TOC entry 267 (class 1259 OID 63068)
-- Name: mtcdttrfinitnsalatab; Type: TABLE; Schema: findata; Owner: findata
--

CREATE TABLE mtcdttrfinitnsalatab (
    correlationid character varying(30) NOT NULL,
    messagetype character varying(50),
    endtoendid character varying(35),
    dbtcustomername character varying(70),
    dbtaccount character varying(35),
    orderingbank character varying(12),
    amount character varying(50),
    currency character varying(3),
    valuedate character varying(6),
    accountingcode character varying(35),
    locationcode character varying(35),
    budgetcode character varying(35),
    cdtcustomername character varying(70),
    cdtaccount character varying(35),
    beneficiarybank character varying(12),
    remittanceinfo character varying(140)
);


ALTER TABLE mtcdttrfinitnsalatab OWNER TO findata;

--
-- TOC entry 306 (class 1259 OID 173157)
-- Name: mtcdttrfinitnsalaview; Type: VIEW; Schema: findata; Owner: findata
--

CREATE VIEW mtcdttrfinitnsalaview AS
 SELECT eq.id,
    rm.messagetype,
    rm.sender,
    rm.receiver,
    rm.reference,
    rm.requestorservice,
    rm.insertdate,
    mt.orderingbank,
    mt.dbtaccount,
    mt.endtoendid,
    mt.cdtcustomername,
    mt.beneficiarybank,
    mt.cdtaccount,
    mt.currency,
    mt.valuedate,
    to_char(to_number(
        CASE
            WHEN (rtrim((mt.amount)::text) IS NULL) THEN '0,00'::text
            WHEN (rtrim((mt.amount)::text) = ''::text) THEN '0,00'::text
            WHEN (rtrim((mt.amount)::text) = ','::text) THEN '0,00'::text
            ELSE replace(rtrim((mt.amount)::text), ','::text, '.'::text)
        END, 'FM99999999999999999D99'::text), '9999999999999D99'::text) AS amount,
    eq.queuename,
    eq.payload,
    rm.entity
   FROM ((( SELECT routedmessages.messagetype,
            routedmessages.sender,
            routedmessages.receiver,
            routedmessages.reference,
            routedmessages.correlationid,
            routedmessages.insertdate,
            routedmessages.requestorservice,
            routedmessages.entity
           FROM routedmessages
          WHERE ((routedmessages.currentqueue IS NOT NULL) AND ((routedmessages.messagetype)::text = 'CstmrCdtTrfInitnSala'::text))) rm
     LEFT JOIN ( SELECT mtcdttrfinitnsalatab.correlationid,
            mtcdttrfinitnsalatab.orderingbank,
            mtcdttrfinitnsalatab.dbtaccount,
            mtcdttrfinitnsalatab.endtoendid,
            mtcdttrfinitnsalatab.cdtcustomername,
            mtcdttrfinitnsalatab.beneficiarybank,
            mtcdttrfinitnsalatab.cdtaccount,
            mtcdttrfinitnsalatab.currency,
            mtcdttrfinitnsalatab.valuedate,
            mtcdttrfinitnsalatab.amount
           FROM mtcdttrfinitnsalatab) mt ON (((rm.correlationid)::text = (mt.correlationid)::text)))
     LEFT JOIN ( SELECT entryqueue.id,
            entryqueue.correlationid,
            entryqueue.queuename,
            entryqueue.payload
           FROM entryqueue) eq ON (((mt.correlationid)::text = (eq.correlationid)::text)));


ALTER TABLE mtcdttrfinitnsalaview OWNER TO findata;

--
-- TOC entry 268 (class 1259 OID 63079)
-- Name: mtcdttrfinitnsupptab; Type: TABLE; Schema: findata; Owner: findata
--

CREATE TABLE mtcdttrfinitnsupptab (
    correlationid character varying(30) NOT NULL,
    messagetype character varying(50),
    endtoendid character varying(35),
    dbtcustomername character varying(70),
    dbtaccount character varying(35),
    orderingbank character varying(12),
    amount character varying(50),
    currency character varying(3),
    valuedate character varying(6),
    accountingcode character varying(35),
    locationcode character varying(35),
    budgetcode character varying(35),
    cdtcustomername character varying(70),
    cdtaccount character varying(35),
    beneficiarybank character varying(12),
    remittanceinfo character varying(140)
);


ALTER TABLE mtcdttrfinitnsupptab OWNER TO findata;

--
-- TOC entry 307 (class 1259 OID 173162)
-- Name: mtcdttrfinitnsuppview; Type: VIEW; Schema: findata; Owner: findata
--

CREATE VIEW mtcdttrfinitnsuppview AS
 SELECT eq.id,
    rm.messagetype,
    rm.sender,
    rm.receiver,
    rm.reference,
    rm.requestorservice,
    rm.insertdate,
    mt.orderingbank,
    mt.dbtaccount,
    mt.endtoendid,
    mt.cdtcustomername,
    mt.beneficiarybank,
    mt.cdtaccount,
    mt.currency,
    mt.valuedate,
    to_char(to_number(
        CASE
            WHEN (rtrim((mt.amount)::text) IS NULL) THEN '0,00'::text
            WHEN (rtrim((mt.amount)::text) = ''::text) THEN '0,00'::text
            WHEN (rtrim((mt.amount)::text) = ','::text) THEN '0,00'::text
            ELSE replace(rtrim((mt.amount)::text), ','::text, '.'::text)
        END, 'FM99999999999999999D99'::text), '9999999999999D99'::text) AS amount,
    eq.queuename,
    eq.payload,
    rm.entity
   FROM ((( SELECT routedmessages.messagetype,
            routedmessages.sender,
            routedmessages.receiver,
            routedmessages.reference,
            routedmessages.correlationid,
            routedmessages.insertdate,
            routedmessages.requestorservice,
            routedmessages.entity
           FROM routedmessages
          WHERE ((routedmessages.currentqueue IS NOT NULL) AND ((routedmessages.messagetype)::text = 'CstmrCdtTrfInitnSupp'::text))) rm
     LEFT JOIN ( SELECT mtcdttrfinitnsupptab.correlationid,
            mtcdttrfinitnsupptab.orderingbank,
            mtcdttrfinitnsupptab.dbtaccount,
            mtcdttrfinitnsupptab.endtoendid,
            mtcdttrfinitnsupptab.cdtcustomername,
            mtcdttrfinitnsupptab.beneficiarybank,
            mtcdttrfinitnsupptab.cdtaccount,
            mtcdttrfinitnsupptab.currency,
            mtcdttrfinitnsupptab.valuedate,
            mtcdttrfinitnsupptab.amount
           FROM mtcdttrfinitnsupptab) mt ON (((rm.correlationid)::text = (mt.correlationid)::text)))
     LEFT JOIN ( SELECT entryqueue.id,
            entryqueue.correlationid,
            entryqueue.queuename,
            entryqueue.payload
           FROM entryqueue) eq ON (((mt.correlationid)::text = (eq.correlationid)::text)));


ALTER TABLE mtcdttrfinitnsuppview OWNER TO findata;

--
-- TOC entry 269 (class 1259 OID 63090)
-- Name: mtcdttrfinitntaxstab; Type: TABLE; Schema: findata; Owner: findata
--

CREATE TABLE mtcdttrfinitntaxstab (
    correlationid character varying(30) NOT NULL,
    messagetype character varying(50),
    endtoendid character varying(35),
    dbtcustomername character varying(70),
    dbtaccount character varying(35),
    orderingbank character varying(12),
    amount character varying(50),
    currency character varying(3),
    valuedate character varying(6),
    accountingcode character varying(35),
    locationcode character varying(35),
    budgetcode character varying(35),
    cdtcustomername character varying(70),
    cdtaccount character varying(35),
    beneficiarybank character varying(12),
    sourcefilename character varying(50),
    remittanceinfo character varying(140)
);


ALTER TABLE mtcdttrfinitntaxstab OWNER TO findata;

--
-- TOC entry 308 (class 1259 OID 173167)
-- Name: mtcdttrfinitntaxsview; Type: VIEW; Schema: findata; Owner: findata
--

CREATE VIEW mtcdttrfinitntaxsview AS
 SELECT eq.id,
    rm.messagetype,
    rm.sender,
    rm.receiver,
    rm.reference,
    rm.requestorservice,
    rm.insertdate,
    mt.orderingbank,
    mt.dbtaccount,
    mt.endtoendid,
    mt.cdtcustomername,
    mt.beneficiarybank,
    mt.cdtaccount,
    mt.currency,
    mt.valuedate,
    to_char(to_number(
        CASE
            WHEN (rtrim((mt.amount)::text) IS NULL) THEN '0,00'::text
            WHEN (rtrim((mt.amount)::text) = ''::text) THEN '0,00'::text
            WHEN (rtrim((mt.amount)::text) = ','::text) THEN '0,00'::text
            ELSE replace(rtrim((mt.amount)::text), ','::text, '.'::text)
        END, 'FM99999999999999999D99'::text), '9999999999999D99'::text) AS amount,
    eq.queuename,
    eq.payload,
    rm.entity
   FROM ((( SELECT routedmessages.messagetype,
            routedmessages.sender,
            routedmessages.receiver,
            routedmessages.reference,
            routedmessages.correlationid,
            routedmessages.insertdate,
            routedmessages.requestorservice,
            routedmessages.entity
           FROM routedmessages
          WHERE ((routedmessages.currentqueue IS NOT NULL) AND ((routedmessages.messagetype)::text = 'CstmrCdtTrfInitnTaxs'::text))) rm
     LEFT JOIN ( SELECT mtcdttrfinitntaxstab.correlationid,
            mtcdttrfinitntaxstab.orderingbank,
            mtcdttrfinitntaxstab.dbtaccount,
            mtcdttrfinitntaxstab.endtoendid,
            mtcdttrfinitntaxstab.cdtcustomername,
            mtcdttrfinitntaxstab.beneficiarybank,
            mtcdttrfinitntaxstab.cdtaccount,
            mtcdttrfinitntaxstab.currency,
            mtcdttrfinitntaxstab.valuedate,
            mtcdttrfinitntaxstab.amount
           FROM mtcdttrfinitntaxstab) mt ON (((rm.correlationid)::text = (mt.correlationid)::text)))
     LEFT JOIN ( SELECT entryqueue.id,
            entryqueue.correlationid,
            entryqueue.queuename,
            entryqueue.payload
           FROM entryqueue) eq ON (((mt.correlationid)::text = (eq.correlationid)::text)));


ALTER TABLE mtcdttrfinitntaxsview OWNER TO findata;

--
-- TOC entry 270 (class 1259 OID 63101)
-- Name: mtcdttrfinitnvatxtab; Type: TABLE; Schema: findata; Owner: findata
--

CREATE TABLE mtcdttrfinitnvatxtab (
    correlationid character varying(30) NOT NULL,
    messagetype character varying(50),
    endtoendid character varying(35),
    dbtcustomername character varying(70),
    dbtaccount character varying(35),
    orderingbank character varying(12),
    amount character varying(50),
    currency character varying(3),
    valuedate character varying(6),
    accountingcode character varying(35),
    locationcode character varying(35),
    budgetcode character varying(35),
    cdtcustomername character varying(70),
    cdtaccount character varying(35),
    beneficiarybank character varying(12),
    remittanceinfo character varying(140)
);


ALTER TABLE mtcdttrfinitnvatxtab OWNER TO findata;

--
-- TOC entry 305 (class 1259 OID 173152)
-- Name: mtcdttrfinitnvatxview; Type: VIEW; Schema: findata; Owner: findata
--

CREATE VIEW mtcdttrfinitnvatxview AS
 SELECT eq.id,
    rm.messagetype,
    rm.sender,
    rm.receiver,
    rm.reference,
    rm.requestorservice,
    rm.insertdate,
    mt.orderingbank,
    mt.dbtaccount,
    mt.endtoendid,
    mt.cdtcustomername,
    mt.beneficiarybank,
    mt.cdtaccount,
    mt.currency,
    mt.valuedate,
    to_char(to_number(
        CASE
            WHEN (rtrim((mt.amount)::text) IS NULL) THEN '0,00'::text
            WHEN (rtrim((mt.amount)::text) = ''::text) THEN '0,00'::text
            WHEN (rtrim((mt.amount)::text) = ','::text) THEN '0,00'::text
            ELSE replace(rtrim((mt.amount)::text), ','::text, '.'::text)
        END, 'FM99999999999999999D99'::text), '9999999999999D99'::text) AS amount,
    eq.queuename,
    eq.payload,
    rm.entity
   FROM ((( SELECT routedmessages.messagetype,
            routedmessages.sender,
            routedmessages.receiver,
            routedmessages.reference,
            routedmessages.correlationid,
            routedmessages.insertdate,
            routedmessages.requestorservice,
            routedmessages.entity
           FROM routedmessages
          WHERE ((routedmessages.currentqueue IS NOT NULL) AND ((routedmessages.messagetype)::text = 'CstmrCdtTrfInitnVatx'::text))) rm
     LEFT JOIN ( SELECT mtcdttrfinitnvatxtab.correlationid,
            mtcdttrfinitnvatxtab.orderingbank,
            mtcdttrfinitnvatxtab.dbtaccount,
            mtcdttrfinitnvatxtab.endtoendid,
            mtcdttrfinitnvatxtab.cdtcustomername,
            mtcdttrfinitnvatxtab.beneficiarybank,
            mtcdttrfinitnvatxtab.cdtaccount,
            mtcdttrfinitnvatxtab.currency,
            mtcdttrfinitnvatxtab.valuedate,
            mtcdttrfinitnvatxtab.amount
           FROM mtcdttrfinitnvatxtab) mt ON (((rm.correlationid)::text = (mt.correlationid)::text)))
     LEFT JOIN ( SELECT entryqueue.id,
            entryqueue.correlationid,
            entryqueue.queuename,
            entryqueue.payload
           FROM entryqueue) eq ON (((mt.correlationid)::text = (eq.correlationid)::text)));


ALTER TABLE mtcdttrfinitnvatxview OWNER TO findata;

SET default_with_oids = false;

--
-- TOC entry 300 (class 1259 OID 135533)
-- Name: mtfininvctab; Type: TABLE; Schema: findata; Owner: findata
--

CREATE TABLE mtfininvctab (
    correlationid character varying(30) NOT NULL,
    messagetype character varying(50),
    dbtcustomername character varying(35),
    cdtcustomername character varying(35),
    invoiceno character varying(35),
    invoiceserial character varying(4),
    amount character varying(18),
    currency character varying(3),
    originalreference character varying(35),
    cdtaccount character varying(35),
    maturitydate character varying(6),
    issuancedate character varying(6),
    invoicetype character varying(35)
);


ALTER TABLE mtfininvctab OWNER TO findata;

--
-- TOC entry 303 (class 1259 OID 147269)
-- Name: mtfininvcview; Type: VIEW; Schema: findata; Owner: findata
--

CREATE VIEW mtfininvcview AS
 SELECT eq.id,
    rm.messagetype,
    rm.sender,
    rm.receiver,
    rm.reference,
    rm.requestorservice,
    rm.insertdate,
    eq.queuename,
    eq.payload,
    rm.entity,
    mt.dbtcustomername,
    mt.cdtcustomername,
    mt.invoiceno,
    mt.invoiceserial,
    mt.issuancedate,
    mt.originalreference,
    to_char(to_number(
        CASE
            WHEN (rtrim((mt.amount)::text) IS NULL) THEN '0,00'::text
            WHEN (rtrim((mt.amount)::text) = ''::text) THEN '0,00'::text
            WHEN (rtrim((mt.amount)::text) = ','::text) THEN '0,00'::text
            ELSE replace(rtrim((mt.amount)::text), ','::text, '.'::text)
        END, 'FM99999999999999999D99'::text), '9,999,999,999,999D99'::text) AS amount
   FROM ((( SELECT routedmessages.messagetype,
            routedmessages.sender,
            routedmessages.receiver,
            routedmessages.reference,
            routedmessages.requestorservice,
            routedmessages.insertdate,
            routedmessages.correlationid,
            routedmessages.entity
           FROM routedmessages
          WHERE ((routedmessages.currentqueue IS NOT NULL) AND ((routedmessages.messagetype)::text = 'FinInvc'::text))) rm
     LEFT JOIN ( SELECT mtfininvctab.dbtcustomername,
            mtfininvctab.cdtcustomername,
            mtfininvctab.invoiceno,
            mtfininvctab.invoiceserial,
            mtfininvctab.issuancedate,
            mtfininvctab.originalreference,
            mtfininvctab.correlationid,
            mtfininvctab.amount
           FROM mtfininvctab) mt ON (((rm.correlationid)::text = (mt.correlationid)::text)))
     LEFT JOIN ( SELECT entryqueue.id,
            entryqueue.correlationid,
            entryqueue.queuename,
            entryqueue.payload
           FROM entryqueue) eq ON (((mt.correlationid)::text = (eq.correlationid)::text)));


ALTER TABLE mtfininvcview OWNER TO findata;

--
-- TOC entry 271 (class 1259 OID 63184)
-- Name: mtundefinedview; Type: VIEW; Schema: findata; Owner: postgres
--

CREATE VIEW mtundefinedview AS
 SELECT entryqueue.id,
    entryqueue.batchid,
    entryqueue.requestorservice,
    entryqueue.correlationid,
    entryqueue.queuename,
    entryqueue.payload
   FROM entryqueue
  WHERE (NOT ((entryqueue.correlationid)::text IN ( SELECT routedmessages.correlationid
           FROM routedmessages)));


ALTER TABLE mtundefinedview OWNER TO postgres;

--
-- TOC entry 317 (class 1259 OID 183201)
-- Name: repstatpymt; Type: VIEW; Schema: findata; Owner: findata
--

CREATE VIEW repstatpymt AS
 SELECT fb.correlationid,
    ba.messagetype,
    ba.endtoendid,
    ba.reference,
    ba.dbtcustomername,
    ba.dbtaccount,
    ba.orderingbank,
    ba.amount,
    ba.currency,
    to_char((to_date((ba.valuedate)::text, 'YYMMDD'::text))::timestamp with time zone, 'yyyy-mm-dd'::text) AS valuedate,
    ba.accountingcode,
    ba.locationcode,
    ba.budgetcode,
        CASE
            WHEN (ba.currentqueue IS NOT NULL) THEN "substring"((ba.status)::text, ("position"((ba.status)::text, '~~'::text) + 2))
            ELSE ''::text
        END AS queuename,
        CASE
            WHEN ((ba.status)::text ~~ '%~~%'::text) THEN ("substring"((ba.status)::text, 1, ("position"((ba.status)::text, '~~'::text) - 1)))::character varying
            ELSE ba.status
        END AS status,
    ba.cdtcustomername,
    ba.cdtaccount,
    ba.beneficiarybank,
    fb.sourcefilename,
    fb.destinationfilename,
    ba.remittanceinfo,
    ba.insertdate,
    fb.operationdetails,
    ba.requestorservice,
    ba.paymentid
   FROM (( SELECT fincfg.getmsgtypebusinessname(rm.messagetype) AS messagetype,
            mt.endtoendid,
            rm.reference,
            mt.dbtcustomername,
            mt.dbtaccount,
            mt.orderingbank,
            to_number(
                CASE
                    WHEN (rtrim((mt.amount)::text) IS NULL) THEN '0,00'::text
                    WHEN (rtrim((mt.amount)::text) = ''::text) THEN '0,00'::text
                    WHEN (rtrim((mt.amount)::text) = ','::text) THEN '0,00'::text
                    ELSE replace(rtrim((mt.amount)::text), ','::text, '.'::text)
                END, 'FM99999999999999999D99'::text) AS amount,
            mt.currency,
            mt.valuedate,
            mt.accountingcode,
            mt.locationcode,
            mt.budgetcode,
            mt.correlationid,
            getstatus(rm.correlationid) AS status,
            rm.currentqueue,
            mt.cdtcustomername,
            mt.cdtaccount,
            mt.beneficiarybank,
            mt.remittanceinfo,
            rm.insertdate,
            rm.requestorservice,
            rm.paymentid
           FROM (( SELECT routedmessages.messagetype,
                    routedmessages.reference,
                    routedmessages.correlationid,
                    routedmessages.currentqueue,
                    routedmessages.insertdate,
                    routedmessages.requestorservice,
                    routedmessages.paymentid
                   FROM routedmessages) rm
             JOIN ( SELECT mtcdttrfinitnothrtab.correlationid,
                    mtcdttrfinitnothrtab.endtoendid,
                    mtcdttrfinitnothrtab.dbtcustomername,
                    mtcdttrfinitnothrtab.dbtaccount,
                    mtcdttrfinitnothrtab.orderingbank,
                    mtcdttrfinitnothrtab.amount,
                    mtcdttrfinitnothrtab.currency,
                    mtcdttrfinitnothrtab.valuedate,
                    mtcdttrfinitnothrtab.accountingcode,
                    mtcdttrfinitnothrtab.locationcode,
                    mtcdttrfinitnothrtab.budgetcode,
                    mtcdttrfinitnothrtab.cdtcustomername,
                    mtcdttrfinitnothrtab.cdtaccount,
                    mtcdttrfinitnothrtab.beneficiarybank,
                    mtcdttrfinitnothrtab.remittanceinfo
                   FROM mtcdttrfinitnothrtab
                UNION ALL
                 SELECT mtcdttrfinitnsupptab.correlationid,
                    mtcdttrfinitnsupptab.endtoendid,
                    mtcdttrfinitnsupptab.dbtcustomername,
                    mtcdttrfinitnsupptab.dbtaccount,
                    mtcdttrfinitnsupptab.orderingbank,
                    mtcdttrfinitnsupptab.amount,
                    mtcdttrfinitnsupptab.currency,
                    mtcdttrfinitnsupptab.valuedate,
                    mtcdttrfinitnsupptab.accountingcode,
                    mtcdttrfinitnsupptab.locationcode,
                    mtcdttrfinitnsupptab.budgetcode,
                    mtcdttrfinitnsupptab.cdtcustomername,
                    mtcdttrfinitnsupptab.cdtaccount,
                    mtcdttrfinitnsupptab.beneficiarybank,
                    mtcdttrfinitnsupptab.remittanceinfo
                   FROM mtcdttrfinitnsupptab
                UNION ALL
                 SELECT mtcdttrfinitnsalatab.correlationid,
                    mtcdttrfinitnsalatab.endtoendid,
                    mtcdttrfinitnsalatab.dbtcustomername,
                    mtcdttrfinitnsalatab.dbtaccount,
                    mtcdttrfinitnsalatab.orderingbank,
                    mtcdttrfinitnsalatab.amount,
                    mtcdttrfinitnsalatab.currency,
                    mtcdttrfinitnsalatab.valuedate,
                    mtcdttrfinitnsalatab.accountingcode,
                    mtcdttrfinitnsalatab.locationcode,
                    mtcdttrfinitnsalatab.budgetcode,
                    mtcdttrfinitnsalatab.cdtcustomername,
                    mtcdttrfinitnsalatab.cdtaccount,
                    mtcdttrfinitnsalatab.beneficiarybank,
                    mtcdttrfinitnsalatab.remittanceinfo
                   FROM mtcdttrfinitnsalatab
                UNION ALL
                 SELECT mtcdttrfinitntaxstab.correlationid,
                    mtcdttrfinitntaxstab.endtoendid,
                    mtcdttrfinitntaxstab.dbtcustomername,
                    mtcdttrfinitntaxstab.dbtaccount,
                    mtcdttrfinitntaxstab.orderingbank,
                    mtcdttrfinitntaxstab.amount,
                    mtcdttrfinitntaxstab.currency,
                    mtcdttrfinitntaxstab.valuedate,
                    mtcdttrfinitntaxstab.accountingcode,
                    mtcdttrfinitntaxstab.locationcode,
                    mtcdttrfinitntaxstab.budgetcode,
                    mtcdttrfinitntaxstab.cdtcustomername,
                    mtcdttrfinitntaxstab.cdtaccount,
                    mtcdttrfinitntaxstab.beneficiarybank,
                    mtcdttrfinitntaxstab.remittanceinfo
                   FROM mtcdttrfinitntaxstab
                UNION ALL
                 SELECT mtcdttrfinitnvatxtab.correlationid,
                    mtcdttrfinitnvatxtab.endtoendid,
                    mtcdttrfinitnvatxtab.dbtcustomername,
                    mtcdttrfinitnvatxtab.dbtaccount,
                    mtcdttrfinitnvatxtab.orderingbank,
                    mtcdttrfinitnvatxtab.amount,
                    mtcdttrfinitnvatxtab.currency,
                    mtcdttrfinitnvatxtab.valuedate,
                    mtcdttrfinitnvatxtab.accountingcode,
                    mtcdttrfinitnvatxtab.locationcode,
                    mtcdttrfinitnvatxtab.budgetcode,
                    mtcdttrfinitnvatxtab.cdtcustomername,
                    mtcdttrfinitnvatxtab.cdtaccount,
                    mtcdttrfinitnvatxtab.beneficiarybank,
                    mtcdttrfinitnvatxtab.remittanceinfo
                   FROM mtcdttrfinitnvatxtab) mt ON (((rm.correlationid)::text = (mt.correlationid)::text)))) ba
     LEFT JOIN ( SELECT feedbackagg.correlationid,
            feedbackagg.sourcefilename,
            feedbackagg.destinationfilename,
            feedbackagg.operationdetails
           FROM feedbackagg) fb ON (((ba.correlationid)::text = (fb.correlationid)::text)));


ALTER TABLE repstatpymt OWNER TO findata;

--
-- TOC entry 287 (class 1259 OID 101299)
-- Name: repstatstmt; Type: VIEW; Schema: findata; Owner: findata
--

CREATE VIEW repstatstmt AS
 SELECT fb.correlationid,
    ba.messagetype,
    ba.reference,
    ba.amount,
    ba.currency,
    to_char((to_date((ba.valuedate)::text, 'YYMMDD'::text))::timestamp with time zone, 'yyyy-mm-dd'::text) AS valuedate,
        CASE
            WHEN ((ba.status)::text ~~ '%~~%'::text) THEN ("substring"((ba.status)::text, 1, ("position"((ba.status)::text, '~~'::text) - 1)))::character varying
            ELSE ba.status
        END AS status,
    fb.sourcefilename,
    ba.remittanceinfo,
    ((ba.openbalancedate1 || ' - '::text) || ba.closebalancedate1) AS statementdate,
    ba.statementnumber,
    ba.statementreference,
    ba.name,
    ba.accountnumber,
    ba.trxmark,
    ba.insertdate,
    to_char(ba.insertdate, 'yyyy-mm-dd hh24:mi:ss'::text) AS insertdatech,
    fb.operationdetails,
    ba.requestorservice,
        CASE
            WHEN (ba.currentqueue IS NOT NULL) THEN "substring"((ba.status)::text, ("position"((ba.status)::text, '~~'::text) + 2))
            ELSE ''::text
        END AS queuename,
    fb.destinationfilename,
    ba.openbalancedate1 AS openbalancedate,
    ba.closebalancedate1 AS closebalancedate,
    to_char(ba.amount, '9,999,999,999,999D99'::text) AS amountchar,
    ba.entity
   FROM (( SELECT fincfg.getmsgtypebusinessname(rm.messagetype) AS messagetype,
            rm.reference,
            to_number(
                CASE
                    WHEN (rtrim((mt.amount)::text) IS NULL) THEN '0,00'::text
                    WHEN (rtrim((mt.amount)::text) = ''::text) THEN '0,00'::text
                    WHEN (rtrim((mt.amount)::text) = ','::text) THEN '0,00'::text
                    ELSE replace(rtrim((mt.amount)::text), ','::text, '.'::text)
                END, 'FM99999999999999999D99'::text) AS amount,
            mt.currency,
            mt.valuedate,
            mt.correlationid,
            getstatus(rm.correlationid) AS status,
            mt.remittanceinfo,
            to_char((to_date((mt.openbalancedate)::text, 'YYMMDD'::text))::timestamp with time zone, 'yyyy-mm-dd'::text) AS openbalancedate1,
            to_char((to_date((mt.closebalancedate)::text, 'YYMMDD'::text))::timestamp with time zone, 'yyyy-mm-dd'::text) AS closebalancedate1,
            mt.statementnumber,
            mt.statementreference,
            mt.name,
            mt.accountnumber,
            mt.trxmark,
            rm.insertdate,
            rm.requestorservice,
            rm.currentqueue,
            rm.entity
           FROM (( SELECT routedmessages.messagetype,
                    routedmessages.reference,
                    routedmessages.correlationid,
                    routedmessages.currentqueue,
                    routedmessages.insertdate,
                    routedmessages.requestorservice,
                    routedmessages.entity
                   FROM routedmessages) rm
             JOIN ( SELECT mtbktocstmrdbtcdttab.correlationid,
                    mtbktocstmrdbtcdttab.amount,
                    mtbktocstmrdbtcdttab.currency,
                    mtbktocstmrdbtcdttab.valuedate,
                    mtbktocstmrdbtcdttab.remittanceinfo,
                    mtbktocstmrdbtcdttab.openbalancedate,
                    mtbktocstmrdbtcdttab.closebalancedate,
                    mtbktocstmrdbtcdttab.statementnumber,
                    mtbktocstmrdbtcdttab.statementreference,
                    mtbktocstmrdbtcdttab.name,
                    mtbktocstmrdbtcdttab.accountnumber,
                    mtbktocstmrdbtcdttab.trxmark
                   FROM mtbktocstmrdbtcdttab) mt ON (((rm.correlationid)::text = (mt.correlationid)::text)))) ba
     LEFT JOIN ( SELECT feedbackagg.correlationid,
            feedbackagg.sourcefilename,
            feedbackagg.operationdetails,
            feedbackagg.destinationfilename
           FROM feedbackagg) fb ON (((ba.correlationid)::text = (fb.correlationid)::text)));


ALTER TABLE repstatstmt OWNER TO findata;

--
-- TOC entry 340 (class 1259 OID 183702)
-- Name: repreconpaymentvsstatement; Type: VIEW; Schema: findata; Owner: findata
--

CREATE VIEW repreconpaymentvsstatement AS
 SELECT row_number() OVER () AS id,
    st.statementreference AS stmtstatementreference,
    st.name AS stmtname,
    st.amount AS stmtamount,
    st.currency AS stmtcurrency,
    st.accountnumber AS stmtaccountnumber,
    st.remittanceinfo AS stmtremittanceinfo,
    st.valuedate AS stmtvaluedate,
    st.correlationid AS stmtcorrelationid,
    st.statementnumber AS stmtstatementnumber,
    py.messagetype AS pymtmessagetype,
    py.endtoendid AS pymtendtoendid,
    py.dbtcustomername AS pymtdbtcustomername,
    py.amount AS pymtamount,
    py.currency AS pymtcurrency,
    py.dbtaccount AS pymtdbtaccount,
    py.remittanceinfo AS pymtremittanceinfo,
    py.valuedate AS pymtvaluedate,
    py.cdtcustomername AS pymtcdtcustomername,
    py.cdtaccount AS pymtcdtaccount,
    py.correlationid AS pymtcorrelationid,
        CASE
            WHEN ((st.correlationid IS NOT NULL) AND (py.correlationid IS NOT NULL)) THEN 'Match'::text
            ELSE 'Unmatch'::text
        END AS matchtype
   FROM (( SELECT repstatstmt.correlationid,
            repstatstmt.messagetype,
            repstatstmt.reference,
            repstatstmt.amount,
            repstatstmt.currency,
            repstatstmt.valuedate,
            repstatstmt.status,
            repstatstmt.sourcefilename,
            repstatstmt.remittanceinfo,
            repstatstmt.statementdate,
            repstatstmt.statementnumber,
            repstatstmt.statementreference,
            repstatstmt.name,
            repstatstmt.accountnumber,
            repstatstmt.trxmark,
            repstatstmt.insertdate,
            repstatstmt.operationdetails,
            repstatstmt.requestorservice,
            repstatstmt.queuename,
            repstatstmt.destinationfilename
           FROM repstatstmt
          WHERE ((repstatstmt.trxmark)::text = 'D'::text)) st
     FULL JOIN repstatpymt py ON ((((st.statementreference)::text = (py.endtoendid)::text) AND ((st.name)::text = (py.dbtcustomername)::text) AND ((st.accountnumber)::text = (py.dbtaccount)::text) AND ((st.amount)::text = (py.amount)::text) AND ((st.currency)::text = (py.currency)::text) AND (st.valuedate = py.valuedate))));


ALTER TABLE repreconpaymentvsstatement OWNER TO findata;

--
-- TOC entry 301 (class 1259 OID 135548)
-- Name: repstatinvc; Type: VIEW; Schema: findata; Owner: findata
--

CREATE VIEW repstatinvc AS
 SELECT rm.correlationid,
    rm.insertdate,
    mt.invoicetype,
    rm.reference,
    mt.cdtcustomername,
    mt.dbtcustomername,
    mt.invoiceno,
    mt.invoiceserial,
    to_number(
        CASE
            WHEN (rtrim((mt.amount)::text) IS NULL) THEN '0,00'::text
            WHEN (rtrim((mt.amount)::text) = ''::text) THEN '0,00'::text
            WHEN (rtrim((mt.amount)::text) = ','::text) THEN '0,00'::text
            ELSE replace(rtrim((mt.amount)::text), ','::text, '.'::text)
        END, 'FM99999999999999999D99'::text) AS amount,
    mt.currency,
    mt.originalreference,
    mt.cdtaccount,
    mt.maturitydate,
    rm.entity
   FROM (( SELECT routedmessages.reference,
            routedmessages.insertdate,
            routedmessages.correlationid,
            routedmessages.entity
           FROM routedmessages) rm
     JOIN ( SELECT mtfininvctab.invoicetype,
            mtfininvctab.cdtcustomername,
            mtfininvctab.dbtcustomername,
            mtfininvctab.invoiceno,
            mtfininvctab.invoiceserial,
            mtfininvctab.originalreference,
            mtfininvctab.correlationid,
            mtfininvctab.currency,
            mtfininvctab.cdtaccount,
            mtfininvctab.maturitydate,
            mtfininvctab.amount
           FROM mtfininvctab) mt ON (((rm.correlationid)::text = (mt.correlationid)::text)));


ALTER TABLE repstatinvc OWNER TO findata;

SET default_tablespace = findatatbs;

SET default_with_oids = true;

--
-- TOC entry 272 (class 1259 OID 63218)
-- Name: routingjobs; Type: TABLE; Schema: findata; Owner: tracker_owner; Tablespace: findatatbs
--

CREATE TABLE routingjobs (
    id character varying(30) NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    backout integer DEFAULT 0 NOT NULL,
    priority integer DEFAULT 10 NOT NULL,
    routingpoint character varying(50),
    function character varying(200) NOT NULL,
    userid integer,
    operationdetails character varying(140)
);


ALTER TABLE routingjobs OWNER TO tracker_owner;

SET default_tablespace = '';

--
-- TOC entry 273 (class 1259 OID 63224)
-- Name: serviceperformance; Type: TABLE; Schema: findata; Owner: findata
--

CREATE TABLE serviceperformance (
    serviceid integer NOT NULL,
    insertdate timestamp without time zone NOT NULL,
    mintrxtime integer NOT NULL,
    maxtrxtime integer NOT NULL,
    meantrxtime integer NOT NULL,
    sequenceno numeric(10,0) NOT NULL,
    ioidentifier integer NOT NULL,
    sessionid integer NOT NULL,
    commitedtrx integer,
    abortedtrx integer
);


ALTER TABLE serviceperformance OWNER TO findata;

SET default_with_oids = false;

--
-- TOC entry 274 (class 1259 OID 63227)
-- Name: status; Type: TABLE; Schema: findata; Owner: findata
--

CREATE TABLE status (
    guid character varying(30) NOT NULL,
    service integer NOT NULL,
    correlationid character varying(30) NOT NULL,
    type character varying(20) NOT NULL,
    machine character varying(30) NOT NULL,
    eventdate timestamp without time zone NOT NULL,
    insertdate timestamp without time zone NOT NULL,
    message character varying(256) NOT NULL,
    class character varying(100),
    innerexception character varying(4000),
    additionalinfo character varying(4000),
    sessionid character varying(30)
);


ALTER TABLE status OWNER TO findata;

SET default_with_oids = true;

--
-- TOC entry 275 (class 1259 OID 63233)
-- Name: tempbatchjobs; Type: TABLE; Schema: findata; Owner: findata
--

CREATE TABLE tempbatchjobs (
    id character varying(30) NOT NULL,
    sequence numeric NOT NULL,
    batchid character varying(35) NOT NULL,
    xformitem character varying(4000) NOT NULL,
    correlationid character varying(30),
    feedback character varying(40)
);


ALTER TABLE tempbatchjobs OWNER TO findata;

--
-- TOC entry 4349 (class 0 OID 63233)
-- Dependencies: 275
-- Data for Name: tempbatchjobs; Type: TABLE DATA; Schema: findata; Owner: findata
--

COPY tempbatchjobs (id, sequence, batchid, xformitem, correlationid, feedback) FROM stdin;
\.


--
-- TOC entry 4355 (class 0 OID 0)
-- Dependencies: 258
-- Name: batchrequests_requestid_seq; Type: SEQUENCE SET; Schema: findata; Owner: findata
--

SELECT pg_catalog.setval('batchrequests_requestid_seq', 550, true);


--
-- TOC entry 4356 (class 0 OID 0)
-- Dependencies: 259
-- Name: commbatchseq; Type: SEQUENCE SET; Schema: findata; Owner: findata
--

SELECT pg_catalog.setval('commbatchseq', 672, true);


--
-- TOC entry 4148 (class 2606 OID 85101)
-- Name: batchjobs PK_BJ_BATCHID; Type: CONSTRAINT; Schema: findata; Owner: findata
--

ALTER TABLE ONLY batchjobs
    ADD CONSTRAINT "PK_BJ_BATCHID" PRIMARY KEY (batchid);


--
-- TOC entry 4152 (class 2606 OID 85103)
-- Name: batchrequests PK_BREQ_REQID; Type: CONSTRAINT; Schema: findata; Owner: findata
--

ALTER TABLE ONLY batchrequests
    ADD CONSTRAINT "PK_BREQ_REQID" PRIMARY KEY (id);


--
-- TOC entry 4154 (class 2606 OID 85105)
-- Name: entryqueue PK_EQ_GUID; Type: CONSTRAINT; Schema: findata; Owner: findata
--

ALTER TABLE ONLY entryqueue
    ADD CONSTRAINT "PK_EQ_GUID" PRIMARY KEY (id);


--
-- TOC entry 4159 (class 2606 OID 85107)
-- Name: history PK_HIST_GUID; Type: CONSTRAINT; Schema: findata; Owner: findata
--

ALTER TABLE ONLY history
    ADD CONSTRAINT "PK_HIST_GUID" PRIMARY KEY (id);


SET default_tablespace = findatatbs;

--
-- TOC entry 4167 (class 2606 OID 85121)
-- Name: mtcdttrfinitnothrtab PK_MTCRPPMTGEN_CORRELID; Type: CONSTRAINT; Schema: findata; Owner: findata; Tablespace: findatatbs
--

ALTER TABLE ONLY mtcdttrfinitnothrtab
    ADD CONSTRAINT "PK_MTCRPPMTGEN_CORRELID" PRIMARY KEY (correlationid);


--
-- TOC entry 4171 (class 2606 OID 85123)
-- Name: mtcdttrfinitnsupptab PK_MTCRPPMTINV_CORRELID; Type: CONSTRAINT; Schema: findata; Owner: findata; Tablespace: findatatbs
--

ALTER TABLE ONLY mtcdttrfinitnsupptab
    ADD CONSTRAINT "PK_MTCRPPMTINV_CORRELID" PRIMARY KEY (correlationid);


--
-- TOC entry 4169 (class 2606 OID 85125)
-- Name: mtcdttrfinitnsalatab PK_MTCRPPMTSAL_CORRELID; Type: CONSTRAINT; Schema: findata; Owner: findata; Tablespace: findatatbs
--

ALTER TABLE ONLY mtcdttrfinitnsalatab
    ADD CONSTRAINT "PK_MTCRPPMTSAL_CORRELID" PRIMARY KEY (correlationid);


--
-- TOC entry 4173 (class 2606 OID 85127)
-- Name: mtcdttrfinitntaxstab PK_MTCRPPMTTAXDUT_CORRELID; Type: CONSTRAINT; Schema: findata; Owner: findata; Tablespace: findatatbs
--

ALTER TABLE ONLY mtcdttrfinitntaxstab
    ADD CONSTRAINT "PK_MTCRPPMTTAXDUT_CORRELID" PRIMARY KEY (correlationid);


--
-- TOC entry 4175 (class 2606 OID 85129)
-- Name: mtcdttrfinitnvatxtab PK_MTCRPPMTVAT_CORRELID; Type: CONSTRAINT; Schema: findata; Owner: findata; Tablespace: findatatbs
--

ALTER TABLE ONLY mtcdttrfinitnvatxtab
    ADD CONSTRAINT "PK_MTCRPPMTVAT_CORRELID" PRIMARY KEY (correlationid);


SET default_tablespace = '';

--
-- TOC entry 4184 (class 2606 OID 135537)
-- Name: mtfininvctab PK_MTFININVC_CORRELID; Type: CONSTRAINT; Schema: findata; Owner: findata
--

ALTER TABLE ONLY mtfininvctab
    ADD CONSTRAINT "PK_MTFININVC_CORRELID" PRIMARY KEY (correlationid);


--
-- TOC entry 4177 (class 2606 OID 85149)
-- Name: routingjobs PK_RJ_GUID; Type: CONSTRAINT; Schema: findata; Owner: tracker_owner
--

ALTER TABLE ONLY routingjobs
    ADD CONSTRAINT "PK_RJ_GUID" PRIMARY KEY (id);


--
-- TOC entry 4161 (class 2606 OID 85151)
-- Name: routedmessages PK_RM_GUID; Type: CONSTRAINT; Schema: findata; Owner: findata
--

ALTER TABLE ONLY routedmessages
    ADD CONSTRAINT "PK_RM_GUID" PRIMARY KEY (id);


--
-- TOC entry 4179 (class 2606 OID 85153)
-- Name: serviceperformance PK_SERVPERF_SERVID; Type: CONSTRAINT; Schema: findata; Owner: findata
--

ALTER TABLE ONLY serviceperformance
    ADD CONSTRAINT "PK_SERVPERF_SERVID" PRIMARY KEY (serviceid);


--
-- TOC entry 4181 (class 2606 OID 85155)
-- Name: status PK_STS_GUID; Type: CONSTRAINT; Schema: findata; Owner: findata
--

ALTER TABLE ONLY status
    ADD CONSTRAINT "PK_STS_GUID" PRIMARY KEY (guid);


--
-- TOC entry 4150 (class 2606 OID 85157)
-- Name: batchjobs UK_BJ_CONST; Type: CONSTRAINT; Schema: findata; Owner: findata
--

ALTER TABLE ONLY batchjobs
    ADD CONSTRAINT "UK_BJ_CONST" UNIQUE (initialbatchid, userid, messagecount, amount, batchuid);


--
-- TOC entry 4156 (class 2606 OID 85159)
-- Name: entryqueue UK_EQ_CORRELID; Type: CONSTRAINT; Schema: findata; Owner: findata
--

ALTER TABLE ONLY entryqueue
    ADD CONSTRAINT "UK_EQ_CORRELID" UNIQUE (correlationid);


--
-- TOC entry 4163 (class 2606 OID 85161)
-- Name: routedmessages UK_RM_CORRELID; Type: CONSTRAINT; Schema: findata; Owner: findata
--

ALTER TABLE ONLY routedmessages
    ADD CONSTRAINT "UK_RM_CORRELID" UNIQUE (correlationid);


SET default_tablespace = findatatbs;

--
-- TOC entry 4165 (class 2606 OID 85163)
-- Name: mtbktocstmrdbtcdttab pk_mtbkcstmr_correlid; Type: CONSTRAINT; Schema: findata; Owner: findata; Tablespace: findatatbs
--

ALTER TABLE ONLY mtbktocstmrdbtcdttab
    ADD CONSTRAINT pk_mtbkcstmr_correlid PRIMARY KEY (correlationid);


SET default_tablespace = '';

--
-- TOC entry 4157 (class 1259 OID 85190)
-- Name: UK_FB_CORRELID; Type: INDEX; Schema: findata; Owner: findata
--

CREATE UNIQUE INDEX "UK_FB_CORRELID" ON findata.feedbackagg USING btree (correlationid);


--
-- TOC entry 4182 (class 1259 OID 85191)
-- Name: idx_status; Type: INDEX; Schema: findata; Owner: findata
--

CREATE INDEX idx_status ON findata.status USING btree (correlationid);


--
-- TOC entry 4196 (class 2620 OID 101648)
-- Name: routingjobs trackerwatcher; Type: TRIGGER; Schema: findata; Owner: tracker_owner
--

CREATE TRIGGER trackerwatcher BEFORE DELETE ON findata.routingjobs FOR EACH ROW EXECUTE PROCEDURE trg_saveprocjob();


--
-- TOC entry 4195 (class 2620 OID 85198)
-- Name: entryqueue trgaientryqueue; Type: TRIGGER; Schema: findata; Owner: findata
--

CREATE TRIGGER trgaientryqueue AFTER INSERT ON findata.entryqueue FOR EACH ROW EXECUTE PROCEDURE trg_insertroutingjob();


--
-- TOC entry 4185 (class 2606 OID 85329)
-- Name: batchjobs FK_BJ_U_UID; Type: FK CONSTRAINT; Schema: findata; Owner: findata
--

ALTER TABLE ONLY batchjobs
    ADD CONSTRAINT "FK_BJ_U_UID" FOREIGN KEY (userid) REFERENCES fincfg.users(id);


--
-- TOC entry 4186 (class 2606 OID 85334)
-- Name: batchrequests FK_BREQ_U_ID; Type: FK CONSTRAINT; Schema: findata; Owner: findata
--

ALTER TABLE ONLY batchrequests
    ADD CONSTRAINT "FK_BREQ_U_ID" FOREIGN KEY (userid) REFERENCES fincfg.users(id);


--
-- TOC entry 4188 (class 2606 OID 98331)
-- Name: mtcdttrfinitnothrtab FK_MTCRPPMTGEN_RM_CORRELID; Type: FK CONSTRAINT; Schema: findata; Owner: findata
--

ALTER TABLE ONLY mtcdttrfinitnothrtab
    ADD CONSTRAINT "FK_MTCRPPMTGEN_RM_CORRELID" FOREIGN KEY (correlationid) REFERENCES routedmessages(correlationid) ON DELETE CASCADE;


--
-- TOC entry 4190 (class 2606 OID 98341)
-- Name: mtcdttrfinitnsupptab FK_MTCRPPMTINV_RM_CORRELID; Type: FK CONSTRAINT; Schema: findata; Owner: findata
--

ALTER TABLE ONLY mtcdttrfinitnsupptab
    ADD CONSTRAINT "FK_MTCRPPMTINV_RM_CORRELID" FOREIGN KEY (correlationid) REFERENCES routedmessages(correlationid) ON DELETE CASCADE;


--
-- TOC entry 4189 (class 2606 OID 98336)
-- Name: mtcdttrfinitnsalatab FK_MTCRPPMTSAL_RM_CORRELID; Type: FK CONSTRAINT; Schema: findata; Owner: findata
--

ALTER TABLE ONLY mtcdttrfinitnsalatab
    ADD CONSTRAINT "FK_MTCRPPMTSAL_RM_CORRELID" FOREIGN KEY (correlationid) REFERENCES routedmessages(correlationid) ON DELETE CASCADE;


--
-- TOC entry 4191 (class 2606 OID 98321)
-- Name: mtcdttrfinitntaxstab FK_MTCRPPMTTAXDUT_RM_CORRELID; Type: FK CONSTRAINT; Schema: findata; Owner: findata
--

ALTER TABLE ONLY mtcdttrfinitntaxstab
    ADD CONSTRAINT "FK_MTCRPPMTTAXDUT_RM_CORRELID" FOREIGN KEY (correlationid) REFERENCES routedmessages(correlationid) ON DELETE CASCADE;


--
-- TOC entry 4192 (class 2606 OID 98326)
-- Name: mtcdttrfinitnvatxtab FK_MTCRPPMTVAT_RM_CORRELID; Type: FK CONSTRAINT; Schema: findata; Owner: findata
--

ALTER TABLE ONLY mtcdttrfinitnvatxtab
    ADD CONSTRAINT "FK_MTCRPPMTVAT_RM_CORRELID" FOREIGN KEY (correlationid) REFERENCES routedmessages(correlationid) ON DELETE CASCADE;


--
-- TOC entry 4194 (class 2606 OID 135538)
-- Name: mtfininvctab FK_MTFININVC_RM_CORRELID; Type: FK CONSTRAINT; Schema: findata; Owner: findata
--

ALTER TABLE ONLY mtfininvctab
    ADD CONSTRAINT "FK_MTFININVC_RM_CORRELID" FOREIGN KEY (correlationid) REFERENCES routedmessages(correlationid);


--
-- TOC entry 4193 (class 2606 OID 85439)
-- Name: tempbatchjobs FK_TBJ_BJ_BATCHID; Type: FK CONSTRAINT; Schema: findata; Owner: findata
--

ALTER TABLE ONLY tempbatchjobs
    ADD CONSTRAINT "FK_TBJ_BJ_BATCHID" FOREIGN KEY (batchid) REFERENCES batchjobs(batchid);


--
-- TOC entry 4187 (class 2606 OID 85444)
-- Name: mtbktocstmrdbtcdttab fk_mtbkcstmr_rm_correlid; Type: FK CONSTRAINT; Schema: findata; Owner: findata
--

ALTER TABLE ONLY mtbktocstmrdbtcdttab
    ADD CONSTRAINT fk_mtbkcstmr_rm_correlid FOREIGN KEY (correlationid) REFERENCES routedmessages(correlationid);


-- Completed on 2020-03-11 18:25:38

--
-- PostgreSQL database dump complete
--

