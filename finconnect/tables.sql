--
-- PostgreSQL database dump
--

-- Dumped from database version 10.5
-- Dumped by pg_dump version 10.1

-- Started on 2020-03-11 18:47:34

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 11 (class 2615 OID 183212)
-- Name: finconnect; Type: SCHEMA; Schema: -; Owner: finconnect
--

CREATE SCHEMA finconnect;


ALTER SCHEMA finconnect OWNER TO finconnect;

SET search_path = finconnect, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 319 (class 1259 OID 183215)
-- Name: authorization_servers; Type: TABLE; Schema: finconnect; Owner: finconnect
--

CREATE TABLE authorization_servers (
    id integer NOT NULL,
    client_id character varying(50) NOT NULL,
    client_secret character varying(255) NOT NULL,
    user_id character varying(50) NOT NULL,
    user_secret character varying(255),
    access_token_uri character varying(255),
    user_authorization_uri character varying(255),
    redirect_uri character varying(255),
    user_info_uri character varying(255),
    expiration_date timestamp without time zone,
    grant_type character varying(255),
    authentication_scheme character varying(50),
    client_authentication_scheme character varying(50),
    token character varying(4096),
    bic character varying(255),
    resource_server_uri character varying(150),
    token_refresh character varying(4096),
    time_trigger character varying
);


ALTER TABLE authorization_servers OWNER TO finconnect;

--
-- TOC entry 318 (class 1259 OID 183213)
-- Name: authorization_servers_id_seq; Type: SEQUENCE; Schema: finconnect; Owner: finconnect
--

CREATE SEQUENCE authorization_servers_id_seq
    START WITH 4
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE authorization_servers_id_seq OWNER TO finconnect;

--
-- TOC entry 320 (class 1259 OID 183223)
-- Name: consents; Type: TABLE; Schema: finconnect; Owner: finconnect
--

CREATE TABLE consents (
    url character varying(100),
    bic character varying(11) NOT NULL,
    consent_id character varying(100),
    valid_until character varying(100)
);


ALTER TABLE consents OWNER TO finconnect;

--
-- TOC entry 323 (class 1259 OID 183279)
-- Name: qrtz_blob_triggers; Type: TABLE; Schema: finconnect; Owner: finconnect
--

CREATE TABLE qrtz_blob_triggers (
    sched_name character varying(120) NOT NULL,
    trigger_name character varying(200) NOT NULL,
    trigger_group character varying(200) NOT NULL,
    blob_data bytea
);


ALTER TABLE qrtz_blob_triggers OWNER TO finconnect;

--
-- TOC entry 324 (class 1259 OID 183292)
-- Name: qrtz_calendars; Type: TABLE; Schema: finconnect; Owner: finconnect
--

CREATE TABLE qrtz_calendars (
    sched_name character varying(120) NOT NULL,
    calendar_name character varying(200) NOT NULL,
    calendar bytea NOT NULL
);


ALTER TABLE qrtz_calendars OWNER TO finconnect;

--
-- TOC entry 325 (class 1259 OID 183300)
-- Name: qrtz_cron_triggers; Type: TABLE; Schema: finconnect; Owner: finconnect
--

CREATE TABLE qrtz_cron_triggers (
    sched_name character varying(120) NOT NULL,
    trigger_name character varying(200) NOT NULL,
    trigger_group character varying(200) NOT NULL,
    cron_expression character varying(120) NOT NULL,
    time_zone_id character varying(80)
);


ALTER TABLE qrtz_cron_triggers OWNER TO finconnect;

--
-- TOC entry 326 (class 1259 OID 183313)
-- Name: qrtz_fired_triggers; Type: TABLE; Schema: finconnect; Owner: finconnect
--

CREATE TABLE qrtz_fired_triggers (
    sched_name character varying(120) NOT NULL,
    entry_id character varying(95) NOT NULL,
    trigger_name character varying(200) NOT NULL,
    trigger_group character varying(200) NOT NULL,
    instance_name character varying(200) NOT NULL,
    fired_time bigint NOT NULL,
    sched_time bigint NOT NULL,
    priority integer NOT NULL,
    state character varying(16) NOT NULL,
    job_name character varying(200),
    job_group character varying(200),
    is_nonconcurrent boolean,
    requests_recovery boolean
);


ALTER TABLE qrtz_fired_triggers OWNER TO finconnect;

--
-- TOC entry 321 (class 1259 OID 183244)
-- Name: qrtz_job_details; Type: TABLE; Schema: finconnect; Owner: finconnect
--

CREATE TABLE qrtz_job_details (
    sched_name character varying(120) NOT NULL,
    job_name character varying(200) NOT NULL,
    job_group character varying(200) NOT NULL,
    description character varying(250),
    job_class_name character varying(250) NOT NULL,
    is_durable boolean NOT NULL,
    is_nonconcurrent boolean NOT NULL,
    is_update_data boolean NOT NULL,
    requests_recovery boolean NOT NULL,
    job_data bytea
);


ALTER TABLE qrtz_job_details OWNER TO finconnect;

--
-- TOC entry 327 (class 1259 OID 183327)
-- Name: qrtz_locks; Type: TABLE; Schema: finconnect; Owner: finconnect
--

CREATE TABLE qrtz_locks (
    sched_name character varying(120) NOT NULL,
    lock_name character varying(40) NOT NULL
);


ALTER TABLE qrtz_locks OWNER TO finconnect;

--
-- TOC entry 328 (class 1259 OID 183332)
-- Name: qrtz_paused_trigger_grps; Type: TABLE; Schema: finconnect; Owner: finconnect
--

CREATE TABLE qrtz_paused_trigger_grps (
    sched_name character varying(120) NOT NULL,
    trigger_group character varying(200) NOT NULL
);


ALTER TABLE qrtz_paused_trigger_grps OWNER TO finconnect;

--
-- TOC entry 329 (class 1259 OID 183337)
-- Name: qrtz_scheduler_state; Type: TABLE; Schema: finconnect; Owner: finconnect
--

CREATE TABLE qrtz_scheduler_state (
    sched_name character varying(120) NOT NULL,
    instance_name character varying(200) NOT NULL,
    last_checkin_time bigint NOT NULL,
    checkin_interval bigint NOT NULL
);


ALTER TABLE qrtz_scheduler_state OWNER TO finconnect;

--
-- TOC entry 330 (class 1259 OID 183342)
-- Name: qrtz_simple_triggers; Type: TABLE; Schema: finconnect; Owner: finconnect
--

CREATE TABLE qrtz_simple_triggers (
    sched_name character varying(120) NOT NULL,
    trigger_name character varying(200) NOT NULL,
    trigger_group character varying(200) NOT NULL,
    repeat_count bigint NOT NULL,
    repeat_interval bigint NOT NULL,
    times_triggered bigint NOT NULL
);


ALTER TABLE qrtz_simple_triggers OWNER TO finconnect;

--
-- TOC entry 331 (class 1259 OID 183355)
-- Name: qrtz_simprop_triggers; Type: TABLE; Schema: finconnect; Owner: finconnect
--

CREATE TABLE qrtz_simprop_triggers (
    sched_name character varying(120) NOT NULL,
    trigger_name character varying(200) NOT NULL,
    trigger_group character varying(200) NOT NULL,
    str_prop_1 character varying(512),
    str_prop_2 character varying(512),
    str_prop_3 character varying(512),
    int_prop_1 integer,
    int_prop_2 integer,
    long_prop_1 bigint,
    long_prop_2 bigint,
    dec_prop_1 numeric(13,4),
    dec_prop_2 numeric(13,4),
    bool_prop_1 boolean,
    bool_prop_2 boolean
);


ALTER TABLE qrtz_simprop_triggers OWNER TO finconnect;

--
-- TOC entry 322 (class 1259 OID 183254)
-- Name: qrtz_triggers; Type: TABLE; Schema: finconnect; Owner: finconnect
--

CREATE TABLE qrtz_triggers (
    sched_name character varying(120) NOT NULL,
    trigger_name character varying(200) NOT NULL,
    trigger_group character varying(200) NOT NULL,
    job_name character varying(200) NOT NULL,
    job_group character varying(200) NOT NULL,
    description character varying(250),
    next_fire_time bigint,
    prev_fire_time bigint,
    priority integer,
    trigger_state character varying(16) NOT NULL,
    trigger_type character varying(8) NOT NULL,
    start_time bigint NOT NULL,
    end_time bigint,
    calendar_name character varying(200),
    misfire_instr smallint,
    job_data bytea
);


ALTER TABLE qrtz_triggers OWNER TO finconnect;

--
-- TOC entry 332 (class 1259 OID 183369)
-- Name: triggers; Type: TABLE; Schema: finconnect; Owner: postgres
--

CREATE TABLE triggers (
    id character varying(36) NOT NULL,
    bic character varying(36) NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE triggers OWNER TO postgres;

--
-- TOC entry 4301 (class 0 OID 183215)
-- Dependencies: 319
-- Data for Name: authorization_servers; Type: TABLE DATA; Schema: finconnect; Owner: finconnect
--

--
-- TOC entry 4113 (class 2606 OID 183222)
-- Name: authorization_servers authorization_servers_pkey; Type: CONSTRAINT; Schema: finconnect; Owner: finconnect
--

ALTER TABLE ONLY authorization_servers
    ADD CONSTRAINT authorization_servers_pkey PRIMARY KEY (id);


--
-- TOC entry 4115 (class 2606 OID 183227)
-- Name: consents consents_pkey; Type: CONSTRAINT; Schema: finconnect; Owner: finconnect
--

ALTER TABLE ONLY consents
    ADD CONSTRAINT consents_pkey PRIMARY KEY (bic);


--
-- TOC entry 4135 (class 2606 OID 183286)
-- Name: qrtz_blob_triggers qrtz_blob_triggers_pkey; Type: CONSTRAINT; Schema: finconnect; Owner: finconnect
--

ALTER TABLE ONLY qrtz_blob_triggers
    ADD CONSTRAINT qrtz_blob_triggers_pkey PRIMARY KEY (sched_name, trigger_name, trigger_group);


--
-- TOC entry 4137 (class 2606 OID 183299)
-- Name: qrtz_calendars qrtz_calendars_pkey; Type: CONSTRAINT; Schema: finconnect; Owner: finconnect
--

ALTER TABLE ONLY qrtz_calendars
    ADD CONSTRAINT qrtz_calendars_pkey PRIMARY KEY (sched_name, calendar_name);


--
-- TOC entry 4139 (class 2606 OID 183307)
-- Name: qrtz_cron_triggers qrtz_cron_triggers_pkey; Type: CONSTRAINT; Schema: finconnect; Owner: finconnect
--

ALTER TABLE ONLY qrtz_cron_triggers
    ADD CONSTRAINT qrtz_cron_triggers_pkey PRIMARY KEY (sched_name, trigger_name, trigger_group);


--
-- TOC entry 4147 (class 2606 OID 183320)
-- Name: qrtz_fired_triggers qrtz_fired_triggers_pkey; Type: CONSTRAINT; Schema: finconnect; Owner: finconnect
--

ALTER TABLE ONLY qrtz_fired_triggers
    ADD CONSTRAINT qrtz_fired_triggers_pkey PRIMARY KEY (sched_name, entry_id);


--
-- TOC entry 4119 (class 2606 OID 183251)
-- Name: qrtz_job_details qrtz_job_details_pkey; Type: CONSTRAINT; Schema: finconnect; Owner: finconnect
--

ALTER TABLE ONLY qrtz_job_details
    ADD CONSTRAINT qrtz_job_details_pkey PRIMARY KEY (sched_name, job_name, job_group);


--
-- TOC entry 4149 (class 2606 OID 183331)
-- Name: qrtz_locks qrtz_locks_pkey; Type: CONSTRAINT; Schema: finconnect; Owner: finconnect
--

ALTER TABLE ONLY qrtz_locks
    ADD CONSTRAINT qrtz_locks_pkey PRIMARY KEY (sched_name, lock_name);


--
-- TOC entry 4151 (class 2606 OID 183336)
-- Name: qrtz_paused_trigger_grps qrtz_paused_trigger_grps_pkey; Type: CONSTRAINT; Schema: finconnect; Owner: finconnect
--

ALTER TABLE ONLY qrtz_paused_trigger_grps
    ADD CONSTRAINT qrtz_paused_trigger_grps_pkey PRIMARY KEY (sched_name, trigger_group);


--
-- TOC entry 4153 (class 2606 OID 183341)
-- Name: qrtz_scheduler_state qrtz_scheduler_state_pkey; Type: CONSTRAINT; Schema: finconnect; Owner: finconnect
--

ALTER TABLE ONLY qrtz_scheduler_state
    ADD CONSTRAINT qrtz_scheduler_state_pkey PRIMARY KEY (sched_name, instance_name);


--
-- TOC entry 4155 (class 2606 OID 183349)
-- Name: qrtz_simple_triggers qrtz_simple_triggers_pkey; Type: CONSTRAINT; Schema: finconnect; Owner: finconnect
--

ALTER TABLE ONLY qrtz_simple_triggers
    ADD CONSTRAINT qrtz_simple_triggers_pkey PRIMARY KEY (sched_name, trigger_name, trigger_group);


--
-- TOC entry 4157 (class 2606 OID 183362)
-- Name: qrtz_simprop_triggers qrtz_simprop_triggers_pkey; Type: CONSTRAINT; Schema: finconnect; Owner: finconnect
--

ALTER TABLE ONLY qrtz_simprop_triggers
    ADD CONSTRAINT qrtz_simprop_triggers_pkey PRIMARY KEY (sched_name, trigger_name, trigger_group);


--
-- TOC entry 4133 (class 2606 OID 183261)
-- Name: qrtz_triggers qrtz_triggers_pkey; Type: CONSTRAINT; Schema: finconnect; Owner: finconnect
--

ALTER TABLE ONLY qrtz_triggers
    ADD CONSTRAINT qrtz_triggers_pkey PRIMARY KEY (sched_name, trigger_name, trigger_group);


--
-- TOC entry 4159 (class 2606 OID 183373)
-- Name: triggers triggers_pkey; Type: CONSTRAINT; Schema: finconnect; Owner: postgres
--

ALTER TABLE ONLY triggers
    ADD CONSTRAINT triggers_pkey PRIMARY KEY (id);


--
-- TOC entry 4140 (class 1259 OID 183321)
-- Name: idx_qrtz_ft_inst_job_req_rcvry; Type: INDEX; Schema: finconnect; Owner: finconnect
--

CREATE INDEX idx_qrtz_ft_inst_job_req_rcvry ON finconnect.qrtz_fired_triggers USING btree (sched_name, instance_name, requests_recovery);


--
-- TOC entry 4141 (class 1259 OID 183322)
-- Name: idx_qrtz_ft_j_g; Type: INDEX; Schema: finconnect; Owner: finconnect
--

CREATE INDEX idx_qrtz_ft_j_g ON finconnect.qrtz_fired_triggers USING btree (sched_name, job_name, job_group);


--
-- TOC entry 4142 (class 1259 OID 183323)
-- Name: idx_qrtz_ft_jg; Type: INDEX; Schema: finconnect; Owner: finconnect
--

CREATE INDEX idx_qrtz_ft_jg ON finconnect.qrtz_fired_triggers USING btree (sched_name, job_group);


--
-- TOC entry 4143 (class 1259 OID 183324)
-- Name: idx_qrtz_ft_t_g; Type: INDEX; Schema: finconnect; Owner: finconnect
--

CREATE INDEX idx_qrtz_ft_t_g ON finconnect.qrtz_fired_triggers USING btree (sched_name, trigger_name, trigger_group);


--
-- TOC entry 4144 (class 1259 OID 183325)
-- Name: idx_qrtz_ft_tg; Type: INDEX; Schema: finconnect; Owner: finconnect
--

CREATE INDEX idx_qrtz_ft_tg ON finconnect.qrtz_fired_triggers USING btree (sched_name, trigger_group);


--
-- TOC entry 4145 (class 1259 OID 183326)
-- Name: idx_qrtz_ft_trig_inst_name; Type: INDEX; Schema: finconnect; Owner: finconnect
--

CREATE INDEX idx_qrtz_ft_trig_inst_name ON finconnect.qrtz_fired_triggers USING btree (sched_name, instance_name);


--
-- TOC entry 4116 (class 1259 OID 183252)
-- Name: idx_qrtz_j_grp; Type: INDEX; Schema: finconnect; Owner: finconnect
--

CREATE INDEX idx_qrtz_j_grp ON finconnect.qrtz_job_details USING btree (sched_name, job_group);


--
-- TOC entry 4117 (class 1259 OID 183253)
-- Name: idx_qrtz_j_req_recovery; Type: INDEX; Schema: finconnect; Owner: finconnect
--

CREATE INDEX idx_qrtz_j_req_recovery ON finconnect.qrtz_job_details USING btree (sched_name, requests_recovery);


--
-- TOC entry 4120 (class 1259 OID 183267)
-- Name: idx_qrtz_t_c; Type: INDEX; Schema: finconnect; Owner: finconnect
--

CREATE INDEX idx_qrtz_t_c ON finconnect.qrtz_triggers USING btree (sched_name, calendar_name);


--
-- TOC entry 4121 (class 1259 OID 183268)
-- Name: idx_qrtz_t_g; Type: INDEX; Schema: finconnect; Owner: finconnect
--

CREATE INDEX idx_qrtz_t_g ON finconnect.qrtz_triggers USING btree (sched_name, trigger_group);


--
-- TOC entry 4122 (class 1259 OID 183269)
-- Name: idx_qrtz_t_j; Type: INDEX; Schema: finconnect; Owner: finconnect
--

CREATE INDEX idx_qrtz_t_j ON finconnect.qrtz_triggers USING btree (sched_name, job_name, job_group);


--
-- TOC entry 4123 (class 1259 OID 183270)
-- Name: idx_qrtz_t_jg; Type: INDEX; Schema: finconnect; Owner: finconnect
--

CREATE INDEX idx_qrtz_t_jg ON finconnect.qrtz_triggers USING btree (sched_name, job_group);


--
-- TOC entry 4124 (class 1259 OID 183271)
-- Name: idx_qrtz_t_n_g_state; Type: INDEX; Schema: finconnect; Owner: finconnect
--

CREATE INDEX idx_qrtz_t_n_g_state ON finconnect.qrtz_triggers USING btree (sched_name, trigger_group, trigger_state);


--
-- TOC entry 4125 (class 1259 OID 183272)
-- Name: idx_qrtz_t_n_state; Type: INDEX; Schema: finconnect; Owner: finconnect
--

CREATE INDEX idx_qrtz_t_n_state ON finconnect.qrtz_triggers USING btree (sched_name, trigger_name, trigger_group, trigger_state);


--
-- TOC entry 4126 (class 1259 OID 183273)
-- Name: idx_qrtz_t_next_fire_time; Type: INDEX; Schema: finconnect; Owner: finconnect
--

CREATE INDEX idx_qrtz_t_next_fire_time ON finconnect.qrtz_triggers USING btree (sched_name, next_fire_time);


--
-- TOC entry 4127 (class 1259 OID 183274)
-- Name: idx_qrtz_t_nft_misfire; Type: INDEX; Schema: finconnect; Owner: finconnect
--

CREATE INDEX idx_qrtz_t_nft_misfire ON finconnect.qrtz_triggers USING btree (sched_name, misfire_instr, next_fire_time);


--
-- TOC entry 4128 (class 1259 OID 183275)
-- Name: idx_qrtz_t_nft_st; Type: INDEX; Schema: finconnect; Owner: finconnect
--

CREATE INDEX idx_qrtz_t_nft_st ON finconnect.qrtz_triggers USING btree (sched_name, trigger_state, next_fire_time);


--
-- TOC entry 4129 (class 1259 OID 183276)
-- Name: idx_qrtz_t_nft_st_misfire; Type: INDEX; Schema: finconnect; Owner: finconnect
--

CREATE INDEX idx_qrtz_t_nft_st_misfire ON finconnect.qrtz_triggers USING btree (sched_name, misfire_instr, next_fire_time, trigger_state);


--
-- TOC entry 4130 (class 1259 OID 183277)
-- Name: idx_qrtz_t_nft_st_misfire_grp; Type: INDEX; Schema: finconnect; Owner: finconnect
--

CREATE INDEX idx_qrtz_t_nft_st_misfire_grp ON finconnect.qrtz_triggers USING btree (sched_name, misfire_instr, next_fire_time, trigger_group, trigger_state);


--
-- TOC entry 4131 (class 1259 OID 183278)
-- Name: idx_qrtz_t_state; Type: INDEX; Schema: finconnect; Owner: finconnect
--

CREATE INDEX idx_qrtz_t_state ON finconnect.qrtz_triggers USING btree (sched_name, trigger_state);


--
-- TOC entry 4161 (class 2606 OID 183287)
-- Name: qrtz_blob_triggers qrtz_blob_triggers_sched_name_fkey; Type: FK CONSTRAINT; Schema: finconnect; Owner: finconnect
--

ALTER TABLE ONLY qrtz_blob_triggers
    ADD CONSTRAINT qrtz_blob_triggers_sched_name_fkey FOREIGN KEY (sched_name, trigger_name, trigger_group) REFERENCES qrtz_triggers(sched_name, trigger_name, trigger_group);


--
-- TOC entry 4162 (class 2606 OID 183308)
-- Name: qrtz_cron_triggers qrtz_cron_triggers_sched_name_fkey; Type: FK CONSTRAINT; Schema: finconnect; Owner: finconnect
--

ALTER TABLE ONLY qrtz_cron_triggers
    ADD CONSTRAINT qrtz_cron_triggers_sched_name_fkey FOREIGN KEY (sched_name, trigger_name, trigger_group) REFERENCES qrtz_triggers(sched_name, trigger_name, trigger_group);


--
-- TOC entry 4163 (class 2606 OID 183350)
-- Name: qrtz_simple_triggers qrtz_simple_triggers_sched_name_fkey; Type: FK CONSTRAINT; Schema: finconnect; Owner: finconnect
--

ALTER TABLE ONLY qrtz_simple_triggers
    ADD CONSTRAINT qrtz_simple_triggers_sched_name_fkey FOREIGN KEY (sched_name, trigger_name, trigger_group) REFERENCES qrtz_triggers(sched_name, trigger_name, trigger_group);


--
-- TOC entry 4164 (class 2606 OID 183363)
-- Name: qrtz_simprop_triggers qrtz_simprop_triggers_sched_name_fkey; Type: FK CONSTRAINT; Schema: finconnect; Owner: finconnect
--

ALTER TABLE ONLY qrtz_simprop_triggers
    ADD CONSTRAINT qrtz_simprop_triggers_sched_name_fkey FOREIGN KEY (sched_name, trigger_name, trigger_group) REFERENCES qrtz_triggers(sched_name, trigger_name, trigger_group);


--
-- TOC entry 4160 (class 2606 OID 183262)
-- Name: qrtz_triggers qrtz_triggers_sched_name_fkey; Type: FK CONSTRAINT; Schema: finconnect; Owner: finconnect
--

ALTER TABLE ONLY qrtz_triggers
    ADD CONSTRAINT qrtz_triggers_sched_name_fkey FOREIGN KEY (sched_name, job_name, job_group) REFERENCES qrtz_job_details(sched_name, job_name, job_group);


--
-- TOC entry 4165 (class 2606 OID 183374)
-- Name: triggers triggers_bic_fkey; Type: FK CONSTRAINT; Schema: finconnect; Owner: postgres
--

ALTER TABLE ONLY triggers
    ADD CONSTRAINT triggers_bic_fkey FOREIGN KEY (bic) REFERENCES finlist.banks(bic);


--
-- TOC entry 4319 (class 0 OID 0)
-- Dependencies: 11
-- Name: finconnect; Type: ACL; Schema: -; Owner: finconnect
--

GRANT USAGE ON SCHEMA finconnect TO finuiuser;
GRANT USAGE ON SCHEMA finconnect TO findata;


-- Completed on 2020-03-11 18:47:34

--
-- PostgreSQL database dump complete
--

