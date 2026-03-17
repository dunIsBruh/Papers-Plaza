--
-- PostgreSQL database dump
--

\restrict Jr55bTzhc1luRCqYejmPDP2ZgettBLQt1UhfU9uILghoe1fi1TaygBs4k2nZCEs

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

SET default_tablespace = '';

SET default_table_access_method = heap;

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
-- Name: country id; Type: DEFAULT; Schema: identity; Owner: postgres
--

ALTER TABLE ONLY identity.country ALTER COLUMN id SET DEFAULT nextval('identity.country_id_seq'::regclass);


--
-- Data for Name: country; Type: TABLE DATA; Schema: identity; Owner: postgres
--

COPY identity.country (id, name) FROM stdin;
5	Arstozka
6	New Kolechia
7	LockCountry
\.


--
-- Name: country_id_seq; Type: SEQUENCE SET; Schema: identity; Owner: postgres
--

SELECT pg_catalog.setval('identity.country_id_seq', 7, true);


--
-- Name: country country_pkey; Type: CONSTRAINT; Schema: identity; Owner: postgres
--

ALTER TABLE ONLY identity.country
    ADD CONSTRAINT country_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

\unrestrict Jr55bTzhc1luRCqYejmPDP2ZgettBLQt1UhfU9uILghoe1fi1TaygBs4k2nZCEs

