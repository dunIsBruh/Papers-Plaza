--
-- PostgreSQL database dump
--

\restrict UUTHZY7RMjhgj940p2aOCLwruJpkM3AfuCgIhkOxsVNfsbNayY2EK8xuMeIWVqC

-- Dumped from database version 15.16 (Debian 15.16-1.pgdg13+1)
-- Dumped by pg_dump version 15.16 (Debian 15.16-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: analytics; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA analytics;


ALTER SCHEMA analytics OWNER TO postgres;

--
-- Name: criminal; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA criminal;


ALTER SCHEMA criminal OWNER TO postgres;

--
-- Name: identity; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA identity;


ALTER SCHEMA identity OWNER TO postgres;

--
-- Name: items; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA items;


ALTER SCHEMA items OWNER TO postgres;

--
-- Name: papers; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA papers;


ALTER SCHEMA papers OWNER TO postgres;

--
-- Name: people; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA people;


ALTER SCHEMA people OWNER TO postgres;

--
-- Name: pageinspect; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pageinspect WITH SCHEMA public;


--
-- Name: EXTENSION pageinspect; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pageinspect IS 'inspect the contents of database pages at a low level';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: border_crossing; Type: TABLE; Schema: analytics; Owner: postgres
--

CREATE TABLE analytics.border_crossing (
    id bigint NOT NULL,
    passport_id integer NOT NULL,
    crossing_time timestamp without time zone NOT NULL,
    checkpoint_code character varying(10) NOT NULL,
    direction character varying(10) NOT NULL,
    transport_type character varying(20) NOT NULL,
    risk_level smallint NOT NULL,
    officer_id integer NOT NULL,
    declaration_text text,
    metadata jsonb,
    luggage_weight_range numrange,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT border_crossing_direction_check CHECK (((direction)::text = ANY ((ARRAY['IN'::character varying, 'OUT'::character varying])::text[])))
);


ALTER TABLE analytics.border_crossing OWNER TO postgres;

--
-- Name: border_crossing_id_seq; Type: SEQUENCE; Schema: analytics; Owner: postgres
--

CREATE SEQUENCE analytics.border_crossing_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE analytics.border_crossing_id_seq OWNER TO postgres;

--
-- Name: border_crossing_id_seq; Type: SEQUENCE OWNED BY; Schema: analytics; Owner: postgres
--

ALTER SEQUENCE analytics.border_crossing_id_seq OWNED BY analytics.border_crossing.id;


--
-- Name: criminal_screening; Type: TABLE; Schema: analytics; Owner: postgres
--

CREATE TABLE analytics.criminal_screening (
    id bigint NOT NULL,
    biometry_id integer NOT NULL,
    screening_time timestamp without time zone NOT NULL,
    match_found boolean NOT NULL,
    threat_level smallint,
    case_type_id integer,
    screening_score numeric(6,3) NOT NULL,
    geo_location point,
    screening_window tsrange,
    additional_info jsonb
);


ALTER TABLE analytics.criminal_screening OWNER TO postgres;

--
-- Name: criminal_screening_id_seq; Type: SEQUENCE; Schema: analytics; Owner: postgres
--

CREATE SEQUENCE analytics.criminal_screening_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE analytics.criminal_screening_id_seq OWNER TO postgres;

--
-- Name: criminal_screening_id_seq; Type: SEQUENCE OWNED BY; Schema: analytics; Owner: postgres
--

ALTER SEQUENCE analytics.criminal_screening_id_seq OWNED BY analytics.criminal_screening.id;


--
-- Name: luggage_inspection; Type: TABLE; Schema: analytics; Owner: postgres
--

CREATE TABLE analytics.luggage_inspection (
    id bigint NOT NULL,
    luggage_id integer NOT NULL,
    officer_id integer NOT NULL,
    inspection_time timestamp without time zone NOT NULL,
    result character varying(20) NOT NULL,
    suspicious_score numeric(5,2) NOT NULL,
    item_count integer NOT NULL,
    prohibited_items text[],
    notes text,
    inspection_duration interval,
    extra_data jsonb,
    CONSTRAINT luggage_inspection_result_check CHECK (((result)::text = ANY ((ARRAY['CLEAR'::character varying, 'CONFISCATED'::character varying, 'WARNING'::character varying])::text[])))
);


ALTER TABLE analytics.luggage_inspection OWNER TO postgres;

--
-- Name: luggage_inspection_id_seq; Type: SEQUENCE; Schema: analytics; Owner: postgres
--

CREATE SEQUENCE analytics.luggage_inspection_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE analytics.luggage_inspection_id_seq OWNER TO postgres;

--
-- Name: luggage_inspection_id_seq; Type: SEQUENCE OWNED BY; Schema: analytics; Owner: postgres
--

ALTER SEQUENCE analytics.luggage_inspection_id_seq OWNED BY analytics.luggage_inspection.id;


--
-- Name: passenger_profile; Type: TABLE; Schema: analytics; Owner: postgres
--

CREATE TABLE analytics.passenger_profile (
    id bigint NOT NULL,
    passport_id integer NOT NULL,
    frequent_traveler boolean NOT NULL,
    total_crossings integer NOT NULL,
    preferred_direction character varying(10),
    average_risk numeric(4,2),
    profile_notes text,
    tags text[],
    risk_distribution jsonb,
    active_period daterange
);


ALTER TABLE analytics.passenger_profile OWNER TO postgres;

--
-- Name: passenger_profile_id_seq; Type: SEQUENCE; Schema: analytics; Owner: postgres
--

CREATE SEQUENCE analytics.passenger_profile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE analytics.passenger_profile_id_seq OWNER TO postgres;

--
-- Name: passenger_profile_id_seq; Type: SEQUENCE OWNED BY; Schema: analytics; Owner: postgres
--

ALTER SEQUENCE analytics.passenger_profile_id_seq OWNED BY analytics.passenger_profile.id;


--
-- Name: case; Type: TABLE; Schema: criminal; Owner: postgres
--

CREATE TABLE criminal."case" (
    id integer NOT NULL,
    casetype_id integer NOT NULL
);


ALTER TABLE criminal."case" OWNER TO postgres;

--
-- Name: case_id_seq; Type: SEQUENCE; Schema: criminal; Owner: postgres
--

CREATE SEQUENCE criminal.case_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE criminal.case_id_seq OWNER TO postgres;

--
-- Name: case_id_seq; Type: SEQUENCE OWNED BY; Schema: criminal; Owner: postgres
--

ALTER SEQUENCE criminal.case_id_seq OWNED BY criminal."case".id;


--
-- Name: casetype; Type: TABLE; Schema: criminal; Owner: postgres
--

CREATE TABLE criminal.casetype (
    id integer NOT NULL,
    description text NOT NULL
);


ALTER TABLE criminal.casetype OWNER TO postgres;

--
-- Name: casetype_id_seq; Type: SEQUENCE; Schema: criminal; Owner: postgres
--

CREATE SEQUENCE criminal.casetype_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE criminal.casetype_id_seq OWNER TO postgres;

--
-- Name: casetype_id_seq; Type: SEQUENCE OWNED BY; Schema: criminal; Owner: postgres
--

ALTER SEQUENCE criminal.casetype_id_seq OWNED BY criminal.casetype.id;


--
-- Name: record; Type: TABLE; Schema: criminal; Owner: postgres
--

CREATE TABLE criminal.record (
    crimeid integer NOT NULL,
    biometryid integer NOT NULL
);


ALTER TABLE criminal.record OWNER TO postgres;

--
-- Name: biometry; Type: TABLE; Schema: identity; Owner: postgres
--

CREATE TABLE identity.biometry (
    id integer NOT NULL
);


ALTER TABLE identity.biometry OWNER TO postgres;

--
-- Name: biometry_id_seq; Type: SEQUENCE; Schema: identity; Owner: postgres
--

CREATE SEQUENCE identity.biometry_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE identity.biometry_id_seq OWNER TO postgres;

--
-- Name: biometry_id_seq; Type: SEQUENCE OWNED BY; Schema: identity; Owner: postgres
--

ALTER SEQUENCE identity.biometry_id_seq OWNED BY identity.biometry.id;


--
-- Name: citizenentrypermission; Type: TABLE; Schema: identity; Owner: postgres
--

CREATE TABLE identity.citizenentrypermission (
    fromid integer NOT NULL,
    toid integer NOT NULL,
    CONSTRAINT citizenentrypermission_check CHECK ((fromid <> toid))
);


ALTER TABLE identity.citizenentrypermission OWNER TO postgres;

--
-- Name: country; Type: TABLE; Schema: identity; Owner: postgres
--

CREATE TABLE identity.country (
    id integer NOT NULL,
    name character varying(20) NOT NULL
);


ALTER TABLE identity.country OWNER TO postgres;

--
-- Name: country_id_seq; Type: SEQUENCE; Schema: identity; Owner: postgres
--

CREATE SEQUENCE identity.country_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE identity.country_id_seq OWNER TO postgres;

--
-- Name: country_id_seq; Type: SEQUENCE OWNED BY; Schema: identity; Owner: postgres
--

ALTER SEQUENCE identity.country_id_seq OWNED BY identity.country.id;


--
-- Name: passport; Type: TABLE; Schema: identity; Owner: postgres
--

CREATE TABLE identity.passport (
    id integer NOT NULL,
    fullname character varying(100) NOT NULL,
    issuedate date NOT NULL,
    validuntil date NOT NULL,
    biometry integer,
    country integer NOT NULL,
    CONSTRAINT passport_check CHECK ((issuedate < validuntil))
);


ALTER TABLE identity.passport OWNER TO postgres;

--
-- Name: passport_id_seq; Type: SEQUENCE; Schema: identity; Owner: postgres
--

CREATE SEQUENCE identity.passport_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE identity.passport_id_seq OWNER TO postgres;

--
-- Name: passport_id_seq; Type: SEQUENCE OWNED BY; Schema: identity; Owner: postgres
--

ALTER SEQUENCE identity.passport_id_seq OWNED BY identity.passport.id;


--
-- Name: luggage; Type: TABLE; Schema: items; Owner: postgres
--

CREATE TABLE items.luggage (
    id integer NOT NULL
);


ALTER TABLE items.luggage OWNER TO postgres;

--
-- Name: luggage_id_seq; Type: SEQUENCE; Schema: items; Owner: postgres
--

CREATE SEQUENCE items.luggage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE items.luggage_id_seq OWNER TO postgres;

--
-- Name: luggage_id_seq; Type: SEQUENCE OWNED BY; Schema: items; Owner: postgres
--

ALTER SEQUENCE items.luggage_id_seq OWNED BY items.luggage.id;


--
-- Name: luggageitem; Type: TABLE; Schema: items; Owner: postgres
--

CREATE TABLE items.luggageitem (
    id integer NOT NULL,
    itemtype_id integer NOT NULL,
    luggage_id integer NOT NULL
);


ALTER TABLE items.luggageitem OWNER TO postgres;

--
-- Name: luggageitem_id_seq; Type: SEQUENCE; Schema: items; Owner: postgres
--

CREATE SEQUENCE items.luggageitem_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE items.luggageitem_id_seq OWNER TO postgres;

--
-- Name: luggageitem_id_seq; Type: SEQUENCE OWNED BY; Schema: items; Owner: postgres
--

ALTER SEQUENCE items.luggageitem_id_seq OWNED BY items.luggageitem.id;


--
-- Name: luggageitemtype; Type: TABLE; Schema: items; Owner: postgres
--

CREATE TABLE items.luggageitemtype (
    id integer NOT NULL,
    itemname character varying(255) NOT NULL,
    CONSTRAINT length_check CHECK ((length((itemname)::text) > 0))
);


ALTER TABLE items.luggageitemtype OWNER TO postgres;

--
-- Name: luggageitemtype_id_seq; Type: SEQUENCE; Schema: items; Owner: postgres
--

CREATE SEQUENCE items.luggageitemtype_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE items.luggageitemtype_id_seq OWNER TO postgres;

--
-- Name: luggageitemtype_id_seq; Type: SEQUENCE OWNED BY; Schema: items; Owner: postgres
--

ALTER SEQUENCE items.luggageitemtype_id_seq OWNED BY items.luggageitemtype.id;


--
-- Name: activity; Type: TABLE; Schema: papers; Owner: postgres
--

CREATE TABLE papers.activity (
    id integer NOT NULL,
    description character varying(100) NOT NULL
);


ALTER TABLE papers.activity OWNER TO postgres;

--
-- Name: activity_id_seq; Type: SEQUENCE; Schema: papers; Owner: postgres
--

CREATE SEQUENCE papers.activity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE papers.activity_id_seq OWNER TO postgres;

--
-- Name: activity_id_seq; Type: SEQUENCE OWNED BY; Schema: papers; Owner: postgres
--

ALTER SEQUENCE papers.activity_id_seq OWNED BY papers.activity.id;


--
-- Name: audit_log; Type: TABLE; Schema: papers; Owner: postgres
--

CREATE TABLE papers.audit_log (
    id integer NOT NULL,
    event_time timestamp without time zone DEFAULT now() NOT NULL,
    description text NOT NULL
);


ALTER TABLE papers.audit_log OWNER TO postgres;

--
-- Name: audit_log_id_seq; Type: SEQUENCE; Schema: papers; Owner: postgres
--

CREATE SEQUENCE papers.audit_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE papers.audit_log_id_seq OWNER TO postgres;

--
-- Name: audit_log_id_seq; Type: SEQUENCE OWNED BY; Schema: papers; Owner: postgres
--

ALTER SEQUENCE papers.audit_log_id_seq OWNED BY papers.audit_log.id;


--
-- Name: diplomatcertificate; Type: TABLE; Schema: papers; Owner: postgres
--

CREATE TABLE papers.diplomatcertificate (
    id integer NOT NULL,
    issuedate date NOT NULL,
    validuntil date NOT NULL,
    fullname character varying(100) NOT NULL,
    countryofissue integer NOT NULL,
    CONSTRAINT diplomatcertificate_check CHECK ((issuedate < validuntil))
);


ALTER TABLE papers.diplomatcertificate OWNER TO postgres;

--
-- Name: diplomatcertificate_id_seq; Type: SEQUENCE; Schema: papers; Owner: postgres
--

CREATE SEQUENCE papers.diplomatcertificate_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE papers.diplomatcertificate_id_seq OWNER TO postgres;

--
-- Name: diplomatcertificate_id_seq; Type: SEQUENCE OWNED BY; Schema: papers; Owner: postgres
--

ALTER SEQUENCE papers.diplomatcertificate_id_seq OWNED BY papers.diplomatcertificate.id;


--
-- Name: diseasevaccine; Type: TABLE; Schema: papers; Owner: postgres
--

CREATE TABLE papers.diseasevaccine (
    vaccineid integer NOT NULL,
    vaccinationcertificateid integer NOT NULL
);


ALTER TABLE papers.diseasevaccine OWNER TO postgres;

--
-- Name: entrypermission; Type: TABLE; Schema: papers; Owner: postgres
--

CREATE TABLE papers.entrypermission (
    id integer NOT NULL,
    issuedate date NOT NULL,
    validuntil date NOT NULL,
    countryofissue integer NOT NULL,
    fullname character varying(100) NOT NULL,
    CONSTRAINT entrypermission_check CHECK ((issuedate < validuntil))
);


ALTER TABLE papers.entrypermission OWNER TO postgres;

--
-- Name: entrypermission_id_seq; Type: SEQUENCE; Schema: papers; Owner: postgres
--

CREATE SEQUENCE papers.entrypermission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE papers.entrypermission_id_seq OWNER TO postgres;

--
-- Name: entrypermission_id_seq; Type: SEQUENCE OWNED BY; Schema: papers; Owner: postgres
--

ALTER SEQUENCE papers.entrypermission_id_seq OWNED BY papers.entrypermission.id;


--
-- Name: vaccinationcertificate; Type: TABLE; Schema: papers; Owner: postgres
--

CREATE TABLE papers.vaccinationcertificate (
    id integer NOT NULL,
    issuedate date NOT NULL,
    validuntil date NOT NULL,
    issuebywhom character varying(100) NOT NULL,
    CONSTRAINT vaccinationcertificate_check CHECK ((issuedate < validuntil))
);


ALTER TABLE papers.vaccinationcertificate OWNER TO postgres;

--
-- Name: vaccinationcertificate_id_seq; Type: SEQUENCE; Schema: papers; Owner: postgres
--

CREATE SEQUENCE papers.vaccinationcertificate_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE papers.vaccinationcertificate_id_seq OWNER TO postgres;

--
-- Name: vaccinationcertificate_id_seq; Type: SEQUENCE OWNED BY; Schema: papers; Owner: postgres
--

ALTER SEQUENCE papers.vaccinationcertificate_id_seq OWNED BY papers.vaccinationcertificate.id;


--
-- Name: vaccine; Type: TABLE; Schema: papers; Owner: postgres
--

CREATE TABLE papers.vaccine (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE papers.vaccine OWNER TO postgres;

--
-- Name: vaccine_id_seq; Type: SEQUENCE; Schema: papers; Owner: postgres
--

CREATE SEQUENCE papers.vaccine_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE papers.vaccine_id_seq OWNER TO postgres;

--
-- Name: vaccine_id_seq; Type: SEQUENCE OWNED BY; Schema: papers; Owner: postgres
--

ALTER SEQUENCE papers.vaccine_id_seq OWNED BY papers.vaccine.id;


--
-- Name: workpermission; Type: TABLE; Schema: papers; Owner: postgres
--

CREATE TABLE papers.workpermission (
    id integer NOT NULL,
    issuedate date NOT NULL,
    validuntil date NOT NULL,
    fullname character varying(100) NOT NULL,
    countryofissue integer NOT NULL,
    activityid integer NOT NULL,
    CONSTRAINT workpermission_check CHECK ((issuedate < validuntil))
);


ALTER TABLE papers.workpermission OWNER TO postgres;

--
-- Name: workpermission_id_seq; Type: SEQUENCE; Schema: papers; Owner: postgres
--

CREATE SEQUENCE papers.workpermission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE papers.workpermission_id_seq OWNER TO postgres;

--
-- Name: workpermission_id_seq; Type: SEQUENCE OWNED BY; Schema: papers; Owner: postgres
--

ALTER SEQUENCE papers.workpermission_id_seq OWNED BY papers.workpermission.id;


--
-- Name: entrant; Type: TABLE; Schema: people; Owner: postgres
--

CREATE TABLE people.entrant (
    passportid integer NOT NULL,
    workpermissionid integer,
    entrypermissionid integer,
    luggageid integer,
    vaccinationcertificateid integer,
    diplomatcertificateid integer
);


ALTER TABLE people.entrant OWNER TO postgres;

--
-- Name: flyway_schema_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.flyway_schema_history (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


ALTER TABLE public.flyway_schema_history OWNER TO postgres;

--
-- Name: border_crossing id; Type: DEFAULT; Schema: analytics; Owner: postgres
--

ALTER TABLE ONLY analytics.border_crossing ALTER COLUMN id SET DEFAULT nextval('analytics.border_crossing_id_seq'::regclass);


--
-- Name: criminal_screening id; Type: DEFAULT; Schema: analytics; Owner: postgres
--

ALTER TABLE ONLY analytics.criminal_screening ALTER COLUMN id SET DEFAULT nextval('analytics.criminal_screening_id_seq'::regclass);


--
-- Name: luggage_inspection id; Type: DEFAULT; Schema: analytics; Owner: postgres
--

ALTER TABLE ONLY analytics.luggage_inspection ALTER COLUMN id SET DEFAULT nextval('analytics.luggage_inspection_id_seq'::regclass);


--
-- Name: passenger_profile id; Type: DEFAULT; Schema: analytics; Owner: postgres
--

ALTER TABLE ONLY analytics.passenger_profile ALTER COLUMN id SET DEFAULT nextval('analytics.passenger_profile_id_seq'::regclass);


--
-- Name: case id; Type: DEFAULT; Schema: criminal; Owner: postgres
--

ALTER TABLE ONLY criminal."case" ALTER COLUMN id SET DEFAULT nextval('criminal.case_id_seq'::regclass);


--
-- Name: casetype id; Type: DEFAULT; Schema: criminal; Owner: postgres
--

ALTER TABLE ONLY criminal.casetype ALTER COLUMN id SET DEFAULT nextval('criminal.casetype_id_seq'::regclass);


--
-- Name: biometry id; Type: DEFAULT; Schema: identity; Owner: postgres
--

ALTER TABLE ONLY identity.biometry ALTER COLUMN id SET DEFAULT nextval('identity.biometry_id_seq'::regclass);


--
-- Name: country id; Type: DEFAULT; Schema: identity; Owner: postgres
--

ALTER TABLE ONLY identity.country ALTER COLUMN id SET DEFAULT nextval('identity.country_id_seq'::regclass);


--
-- Name: passport id; Type: DEFAULT; Schema: identity; Owner: postgres
--

ALTER TABLE ONLY identity.passport ALTER COLUMN id SET DEFAULT nextval('identity.passport_id_seq'::regclass);


--
-- Name: luggage id; Type: DEFAULT; Schema: items; Owner: postgres
--

ALTER TABLE ONLY items.luggage ALTER COLUMN id SET DEFAULT nextval('items.luggage_id_seq'::regclass);


--
-- Name: luggageitem id; Type: DEFAULT; Schema: items; Owner: postgres
--

ALTER TABLE ONLY items.luggageitem ALTER COLUMN id SET DEFAULT nextval('items.luggageitem_id_seq'::regclass);


--
-- Name: luggageitemtype id; Type: DEFAULT; Schema: items; Owner: postgres
--

ALTER TABLE ONLY items.luggageitemtype ALTER COLUMN id SET DEFAULT nextval('items.luggageitemtype_id_seq'::regclass);


--
-- Name: activity id; Type: DEFAULT; Schema: papers; Owner: postgres
--

ALTER TABLE ONLY papers.activity ALTER COLUMN id SET DEFAULT nextval('papers.activity_id_seq'::regclass);


--
-- Name: audit_log id; Type: DEFAULT; Schema: papers; Owner: postgres
--

ALTER TABLE ONLY papers.audit_log ALTER COLUMN id SET DEFAULT nextval('papers.audit_log_id_seq'::regclass);


--
-- Name: diplomatcertificate id; Type: DEFAULT; Schema: papers; Owner: postgres
--

ALTER TABLE ONLY papers.diplomatcertificate ALTER COLUMN id SET DEFAULT nextval('papers.diplomatcertificate_id_seq'::regclass);


--
-- Name: entrypermission id; Type: DEFAULT; Schema: papers; Owner: postgres
--

ALTER TABLE ONLY papers.entrypermission ALTER COLUMN id SET DEFAULT nextval('papers.entrypermission_id_seq'::regclass);


--
-- Name: vaccinationcertificate id; Type: DEFAULT; Schema: papers; Owner: postgres
--

ALTER TABLE ONLY papers.vaccinationcertificate ALTER COLUMN id SET DEFAULT nextval('papers.vaccinationcertificate_id_seq'::regclass);


--
-- Name: vaccine id; Type: DEFAULT; Schema: papers; Owner: postgres
--

ALTER TABLE ONLY papers.vaccine ALTER COLUMN id SET DEFAULT nextval('papers.vaccine_id_seq'::regclass);


--
-- Name: workpermission id; Type: DEFAULT; Schema: papers; Owner: postgres
--

ALTER TABLE ONLY papers.workpermission ALTER COLUMN id SET DEFAULT nextval('papers.workpermission_id_seq'::regclass);


--
-- Name: border_crossing border_crossing_pkey; Type: CONSTRAINT; Schema: analytics; Owner: postgres
--

ALTER TABLE ONLY analytics.border_crossing
    ADD CONSTRAINT border_crossing_pkey PRIMARY KEY (id);


--
-- Name: criminal_screening criminal_screening_pkey; Type: CONSTRAINT; Schema: analytics; Owner: postgres
--

ALTER TABLE ONLY analytics.criminal_screening
    ADD CONSTRAINT criminal_screening_pkey PRIMARY KEY (id);


--
-- Name: luggage_inspection luggage_inspection_pkey; Type: CONSTRAINT; Schema: analytics; Owner: postgres
--

ALTER TABLE ONLY analytics.luggage_inspection
    ADD CONSTRAINT luggage_inspection_pkey PRIMARY KEY (id);


--
-- Name: passenger_profile passenger_profile_pkey; Type: CONSTRAINT; Schema: analytics; Owner: postgres
--

ALTER TABLE ONLY analytics.passenger_profile
    ADD CONSTRAINT passenger_profile_pkey PRIMARY KEY (id);


--
-- Name: case case_pkey; Type: CONSTRAINT; Schema: criminal; Owner: postgres
--

ALTER TABLE ONLY criminal."case"
    ADD CONSTRAINT case_pkey PRIMARY KEY (id);


--
-- Name: casetype casetype_pkey; Type: CONSTRAINT; Schema: criminal; Owner: postgres
--

ALTER TABLE ONLY criminal.casetype
    ADD CONSTRAINT casetype_pkey PRIMARY KEY (id);


--
-- Name: record record_pkey; Type: CONSTRAINT; Schema: criminal; Owner: postgres
--

ALTER TABLE ONLY criminal.record
    ADD CONSTRAINT record_pkey PRIMARY KEY (crimeid, biometryid);


--
-- Name: biometry biometry_pkey; Type: CONSTRAINT; Schema: identity; Owner: postgres
--

ALTER TABLE ONLY identity.biometry
    ADD CONSTRAINT biometry_pkey PRIMARY KEY (id);


--
-- Name: citizenentrypermission citizenentrypermission_pkey; Type: CONSTRAINT; Schema: identity; Owner: postgres
--

ALTER TABLE ONLY identity.citizenentrypermission
    ADD CONSTRAINT citizenentrypermission_pkey PRIMARY KEY (fromid, toid);


--
-- Name: country country_pkey; Type: CONSTRAINT; Schema: identity; Owner: postgres
--

ALTER TABLE ONLY identity.country
    ADD CONSTRAINT country_pkey PRIMARY KEY (id);


--
-- Name: passport passport_pkey; Type: CONSTRAINT; Schema: identity; Owner: postgres
--

ALTER TABLE ONLY identity.passport
    ADD CONSTRAINT passport_pkey PRIMARY KEY (id);


--
-- Name: luggage luggage_pkey; Type: CONSTRAINT; Schema: items; Owner: postgres
--

ALTER TABLE ONLY items.luggage
    ADD CONSTRAINT luggage_pkey PRIMARY KEY (id);


--
-- Name: luggageitem luggageitem_pkey; Type: CONSTRAINT; Schema: items; Owner: postgres
--

ALTER TABLE ONLY items.luggageitem
    ADD CONSTRAINT luggageitem_pkey PRIMARY KEY (id);


--
-- Name: luggageitemtype luggageitemtype_pkey; Type: CONSTRAINT; Schema: items; Owner: postgres
--

ALTER TABLE ONLY items.luggageitemtype
    ADD CONSTRAINT luggageitemtype_pkey PRIMARY KEY (id);


--
-- Name: activity activity_pkey; Type: CONSTRAINT; Schema: papers; Owner: postgres
--

ALTER TABLE ONLY papers.activity
    ADD CONSTRAINT activity_pkey PRIMARY KEY (id);


--
-- Name: audit_log audit_log_pkey; Type: CONSTRAINT; Schema: papers; Owner: postgres
--

ALTER TABLE ONLY papers.audit_log
    ADD CONSTRAINT audit_log_pkey PRIMARY KEY (id);


--
-- Name: diplomatcertificate diplomatcertificate_pkey; Type: CONSTRAINT; Schema: papers; Owner: postgres
--

ALTER TABLE ONLY papers.diplomatcertificate
    ADD CONSTRAINT diplomatcertificate_pkey PRIMARY KEY (id);


--
-- Name: diseasevaccine diseasevaccine_pkey; Type: CONSTRAINT; Schema: papers; Owner: postgres
--

ALTER TABLE ONLY papers.diseasevaccine
    ADD CONSTRAINT diseasevaccine_pkey PRIMARY KEY (vaccineid, vaccinationcertificateid);


--
-- Name: entrypermission entrypermission_pkey; Type: CONSTRAINT; Schema: papers; Owner: postgres
--

ALTER TABLE ONLY papers.entrypermission
    ADD CONSTRAINT entrypermission_pkey PRIMARY KEY (id);


--
-- Name: vaccinationcertificate vaccinationcertificate_pkey; Type: CONSTRAINT; Schema: papers; Owner: postgres
--

ALTER TABLE ONLY papers.vaccinationcertificate
    ADD CONSTRAINT vaccinationcertificate_pkey PRIMARY KEY (id);


--
-- Name: vaccine vaccine_pkey; Type: CONSTRAINT; Schema: papers; Owner: postgres
--

ALTER TABLE ONLY papers.vaccine
    ADD CONSTRAINT vaccine_pkey PRIMARY KEY (id);


--
-- Name: workpermission workpermission_pkey; Type: CONSTRAINT; Schema: papers; Owner: postgres
--

ALTER TABLE ONLY papers.workpermission
    ADD CONSTRAINT workpermission_pkey PRIMARY KEY (id);


--
-- Name: entrant entrant_pkey; Type: CONSTRAINT; Schema: people; Owner: postgres
--

ALTER TABLE ONLY people.entrant
    ADD CONSTRAINT entrant_pkey PRIMARY KEY (passportid);


--
-- Name: flyway_schema_history flyway_schema_history_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flyway_schema_history
    ADD CONSTRAINT flyway_schema_history_pk PRIMARY KEY (installed_rank);


--
-- Name: flyway_schema_history_s_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX flyway_schema_history_s_idx ON public.flyway_schema_history USING btree (success);


--
-- Name: border_crossing border_crossing_passport_id_fkey; Type: FK CONSTRAINT; Schema: analytics; Owner: postgres
--

ALTER TABLE ONLY analytics.border_crossing
    ADD CONSTRAINT border_crossing_passport_id_fkey FOREIGN KEY (passport_id) REFERENCES identity.passport(id);


--
-- Name: criminal_screening criminal_screening_biometry_id_fkey; Type: FK CONSTRAINT; Schema: analytics; Owner: postgres
--

ALTER TABLE ONLY analytics.criminal_screening
    ADD CONSTRAINT criminal_screening_biometry_id_fkey FOREIGN KEY (biometry_id) REFERENCES identity.biometry(id);


--
-- Name: criminal_screening criminal_screening_case_type_id_fkey; Type: FK CONSTRAINT; Schema: analytics; Owner: postgres
--

ALTER TABLE ONLY analytics.criminal_screening
    ADD CONSTRAINT criminal_screening_case_type_id_fkey FOREIGN KEY (case_type_id) REFERENCES criminal.casetype(id);


--
-- Name: luggage_inspection luggage_inspection_luggage_id_fkey; Type: FK CONSTRAINT; Schema: analytics; Owner: postgres
--

ALTER TABLE ONLY analytics.luggage_inspection
    ADD CONSTRAINT luggage_inspection_luggage_id_fkey FOREIGN KEY (luggage_id) REFERENCES items.luggage(id);


--
-- Name: passenger_profile passenger_profile_passport_id_fkey; Type: FK CONSTRAINT; Schema: analytics; Owner: postgres
--

ALTER TABLE ONLY analytics.passenger_profile
    ADD CONSTRAINT passenger_profile_passport_id_fkey FOREIGN KEY (passport_id) REFERENCES identity.passport(id);


--
-- Name: case case_casetype_id_fkey; Type: FK CONSTRAINT; Schema: criminal; Owner: postgres
--

ALTER TABLE ONLY criminal."case"
    ADD CONSTRAINT case_casetype_id_fkey FOREIGN KEY (casetype_id) REFERENCES criminal.casetype(id);


--
-- Name: record record_biometryid_fkey; Type: FK CONSTRAINT; Schema: criminal; Owner: postgres
--

ALTER TABLE ONLY criminal.record
    ADD CONSTRAINT record_biometryid_fkey FOREIGN KEY (biometryid) REFERENCES identity.biometry(id);


--
-- Name: record record_crimeid_fkey; Type: FK CONSTRAINT; Schema: criminal; Owner: postgres
--

ALTER TABLE ONLY criminal.record
    ADD CONSTRAINT record_crimeid_fkey FOREIGN KEY (crimeid) REFERENCES criminal."case"(id);


--
-- Name: citizenentrypermission citizenentrypermission_fromid_fkey; Type: FK CONSTRAINT; Schema: identity; Owner: postgres
--

ALTER TABLE ONLY identity.citizenentrypermission
    ADD CONSTRAINT citizenentrypermission_fromid_fkey FOREIGN KEY (fromid) REFERENCES identity.country(id);


--
-- Name: citizenentrypermission citizenentrypermission_toid_fkey; Type: FK CONSTRAINT; Schema: identity; Owner: postgres
--

ALTER TABLE ONLY identity.citizenentrypermission
    ADD CONSTRAINT citizenentrypermission_toid_fkey FOREIGN KEY (toid) REFERENCES identity.country(id);


--
-- Name: passport passport_biometry_fkey; Type: FK CONSTRAINT; Schema: identity; Owner: postgres
--

ALTER TABLE ONLY identity.passport
    ADD CONSTRAINT passport_biometry_fkey FOREIGN KEY (biometry) REFERENCES identity.biometry(id);


--
-- Name: passport passport_country_fkey; Type: FK CONSTRAINT; Schema: identity; Owner: postgres
--

ALTER TABLE ONLY identity.passport
    ADD CONSTRAINT passport_country_fkey FOREIGN KEY (country) REFERENCES identity.country(id);


--
-- Name: luggageitem luggageitem_itemtype_id_fkey; Type: FK CONSTRAINT; Schema: items; Owner: postgres
--

ALTER TABLE ONLY items.luggageitem
    ADD CONSTRAINT luggageitem_itemtype_id_fkey FOREIGN KEY (itemtype_id) REFERENCES items.luggageitemtype(id);


--
-- Name: luggageitem luggageitem_luggage_id_fkey; Type: FK CONSTRAINT; Schema: items; Owner: postgres
--

ALTER TABLE ONLY items.luggageitem
    ADD CONSTRAINT luggageitem_luggage_id_fkey FOREIGN KEY (luggage_id) REFERENCES items.luggage(id);


--
-- Name: diplomatcertificate diplomatcertificate_countryofissue_fkey; Type: FK CONSTRAINT; Schema: papers; Owner: postgres
--

ALTER TABLE ONLY papers.diplomatcertificate
    ADD CONSTRAINT diplomatcertificate_countryofissue_fkey FOREIGN KEY (countryofissue) REFERENCES identity.country(id);


--
-- Name: diseasevaccine diseasevaccine_vaccinationcertificateid_fkey; Type: FK CONSTRAINT; Schema: papers; Owner: postgres
--

ALTER TABLE ONLY papers.diseasevaccine
    ADD CONSTRAINT diseasevaccine_vaccinationcertificateid_fkey FOREIGN KEY (vaccinationcertificateid) REFERENCES papers.vaccinationcertificate(id);


--
-- Name: diseasevaccine diseasevaccine_vaccineid_fkey; Type: FK CONSTRAINT; Schema: papers; Owner: postgres
--

ALTER TABLE ONLY papers.diseasevaccine
    ADD CONSTRAINT diseasevaccine_vaccineid_fkey FOREIGN KEY (vaccineid) REFERENCES papers.vaccine(id);


--
-- Name: entrypermission entrypermission_countryofissue_fkey; Type: FK CONSTRAINT; Schema: papers; Owner: postgres
--

ALTER TABLE ONLY papers.entrypermission
    ADD CONSTRAINT entrypermission_countryofissue_fkey FOREIGN KEY (countryofissue) REFERENCES identity.country(id);


--
-- Name: workpermission workpermission_activityid_fkey; Type: FK CONSTRAINT; Schema: papers; Owner: postgres
--

ALTER TABLE ONLY papers.workpermission
    ADD CONSTRAINT workpermission_activityid_fkey FOREIGN KEY (activityid) REFERENCES papers.activity(id);


--
-- Name: workpermission workpermission_countryofissue_fkey; Type: FK CONSTRAINT; Schema: papers; Owner: postgres
--

ALTER TABLE ONLY papers.workpermission
    ADD CONSTRAINT workpermission_countryofissue_fkey FOREIGN KEY (countryofissue) REFERENCES identity.country(id);


--
-- Name: entrant entrant_diplomatcertificateid_fkey; Type: FK CONSTRAINT; Schema: people; Owner: postgres
--

ALTER TABLE ONLY people.entrant
    ADD CONSTRAINT entrant_diplomatcertificateid_fkey FOREIGN KEY (diplomatcertificateid) REFERENCES papers.diplomatcertificate(id);


--
-- Name: entrant entrant_entrypermissionid_fkey; Type: FK CONSTRAINT; Schema: people; Owner: postgres
--

ALTER TABLE ONLY people.entrant
    ADD CONSTRAINT entrant_entrypermissionid_fkey FOREIGN KEY (entrypermissionid) REFERENCES papers.entrypermission(id);


--
-- Name: entrant entrant_luggageid_fkey; Type: FK CONSTRAINT; Schema: people; Owner: postgres
--

ALTER TABLE ONLY people.entrant
    ADD CONSTRAINT entrant_luggageid_fkey FOREIGN KEY (luggageid) REFERENCES items.luggage(id);


--
-- Name: entrant entrant_passportid_fkey; Type: FK CONSTRAINT; Schema: people; Owner: postgres
--

ALTER TABLE ONLY people.entrant
    ADD CONSTRAINT entrant_passportid_fkey FOREIGN KEY (passportid) REFERENCES identity.passport(id);


--
-- Name: entrant entrant_vaccinationcertificateid_fkey; Type: FK CONSTRAINT; Schema: people; Owner: postgres
--

ALTER TABLE ONLY people.entrant
    ADD CONSTRAINT entrant_vaccinationcertificateid_fkey FOREIGN KEY (vaccinationcertificateid) REFERENCES papers.vaccinationcertificate(id);


--
-- Name: entrant entrant_workpermissionid_fkey; Type: FK CONSTRAINT; Schema: people; Owner: postgres
--

ALTER TABLE ONLY people.entrant
    ADD CONSTRAINT entrant_workpermissionid_fkey FOREIGN KEY (workpermissionid) REFERENCES papers.workpermission(id);


--
-- Name: SCHEMA analytics; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA analytics TO app;
GRANT USAGE ON SCHEMA analytics TO readonly;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO app;
GRANT USAGE ON SCHEMA public TO readonly;


--
-- Name: TABLE border_crossing; Type: ACL; Schema: analytics; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE analytics.border_crossing TO app;
GRANT SELECT ON TABLE analytics.border_crossing TO readonly;


--
-- Name: SEQUENCE border_crossing_id_seq; Type: ACL; Schema: analytics; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE analytics.border_crossing_id_seq TO app;
GRANT SELECT ON SEQUENCE analytics.border_crossing_id_seq TO readonly;


--
-- Name: TABLE criminal_screening; Type: ACL; Schema: analytics; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE analytics.criminal_screening TO app;
GRANT SELECT ON TABLE analytics.criminal_screening TO readonly;


--
-- Name: SEQUENCE criminal_screening_id_seq; Type: ACL; Schema: analytics; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE analytics.criminal_screening_id_seq TO app;
GRANT SELECT ON SEQUENCE analytics.criminal_screening_id_seq TO readonly;


--
-- Name: TABLE luggage_inspection; Type: ACL; Schema: analytics; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE analytics.luggage_inspection TO app;
GRANT SELECT ON TABLE analytics.luggage_inspection TO readonly;


--
-- Name: SEQUENCE luggage_inspection_id_seq; Type: ACL; Schema: analytics; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE analytics.luggage_inspection_id_seq TO app;
GRANT SELECT ON SEQUENCE analytics.luggage_inspection_id_seq TO readonly;


--
-- Name: TABLE passenger_profile; Type: ACL; Schema: analytics; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE analytics.passenger_profile TO app;
GRANT SELECT ON TABLE analytics.passenger_profile TO readonly;


--
-- Name: SEQUENCE passenger_profile_id_seq; Type: ACL; Schema: analytics; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE analytics.passenger_profile_id_seq TO app;
GRANT SELECT ON SEQUENCE analytics.passenger_profile_id_seq TO readonly;


--
-- Name: TABLE flyway_schema_history; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.flyway_schema_history TO app;
GRANT SELECT ON TABLE public.flyway_schema_history TO readonly;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: analytics; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA analytics GRANT SELECT,USAGE ON SEQUENCES  TO app;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: analytics; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA analytics GRANT SELECT,INSERT,DELETE,UPDATE ON TABLES  TO app;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA analytics GRANT SELECT ON TABLES  TO readonly;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT,USAGE ON SEQUENCES  TO app;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT,INSERT,DELETE,UPDATE ON TABLES  TO app;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT ON TABLES  TO readonly;


--
-- PostgreSQL database dump complete
--

\unrestrict UUTHZY7RMjhgj940p2aOCLwruJpkM3AfuCgIhkOxsVNfsbNayY2EK8xuMeIWVqC

