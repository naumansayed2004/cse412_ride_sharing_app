--
-- PostgreSQL database dump
--

\restrict GseffI9poLLMK6rIM6pjlT1hbAEBTlvl0rjjXsJJuPmBKZQmVl2YOkXhP87tCzV

-- Dumped from database version 14.20 (Homebrew)
-- Dumped by pg_dump version 18.2

-- Started on 2026-05-03 20:54:57 MST

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: Nauman
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO "Nauman";

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 210 (class 1259 OID 249810)
-- Name: app_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.app_user (
    u_userid integer NOT NULL,
    u_name character varying(100) NOT NULL,
    u_email character varying(100) NOT NULL,
    u_phone character varying(15) NOT NULL,
    u_password character varying(100) NOT NULL,
    u_usertype character varying(20) NOT NULL,
    CONSTRAINT app_user_u_usertype_check CHECK (((u_usertype)::text = ANY ((ARRAY['Passenger'::character varying, 'Driver'::character varying])::text[])))
);


ALTER TABLE public.app_user OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 249809)
-- Name: app_user_u_userid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.app_user_u_userid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.app_user_u_userid_seq OWNER TO postgres;

--
-- TOC entry 3742 (class 0 OID 0)
-- Dependencies: 209
-- Name: app_user_u_userid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.app_user_u_userid_seq OWNED BY public.app_user.u_userid;


--
-- TOC entry 214 (class 1259 OID 249834)
-- Name: driver; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.driver (
    d_driverid integer NOT NULL,
    d_userid integer NOT NULL,
    d_vehicletype character varying(30) NOT NULL,
    d_vehiclemodel character varying(50) NOT NULL,
    d_licenseplate character varying(20) NOT NULL,
    d_onlinestatus character varying(20) NOT NULL,
    CONSTRAINT driver_d_onlinestatus_check CHECK (((d_onlinestatus)::text = ANY ((ARRAY['Online'::character varying, 'Offline'::character varying])::text[])))
);


ALTER TABLE public.driver OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 249833)
-- Name: driver_d_driverid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.driver_d_driverid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.driver_d_driverid_seq OWNER TO postgres;

--
-- TOC entry 3743 (class 0 OID 0)
-- Dependencies: 213
-- Name: driver_d_driverid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.driver_d_driverid_seq OWNED BY public.driver.d_driverid;


--
-- TOC entry 212 (class 1259 OID 249820)
-- Name: passenger; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.passenger (
    p_passengerid integer NOT NULL,
    p_userid integer NOT NULL
);


ALTER TABLE public.passenger OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 249819)
-- Name: passenger_p_passengerid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.passenger_p_passengerid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.passenger_p_passengerid_seq OWNER TO postgres;

--
-- TOC entry 3744 (class 0 OID 0)
-- Dependencies: 211
-- Name: passenger_p_passengerid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.passenger_p_passengerid_seq OWNED BY public.passenger.p_passengerid;


--
-- TOC entry 218 (class 1259 OID 249870)
-- Name: payment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment (
    pay_paymentid integer NOT NULL,
    pay_rideid integer NOT NULL,
    pay_totalfare numeric(10,2) NOT NULL,
    pay_paymentmethod character varying(30) NOT NULL,
    pay_transactionstatus character varying(30) NOT NULL,
    CONSTRAINT payment_pay_totalfare_check CHECK ((pay_totalfare >= (0)::numeric)),
    CONSTRAINT payment_pay_transactionstatus_check CHECK (((pay_transactionstatus)::text = ANY ((ARRAY['Successful'::character varying, 'Failed'::character varying, 'Pending'::character varying])::text[])))
);


ALTER TABLE public.payment OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 249869)
-- Name: payment_pay_paymentid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payment_pay_paymentid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payment_pay_paymentid_seq OWNER TO postgres;

--
-- TOC entry 3745 (class 0 OID 0)
-- Dependencies: 217
-- Name: payment_pay_paymentid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payment_pay_paymentid_seq OWNED BY public.payment.pay_paymentid;


--
-- TOC entry 220 (class 1259 OID 249886)
-- Name: rating_review; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rating_review (
    rr_ratingid integer NOT NULL,
    rr_rideid integer NOT NULL,
    rr_givenby_userid integer NOT NULL,
    rr_givento_userid integer NOT NULL,
    rr_ratingvalue integer NOT NULL,
    rr_feedback character varying(255),
    CONSTRAINT rating_review_check CHECK ((rr_givenby_userid <> rr_givento_userid)),
    CONSTRAINT rating_review_rr_ratingvalue_check CHECK (((rr_ratingvalue >= 1) AND (rr_ratingvalue <= 5)))
);


ALTER TABLE public.rating_review OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 249885)
-- Name: rating_review_rr_ratingid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rating_review_rr_ratingid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.rating_review_rr_ratingid_seq OWNER TO postgres;

--
-- TOC entry 3746 (class 0 OID 0)
-- Dependencies: 219
-- Name: rating_review_rr_ratingid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rating_review_rr_ratingid_seq OWNED BY public.rating_review.rr_ratingid;


--
-- TOC entry 216 (class 1259 OID 249851)
-- Name: ride; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ride (
    r_rideid integer NOT NULL,
    r_passengerid integer NOT NULL,
    r_driverid integer,
    r_pickuplocation character varying(200) NOT NULL,
    r_dropofflocation character varying(200) NOT NULL,
    r_requesttime timestamp without time zone NOT NULL,
    r_status character varying(30) NOT NULL,
    r_totalfare numeric(10,2) NOT NULL,
    r_distance numeric(10,2),
    r_duration integer,
    CONSTRAINT ride_r_status_check CHECK (((r_status)::text = ANY ((ARRAY['Requested'::character varying, 'Accepted'::character varying, 'In Progress'::character varying, 'Completed'::character varying, 'Cancelled'::character varying])::text[]))),
    CONSTRAINT ride_r_totalfare_check CHECK ((r_totalfare >= (0)::numeric))
);


ALTER TABLE public.ride OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 249850)
-- Name: ride_r_rideid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ride_r_rideid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ride_r_rideid_seq OWNER TO postgres;

--
-- TOC entry 3747 (class 0 OID 0)
-- Dependencies: 215
-- Name: ride_r_rideid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ride_r_rideid_seq OWNED BY public.ride.r_rideid;


--
-- TOC entry 3541 (class 2604 OID 249813)
-- Name: app_user u_userid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_user ALTER COLUMN u_userid SET DEFAULT nextval('public.app_user_u_userid_seq'::regclass);


--
-- TOC entry 3543 (class 2604 OID 249837)
-- Name: driver d_driverid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.driver ALTER COLUMN d_driverid SET DEFAULT nextval('public.driver_d_driverid_seq'::regclass);


--
-- TOC entry 3542 (class 2604 OID 249823)
-- Name: passenger p_passengerid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passenger ALTER COLUMN p_passengerid SET DEFAULT nextval('public.passenger_p_passengerid_seq'::regclass);


--
-- TOC entry 3545 (class 2604 OID 249873)
-- Name: payment pay_paymentid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment ALTER COLUMN pay_paymentid SET DEFAULT nextval('public.payment_pay_paymentid_seq'::regclass);


--
-- TOC entry 3546 (class 2604 OID 249889)
-- Name: rating_review rr_ratingid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rating_review ALTER COLUMN rr_ratingid SET DEFAULT nextval('public.rating_review_rr_ratingid_seq'::regclass);


--
-- TOC entry 3544 (class 2604 OID 249854)
-- Name: ride r_rideid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ride ALTER COLUMN r_rideid SET DEFAULT nextval('public.ride_r_rideid_seq'::regclass);


--
-- TOC entry 3725 (class 0 OID 249810)
-- Dependencies: 210
-- Data for Name: app_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.app_user (u_userid, u_name, u_email, u_phone, u_password, u_usertype) FROM stdin;
1	Riya Sharma	riya.sharma@email.com	6021111111	hashed_pw_riya	Passenger
2	Arjun Mehta	arjun.mehta@email.com	6022222222	hashed_pw_arjun	Passenger
3	Karan Patel	karan.patel@email.com	6023333333	hashed_pw_karan	Driver
4	Sneha Verma	sneha.verma@email.com	6024444444	hashed_pw_sneha	Driver
5	Rahul Nair	rahul.nair@email.com	6025555555	hashed_pw_rahul	Passenger
6	Aisha Khan	aisha.khan@email.com	6026666666	hashed_pw_aisha	Driver
7	Rounak Sharma	ronak1@gmail.com	3474994884	rounaksharma	Passenger
8	revanth alimela	reva2@gmail.com	7478472957	revanthalimela	Driver
9	shashank	nonu107@gmail.com	7478472957	rounaksharma	Passenger
\.


--
-- TOC entry 3729 (class 0 OID 249834)
-- Dependencies: 214
-- Data for Name: driver; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.driver (d_driverid, d_userid, d_vehicletype, d_vehiclemodel, d_licenseplate, d_onlinestatus) FROM stdin;
201	3	Sedan	Toyota Camry	AZC1234	Online
202	4	SUV	Honda CR-V	AZD5678	Offline
203	6	Compact	Hyundai Elantra	AZE9012	Online
204	8	honda	crv	BSY39J	Online
\.


--
-- TOC entry 3727 (class 0 OID 249820)
-- Dependencies: 212
-- Data for Name: passenger; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.passenger (p_passengerid, p_userid) FROM stdin;
101	1
102	2
103	5
104	7
105	9
\.


--
-- TOC entry 3733 (class 0 OID 249870)
-- Dependencies: 218
-- Data for Name: payment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment (pay_paymentid, pay_rideid, pay_totalfare, pay_paymentmethod, pay_transactionstatus) FROM stdin;
401	301	28.50	Credit Card	Successful
402	302	22.75	Debit Card	Successful
\.


--
-- TOC entry 3735 (class 0 OID 249886)
-- Dependencies: 220
-- Data for Name: rating_review; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rating_review (rr_ratingid, rr_rideid, rr_givenby_userid, rr_givento_userid, rr_ratingvalue, rr_feedback) FROM stdin;
501	301	1	3	5	Driver was very polite and arrived on time.
502	301	3	1	5	Passenger was cooperative and punctual.
503	302	2	6	4	Smooth ride and clean vehicle.
\.


--
-- TOC entry 3731 (class 0 OID 249851)
-- Dependencies: 216
-- Data for Name: ride; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ride (r_rideid, r_passengerid, r_driverid, r_pickuplocation, r_dropofflocation, r_requesttime, r_status, r_totalfare, r_distance, r_duration) FROM stdin;
301	101	201	ASU Tempe Campus	Phoenix Sky Harbor Airport	2026-04-01 09:15:00	Completed	28.50	11.20	24
302	102	203	Tempe Marketplace	Downtown Phoenix	2026-04-02 14:30:00	Completed	22.75	9.60	20
303	103	\N	Mill Avenue	Scottsdale Fashion Square	2026-04-03 18:10:00	Requested	18.00	7.40	16
304	101	201	ASU Library	Mesa Riverview	2026-04-04 11:00:00	Accepted	16.25	6.80	15
\.


--
-- TOC entry 3748 (class 0 OID 0)
-- Dependencies: 209
-- Name: app_user_u_userid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_user_u_userid_seq', 9, true);


--
-- TOC entry 3749 (class 0 OID 0)
-- Dependencies: 213
-- Name: driver_d_driverid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.driver_d_driverid_seq', 204, true);


--
-- TOC entry 3750 (class 0 OID 0)
-- Dependencies: 211
-- Name: passenger_p_passengerid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.passenger_p_passengerid_seq', 105, true);


--
-- TOC entry 3751 (class 0 OID 0)
-- Dependencies: 217
-- Name: payment_pay_paymentid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payment_pay_paymentid_seq', 402, true);


--
-- TOC entry 3752 (class 0 OID 0)
-- Dependencies: 219
-- Name: rating_review_rr_ratingid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rating_review_rr_ratingid_seq', 503, true);


--
-- TOC entry 3753 (class 0 OID 0)
-- Dependencies: 215
-- Name: ride_r_rideid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ride_r_rideid_seq', 312, true);


--
-- TOC entry 3556 (class 2606 OID 249816)
-- Name: app_user app_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_user
    ADD CONSTRAINT app_user_pkey PRIMARY KEY (u_userid);


--
-- TOC entry 3558 (class 2606 OID 249818)
-- Name: app_user app_user_u_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_user
    ADD CONSTRAINT app_user_u_email_key UNIQUE (u_email);


--
-- TOC entry 3564 (class 2606 OID 249844)
-- Name: driver driver_d_licenseplate_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.driver
    ADD CONSTRAINT driver_d_licenseplate_key UNIQUE (d_licenseplate);


--
-- TOC entry 3566 (class 2606 OID 249842)
-- Name: driver driver_d_userid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.driver
    ADD CONSTRAINT driver_d_userid_key UNIQUE (d_userid);


--
-- TOC entry 3568 (class 2606 OID 249840)
-- Name: driver driver_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.driver
    ADD CONSTRAINT driver_pkey PRIMARY KEY (d_driverid);


--
-- TOC entry 3560 (class 2606 OID 249827)
-- Name: passenger passenger_p_userid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passenger
    ADD CONSTRAINT passenger_p_userid_key UNIQUE (p_userid);


--
-- TOC entry 3562 (class 2606 OID 249825)
-- Name: passenger passenger_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passenger
    ADD CONSTRAINT passenger_pkey PRIMARY KEY (p_passengerid);


--
-- TOC entry 3572 (class 2606 OID 249879)
-- Name: payment payment_pay_rideid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_pay_rideid_key UNIQUE (pay_rideid);


--
-- TOC entry 3574 (class 2606 OID 249877)
-- Name: payment payment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (pay_paymentid);


--
-- TOC entry 3576 (class 2606 OID 249893)
-- Name: rating_review rating_review_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rating_review
    ADD CONSTRAINT rating_review_pkey PRIMARY KEY (rr_ratingid);


--
-- TOC entry 3570 (class 2606 OID 249858)
-- Name: ride ride_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ride
    ADD CONSTRAINT ride_pkey PRIMARY KEY (r_rideid);


--
-- TOC entry 3578 (class 2606 OID 249845)
-- Name: driver driver_d_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.driver
    ADD CONSTRAINT driver_d_userid_fkey FOREIGN KEY (d_userid) REFERENCES public.app_user(u_userid);


--
-- TOC entry 3577 (class 2606 OID 249828)
-- Name: passenger passenger_p_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passenger
    ADD CONSTRAINT passenger_p_userid_fkey FOREIGN KEY (p_userid) REFERENCES public.app_user(u_userid);


--
-- TOC entry 3581 (class 2606 OID 249880)
-- Name: payment payment_pay_rideid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment_pay_rideid_fkey FOREIGN KEY (pay_rideid) REFERENCES public.ride(r_rideid);


--
-- TOC entry 3582 (class 2606 OID 249899)
-- Name: rating_review rating_review_rr_givenby_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rating_review
    ADD CONSTRAINT rating_review_rr_givenby_userid_fkey FOREIGN KEY (rr_givenby_userid) REFERENCES public.app_user(u_userid);


--
-- TOC entry 3583 (class 2606 OID 249904)
-- Name: rating_review rating_review_rr_givento_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rating_review
    ADD CONSTRAINT rating_review_rr_givento_userid_fkey FOREIGN KEY (rr_givento_userid) REFERENCES public.app_user(u_userid);


--
-- TOC entry 3584 (class 2606 OID 249894)
-- Name: rating_review rating_review_rr_rideid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rating_review
    ADD CONSTRAINT rating_review_rr_rideid_fkey FOREIGN KEY (rr_rideid) REFERENCES public.ride(r_rideid);


--
-- TOC entry 3579 (class 2606 OID 249864)
-- Name: ride ride_r_driverid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ride
    ADD CONSTRAINT ride_r_driverid_fkey FOREIGN KEY (r_driverid) REFERENCES public.driver(d_driverid);


--
-- TOC entry 3580 (class 2606 OID 249859)
-- Name: ride ride_r_passengerid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ride
    ADD CONSTRAINT ride_r_passengerid_fkey FOREIGN KEY (r_passengerid) REFERENCES public.passenger(p_passengerid);


--
-- TOC entry 3741 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: Nauman
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2026-05-03 20:54:57 MST

--
-- PostgreSQL database dump complete
--

\unrestrict GseffI9poLLMK6rIM6pjlT1hbAEBTlvl0rjjXsJJuPmBKZQmVl2YOkXhP87tCzV

