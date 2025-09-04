--
-- PostgreSQL database dump
--

-- Dumped from database version 15.13 (Debian 15.13-1.pgdg120+1)
-- Dumped by pg_dump version 15.13 (Debian 15.13-1.pgdg120+1)

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
-- Name: predictions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.predictions (
    id integer NOT NULL,
    picture_filename character varying,
    label_filename character varying,
    predicted_class character varying,
    confidence double precision,
    "timestamp" timestamp without time zone,
    corrected_class character varying,
    correction boolean
);


ALTER TABLE public.predictions OWNER TO postgres;

--
-- Name: predictions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.predictions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.predictions_id_seq OWNER TO postgres;

--
-- Name: predictions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.predictions_id_seq OWNED BY public.predictions.id;


--
-- Name: predictions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.predictions ALTER COLUMN id SET DEFAULT nextval('public.predictions_id_seq'::regclass);


--
-- Data for Name: predictions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.predictions (id, picture_filename, label_filename, predicted_class, confidence, "timestamp", corrected_class, correction) FROM stdin;
1	20250830050441_6b7e67e488c54112be80f6b8a4062af6_1000011161.jpg	20250830050441_6b7e67e488c54112be80f6b8a4062af6_1000011161.txt	Recycable	0.7838470935821533	2025-08-30 05:04:41.57569	\N	f
2	20250830050509_d884cb6a79db4fbfaa51b4491e11e8d7_1000011161.jpg	20250830050509_d884cb6a79db4fbfaa51b4491e11e8d7_1000011161.txt	Recycable	0.7838470935821533	2025-08-30 05:05:09.681224	general	t
3	20250830051729_53ea029d296948789b3a45f95a21f74a_a32a5032-420c-402a-9dc2-473972be83a96448355408653946955.jpg	20250830051729_53ea029d296948789b3a45f95a21f74a_a32a5032-420c-402a-9dc2-473972be83a96448355408653946955.txt	Recycable	0.8455588221549988	2025-08-30 05:17:29.96305	\N	f
4	20250830051741_ed641a7b4f154c30b1c75d89b615f677_1000011161.jpg	20250830051741_ed641a7b4f154c30b1c75d89b615f677_1000011161.txt	Recycable	0.7838470935821533	2025-08-30 05:17:42.000695	organic	t
5	20250830053548_733203a6023945dd943aed7f332d7ced_0ce311cd-222e-4ed5-9720-bf012c6dd5997098743271308532841.jpg	20250830053548_733203a6023945dd943aed7f332d7ced_0ce311cd-222e-4ed5-9720-bf012c6dd5997098743271308532841.txt	General	0.7863278985023499	2025-08-30 05:35:48.654438	organic	t
6	20250830062504_6ddff7c633fc487b903d032eaffa6f60_9d51825a-704a-4e91-8da9-e66efddf2d6b6068519224247304959.jpg	20250830062504_6ddff7c633fc487b903d032eaffa6f60_9d51825a-704a-4e91-8da9-e66efddf2d6b6068519224247304959.txt	Recycable	0.7445434927940369	2025-08-30 06:25:04.703357	\N	f
7	20250830062527_43d5ae4428d34680ae37ed7d3ea6919f_1000011161.jpg	20250830062527_43d5ae4428d34680ae37ed7d3ea6919f_1000011161.txt	Recycable	0.7838470935821533	2025-08-30 06:25:28.05875	general	t
8	20250830062953_0a33149eed49460dbb361e15e1721aac_0377dd68-477b-4e3a-a1ad-2aade02b22eb1514670836396670038.jpg	20250830062953_0a33149eed49460dbb361e15e1721aac_0377dd68-477b-4e3a-a1ad-2aade02b22eb1514670836396670038.txt	Recycable	0.8368608951568604	2025-08-30 06:29:53.235988	\N	f
9	20250830063002_9bd160354a5942c4a0c1a87d7e1d3bcf_1000011173.jpg	\N	unknown	0	2025-08-30 06:30:02.411694	\N	f
10	20250830063006_fd77a9c6de3f4a0a957e0d98a349892d_1000011171.jpg	\N	unknown	0	2025-08-30 06:30:06.695318	\N	f
11	20250830063015_da83ec19bd0e4dd4a2df8e9649c076cf_1000011172.jpg	20250830063015_da83ec19bd0e4dd4a2df8e9649c076cf_1000011172.txt	Recycable	0.7308946251869202	2025-08-30 06:30:15.288182	general	t
12	20250830063156_f59827a76b684e1eb4bea5cadc04ca84_d918914e-1c4f-4d4b-a8d8-9d62a95a27921658815258779091778.jpg	20250830063156_f59827a76b684e1eb4bea5cadc04ca84_d918914e-1c4f-4d4b-a8d8-9d62a95a27921658815258779091778.txt	Recycable	0.7712668180465698	2025-08-30 06:31:56.616318	\N	f
13	20250830063210_2ad0a24dd2d344988a0a23aad6bf86ac_1000011172.jpg	20250830063210_2ad0a24dd2d344988a0a23aad6bf86ac_1000011172.txt	Recycable	0.7308946251869202	2025-08-30 06:32:10.751863	\N	f
14	20250830063215_d61215bb316a401d959d140874d9ac4a_1000011175.jpg	20250830063215_d61215bb316a401d959d140874d9ac4a_1000011175.txt	Recycable	0.8674061894416809	2025-08-30 06:32:15.567479	general	t
15	20250830063425_b06cab1df2fb499d936f35ff19362a19_Screenshot 2025-06-14 212309.png	\N	unknown	0	2025-08-30 06:34:25.051505	\N	f
16	20250830064429_22320f10fa3141f2b831bf26e0032724_42.jpg	20250830064429_22320f10fa3141f2b831bf26e0032724_42.txt	Recycable	0.5119251012802124	2025-08-30 06:44:29.596057	\N	f
17	20250830064433_feb2503daf1f4d05b0fa40948a898d9c_43.jpg	20250830064433_feb2503daf1f4d05b0fa40948a898d9c_43.txt	Recycable	0.9024385213851929	2025-08-30 06:44:33.438961	general	t
\.


--
-- Name: predictions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.predictions_id_seq', 17, true);


--
-- Name: predictions predictions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.predictions
    ADD CONSTRAINT predictions_pkey PRIMARY KEY (id);


--
-- Name: ix_predictions_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_predictions_id ON public.predictions USING btree (id);


--
-- PostgreSQL database dump complete
--

