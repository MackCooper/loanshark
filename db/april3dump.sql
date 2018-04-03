PGDMP                         v           oliver    10.3    10.3 !    .           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            /           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            0           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                       false            1           1262    16810    oliver    DATABASE     �   CREATE DATABASE oliver WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'English_United States.1252' LC_CTYPE = 'English_United States.1252';
    DROP DATABASE oliver;
             postgres    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             postgres    false            2           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  postgres    false    4                        3079    12924    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false            3           0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    1                        3079    24937    pgcrypto 	   EXTENSION     <   CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
    DROP EXTENSION pgcrypto;
                  false    4            4           0    0    EXTENSION pgcrypto    COMMENT     <   COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
                       false    2            �            1255    16948 )   add_loan(integer, integer, numeric, text)    FUNCTION       CREATE FUNCTION public.add_loan(owner integer, sender integer, cost numeric, description text) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO transactions (owner, sender, cost, description) VALUES (owner, sender, cost, description);
END;
$$;
 ^   DROP FUNCTION public.add_loan(owner integer, sender integer, cost numeric, description text);
       public       oliver    false    1    4            �            1255    16812    add_user(text, text)    FUNCTION     �   CREATE FUNCTION public.add_user(first_name text, last_name text) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
INSERT INTO users(first_name, last_name) VALUES (first_name, last_name);
END;
$$;
 @   DROP FUNCTION public.add_user(first_name text, last_name text);
       public       oliver    false    4    1            �            1255    16981    get_all_transactions()    FUNCTION     �  CREATE FUNCTION public.get_all_transactions() RETURNS TABLE(transactionid integer, owner text, sender text, cost numeric, date date, description text)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY SELECT
                 a.transactionid,
                 a.owner,
                 b.sender,
                 a.cost,
                 a.date,
                 a.description
               FROM (SELECT
                       transactions.transactionid,
                       first_name AS owner,
                       transactions.cost,
                       transactions.date,
                       transactions.description
                     FROM transactions
                       INNER JOIN users ON transactions.owner = users.uid) AS a NATURAL JOIN (SELECT
                                                                                                transactions.transactionid,
                                                                                                first_name AS sender
                                                                                              FROM users
                                                                                                INNER JOIN transactions
                                                                                                  ON transactions.sender
                                                                                                     = users.uid) AS b
               WHERE a.cost :: NUMERIC > 0;
END;
$$;
 -   DROP FUNCTION public.get_all_transactions();
       public       oliver    false    1    4            �            1255    16944    get_credit_data(integer)    FUNCTION     �  CREATE FUNCTION public.get_credit_data(searcheduser integer) RETURNS TABLE(owner text, sender text, cost numeric, date date, description text)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY SELECT
                 a.owner,
                 b.sender,
                 a.cost,
                 a.date,
                 a.description
               FROM (
                      SELECT
                        transactionid,
                        first_name AS owner,
                        transactions.cost,
                        transactions.date,
                        transactions.description
                      FROM
                        transactions
                        INNER JOIN users ON transactions.owner = users.uid
                      WHERE users.uid = searchedUser) AS a
                 NATURAL JOIN (
                                SELECT
                                  transactionid,
                                  first_name AS sender
                                FROM users
                                  INNER JOIN transactions ON transactions.sender = users.uid) AS b;
END;
$$;
 <   DROP FUNCTION public.get_credit_data(searcheduser integer);
       public       oliver    false    1    4            �            1255    16946    get_debt_data(integer)    FUNCTION     �  CREATE FUNCTION public.get_debt_data(searcheduser integer) RETURNS TABLE(owner text, sender text, cost numeric, date date, description text)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY SELECT
                 a.owner,
                 b.sender,
                 -1 * a.cost,
                 a.date,
                 a.description
               FROM (
                      SELECT
                        transactionid,
                        first_name AS owner,
                        transactions.cost,
                        transactions.date,
                        transactions.description
                      FROM
                        transactions
                        INNER JOIN users ON transactions.sender = users.uid
                      WHERE users.uid = searchedUser) AS a
                 NATURAL JOIN (
                                SELECT
                                  transactionid,
                                  first_name AS sender
                                FROM users
                                  INNER JOIN transactions ON transactions.owner = users.uid) AS b;
END;
$$;
 :   DROP FUNCTION public.get_debt_data(searcheduser integer);
       public       oliver    false    1    4            �            1259    24980    test    TABLE     C   CREATE TABLE public.test (
    username text,
    password text
);
    DROP TABLE public.test;
       public         oliver    false    4            �            1259    16816    transactions    TABLE     �   CREATE TABLE public.transactions (
    transactionid integer NOT NULL,
    owner integer NOT NULL,
    sender integer NOT NULL,
    cost numeric(7,2) NOT NULL,
    date date DEFAULT ('now'::text)::date NOT NULL,
    description text
);
     DROP TABLE public.transactions;
       public         oliver    false    4            �            1259    16823    transactions_transactionid_seq    SEQUENCE     �   CREATE SEQUENCE public.transactions_transactionid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.transactions_transactionid_seq;
       public       oliver    false    4    197            5           0    0    transactions_transactionid_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.transactions_transactionid_seq OWNED BY public.transactions.transactionid;
            public       oliver    false    198            �            1259    16825    users    TABLE     �   CREATE TABLE public.users (
    uid integer NOT NULL,
    first_name text NOT NULL,
    last_name text NOT NULL,
    username text,
    password text
);
    DROP TABLE public.users;
       public         oliver    false    4            �            1259    16831    users_uid_seq    SEQUENCE     v   CREATE SEQUENCE public.users_uid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.users_uid_seq;
       public       oliver    false    4    199            6           0    0    users_uid_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.users_uid_seq OWNED BY public.users.uid;
            public       oliver    false    200            �
           2604    16833    transactions transactionid    DEFAULT     �   ALTER TABLE ONLY public.transactions ALTER COLUMN transactionid SET DEFAULT nextval('public.transactions_transactionid_seq'::regclass);
 I   ALTER TABLE public.transactions ALTER COLUMN transactionid DROP DEFAULT;
       public       oliver    false    198    197            �
           2604    16834 	   users uid    DEFAULT     f   ALTER TABLE ONLY public.users ALTER COLUMN uid SET DEFAULT nextval('public.users_uid_seq'::regclass);
 8   ALTER TABLE public.users ALTER COLUMN uid DROP DEFAULT;
       public       oliver    false    200    199            +          0    24980    test 
   TABLE DATA                     public       oliver    false    201   �/       '          0    16816    transactions 
   TABLE DATA                     public       oliver    false    197   �0       )          0    16825    users 
   TABLE DATA                     public       oliver    false    199   J2       7           0    0    transactions_transactionid_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.transactions_transactionid_seq', 20, true);
            public       oliver    false    198            8           0    0    users_uid_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.users_uid_seq', 25, true);
            public       oliver    false    200            �
           2606    16836    transactions transactions_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (transactionid);
 H   ALTER TABLE ONLY public.transactions DROP CONSTRAINT transactions_pkey;
       public         oliver    false    197            �
           2606    16838    users users_pkey 
   CONSTRAINT     O   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (uid);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public         oliver    false    199            �
           2606    16839 $   transactions transactions_owner_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_owner_fkey FOREIGN KEY (owner) REFERENCES public.users(uid);
 N   ALTER TABLE ONLY public.transactions DROP CONSTRAINT transactions_owner_fkey;
       public       oliver    false    197    2731    199            �
           2606    16844 %   transactions transactions_sender_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_sender_fkey FOREIGN KEY (sender) REFERENCES public.users(uid);
 O   ALTER TABLE ONLY public.transactions DROP CONSTRAINT transactions_sender_fkey;
       public       oliver    false    197    2731    199            +   �   x���v
Q���W((M��L�+I-.Q�(-N-�K�M�Q(H,..�/J�Ts�	uV�P)Q�QPW1JT10S���H16�r�K�I���3��6K-Oʉ
07
�JqO���5�(�,K��LNt7�pV״��� >�'A      '   �  x���[K�0 �����6�V�^�OS�vW�9�Gh��t��{�v�*}5ph	�qnY���s�u�������L�k�����I��D�AY�7W��`5�'���}y	���K����(��\�8"tR�xlOyhvB��˛��%Q#�m�!Q����5�
�LG�w>Hq�q��g"qHgz�C���L�
jc|>�gɌAビvII��I�&��*
T��*/��t�)�l{԰bZ(�'���յ�T�S=g��<��A�u�M���2ܴm�mS�x��K�ۃ,J/�CI�����M�BA�	�7m��͵�K���U�����ߖ�8����|���E���RO�40�x�5�l#-W��ŗ�f��ܢ}dr���j6�n
:Ġ^n�v�l�C���<ؿ7%i���tϚ���;�ܔW(�
�Fߙ���      )   �  x�ŖOO�@��|��-b,�'�5��A<��aӥKv[�~zw�F�2^�9���l�{3��4y���d��M��*?lZ'��*��MYW�V�ƾ��]�+m��v�=1�J����F}!3��h��f���a���s���ް3�s��� /��PH�1�p�=��=k��ڄ��C�'�׺^᎘�F���{n�YB�4��z�Q7�*/�P�p��KϺ3+����0 �#Ozĺu�#ؒC�Q���=���T&�5�M����Nɩ#�v(ﱪ�d�XC+�U���Bv���sH��D��nT�j)eo(�I��f�@�<e�s7���0�S$Yp�P��:hYقylc�d�-`��iz�B&��@�0L�%�m��v�-�c��4�-2o1���>QP]-,�`M�TU��`
��G���H�ԃ��N��`V     