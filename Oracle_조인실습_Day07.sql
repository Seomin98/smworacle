--@���νǽ�����_kh
--1. 2022�� 12�� 25���� ���� �������� ��ȸ�Ͻÿ�.
SELECT TO_CHAR(TO_DATE(20221225), 'DAY') FROM DUAL;

--2. �ֹι�ȣ�� 1970��� ���̸鼭 ������ �����̰�, ���� ������ �������� �����, �ֹι�ȣ, �μ���, ���޸��� ��ȸ�Ͻÿ�.

SELECT EMP_NAME AS �����, EMP_NO AS �ֹι�ȣ, DEPT_TITLE AS �μ���, JOB_NAME AS ���޸�
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN JOB USING(JOB_CODE)
WHERE (SUBSTR(EMP_NO,1,2)) BETWEEN '70' AND '79' AND SUBSTR(EMP_NO,8 ,1) IN('2','4') AND EMP_NAME LIKE '��%';

SELECT * FROM EMPLOYEE;
--3. �̸��� '��'�ڰ� ���� �������� ���, �����, �μ����� ��ȸ�Ͻÿ�.

SELECT EMP_ID AS ���, EMP_NAME AS �����, DEPT_TITLE AS �μ���
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE EMP_NAME LIKE '%��%';

--4. �ؿܿ����ο� �ٹ��ϴ� �����, ���޸�, �μ��ڵ�, �μ����� ��ȸ�Ͻÿ�.

SELECT EMP_NAME AS �����, JOB_NAME AS ���޸�, DEPT_CODE AS �μ��ڵ�, DEPT_TITLE AS �μ���
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID 
WHERE DEPT_TITLE LIKE '�ؿܿ���_��';

--5. ���ʽ�����Ʈ�� �޴� �������� �����, ���ʽ�����Ʈ, �μ���, �ٹ��������� ��ȸ�Ͻÿ�.

SELECT EMP_NAME AS �����, NVL(BONUS,0) AS ���ʽ�����Ʈ, DEPT_TITLE AS �μ���, LOCAL_NAME AS �ٹ�������
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
WHERE BONUS IS NOT NULL;
SELECT * FROM DEPARTMENT, LOCATION;
SELECT * FROM LOCATION;

--6. �μ��ڵ尡 D2�� �������� �����, ���޸�, �μ���, �ٹ��������� ��ȸ�Ͻÿ�.

SELECT EMP_NAME AS �����, JOB_NAME AS ���޸�, DEPT_TITLE AS �μ���, LOCAL_NAME AS �ٹ�������
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
WHERE DEPT_CODE = 'D2';

--7. �޿�������̺��� �ִ�޿�(MAX_SAL)���� ���� �޴� �������� �����, ���޸�, �޿�, ������ ��ȸ�Ͻÿ�.
-- (������̺�� �޿�������̺��� SAL_LEVEL�÷��������� ������ ��)
--> ������ �������� ����!!!

--8. �ѱ�(KO)�� �Ϻ�(JP)�� �ٹ��ϴ� �������� �����, �μ���, ������, �������� ��ȸ�Ͻÿ�.

SELECT EMP_NAME AS �����, DEPT_TITLE AS �μ���, LOCAL_NAME AS ������, NATIONAL_NAME AS ������
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
JOIN NATIONAL USING(NATIONAL_CODE)
WHERE NATIONAL_NAME IN ('�ѱ�', '�Ϻ�')
ORDER BY 1 ASC;

--9. ���ʽ�����Ʈ�� ���� ������ �߿��� ������ ����� ����� �������� �����, ���޸�, �޿��� ��ȸ�Ͻÿ�. ��, join�� IN ����� ��
SELECT EMP_NAME AS �����, JOB_NAME AS ���޸�, SALARY AS �޿�
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE) 
WHERE BONUS IS NULL AND JOB_NAME IN ('����', '���');

--10. �������� ������ ����� ������ ���� ��ȸ�Ͻÿ�.
-- ���ξƴ����� Ǯ�����!
SELECT DECODE(ENT_YN, 'Y','����', 'N', '����') AS �ټӿ���, COUNT(*) AS ������
FROM EMPLOYEE
GROUP BY DECODE(ENT_YN, 'Y','����', 'N', '����');
SELECT ENT_DATE, ENT_YN FROM EMPLOYEE;

-- ## ��������(subQuery)
--> �ϳ��� SQL�� �ȿ� ���ԵǾ� �ִ� �� �ٸ� SQL��(SELECT)
--> ���������� ���������� �����ϴ� �������� ����
-- ### Ư¡
-- >> ���������� �������� �����ʿ� ��ġ�ؾ� ��
-- >> ���������� �ݵ�� �Ұ�ȣ�� ����� �� ( SELECT .... )

-- ex1) ������ ������ ������ �̸��� ����Ͽ���!!!!
SELECT EMP_ID, EMP_NAME, MANAGER_ID FROM EMPLOYEE;

-- STEP1. ������ ������ ������ ID�� �����ΰ�?
SELECT MANAGER_ID FROM EMPLOYEE
WHERE EMP_NAME = '������'; -- 214
-- STEP2. ������ ID�� ������ �̸��� ���Ѵ�.
SELECT EMP_NAME FROM EMPLOYEE WHERE EMP_ID = 214;
-- ���������� �ѹ濡!!
SELECT EMP_NAME FROM EMPLOYEE WHERE EMP_ID = 
(SELECT MANAGER_ID FROM EMPLOYEE WHERE EMP_NAME = '������');

--ex2) �� ������ ��� �޿����� ���� �޿��� �ް� �ִ� ������ ���, �̸�, �����ڵ�, �޿��� ��ȸ�Ͻÿ�
-- STEP1.��� �޿��� ���Ѵ�
SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE; -- 3047662
-- STEP2. ��� �޿����� ���� �޿��� �޴� ������ ��ȸ�Ѵ�.
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY FROM EMPLOYEE
WHERE SALARY > 3047662;
-- �ѹ濡!!
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY FROM EMPLOYEE
WHERE SALARY > (SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE);

-- ��������(Sub Query)�� ����
-- 1. ������ ��������
-- 2. ������ ��������
-- 3. ���߿� ��������
-- 4. ������ ���߿� ��������
-- 5. ��(ȣ��)�� ��������
-- 6. ��Į�� ��������
-- ### 1. ������ ��������
-- ���������� ��ȸ �����(��, Ʃ��, ���ڵ�)�� ������ 1�� �϶�
-- ### 2. ������ ��������
-- ���������� ��ȸ �����(��, Ʃ��, ���ڵ�)�� ������ �� ��
-- ������ �������� �տ��� �Ϲ� �񱳿����� ���Ұ� ( IN/NOT IN, ANY, ALL, EXIST )
-- 2.1 IN
-- ������ �� ������ ��� �߿��� �ϳ��� ��ġ�ϴ� ��, OR
-- EX) �����⳪ �ڳ��� ���� �μ��� ���� ����� ���� ���
-- STEP1. ������ �μ��ڵ� ���ϰ� �ڳ��� �μ��ڵ� ���ؾ���
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '������'; -- D9
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '�ڳ���'; -- D5
-- STEP2. ���� �μ��ڵ�� ���� ���
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D9', 'D5');
-- �ѹ濡.
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE IN (SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME IN ('������', '�ڳ���'));

--@�ǽ�����
-- 1.���¿�, ������ ����� �޿����(employee���̺��� sal_level�÷�)�� ���� ����� ���޸�, ������� ���.
SELECT SAL_LEVEL FROM EMPLOYEE WHERE EMP_NAME = '���¿�';
SELECT SAL_LEVEL FROM EMPLOYEE WHERE EMP_NAME = '������';
SELECT JOB_NAME AS ���޸�, EMP_NAME AS ����� FROM EMPLOYEE JOIN JOB USING(JOB_CODE)
WHERE SAL_LEVEL IN (SELECT SAL_LEVEL FROM EMPLOYEE WHERE EMP_NAME IN ('���¿�', '������'));

-- 2. Asia1������ �ٹ��ϴ� ��� �������, �μ��ڵ�, �����
-- �������� ���λ��
SELECT DEPT_CODE AS �μ��ڵ�, EMP_NAME AS �����
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
WHERE LOCAL_NAME = 'ASIA1';
-- �������� ���
SELECT DEPT_CODE AS �μ��ڵ�, EMP_NAME AS �����
FROM EMPLOYEE
WHERE DEPT_CODE IN (SELECT DEPT_ID FROM DEPARTMENT
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
WHERE LOCAL_NAME = 'ASIA1');



--2.2 NOT IN
-- ������ �������� ��� �߿��� �ϳ��� ��ġ���� �ʴ� ��
--@ �ǽ�����
-- ������ ��ǥ, �λ����� �ƴ� ��� ����� �μ����� ���.
-- STEP1. ��ǥ, �λ��� JOB_CODE ���ϱ�
SELECT JOB_CODE FROM JOB WHERE JOB_NAME IN ('��ǥ', '�λ���');
-- STEP2. ���� JOB_CODE �������� �ֱ�

-- �ѹ濡
SELECT DEPT_CODE, EMP_NAME
FROM EMPLOYEE
WHERE JOB_CODE NOT IN (SELECT JOB_CODE FROM JOB WHERE JOB_NAME IN ('��ǥ', '�λ���'))
--GROUP BY DEPT_CODE, EMP_NAME
ORDER BY 1;

-- ## 3. ���߿� ��������
-- ## 4. ������ ���߿� ��������
-- ## 5. ��(ȣ��)�� ��������
-- >> ���������� ���� ���������� �ְ� ���������� ������ ���� �� �����
-- �ٽ� ���������� ��ȯ�ؼ� �����ϴ� ����
-- > ���� ������ WHERE�� ������ ���ؼ��� ���������� ���� ����Ǵ� ����
-- > ���� ���� ���̺��� ���ڵ�(��)�� ���� ���������� ��� ���� �ٲ�
-- �����ϱ�! : ���������� �ִ� ���� ���������� ������ ���� ��� ��������
-- �׷��� �ʰ� ���������� �ܵ����� ���Ǹ� �Ϲ� ��������
SELECT EMP_NAME, SALARY
FROM EMPLOYEE WHERE JOB_CODE = (SELECT JOB_CODE FROM JOB WHERE JOB_NAME = '��ǥ');

SELECT * FROM EMPLOYEE WHERE '1' = '2';

-- ���������� �Ѹ��̶� �ִ� ����, �Ŵ����� ����Ͻÿ�
SELECT EMP_NAME,EMP_ID, MANAGER_ID, SALARY
FROM EMPLOYEE E WHERE EXISTS(SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = E.EMP_ID);
SELECT DISTINCT MANAGER_ID FROM EMPLOYEE;

SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = 209;

-- DEPT_CODE�� ���� ����� ����Ͻÿ�.
SELECT EMP_NAME FROM EMPLOYEE WHERE DEPT_CODE IS NULL;
SELECT EMP_NAME FROM EMPLOYEE E 
WHERE NOT EXISTS(SELECT 1 FROM DEPARTMENT WHERE DEPT_ID = E.DEPT_CODE );
-- ������������ ������ ����ϴ� �÷��� �����ΰ�? DEPT_CODE
-- �� ���� ��� ���̺��� ��ߵǴ°�? DEPARTMENT

-- ���� ���� �޿��� �޴� ����� EXISTS ��� ���������� �̿��ؼ� ���϶�
SELECT EMP_NAME FROM EMPLOYEE E
WHERE NOT EXISTS(SELECT 1 FROM EMPLOYEE WHERE SALARY > E.SALARY);
SELECT EMP_NAME FROM EMPLOYEE WHERE SALARY = (SELECT MAX(SALARY) FROM EMPLOYEE);
-- ���� ���� �޿��� �޴� ����� EXISTS ��� ���������� �̿��ؼ� ���϶�
SELECT EMP_NAME FROM EMPLOYEE E
WHERE NOT EXISTS(SELECT 1 FROM EMPLOYEE WHERE SALARY < E.SALARY);
SELECT EMP_NAME FROM EMPLOYEE WHERE SALARY = (SELECT MIN(SALARY) FROM EMPLOYEE);

-- ������ J1, J2, J3�� �ƴ� ����߿��� �ڽ��� �μ��� ��� �޿����� ���� �޿��� �޴� ������.
-- �μ��ڵ�, �����, �޿�, �μ��� �޿����

-- ## 6. ��Į�� ���� ����
-- ��� ���� 1���� �����������, SELECT������ ����
-- ### 6.1 ��Į�� �������� - SELECT��
-- EX) ��� ����� ���, �̸�, �����ڻ��, �����ڸ��� ��ȸ�ϼ���
SELECT EMP_ID, EMP_NAME, MANAGER_ID, 
(SELECT EMP_NAME FROM EMPLOYEE M WHERE M.EMP_ID = E.MANAGER_ID)
FROM EMPLOYEE E;

--@�ǽ�����
--1. �����, �μ���, �μ��� ����ӱ��� ��Į�� ���������� �̿��ؼ� ����ϼ���.
SELECT EMP_NAME AS �����, DEPT_TITLE AS �μ���
, (SELECT ROUND(AVG(SALARY)) FROM EMPLOYEE WHERE DEPT_CODE = D.DEPT_ID) "�μ��� ����ӱ�"
FROM EMPLOYEE
JOIN DEPARTMENT D ON DEPT_CODE = DEPT_ID;
-- ### 6.2 ��Į�� �������� - WHERE��
-- EX) �ڽ��� ���� ������ ��� �޿����� ���� �޴� ������ �̸�, ����, �޿��� ��ȸ�ϼ���

-- ### 6.3 ��Į�� �������� - ORDER BY��
-- EX) ��� ������ ���, �̸�, �ҼӺμ��� ��ȸ�� �μ����� ������������ �����ϼ���

-- ## 7. �ζ��� ��(FROM�������� ��������)
-- FROM���� ���������� ����� ���� �ζ��κ�(INLINE-VIEW)��� ��
SELECT -- 2. ()
FROM   -- 3. ()
WHERE  -- 1. ()
ORDER BY;

SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID
FROM
(SELECT DEPT_ID, DEPT_TITLE FROM DEPARTMENT);

-- ORA-00904: "MANAGER_ID": invalid identifier
SELECT EMP_ID, SALARY, MANAGER_ID
FROM
(SELECT EMP_NAME, EMP_ID, SALARY, EMP_NO FROM EMPLOYEE);

-- ** VIEW��??
-- �������̺��� �ٰ��� ������ ������ ���̺�(����ڿ��� �ϳ��� ���̺�ó�� ��밡���ϰ� ��)
-- *** VIEW�� ����
-- 1. Stored View : ���������� ��밡�� -> ����Ŭ ��ü
-- 2. Inline View : FROM���� ����ϴ� ��������, 1ȸ��
SELECT * FROM EMPLOYEE;

--@�ǽ�����
--1. employee���̺��� 2010�⵵�� �Ի��� ����� ���, �����, �Ի�⵵�� �ζ��κ並 ����ؼ� ����϶�.
SELECT ���, �����, �Ի�⵵ -- EMP_ID,EMP_NAME,HIRE_DATE ����ϸ� �ȵ�! AS ������ �Ѱɷ� ����ߵ�
FROM(SELECT EMP_ID AS ���, EMP_NAME AS �����, 
EXTRACT (YEAR FROM HIRE_DATE) AS �Ի�⵵ FROM EMPLOYEE )
WHERE (�Ի�⵵ - 2010) BETWEEN 0 AND 9;
--2. employee���̺��� ����� 30��, 40���� ���ڻ���� ���, �μ���, ����, ���̸� �ζ��κ並 ����ؼ� ����϶�.
SELECT *
FROM
(SELECT EMP_ID AS ���
, (SELECT DEPT_TITLE FROM DEPARTMENT WHERE DEPT_ID = E.DEPT_CODE) AS �μ���
, DECODE(SUBSTR(EMP_NO,8,1), '1','��', '3','��','��') ����
-- 2022 - 1963 = 59
, EXTRACT(YEAR FROM SYSDATE) - (1900 + TO_NUMBER(SUBSTR(EMP_NO,1,2))) AS ����
FROM EMPLOYEE E)
--JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID)
WHERE ���� = '��' AND FLOOR(����/10) IN (3, 4);

SELECT EMP_ID AS ���
, (SELECT DEPT_TITLE FROM DEPARTMENT WHERE DEPT_ID = E.DEPT_CODE) AS �μ���
, DECODE(SUBSTR(EMP_NO,8,1), '1','��', '3','��','��') ����
-- 2022 - 1963 = 59
, EXTRACT(YEAR FROM SYSDATE) - (1900 + TO_NUMBER(SUBSTR(EMP_NO,1,2))) AS ����
FROM EMPLOYEE E
--JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID)
WHERE DECODE(SUBSTR(EMP_NO,8,1), '1','��', '3','��','��') = '��'
AND FLOOR ((EXTRACT(YEAR FROM SYSDATE) - (1900 + TO_NUMBER(SUBSTR(EMP_NO,1,2))))/10) IN (3, 4);

-- ## �������
-- ### 1. TOP-N �м�
-- ### 2. WITH
-- ### 3. ������ ����(Hiererchical Query)
-- ### 4. ������ �Լ�
-- #### 4.1 ���� �Լ�

-- ## JOIN�� ����3
-- 1. ��ȣ����(CROSS JOIN)
-- 2. ��������(SELF JOIN)

-- # ��������
-- ## 1. CHECK
-- ## 2. DEFAULT