--@DQL���սǽ�����

--����1
--��������ο� ���� ������� ����� �̸�,�μ��ڵ�,�޿��� ����Ͻÿ�.
SELECT EMP_NAME AS �̸�, DEPT_CODE AS �μ��ڵ�, SALARY AS �޿�
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE DEPT_TITLE = '���������';
--����2
--��������ο� ���� ����� �� ���� ������ ���� ����� �̸�,�μ��ڵ�,�޿��� ����Ͻÿ�

SELECT EMP_NAME AS �̸�, DEPT_CODE AS �μ��ڵ�, SALARY AS �޿�
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE DEPT_TITLE = '���������' 
AND SALARY = (SELECT MAX(SALARY) FROM EMPLOYEE JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID 
WHERE DEPT_TITLE = '���������');


--����3
--�Ŵ����� �ִ� ����߿� ������ ��ü��� ����� �Ѱ� 
--���,�̸�,�Ŵ��� �̸�, ������ ���Ͻÿ�.
-- > ���� ������ �Ŵ����̸� ���ϴ°� ����Ʈ
SELECT EMP_ID AS ���, EMP_NAME AS �̸�
, (SELECT EMP_NAME FROM EMPLOYEE WHERE EMP_ID = E.MANAGER_ID) AS "�Ŵ��� �̸�", SALARY AS ����
FROM EMPLOYEE E
WHERE MANAGER_ID IS NOT NULL AND SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE);



-- ## �������
-- ### 1. TOP-N �м�
-- ### 2. WITH
-- ### 3. ������ ����(Hiererchical Query)
-- ### 4. ������ �Լ�
-- #### 4.1 ���� �Լ�

-- ## JOIN�� ����3
-- 1. ��ȣ����(CROSS JOIN)
-- ī���̼� ��(Cartensial product)��� ��
-- ���εǴ� ���̺��� �� ����� ��� ���ε� ���� ���
-- �ٽø���, ���� ���̺��� ��� ��� �ٸ��� ���̺��� ��� ���� ���� ��Ŵ
-- ��� ����� ���� ���ϹǷ� ����� �� ���̺��� �÷����� ���� ������ ����.
-- 4 * 3 = ?
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE CROSS JOIN DEPARTMENT;
--@�ǽ�����
--�Ʒ�ó�� �������� �ϼ���.
----------------------------------------------------------------
-- �����ȣ    �����     ����    ��տ���    ����-��տ���
----------------------------------------------------------------
SELECT EMP_ID AS �����ȣ, EMP_NAME AS �����, SALARY AS ����
, AVG_SAL AS ��տ���
, (CASE WHEN SALARY-AVG_SAL > 0 THEN '+' END) || (SALARY-AVG_SAL) AS "����-��տ���"
FROM EMPLOYEE
CROSS JOIN (SELECT ROUND(AVG(SALARY)) "AVG_SAL" FROM EMPLOYEE);

-- 2. ��������(SELF JOIN)
--�Ŵ����� �ִ� ����߿� ������ ��ü��� ����� �Ѱ� ���,�̸�,�Ŵ��� �̸�, ������ ���Ͻÿ�.
SELECT EMP_ID AS ���, EMP_NAME AS �̸�
, (SELECT EMP_NAME FROM EMPLOYEE WHERE EMP_ID = E.MANAGER_ID) AS "�Ŵ��� �̸�", SALARY AS ����
FROM EMPLOYEE E
WHERE MANAGER_ID IS NOT NULL AND SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE);
-- ��������� �̿��� �Ŵ��� �̸� ���ϱ� ��� ���� ���� ���� ������ �̿��ؼ� ���� �� ����.
SELECT E.EMP_ID, E.EMP_NAME, M.EMP_NAME, E.SALARY
FROM EMPLOYEE E
JOIN EMPLOYEE M
ON M.EMP_ID = E.MANAGER_ID;

SELECT EMP_ID, EMP_NAME, MANAGER_ID FROM EMPLOYEE;


-- # ��������
-- ## 1. CHECK
-- 1. ���̺� USER_CHECK, CHAR(1) �Ǽ�
-- 2. CHAR(1) -> CHAR(3)
-- 3. INSERT INTO, 4���� ����
-- 4. CHECK ����, �̹� ������� ���̺��̶� ALTER TABLE
-- 5. BUT M,F�� �� �־ DELETE FROM, 4���� ����
-- 6. ALTER TABLE ADD�� �������� �߰�
-- 7. INSERT INTO �ؼ� M, F�� ������ �� Ȯ��('��','��'�� ��)

CREATE TABLE USER_CHECK (
    USER_NO NUMBER PRIMARY KEY,
    USER_NAME VARCHAR2(30) NOT NULL,
    USER_GENDER CHAR(1) CONSTRAINT GENDER_VAL CHECK (USER_GENDER IN('��', '��'))
);
-- �̹� ���̺��� ����� ���� ���¿��� ���������� �����ϴ� ���
ALTER TABLE USER_CHECK 
MODIFY USER_GENDER CHAR(3);
-- �̹� ���̺��� ����� ���� ���¿��� ���������� �߰��ϴ� ���
DELETE FROM USER_CHECK;
-- 4�� �� ��(��) �����Ǿ����ϴ�.
ALTER TABLE USER_CHECK
ADD CONSTRAINT GENDER_VAL CHECK (USER_GENDER IN('��', '��'));


INSERT INTO USER_CHECK VALUES('1', '�Ͽ���', '��');
INSERT INTO USER_CHECK VALUES('2', '�̿���', '��');
INSERT INTO USER_CHECK VALUES('3', '�����', 'M');
INSERT INTO USER_CHECK VALUES('4', '�����', 'F');

-- ## 2. DEFAULT
-- DDL, DML, DCL, TCL
CREATE TABLE USER_DEFAULT(
    USER_NO NUMBER CONSTRAINT USERNO_PK PRIMARY KEY,
    USER_NAME VARCHAR2(30) NOT NULL,
    USER_DATA DATE DEFAULT SYSDATE,
    USER_YN CHAR(1) DEFAULT 'Y'
);
-- ���Գ�¥, ȸ������ ���� �÷��� �⺻���� ������ �� ����
-- Table USER_DEFAULT��(��) �����Ǿ����ϴ�.
DROP TABLE USER_DEFAULT;
-- Table USER_DEFAULT��(��) �����Ǿ����ϴ�.
ALTER TABLE USER_DEFAULT
ADD USER_DATE DEFAULT SYSDATE;
-- DROP�� �δ�Ǹ� ALTER TABLE ���
INSERT INTO USER_DEFAULT VALUES(1, '�Ͽ���', '2022-12-23', 'Y');
INSERT INTO USER_DEFAULT VALUES(2, '�Ͽ���', 'SYSDATE', 'N');

-- TCL

INSERT INTO USER_DEFAULT VALUES(1, '�Ͽ���', DEFAULT, DEFAULT);
INSERT INTO USER_DEFAULT VALUES(2, '�̿���', DEFAULT, DEFAULT);
INSERT INTO USER_DEFAULT VALUES(3, '�����', DEFAULT, DEFAULT);
INSERT INTO USER_DEFAULT VALUES(4, '�����', DEFAULT, DEFAULT); -- ���� Ŀ��, Ʈ����� ����
INSERT INTO USER_DEFAULT VALUES(5, '������', DEFAULT, DEFAULT); -- �ӽ����� SAVEPOINT temp1
SAVEPOINT temp1;
INSERT INTO USER_DEFAULT VALUES(6, '������', DEFAULT, DEFAULT);
INSERT INTO USER_DEFAULT VALUES(7, 'ĥ����', DEFAULT, DEFAULT);
SAVEPOINT temp1;
ROLLBACK;
ROLLBACK TO temp1;
COMMIT; -- ��������
SELECT * FROM USER_DEFAULT;

-- TCL
-- Ʈ������̶�?
-- �Ѳ����� ����Ǿ�� �� �ּ��� �۾� ������ ����, 
-- �ϳ��� Ʈ��������� �̷���� �۾����� �ݵ�� �Ѳ����� �Ϸᰡ �Ǿ�� �ϸ�,
-- TCL
-- Ʈ������̶�?
-- �Ѳ����� ����Ǿ�� �� �ּ��� �۾� ������ ����, 
-- �ϳ��� Ʈ��������� �̷���� �۾����� �ݵ�� �Ѳ����� �Ϸᰡ �Ǿ�� �ϸ�,
-- �׷��� ���� ��쿡�� �Ѳ����� ��� �Ǿ�� ��
-- TCL�� ����
-- 1. COMMIT : Ʈ����� �۾��� ���� �Ϸ� �Ǹ� ���� ������ ������ ���� (��� savepoint ����)
-- 2. ROLLBACK : Ʈ����� �۾��� ��� ����ϰ� ���� �ֱ� commit �������� �̵�
-- 3. SAVEPOINT : ���� Ʈ����� �۾� ������ �̸��� ������, �ϳ��� Ʈ����� �ȿ��� ������ ������ ����
-- >> ROLLBACK TO ���̺�����Ʈ�� : Ʈ����� �۾��� ����ϰ� savepoint �������� �̵�

-- # DCL(Data Control Language)
-- ������ ����� --> System�������� �ؾ߸� ��
-- DB�� ���� ����, ���Ἲ, ���� �� DBSM�� �����ϱ� ���� ���
-- ���Ἲ�̶�? ��Ȯ��, �ϰ����� �����ϴ� ��
-- ������� �����̳� ������ ���� ���� ó��
-- DCL�� ����
-- 1. GRANT : ���� �ο�
-- 2. REVOKE : ���� ȸ��
-- GRANT CONNECT, RESOURCE TO STUDENT; -- System������ �����ؼ� �ϼ���!!
-- CONNECT, RESOURCE ���̴�. ���� ������ �������� ���ִ�.
-- ���� �ʿ��� ������ ��� ������ �� ���ϰ� �ο�, ����, ȸ���� �� ���ϴ�!!
-- ROLE
-- CONNECT�� : CREATE SESSION;
-- RESOURCE�� : CREATE CLUSTER, CREATE PROCEDURE, CREATE SEQUENCE, CREATE TABLE
--             CREATE TRIGGER, CREATE TYPE, CREATE INDEXTYPE, CREATE OPERATOR;



SELECT DISTINCT OBJECT_TYPE FROM ALL_OBJECTS;
-- ### 1. VIEW
-- > �ϳ� �̻��� ���̺��� ���ϴ� �����͸� �����Ͽ� ������ ���̺��� ����� �ִ°�
-- �ٸ� ���̺� �ִ� �����͸� ������ ���̸�, ������ ��ü�� �����ϰ� �ִ� ���� �ƴ�
-- ��, ������ġ ���� ���������� �������� �ʰ� �������̺�� �������
-- �������� ���� ���̺���� ��ũ ����
--> �並 ����ϸ� Ư�� ����ڰ� ���� ���̺� �����Ͽ� ��� �����͸� ���� �ϴ� ���� ������ �� ����.
-- �ٽø���, ���� ���̺��� �ƴ� �並 ���� Ư�� �����͸� �������� ����
--> �並 ����� ���ؼ��� ������ �ʿ���. RESOURCE�ѿ��� ���ԵǾ����� ����!!!(����)
-- GRANT CREATE VIEW TO KH; (�ý��� �������� ����)
-- Grant��(��) �����߽��ϴ�.

-- VIEW ����
CREATE VIEW V_EMPLOYEE
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE;
SELECT * FROM( SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE 
FROM EMPLOYEE);

SELECT * FROM V_EMPLOYEE
WHERE EMP_ID = 200;

-- VIEW ����
UPDATE V_EMPLOYEE
SET DEPT_CODE = 'D8'
WHERE EMP_ID = 200;

-- �������̺� Ȯ��
SELECT * FROM EMPLOYEE WHERE EMP_ID = 200;
--> VIEW�� ���� ������!!

-- VIEW ����2
UPDATE V_EMPLOYEE
SET SALARY = 600000
WHERE EMP_ID = 200;
-- ORA-00904: "SALARY": invalid identifier, �ȵȴ�!

-- VIEW �����ϱ�
DROP VIEW V_EMPLOYEE;



CREATE VIEW V_EMP_READ
AS SELECT EMP_ID, DEPT_TITLE FROM EMPLOYEE JOIN DEPARTMENT
ON DEPT_CODE = DEPT_ID;

SELECT * FROM V_EMP_READ;

-- ### 2. Sequence(������)
-- ���������� ���� ���� �ڵ����� �����ϴ� ��ü�� �ڵ� ��ȣ �߻���(ä����)�� ������ ��
-- CREATE SEQUENCE ��������
-- ���������� �ɼ��� 6���� ����! START WITH, INCREMENT BY, MAXVALUE, MINVALUE, CYCLE, CACHE
SELECT * FROM USER_DEFAULT;
COMMIT;
DELETE FROM USER_DEFAULT;
INSERT INTO USER_DEFAULT VALUES(1, '�Ͽ���', 2022-12-23, DEFAULT);
-- ������ ����
CREATE SEQUENCE SEQ_USERNO;
-- ������ ����
DROP SEQUENCE SEQ_USERNO;
-- ������� ������ Ȯ��
SELECT * FROM USER_SEQUENCES;
-- �׷� ��� ��� ����?
INSERT INTO USER_DEFAULT VALUES(SEQ_USERNO.NEXTVAL, '������', DEFAULT, DEFAULT);
SELECT SEQ_USERNO.CURRVAL FROM DUAL;
-- �������� INSERT�� �� ������ ���� ���������� ������!!

SELECT * FROM USER_DEFAULT;
SELECT * FROM USER_DEFAULT ORDER BY 1;

--NEXTVAL, CURRVAL ����� �� �ִ� ���
-- 1. ���������� �ƴ� SELECT��
-- 2. INSERT���� SELECT��
-- 3. INSERT���� VALUES��
-- 4. UPDATE���� SET��

-- CURRVAL�� ����� �� ������ ��
-- NEXTVAL�� ������ 1�� ������ �Ŀ� CURRVAL�� �� �� ����.

-- ������ ����
-- START WITH���� ������ �Ұ����ϱ� ������ �����Ϸ��� ���� �� �ٽ� �����ؾ���.
CREATE SEQUENCE SEQ_SAMPLE1;
SELECT * FROM USER_SEQUENCES;
ALTER SEQUENCE SEQ_SAMPLE1
INCREMENT BY 11;
-- Sequence SEQ_SAMPLE1��(��) ����Ǿ����ϴ�.
SELECT SEQ_SAMPLE2.NEXTVAL FROM DUAL;
SELECT LAST_NUMBER FROM USER_SEQUENCES WHERE SEQUENCE_NAME = 'SEQ_USERNO';
SELECT SEQ_SAMPLE2.CURRVAL FROM DUAL;
-- 1. VIEW
-- 2. SEQUENCE


-- Day07�� �ִ� ����(��)
-- ������ J1, J2, J3�� �ƴ� ����߿��� �ڽ��� �μ��� ��� �޿����� ���� �޿��� �޴� ������.
-- �μ��ڵ�, �����, �޿�, �μ��� �޿����
SELECT 
    E.DEPT_CODE AS �μ��ڵ�
    , E.EMP_NAME AS �����
    , E.SALARY AS �޿�
    , AVG_SAL AS "�μ��� �޿����"
FROM EMPLOYEE E
JOIN (SELECT DEPT_CODE, CEIL(AVG(SALARY)) "AVG_SAL"
        FROM EMPLOYEE 
        GROUP BY DEPT_CODE) A ON E.DEPT_CODE = A.DEPT_CODE
WHERE JOB_CODE NOT IN('J1', 'J2', 'J3') AND E.SALARY > AVG_SAL;

SELECT DEPT_CODE, CEIL(AVG(SALARY)) "AVG_SAL"
FROM EMPLOYEE
GROUP BY DEPT_CODE;