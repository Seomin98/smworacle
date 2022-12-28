--@�ǽ�����
--kh���� ������ �� employee, job, department���̺��� �Ϻ������� ����ڿ��� �����Ϸ��� �Ѵ�.
-- ������̵�, �����, ���޸�, �μ���, �����ڸ�, �Ի����� �÷������� ��(v_emp_info)�� (�б� ��������) �����Ͽ���.
CREATE OR REPLACE VIEW V_EMP_INFO
AS SELECT E.EMP_ID AS ������̵�, E.EMP_NAME AS �����
, JOB_NAME AS ���޸�, DEPT_TITLE AS �μ���
, M.EMP_NAME AS �����ڸ�
, E.HIRE_DATE AS �Ի���
FROM EMPLOYEE E
LEFT JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
LEFT JOIN EMPLOYEE M ON M.EMP_ID = E.MANAGER_ID;
-- ORA-00955: name is already used by an existing object
SELECT * FROM V_EMP_INFO;
DROP VIEW V_EMP_INFO;

-- VIEW �ɼ�
-- VIEW�� ���� �Ŀ� �����ؾߵ� ��� ���� �� ������ؾ���.
-- 1. OR REPLACE
-- > ������ �䰡 �����ϸ� �並 ��������.
--CREATE OR REPLACE SEQUENCE SEQ_USERNO; (X)
--CREATE OR REPLACE TABLE EMPLOYEE; (X)
-- 2. FORCE/NOFORCE
-- �⺻���� NOFORCE�� �����Ǿ� ����.
CREATE OR REPLACE FORCE VIEW V_FORCE_SOMETHING
AS SELECT EMP_ID, EMP_NO FROM NOTHING_TBL;
-- ORA-00942: table or view does not exist
-- 3. WITH CHECK OPTION
-- > WHERE�� ���ǿ� ����� �÷��� ���� �������� ���ϰ� ��.
CREATE OR REPLACE VIEW V_EMP_D5
AS SELECT EMP_ID, EMP_NAME, SALARY, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' WITH CHECK OPTION;
SELECT * FROM V_EMP_D5;
UPDATE V_EMP_D5 SET EMP_NAME = '������' 
WHERE SALARY >= 800000;
UPDATE V_EMP_D5 SET DEPT_CODE = 'D2'
WHERE SALARY >= 8500000;
-- ORA-01402: view WITH CHECK OPTION where-clause violation
ROLLBACK;
-- 4. WITH READ ONLY
-- View�����ϱ�
CREATE OR REPLACE VIEW V_EMPLOYEE
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WITH READ ONLY;
-- �б� �������� ����
-- View V_EMPLOYEE��(��) �����Ǿ����ϴ�.

-- View����
UPDATE V_EMPLOYEE
SET DEPT_CODE = 'D8'
WHERE EMP_ID = 200;
-- ORA-42399: cannot perform a DML operation on a read-only view

-- SEQUENCE �ǽ�
--@�ǽ�����
--���� ��ǰ�ֹ��� ����� ���̺� TBL_ORDER�� �����, ������ ���� �÷��� �����ϼ���
-- ORDER_NO(�ֹ�NO) : PK
-- USER_ID(�����̵�)
-- PRODUCT_ID(�ֹ���ǰ���̵�)
-- PRODUCT_CNT(�ֹ�����) 
-- ORDER_DATE : DEFAULT SYSDATE
CREATE TABLE ORDER_TBL(
    ORDER_NO NUMBER, 
    USER_ID VARCHAR2(20),
    PRODUCT_ID VARCHAR(30),
    PRODUCT_CNT NUMBER,
    ORDER_DATE DATE DEFAULT SYSDATE,
    CONSTRAINT PK_ORDER_NO PRIMARY KEY(ORDER_NO)
);
-- ORDER_NO�� ������ SEQ_ORDER_NO�� �����, ���� �����͸� �߰��ϼ���.(����ð� ����)
-- * kang���� saewookkang��ǰ�� 5�� �ֹ��ϼ̽��ϴ�.
-- * gam���� gamjakkang��ǰ�� 30�� �ֹ��ϼ̽��ϴ�.
-- * ring���� onionring��ǰ�� 50�� �ֹ��ϼ̽��ϴ�.
CREATE SEQUENCE SEQ_ORDER_NO;
INSERT INTO ORDER_TBL
VALUES(SEQ_ORDER_NO.NEXTVAL, 'kang', 'saewookkang', 5, DEFAULT);
INSERT INTO ORDER_TBL
VALUES(SEQ_ORDER_NO.NEXTVAL, 'gam', 'gamjakkang', 30, DEFAULT);
INSERT INTO ORDER_TBL
VALUES(SEQ_ORDER_NO.NEXTVAL, 'ring', 'onionring', 50, DEFAULT);
SELECT * FROM ORDER_TBL;
COMMIT;
ROLLBACK;
INSERT INTO ORDER_TBL
VALUES(1, 'khuser01', 'product01', 1, DEFAULT);
ROLLBACK;

-- �ǽ�����2
--KH_MEMBER ���̺��� ����
--�÷�
--MEMBER_ID	NUNBER
--MEMBER_NAME	VARCHAR2(20)
--MEMBER_AGE	NUMBER
--MEMBER_JOIN_COM	NUMBER
CREATE TABLE KH_MEMBER(
    MEMBER_ID NUMBER,
    MEMBER_NAME VARCHAR2(20),
    MEMBER_AGE NUMBER,
    MEMBER_JOIN_COM NUMBER
);
INSERT INTO KH_MEMBER
VALUES(1, '�Ͽ���', 22, 1);
SELECT * FROM KH_MEMBER;
ROLLBACK;
--�̶� �ش� ������� ������ INSERT �ؾ� ��
--ID ���� JOIN_COM�� SEQUENCE �� �̿��Ͽ� ������ �ְ��� ��

--1. ID���� 500 �� ���� �����Ͽ� 10�� �����Ͽ� ���� �ϰ��� ��
--2. JOIN_COM ���� 1������ �����Ͽ� 1�� �����Ͽ� ���� �ؾ� ��
--(ID ���� JOIN_COM ���� MAX�� 10000���� ����)
CREATE SEQUENCE SEQ_MEMBER_ID
START WITH 500
INCREMENT BY 10
MAXVALUE 10000;
CREATE SEQUENCE SEQ_JOIN_COME
MAXVALUE 10000;
SELECT * FROM USER_SEQUENCES;
INSERT INTO KH_MEMBER VALUES(SEQ_MEMBER_ID.NEXTVAL, 'ȫ�浿', 20, SEQ_JOIN_COME.NEXTVAL);
INSERT INTO KH_MEMBER VALUES(SEQ_MEMBER_ID.NEXTVAL, '�踻��', 30, SEQ_JOIN_COME.NEXTVAL);
INSERT INTO KH_MEMBER VALUES(SEQ_MEMBER_ID.NEXTVAL, '�ֻ��', 40, SEQ_JOIN_COME.NEXTVAL);
INSERT INTO KH_MEMBER VALUES(SEQ_MEMBER_ID.NEXTVAL, '����', 24, SEQ_JOIN_COME.NEXTVAL);
SELECT * FROM KH_MEMBER;
--	MEMBER_ID	MEMBER_NAME	 MEMBER_AGE	 MEMBER_JOIN_COM	
--	500		        ȫ�浿		20		        1
--	510		        �踻��		30		        2
--	520		        �����		40		        3
--	530		        ����		24		        4

-- 1. VIEW
-- > DATA DICTIONARY VIEW
-- 2. SEQUENCE
-- 3. ROLE

-- ###ROLE
-- > ����ڿ��� ���� ���� ������ �ѹ��� �ο��� �� �ִ� �����ͺ��̽� ��ü
-- > ����ڿ��� ������ �ο��� �� �Ѱ��� �ο��� �ȴٸ� ���� �ο� �� ȸ���� ������ �����ϹǷ� ���!
-- EX. GRANT CONNECT, RESOURCE TO KH;
-- ���Ѱ� ���õ� ��ɾ�� �ݵ�� SYSTEM���� ����!
-- CONNECT, RESOURCE ���̴�. ���� ������ �������� ���ִ�.
-- ���� �ʿ��� ������ ��� ������ �� ���ϰ� �ο�, ȸ���� �� ���ϴ�!!
-- ROLE
-- CONNECT�� : CREATE SESSION
-- RESOURCE�� : CREATE CLUSTER, CREATE PROCEDURE, CREATE SEQUENCE, CREATE TABLE
--             CREATE TRIGGER, CREATE TYPE, CREATE INDEXTYPE, CREATE OPERATOR;
-- SYSTEM���� ��ȸ ����
-- 1. KH���� ��ȸ ����
-- 2. SYSTEM���� ��ȸ�ȵ�
-- 3. KH���� �ο��޾Ұ�, SYSTEM���� �ο���������.
SELECT * FROM ROLE_SYS_PRIVS
WHERE ROLE = 'CONNECT';
-- ROLE ����
CREATE ROLE ROLE_PUBLIC_EMP;
-- ORA-01031: insufficient privileges
GRANT SELECT ON KH.V_EMP_INFO TO ROLE_PUBLIC_EMP;
-- ORA-01031: insufficient privileges
GRANT SELECT ON KH.V_EMP_INFO TO ROLE_PUBLIC_EMP;
-- Grant��(��) �����߽��ϴ�. (KH����)
-- �̰��� ������!
-- �����
GRANT ROLE_PUBLIC_EMP TO ������;
-- ORA-01031: insufficient privileges
SELECT * FROM USER_SYS_PRIVS;

-- 4. INDEX
-- SQL ��ɹ��� ó���ӵ��� ����Ű�� ���ؼ� �÷��� ���ؼ� �����ϴ� ����Ŭ ��ü
--> key-value ���·� ������ �Ǹ� key���� �ε����� ���� �÷���, value���� ���� ����� 
-- �ּҰ��� �����.
-- * ���� : �˻��ӵ��� �������� �ý��ۿ� �ɸ��� ���ϸ� �ٿ��� �ý��� ��ü ������ ����ų �� ����.
-- * ���� : 1. �ε����� ���� �߰� ���� ������ �ʿ��ϰ�, �ε����� �����ϴµ� �ð��� �ɸ�
--         2. �������� �����۾�(INSERT/UPDATE/DELETE)�� ���� �Ͼ�� ���̺� INDEX ������
--            ������ �������ϰ� �߻��� �� ����.
-- SELECT�� �� ���Ǵ� BUFFER CACHE�� �÷����� �۾�
-- * � �÷��� �ε����� ����� ������?
-- �����Ͱ��� �ߺ��� ���� ���� ������ �����Ͱ��� ������ �÷��� ����� ���� ���� ����.
-- �׸��� ���� ���Ǵ� �÷��� ����� ����.
-- * ȿ������ �ε��� ��� ��
-- WHERE���� ���� ���Ǵ� �÷��� �ε��� ����
-- > ��ü ������ �߿��� 10% ~ 15% �̳��� �����͸� �˻��ϴ� ���, �ߺ��� ���� ���� �÷��̾�� ��.
-- > �� �� �̻��� �÷� WHERE���̳� ����(join)�������� ���� ���Ǵ� ���
-- > �� �� �Էµ� ������ ���� �Ͼ�� �ʴ� ���
-- >  �� ���̺� ����� ������ �뷮�� ����� Ŭ ���
--* ��ȿ������ �ε��� ��� ��
-- �ߺ����� ���� �÷��� ���� �ε���
-- NULL���� ���� �÷��� ���� �ε���
-- �ε��� ���� ��ȸ
SELECT * FROM USER_INDEXES
WHERE TABLE_NAME = 'EMPLOYEE';
-- �ѹ��� ������ �ʾ����� PK, UNIQUE �������� �÷��� �ڵ����� ������ �̸��� �ε����� ������
-- INDEX ����
-- CREATE INDEX �ε����� ON ���̺��(�÷���1, �÷���2, ...);
SELECT * FROM EMPLOYEE WHERE EMP_NAME = '������';
-- ����Ŭ �÷�, Ʃ���� �� ����ϰ� F10���� ���డ����.
CREATE INDEX IDX_EMP_NAME ON EMPLOYEE(EMP_NAME);
-- Index IDX_EMP_NAME��(��) �����Ǿ����ϴ�.
DROP INDEX IDX_EMP_NAME;

SELECT * FROM USER_SEQUENCES;
SELECT * FROM USER_VIEWS;
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'EMPLOYEE';
SELECT * FROM USER_TABLES;


-- ������ ��ųʸ�(DD, DATA DICTIONARY)
-- > �ڿ��� ȿ�������� �����ϱ� ���� �پ��� ������ �����ϴ� �ý��� ���̺�
-- > ������ ��ųʸ��� ����ڰ� ���̺��� �����ϰų� ����ڸ� �����ϴ� ����
--  �۾��� �� �� �����ͺ��̽� ������ ���� �ڵ����� ���ŵǴ� ���̺�
-- ����. ����ڴ� ������ ��ųʸ��� ������ ���� �����ϰų� ������ �� ����.
-- ������ ��ųʸ� �ȿ��� �߿��� ������ ���� �ֱ� ������ ����ڴ� �̸� Ȱ���ϱ� ����
-- ������ ��ųʸ� ��(�������̺�)�� ����ϰ� ��.
-- ������ ��ųʸ� ���� ���� 1
-- 1. USER_XXXX
-- > �ڽ�(����)�� ������ ��ü � ���� ���� ��ȸ����
-- ����ڰ� �ƴ� DB���� �ڵ�����/�������ִ� ���̸� USER_�ڿ� ��ü���� �Ἥ ��ȸ��.
-- 2. ALL_XXXX
-- > �ڽ��� ������ �����ϰų� ������ �ο����� ��ü � ���� ���� ��ȸ����
-- 3. DBA_XXXX
-- > �����ͺ��̽� �����ڸ� ������ ������ ��ü � ���� ���� ��ȸ����
-- (DBA�� ��� ������ �����ϹǷ� �ᱹ DB�� �ִ� ��� ��ü�� ���� ��ȸ ����)
-- �Ϲ� ����ڴ� ������
SELECT * FROM DBA_TABLES;
-- ORA-00942: table or view does not exist

-- 1. VIEW
-- 2. SEQUENCE
-- 3. ROLE
-- 4. INDEX

--����4
--���� ������ ��ձ޿����� ���ų� ���� �޿��� �޴� ������ �̸�, �����ڵ�, �޿�, �޿���� ��ȸ
SELECT EMP_NAME, JOB_CODE, SALARY, SAL_LEVEL
FROM EMPLOYEE E
WHERE SALARY >= (SELECT AVG(SALARY)
                  FROM EMPLOYEE 
                  WHERE E.JOB_CODE = JOB_CODE);

--����5
--�μ��� ��� �޿��� 2200000 �̻��� �μ���, ��� �޿� ��ȸ
--��, ��� �޿��� �Ҽ��� ����, �μ����� ���� ��� '����'ó��
SELECT NVL((SELECT DEPT_TITLE FROM DEPARTMENT WHERE DEPT_ID=EMPLOYEE.DEPT_CODE),'����') �μ���
        ,FLOOR(AVG(SALARY)) ��ձ޿�
FROM EMPLOYEE GROUP BY DEPT_CODE
HAVING AVG(SALARY) >= 2200000;

--����6
--������ ���� ��պ��� ���� �޴� ���ڻ����
--�����,���޸�,�μ���,������ �̸� ������������ ��ȸ�Ͻÿ�
--���� ��� => (�޿�+(�޿�*���ʽ�))*12    
-- �����,���޸�,�μ���,������ EMPLOYEE ���̺��� ���� ����� ������  
SELECT EMP_NAME �����
        , JOB_NAME ����
        , DEPT_TITLE �μ���
        , (SALARY+SALARY*NVL(BONUS,0))*12 ���� 
FROM EMPLOYEE E LEFT JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
    LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE (SALARY+SALARY*NVL(BONUS,0))*12 < (SELECT AVG((SALARY+SALARY*NVL(BONUS,0))*12) FROM EMPLOYEE WHERE E.JOB_CODE=JOB_CODE)
    AND SUBSTR(EMP_NO,8,1) IN (2,4)
ORDER BY 1 ASC;



-- PL/SQL
-- 
SET SERVEROUTPUT ON;
-- sqldeveloper�� ���ٰ� ���� ��
-- �����ߴµ� �ȳ����� ��(DBMS_OUTPUT.PUT_LINE�����µ�..)
BEGIN 
    DBMS_OUTPUT.PUT_LINE('HELLO ORACLE');
END;
/

-- PL/SQL
-- > Oracle's procedural Language Extension to SQL�� ����
-- > ����Ŭ ��ü�� ����Ǿ� �ִ� ������ ���ν�
-- SQL�� ������ �����Ͽ� SQL ���峻���� ������ ����, ����ó��, �ݺ�ó�� ���� ������

-- ## PL/SQL�� ����(�͸���)
-- 1. �����(����)
-- DECLARE : ������ ����� �����ϴ� �κ�
-- 2. �����(�ʼ�)
-- BEGIN : ���, �ݺ���, �Լ� ���� �� ���� ���
-- 3. ����ó����(����)
-- EXCEPTION : ���ܻ��� �߻��� �ذ��ϱ� ���� ���� ���
-- END; -- ��� ����
-- /    -- PL/SQL ���� �� ����

-- '������' �̶�� ����� EMP_ID���� �����Ͽ� ID��� ������ �־��ְ� PUT_LINE�� ���� �����
--���� '������' �̶�� ����� ������ 'No Data!!!' ��� ���� ������ ����ϵ��� ��
DECLARE
        vId NUMBER;
BEGIN
    SELECT EMP_ID
    INTO vId
    FROM EMPLOYEE
    WHERE EMP_NAME = '������';
    DBMS_OUTPUT.PUT_LINE('ID='||vId);
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('NO Data!!');
END;
/

-- ## ���� ����
-- ������ [CONSTRANT] �ڷ���(����Ʈũ��) [NOT NULL] [:=�ʱⰪ];

-- ## ������ ����
-- �Ϲݺ���, ���, %TYPE, %ROWTYPE, ���ڵ�(RECORD)

-- ## ���
-- �Ϲݺ����� �����ϳ� CONSTANT��� Ű���尡 �ڷ��� �տ� �ٰ�
-- ����ÿ� ���� �Ҵ��� �־�� ��
DECLARE
    EMPNO NUMBER := 507;
    ENAME VARCHAR(20) := '�Ͽ���';
BEGIN
    DBMS_OUTPUT.PUT_LINE('��� : ' || EMPNO);
    DBMS_OUTPUT.PUT_LINE('�̸� : ' || ENAME);
END;
/

DECLARE
    USER_NAME VARCHAR2(20) :='�Ͽ���';
    MNAME CONSTANT VARCHAR2(20) := '�����';
BEGIN
    DBMS_OUTPUT.PUT_LINE('�̸� : '|| USER_NAME);
    -- MNAME := '�����';
    -- PLS-00363: expression 'MNAME' cannot be used as an assignment target
    DBMS_OUTPUT.PUT_LINE('��� : '|| USER_NAME);
END;
/

-- PL/SQL������ SELECT��
-- > SQL���� ����ϴ� ��ɾ �״�� ����� �� ������ SELECT ���� ����� ���� ����
-- ������ �Ҵ��ϱ� ���� �����.
--����1)
--PL/SQL�� SELECT������ EMPLOYEE ���̺��� �ֹι�ȣ�� �̸� ��ȸ�ϱ�
DESC EMPLOYEE;
DECLARE
    VEMPNO EMPLOYEE.EMP_NO%TYPE; -- CHAR(14)
    VENAME EMPLOYEE.EMP_NAME%TYPE; -- VARCHAR2(20)
BEGIN
    SELECT EMP_NO AS �ֹι�ȣ, EMP_NAME AS �̸�
    INTO VEMPNO, VENAME
    FROM EMPLOYEE
    WHERE EMP_NAME = '������';
    DBMS_OUTPUT.PUT_LINE('�ֹε�Ϲ�ȣ : '||VEMPNO);
    DBMS_OUTPUT.PUT_LINE('�̸� : '||VENAME);
END;
/

--���� 2)
--������ ����� �����ȣ, �̸�, �޿�, �Ի����� ����Ͻÿ�
DECLARE
    VEMPID EMPLOYEE.EMP_ID%TYPE; -- CHAR(14)
    VENAME EMPLOYEE.EMP_NAME%TYPE; -- VARCHAR2(20)
    VSAL EMPLOYEE.SALARY%TYPE;
    VHIRE EMPLOYEE.HIRE_DATE%TYPE;
BEGIN
    SELECT EMP_ID AS �����ȣ, EMP_NAME AS �̸�, SALARY AS �޿�, HIRE_DATE AS �Ի���
    INTO VEMPID, VENAME, VSAL, VHIRE
    FROM EMPLOYEE
    WHERE EMP_NAME = '������';
    DBMS_OUTPUT.PUT_LINE('�����ȣ : '||VEMPID);
    DBMS_OUTPUT.PUT_LINE('�̸� : '||VENAME);
    DBMS_OUTPUT.PUT_LINE('�޿� : '||VSAL);
    DBMS_OUTPUT.PUT_LINE('�Ի��� : '||VHIRE);
END;
/


--���� 3)
--�����ȣ�� �Է� �޾Ƽ� ����� �����ȣ, �̸�, �޿�, �Ի����� ����Ͻÿ�
DECLARE
    VENAME EMPLOYEE.EMP_NAME%TYPE;
    VSAL EMPLOYEE.SALARY%TYPE;
    VHIRE EMPLOYEE.HIRE_DATE%TYPE;
BEGIN
    SELECT EMP_NAME, SALARY, HIRE_DATE
    INTO VENAME, VSAL, VHIRE
    FROM EMPLOYEE
    WHERE EMP_ID = '&EMPID';
    DBMS_OUTPUT.PUT_LINE('�̸� : '||VENAME);
    DBMS_OUTPUT.PUT_LINE('�޿� : '||VSAL);
    DBMS_OUTPUT.PUT_LINE('�Ի��� : '||VHIRE);
END;
/

--## ���� �ǽ� 1 ##
-- �ش� ����� �����ȣ�� �Է½�
-- �̸�,�μ��ڵ�,�����ڵ尡 ��µǵ��� PL/SQL�� ����� ���ÿ�.
DECLARE
    VENAME EMPLOYEE.EMP_NAME%TYPE;
    VCODE EMPLOYEE.DEPT_CODE%TYPE;
    VJCODE EMPLOYEE.JOB_CODE%TYPE;
BEGIN
    SELECT EMP_NAME, DEPT_CODE, JOB_CODE
    INTO VENAME, VCODE, VJCODE
    FROM EMPLOYEE
    WHERE EMP_ID = '&EMPID';
    DBMS_OUTPUT.PUT_LINE('�̸� : '||VENAME);
    DBMS_OUTPUT.PUT_LINE('�μ��ڵ� : '||VCODE);
    DBMS_OUTPUT.PUT_LINE('�����ڵ� : '||VJCODE);
END;
/
--## ���� �ǽ� 2 ##
-- �ش� ����� �����ȣ�� �Է½�
-- �̸�,�μ���,���޸��� ��µǵ��� PL/SQL�� ����� ���ÿ�
DECLARE
    VENAME EMPLOYEE.EMP_NAME%TYPE;
    VDEPTTITLE DEPARTMENT.DEPT_TITLE%TYPE;
    VJOBNAME JOB.JOB_NAME%TYPE;
BEGIN
    SELECT EMP_NAME, DEPT_TITLE, JOB_NAME
    INTO VENAME, VDEPTTITLE, VJOBNAME
    FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    LEFT JOIN JOB USING(JOB_CODE)
    WHERE EMP_ID = '&EMPID';
    DBMS_OUTPUT.PUT_LINE('�̸� : '||VENAME);
    DBMS_OUTPUT.PUT_LINE('�μ��� : '||VDEPTTITLE);
    DBMS_OUTPUT.PUT_LINE('���޸� : '||VJOBNAME);
END;
/

-- ### PL/SQL�� ���ù�
-- ��� ������� ����� ������� ���������� �����
-- ������ ���������� �����Ϸ��� IF���� ����ϸ��
-- IF ~ THEN ~ END IF; ��

--����1) �����ȣ�� ������ ����� ���,�̸�,�޿�,���ʽ����� ����ϰ�
-- ���ʽ����� ������ '���ʽ��� ���޹��� �ʴ� ����Դϴ�' �� ����Ͻÿ�
DECLARE
    VEMPID EMPLOYEE.EMP_ID%TYPE;
    VNAME EMPLOYEE.EMP_NAME%TYPE;
    VSALARY EMPLOYEE.SALARY%TYPE;
    VBONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS, 0)
    INTO VEMPID, VNAME, VSALARY, VBONUS
    FROM EMPLOYEE
    WHERE EMP_ID = '202';
    DBMS_OUTPUT.PUT_LINE('��� : '||VEMPID);
    DBMS_OUTPUT.PUT_LINE('�̸� : '||VNAME);
    DBMS_OUTPUT.PUT_LINE('�޿� : '||VSALARY);
    -- ���ʽ����� ������ ���ʽ��� ����ϰ�
    -- ���ʽ����� ������ (0�̸�) ���ʽ��� ���޹��� �ʴ� ����Դϴ�. ���
    -- IF ~ THEN ~ END IF; ��
    IF(VBONUS <> 0)
     THEN DBMS_OUTPUT.PUT_LINE('���ʽ� : '|| VBONUS);
     ELSE DBMS_OUTPUT.PUT_LINE('���ʽ��� ���޹��� �ʴ� ����Դϴ�');
     END IF;
END;
/
--����2) ��� �ڵ带 �Է� �޾����� ���,�̸�,�����ڵ�,���޸�,�Ҽ� ���� ����Ͻÿ�
--�׶�, �ҼӰ��� J1,J2 �� �ӿ���, �׿ܿ��� �Ϲ��������� ��µǰ� �Ͻÿ�
DECLARE
    VEMPID EMPLOYEE.EMP_ID%TYPE;
    VEMPNAME EMPLOYEE.EMP_NAME%TYPE;
    VJOBCODE EMPLOYEE.JOB_CODE%TYPE;
    VJOBNAME JOB.JOB_NAME%TYPE;
    VTEAM VARCHAR2(20);
BEGIN
    SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
    INTO VEMPID, VEMPNAME, VJOBCODE, VJOBNAME
    FROM EMPLOYEE
    JOIN JOB USING(JOB_CODE)
    WHERE EMP_ID = '&EMPID';
    IF(VJOBCODE IN ('J1', 'J2'))
    THEN VTEAM := '�ӿ���';
    ELSE VTEAM := '�Ϲ�����';
    END IF;
    DBMS_OUTPUT.PUT_LINE('��� : '||VEMPID);
    DBMS_OUTPUT.PUT_LINE('�̸� : '||VEMPNAME);
    DBMS_OUTPUT.PUT_LINE('�����ڵ� : '||VJOBCODE);
    DBMS_OUTPUT.PUT_LINE('���޸� : '||VJOBNAME);
    DBMS_OUTPUT.PUT_LINE('�Ҽ� : '||VTEAM);
END;
/

--## ���� �ǽ� 1 ##
-- ��� ��ȣ�� ������ �ش� ����� ��ȸ
-- �̶� �����,�μ��� �� ����Ͽ���.
-- ���� �μ��� ���ٸ� �μ����� ������� �ʰ�,
-- '�μ��� ���� ��� �Դϴ�' �� ����ϰ�
-- �μ��� �ִٸ� �μ����� ����Ͽ���.
DECLARE
    VEMPNAME EMPLOYEE.EMP_NAME%TYPE;
    VDTITLE DEPARTMENT.DEPT_TITLE%TYPE;
    VDCODE DEPARTMENT.DEPT_ID%TYPE;
BEGIN
    SELECT EMP_NAME, DEPT_CODE, DEPT_TITLE
    INTO VEMPNAME, VDCODE, VDTITLE
    FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    WHERE EMP_ID = '&�����ȣ';
    DBMS_OUTPUT.PUT_LINE('�̸� : '|| VEMPNAME);
    IF(VDCODE IS NULL)
    THEN DBMS_OUTPUT.PUT_LINE('�μ��� ���� ����Դϴ�.');
    ELSE DBMS_OUTPUT.PUT_LINE('�μ��� : '|| VDTITLE);
    END IF;
END;
/

--## ���� �ǽ�2 ##
--����� �Է� ���� �� �޿��� ���� ����� ������ ����ϵ��� �Ͻÿ� 
--�׶� ��� ���� ���,�̸�,�޿�,�޿������ ����Ͻÿ�

--0���� ~ 99���� : F
--100���� ~ 199���� : E
--200���� ~ 299���� : D
--300���� ~ 399���� : C
--400���� ~ 499���� : B
--500���� �̻�(�׿�) : A

--ex) 200
--��� : 200
--�̸� : ������
--�޿� : 8000000
--��� : A
DECLARE
    VEMPID EMPLOYEE.EMP_ID%TYPE;
    VEMPNAME EMPLOYEE.EMP_NAME%TYPE;
    VSALARY EMPLOYEE.SALARY%TYPE;
    SGRADE VARCHAR2(3);
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY
    INTO VEMPID, VEMPNAME, VSALARY
    FROM EMPLOYEE
    WHERE EMP_ID = '&�˻��һ��';
    IF(VSALARY >= 0 AND VSALARY <= 99) THEN SGRADE := 'F';
    ELSIF(VSALARY >= 100 AND VSALARY <= 199) THEN SGRADE := 'E';
    ELSIF(VSALARY >= 200 AND VSALARY <= 299) THEN SGRADE := 'D';
    ELSIF(VSALARY >= 300 AND VSALARY <= 399) THEN SGRADE := 'C';
    ELSIF(VSALARY >= 400 AND VSALARY <= 499) THEN SGRADE := 'B';
    ELSE SGRADE := 'A';
    END IF;
    DBMS_OUTPUT.PUT_LINE('��� : '||VEMPID);
    DBMS_OUTPUT.PUT_LINE('�̸� : '||VEMPNAME);
    DBMS_OUTPUT.PUT_LINE('�޿� : '||VSALARY);
    DBMS_OUTPUT.PUT_LINE('��� : '||SGRADE);
END;
/

-- CASE��
-- CASE ����
--      WHEN ��1 THEN ���๮1;
--      WHEN ��1 THEN ���๮2;
--      ELSE ���๮3;
-- END CASE;
DECLARE
    VEMPID EMPLOYEE.EMP_ID%TYPE;
    VEMPNAME EMPLOYEE.EMP_NAME%TYPE;
    VSALARY EMPLOYEE.SALARY%TYPE;
    SGRADE VARCHAR2(3);
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY
    INTO VEMPID, VEMPNAME, VSALARY
    FROM EMPLOYEE
    WHERE EMP_ID = '&�˻��һ��';
    VSALARY := VSALARY / 10000;
    CASE
        WHEN (VSALARY >= 0 AND VSALARY <= 99)    THEN SGRADE := 'F';
        WHEN (VSALARY BETWEEN 100 AND 199)       THEN SGRADE := 'E';
        WHEN (VSALARY BETWEEN 100 AND 199)       THEN SGRADE := 'D';
        WHEN (VSALARY >= 300 AND VSALARY <= 399) THEN SGRADE := 'C';
        WHEN (VSALARY >= 400 AND VSALARY <= 499) THEN SGRADE := 'B';
        ELSE SGRADE := 'A';
        END CASE;
    DBMS_OUTPUT.PUT_LINE('��� : '||VEMPID);
    DBMS_OUTPUT.PUT_LINE('�̸� : '||VEMPNAME);
    DBMS_OUTPUT.PUT_LINE('�޿� : '||VSALARY || '����');
    DBMS_OUTPUT.PUT_LINE('��� : '||SGRADE);
END;
/
SET SERVEROUTPUT ON;
 DECLARE
    VEMPID EMPLOYEE.EMP_ID%TYPE;
    VENAME EMPLOYEE.EMP_NAME%TYPE;
    VSALARY EMPLOYEE.SALARY%TYPE;
    SGRADE VARCHAR2(3);
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY
    INTO VEMPID, VENAME, VSALARY
    FROM EMPLOYEE
    WHERE EMP_ID = '&�˻��һ��';
    VSALARY := VSALARY / 10000;
    CASE FLOOR(VSALARY/100)
        WHEN 0 THEN SGRADE := 'F';
        WHEN 1 THEN SGRADE := 'E';
        WHEN 2 THEN SGRADE := 'D';
        WHEN 3 THEN SGRADE := 'C';
        WHEN 4 THEN SGRADE := 'B';
        ELSE SGRADE := 'A';
    END CASE;    
    DBMS_OUTPUT.PUT_LINE('��� : '|| VEMPID);
    DBMS_OUTPUT.PUT_LINE('�̸� : '|| VENAME);
    DBMS_OUTPUT.PUT_LINE('�޿� : '|| VSALARY || '����');
    DBMS_OUTPUT.PUT_LINE('��� : '|| SGRADE);
END;
/

