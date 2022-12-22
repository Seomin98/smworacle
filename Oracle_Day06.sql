--5. �μ��� �޿� ����� 3,000,000��(��������) �̻���  �μ��鿡 ���ؼ� �μ���, �޿������ ����ϼ���.
SELECT DEPT_CODE, FLOOR(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING FLOOR(AVG(SALARY)) >= 3000000;

-- # HAVING��
-- �׷��Լ��� ���� ���ؿ� �׷쿡 ���� ������ ������ ����
-- HAVING���� �����!! WHERE���� ��� �Ұ�!!!!!!!!!!!!!!!!!!!!!!!!!!!

--@�ǽ�����
--1. �μ��� �ο��� 5���� ���� �μ��� �ο����� ����ϼ���.
SELECT DEPT_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING COUNT(*) > 5;

--2. �μ��� ���޺� �ο����� 3���̻��� ������ �μ��ڵ�, �����ڵ�, �ο����� ����ϼ���.
SELECT DEPT_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE;
SELECT DEPT_CODE,JOB_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
HAVING COUNT(*) >= 3
ORDER BY 1 ASC;

--3. �Ŵ����� �����ϴ� ����� 2���̻��� �Ŵ������̵�� �����ϴ� ������� ����ϼ���.
SELECT MANAGER_ID, COUNT(*)
FROM EMPLOYEE
GROUP BY MANAGER_ID
HAVING COUNT(*) >= 2 AND MANAGER_ID IS NOT NULL
ORDER BY 1 ASC;

--# ROLLUP�� CUBE
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(JOB_CODE)
ORDER BY 1;

SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(JOB_CODE)
ORDER BY 1;

-- �μ� �� ���޺� �޿� �հ�
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
ORDER BY 1;

SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1;

-- ���տ�����
-- A = {1, 2, 4}, B = {2, 5, 7}
-- A��B = { 2 }? ���� �� -> ������
-- A��B = {1, 2, 4, 5, 7}? -> ������
-- A-B = {1, 4}? -> ������
-- A - A��B = {1, 4}
-- ������ -> INTERSECT
-- ������ -> UNION, UNION ALL
-- ������ -> MINUS
-- ResultSet �� ������?

-- ������ ����
SELECT EMP_NAME, EMP_ID FROM EMPLOYEE WHERE DEPT_CODE = 'D5'
INTERSECT
SELECT EMP_NAME, EMP_ID FROM EMPLOYEE WHERE SALARY >= 2400000;
-- ������1(�ߺ� ���)
SELECT EMP_NAME, EMP_ID FROM EMPLOYEE WHERE DEPT_CODE = 'D5'
UNION ALL
SELECT EMP_NAME, EMP_ID FROM EMPLOYEE WHERE SALARY >= 2400000;
-- ������2(�ߺ� ����)
SELECT EMP_NAME, EMP_ID FROM EMPLOYEE WHERE DEPT_CODE = 'D5'
UNION 
SELECT EMP_NAME, EMP_ID FROM EMPLOYEE WHERE SALARY >= 2400000;
-- ������
SELECT EMP_NAME, EMP_ID FROM EMPLOYEE WHERE DEPT_CODE = 'D5'
MINUS
SELECT EMP_NAME, EMP_ID FROM EMPLOYEE WHERE SALARY >= 2400000;

--** UNION�� ����!!
-- 1. SELECT���� Į�� ������ �ݵ�� ���ƾ� ��
-- 2. �÷��� ����ó Ÿ���� �ݵ�� ���ų� ��ȯ�����ؾ��� (ex. CHAR - VARCHAR2)
SELECT EMP_NAME, EMP_ID FROM EMPLOYEE WHERE DEPT_CODE = 'D5'
UNION
SELECT EMP_NAME, EMP_ID FROM EMPLOYEE WHERE SALARY >= 2400000;

-- ���ι�(JOIN)
---- ���� ���̺��� ���ڵ带 �����Ͽ� �ϳ��� ���� ǥ���� ��
---> �� �� �̻��� ���̺��� �������� ������ �ִ� �����͵��� �÷� �������� �з��Ͽ�
-- ���ο� ������ ���̺��� �̿��Ͽ� �����
-- �ٽø���, ���� �ٸ� ���̺��� ������ ���밪�� �̿������μ� �ʵ带 ������.

--11. ������, �μ����� ����ϼ���.
--   �μ��ڵ尡 D5�̸� �ѹ���, D6�̸� ��ȹ��, D9�̸� �����η� ó���Ͻÿ�.(case ���)
--   ��, �μ��ڵ尡 D5, D6, D9 �� ������ ������ ��ȸ�ϰ�, �μ��ڵ� �������� �������� ������.
SELECT EMP_NAME, DECODE(DEPT_CODE, 'D9', '�ѹ���', 'D5', '�ؿܿ���1��', 'D6', '�ؿܿ���2��')
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5', 'D6', 'D9');
SELECT * FROM DEPARTMENT;

SELECT EMP_NAME, DEPT_CODE FROM EMPLOYEE;
SELECT DEPT_ID DEPT_TITLE FROM DEPARTMENT;

-- # ���ι�
-- SELECT �÷��� FROM ���̺� JOIN ���̺� ON �÷���1 = �÷���2
SELECT EMP_NAME, DEPT_TITLE 
FROM EMPLOYEE JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;
-- ANSI ǥ�ر���
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT WHERE DEPT_CODE = DEPT_ID;
-- ����Ŭ ���� ����
-- JOIN�� ����1
-- 1. EQUI-JOIN : �Ϲ������� ���, =�� ���� ����
-- 2. NON-Equi JOIN : ���������� �ƴ� BETWEEN AND, IS NULL, IS NOT NULL, IN, NOT IN ������ ���

-- @�ǽ�����
--1. �μ���� �������� ����ϼ���. DEPARTMENT, LOCATION ���̺� �̿�.
SELECT DEPT_TITLE, LOCAL_NAME FROM DEPARTMENT JOIN LOCATION ON LOCATION_ID = LOCAL_CODE;

SELECT * FROM LOCATION;

--2. ������ ���޸��� ����ϼ���. EMPLOYEE, JOB ���̺� �̿�
-- ��ȣ�� ���� �ذ���
SELECT EMP_NAME, JOB_NAME FROM EMPLOYEE JOIN JOB
ON EMPLOYEE.JOB_CODE = JOB.JOB_CODE;
SELECT * FROM JOB;
-- ��ȣ�� ���� �ذ���2
SELECT EMP_NAME, JOB_NAME FROM EMPLOYEE EMP JOIN JOB JB
ON EMP.JOB_CODE = JB.JOB_CODE;
-- ��ȣ�� ���� �ذ���3
SELECT EMP_NAME, JOB_NAME FROM EMPLOYEE JOIN JOB 
USING(JOB_CODE);

SELECT * FROM JOB;
--3. ������� ������� ����ϼ���. LOCATION, NATIONAL ���̺� �̿�
SELECT * FROM LOCATION, NATIONAL;
SELECT * FROM NATIONAL;
SELECT LOCAL_NAME, NATIONAL_NAME 
FROM LOCATION JOIN NATIONAL
USING(NATIONAL_CODE);

SELECT LOCAL_NAME, NATIONAL_NAME FROM NATIONAL
JOIN LOCATION USING(NATIONAL_CODE);

-- ## INNRT JOIN
-- ## INNER EQUI JOIN

-- ## JOIN�� ����2
-- INNER JOIN(��������) : �Ϲ������� ����ϴ� ����(������)
-- OUTER IN(�ܺ�����) : ������, ��� ���
-- -> 1. LEFT (OUTER) JOIN
-- -> 1. RIGHT (OUTER) JOIN
-- -> 1. FULL (OUTER) JOIN
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE INNER JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

-- ANSI ǥ�� ����
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

-- ����Ŭ ���� ����
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT WHERE DEPT_CODE = DEPT_ID(+);

-- ANSI ǥ�� ����
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE RIGHT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

-- ����Ŭ ���� ����
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT ON DEPT_CODE(+)= DEPT_ID;

-- ANSI ǥ�� ������ ����
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE FULL JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

-- OUTER JOIN(�ܺ� ����)�� ���캸��
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

SELECT EMP_NAME, DEPT_TITLE
FROM DEPARTMENT RIGHT JOIN EMPLOYEE ON DEPT_ID = DEPT_CODE;

-- ## JOIN�� ����3
-- 1. ��ȣ����(CROSS JOIN)
-- 2. ��������(SELF JOIN)
-- 3. ��������
-- -> ���� ���� ���ι��� �ѹ��� ����� �� ����
SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE;
---> ������ �߿��ϴ�!!

--@�ǽ�����
-- 1. ������ �븮�̸鼭, ASIA ������ �ٹ��ϴ� ���� ��ȸ
-- ���, �̸� ,���޸�, �μ���, �ٹ�������, �޿��� ��ȸ�Ͻÿ�
SELECT EMP_ID AS ���, EMP_NAME AS �̸�, JOB_NAME AS ���޸�,  DEPT_TITLE AS �μ���
, LOCAL_NAME AS �ٹ�������, SALARY AS �޿�
FROM EMPLOYEE;
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
-- WHERE JOB_NAME = '�븮' AND LOCAL_NAME IN ('ASIA1','ASIA2','ASIA3')
WHERE JOB_NAME = '�븮' AND LOCAL_NAME LIKE 'ASIA%';

SELECT * FROM EMPLOYEE, DEPARTMENT;








