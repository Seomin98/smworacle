-- ����Ŭ �Լ�
-- 1. ���� ó�� �Լ�
-- ���ݱ��� �� ���� ó�� �Լ���?
-- LENGTH, LENGTHB(���� ����), SUBSTR(���� �ڸ�), INSTR(��ġ ����)
-- LPAD, RPAD(ä��� ��)

--@�ǽ����� 
-- �������ڿ����� �յ� ��� ���ڸ� �����ϼ���.
-- '982341678934509hello89798739273402'
SELECT RTRIM(LTRIM('982341678934509hello89798739273402', '0123456789'), '0123456789')
FROM DUAL;

--@�ǽ�����
---- ������� ���� �ߺ����� ���������� ����ϼ���.
SELECT SUBSTR(EMP_NAME,1,1) "EMP_NAME"
FROM EMPLOYEE
ORDER BY 1 ASC; -- ������� ���� ���������� ����ϼ��� �ϼ�!
-- �ߺ����� ����� ��� �ϴ� �ɱ�?
SELECT DISTINCT SUBSTR(EMP_NAME,1,1) "EMP_NAME"
FROM EMPLOYEE
ORDER BY EMP_NAME ASC;

-- @�ǽ�����
-- employee ���̺��� ���ڸ� �����ȣ, �����, �ֹι�ȣ, ������ ��Ÿ������.
-- �ֹι�ȣ�� ��6�ڸ��� *ó���ϼ���.
SELECT EMP_ID, EMP_NAME, RPAD(SUBSTR(EMP_NO,1,8), 14, '*'), SALARY*12
FROM EMPLOYEE
--WHERE SUBSTR(EMP_NO,8,1) = '1' OR SUBSTR(EMP_NO,8,1) = '3';
WHERE SUBSTR(EMP_NO, 8, 1) IN ('1', '3');

--SELECT EMP_ID, EMP_NAME, SUBSTR(EMP_NO,1,8)||'******', SALARY*12
SELECT EMP_ID, EMP_NAME, CONCAT(SUBSTR(EMP_NO,1,8),'******'), SALARY*12, '��'
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN ('1', '3');

-- 2. ���� ó�� �Լ�
--@�ǽ�����
--EMPLOYEE ���̺��� �̸�, �ٹ� �ϼ��� ����غ��ÿ� 
--(SYSDATE�� ����ϸ� ���� �ð� ���)
SELECT EMP_NAME, SYSDATE - HIRE_DATE "�ٹ��ϼ�"
, FLOOR(SYSDATE-HIRE_DATE), ROUND(SYSDATE-HIRE_DATE), CEIL(SYSDATE-HIRE_DATE)
FROM EMPLOYEE;


-- 3. ��¥ ó�� �Լ�
--@�ǽ�����
-- EMPLOYEE ���̺��� ����� �̸�, �Ի���, �Ի� �� 3������ �� ��¥�� ��ȸ�Ͻÿ�
SELECT EMP_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE, 3)
FROM EMPLOYEE;
--@�ǽ�����
--EMPLOYEE ���̺��� ����� �̸�, �Ի���, �ٹ� �������� ��ȸ�Ͻÿ�
SELECT EMP_NAME, HIRE_DATE, ROUND(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) "PERIOD"
FROM EMPLOYEE;
--@�ǽ�����
--ex) EMPLOYEE ���̺��� ����� �̸�, �Ի���, �Ի���� ���������� ��ȸ�ϼ���
SELECT EMP_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE)
FROM EMPLOYEE;
--@�ǽ�����
--ex) EMPLOYEE ���̺��� ��� �̸�, �Ի� �⵵, �Ի� ��, �Ի� ���� ��ȸ�Ͻÿ�.
SELECT EMP_NAME, EXTRACT(YEAR FROM HIRE_DATE)||'��'
, EXTRACT(MONTH FROM HIRE_DATE)||'��'
, EXTRACT(DAY FROM HIRE_DATE)||'��'
FROM EMPLOYEE;
--@�ǽ�����
/*
     ���úη� �Ͽ��ھ��� ���뿡 �������ϴ�.
     ������ �Ⱓ�� 1�� 6������ �Ѵٶ�� �����ϸ�
     ù��°,�������ڸ� ���Ͻð�,
     �ι�°,�������ڱ��� �Ծ���� «���� �׷���� ���մϴ�.
     (��, 1�� 3���� �Դ´ٰ� �Ѵ�.)
*/
SELECT ADD_MONTHS(SYSDATE, 18) "��������", (ADD_MONTHS(SYSDATE, 18)-SYSDATE)*3 "«���"
FROM DUAL;
-- 4. ����ȯ �Լ�





-- @�Լ� �����ǽ�����
--1. ������� �̸��� , �̸��� ���̸� ����Ͻÿ�
--		  �̸�	    �̸���		�̸��ϱ���
--	ex)  ȫ�浿 , hong@kh.or.kr   	  13
SELECT 
EMP_NAME, EMAIL, LENGTH(EMAIL), LENGTHB(EMAIL)
, LENGTH(EMP_NAME), LENGTHB(EMP_NAME)
FROM EMPLOYEE;
-- �̸����� ���̰� 15���� ���� �����͸� �˻��غ��ÿ�
SELECT *
FROM EMPLOYEE
WHERE LENGTH(EMAIL) < 15;
-- WHERE EMAIL = 'no_hc@kh.or.kr';

--2. ������ �̸��� �̸��� �ּ��� ���̵� �κи� ����Ͻÿ�
--	ex) ���ö	no_hc
--	ex) ������	jung_jh
SELECT EMP_NAME, EMAIL, SUBSTR(EMAIL, 1, 6), SUBSTR(EMAIL, 1, INSTR(EMAIL, '@', 1, 1)-1)
FROM EMPLOYEE;
SELECT EMAIL, INSTR(EMAIL, '@', 1, 1)
FROM EMPLOYEE;

--3. 60��뿡 �¾ ������� ���, ���ʽ� ���� ����Ͻÿ�. �׶� ���ʽ� ���� null�� ��쿡�� 0 �̶�� ��� �ǰ� ����ÿ�
--	    ������    ���      ���ʽ�
--	ex) ������	    1962	    0.3
--	ex) ������	    1963  	    0
-- ��¥ ó�� �Լ�
SELECT EXTRACT(YEAR FROM SYSDATE) FROM DUAL;
SELECT EXTRACT(YEAR FROM HIRE_DATE) FROM EMPLOYEE;
SELECT EXTRACT(YEAR FROM TO_DATE(EMP_NO)) FROM EMPLOYEE;
SELECT EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO,1,2), 'RR')) FROM EMPLOYEE;
-- ORA-30076: invalid extract field for extract source
SELECT TO_DATE(SUBSTR(EMP_NO,1,2), 'RR') FROM EMPLOYEE;
-- 66 -> �ʹ� ª��
-- ORA-01840: input value not long enough for date format
-- 660211-1029373 -> 661201
-- ORA-01861: literal does not match format string
DESC EMPLOYEE;
-- ���� ó�� �Լ�
SELECT EMP_NAME AS ������, CONCAT(19,SUBSTR(EMP_NO,1,2)) AS ���, NVL(BONUS,0) AS ���ʽ�
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,1,2) BETWEEN 60 AND 69;

--4. '010' �ڵ��� ��ȣ�� ���� �ʴ� ����� ���� ����Ͻÿ� (�ڿ� ������ ���� ���̽ÿ�)
--	   �ο�
--	ex) 3��

--5. ������� �Ի����� ����Ͻÿ� 
--	��, �Ʒ��� ���� ��µǵ��� ����� ���ÿ�
--	    ������		�Ի���
--	ex) ������		2012�� 12��
--	ex) ������		1997�� 3��
SELECT EMP_NAME AS ������
,EXTRACT(YEAR FROM HIRE_DATE)||'�� '||EXTRACT(MONTH FROM HIRE_DATE)||'��'  �Ի���
FROM EMPLOYEE
ORDER BY 2;

--6. ������� �ֹι�ȣ�� ��ȸ�Ͻÿ�
--	��, �ֹι�ȣ 9��° �ڸ����� �������� '*' ���ڷ� ä���� ��� �Ͻÿ�
--	ex) ȫ�浿 771120-1******
SELECT EMP_NAME AS ������, SUBSTR(EMP_NO,1,8)||'******' AS �ֹι�ȣ
FROM EMPLOYEE;

--7. ������, �����ڵ�, ����(��) ��ȸ
--  ��, ������ ��57,000,000 ���� ǥ�õǰ� ��
--     ������ ���ʽ�����Ʈ�� ����� 1��ġ �޿���
SELECT EMP_NAME AS ������,JOB_CODE AS �����ڵ�, SALARY*12+SALARY*NVL(BONUS,0) AS "����(��)
", NVL(BONUS,0)
FROM EMPLOYEE;
SELECT EMP_NAME AS ������,JOB_CODE AS �����ڵ�
, TO_CHAR(SALARY*12+SALARY*BONUS,'L999,999,999,999') AS "����(��)", BONUS
FROM EMPLOYEE;

SELECT TO_CHAR(SALARY,'L999,999,999') FROM EMPLOYEE;
SELECT TO_CHAR(SALARY,'L000,000,000') FROM EMPLOYEE;
--8. �μ��ڵ尡 D5, D9�� ������ �߿��� 2004�⵵�� �Ի��� �����߿� ��ȸ��.
--   ��� ����� �μ��ڵ� �Ի���
SELECT EMP_ID AS ���, EMP_NAME AS �����, DEPT_CODE AS �μ��ڵ�
, TO_CHAR(HIRE_DATE,'YYYY-MM-DD') AS �Ի���
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5','D9') AND EXTRACT(YEAR FROM HIRE_DATE) = 2004;

--9. ������, �Ի���, ���ñ����� �ٹ��ϼ� ��ȸ 
--	* �ָ��� ���� , �Ҽ��� �Ʒ��� ����

--10. ������, �μ��ڵ�, �������, ����(��) ��ȸ
--   ��, ��������� �ֹι�ȣ���� �����ؼ�, 
--   ���������� ������ �����Ϸ� ��µǰ� ��.
--   ���̴� �ֹι�ȣ���� �����ؼ� ��¥�����ͷ� ��ȯ�� ����, �����
--	* �ֹι�ȣ�� �̻��� ������� ���ܽ�Ű�� ���� �ϵ���(200,201,214 �� ����)
--	* HINT : NOT IN ���
SELECT EMP_NAME AS ������,DEPT_CODE AS �μ��ڵ�
-- ���� ó�� �Լ�
, '19'||SUBSTR(EMP_NO,1,2)||'�� '||SUBSTR(EMP_NO,3,2)||'�� '||SUBSTR(EMP_NO,5,2)||'��' AS �������
-- ��¥ ó�� �Լ�
, EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO,1,2),'RR')) 
||'�� '|| EXTRACT(MONTH FROM TO_DATE(SUBSTR(EMP_NO,3,2),'MM'))
||'�� '|| EXTRACT(DAY FROM TO_DATE(SUBSTR(EMP_NO,5,2),'DD')) 
||'��' AS �������2
-- ��¥ ó�� �Լ�
, EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM TO_DATE(SUBSTR(EMP_NO,1,2),'RR')) AS "����(��)"
-- ���� ó�� �Լ�
, EXTRACT(YEAR FROM SYSDATE) - (1900 + TO_NUMBER(SUBSTR(EMP_NO,1,2))) AS ����1
, EXTRACT(YEAR FROM SYSDATE) 
- (DECODE(SUBSTR(EMP_NO,8,1),'1',1900,'2',1900,'3',2000,'4',2000) 
+ TO_NUMBER(SUBSTR(EMP_NO,1,2))) AS ����2
-- DECODE
-- 2022 - 1986 = 36
-- 2022 - 1963 = 59
-- 2022 - 1966 = 56
FROM EMPLOYEE
WHERE EMP_ID NOT IN (200, 201, 214);

SELECT 
    DECODE(SUBSTR(EMP_NO,8,1), '1', '��', '2','��','3','��','4','��')
FROM EMPLOYEE;

--11. ������, �μ����� ����ϼ���.
--   �μ��ڵ尡 D5�̸� �ѹ���, D6�̸� ��ȹ��, D9�̸� �����η� ó���Ͻÿ�.(case ���)
--   ��, �μ��ڵ尡 D5, D6, D9 �� ������ ������ ��ȸ�ϰ�, �μ��ڵ� �������� �������� ������.
SELECT EMP_NAME AS �����
, DECODE(DEPT_CODE,'D5', '�ѹ���', 'D6', '��ȹ��', 'D9', '������') AS �μ���
,CASE
    WHEN DEPT_CODE = 'D5' THEN '�ѹ���'
    WHEN DEPT_CODE = 'D6' THEN '��ȹ��'
    WHEN DEPT_CODE = 'D9' THEN '������'
END AS �μ���2
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5', 'D6', 'D9')
ORDER BY 1 ASC;

-------------------------------------------------------------------------------

-- ���� �ǽ� ����
-- ����1. 
-- �Ի����� 5�� �̻�, 10�� ������ ������ �̸�,�ֹι�ȣ,�޿�,�Ի����� �˻��Ͽ���
SELECT EMP_NAME AS �̸�, EMP_NO AS �ֹι�ȣ, SALARY AS �޿�, HIRE_DATE AS �Ի���
FROM EMPLOYEE
WHERE CEIL((SYSDATE-HIRE_DATE)/365) BETWEEN 5 AND 10;

-- ����2.
-- �������� �ƴ� ������ �̸�,�μ��ڵ�, �����, �ٹ��Ⱓ, �������� �˻��Ͽ��� 
--(��� ���� : ENT_YN)
SELECT EMP_NAME AS �̸�
, DEPT_CODE AS �μ��ڵ�
, HIRE_DATE AS �����
, (ENT_DATE-HIRE_DATE) AS �ٹ��Ⱓ, ENT_DATE AS ������
FROM EMPLOYEE
--WHERE ENT_YN != 'N';
WHERE ENT_YN = 'Y';

-- ����3.
-- �ټӳ���� 10�� �̻��� �������� �˻��Ͽ�
-- ��� ����� �̸�,�޿�,�ټӳ��(�Ҽ���X)�� �ټӳ���� ������������ �����Ͽ� ����Ͽ���
-- ��, �޿��� 50% �λ�� �޿��� ��µǵ��� �Ͽ���.
SELECT EMP_NAME AS �̸�, SALARY AS �޿�, CEIL((SYSDATE-HIRE_DATE)/365) AS �ټӳ��
FROM EMPLOYEE
WHERE CEIL((SYSDATE-HIRE_DATE)/365) >= 10
ORDER BY 3 ASC;

-- ����4.
-- �Ի����� 99/01/01 ~ 10/01/01 �� ��� �߿��� �޿��� 2000000 �� ������ �����
-- �̸�,�ֹι�ȣ,�̸���,����ȣ,�޿��� �˻� �Ͻÿ�
SELECT EMP_NAME AS �̸�,EMP_NO AS �ֹι�ȣ,EMAIL AS �̸���,PHONE AS ����ȣ, SALARY AS �޿�
FROM EMPLOYEE
WHERE (HIRE_DATE BETWEEN TO_DATE('99/01/01') AND TO_DATE('10/01/01')) AND SALARY <= 2000000;

-- ����5.
-- �޿��� 2000000�� ~ 3000000�� �� ������ �߿��� 4�� �����ڸ� �˻��Ͽ� 
-- �̸�,�ֹι�ȣ,�޿�,�μ��ڵ带 �ֹι�ȣ ������(��������) ����Ͽ���
-- ��, �μ��ڵ尡 null�� ����� �μ��ڵ尡 '����' ���� ��� �Ͽ���.
SELECT NVL(DEPT_CODE,'����') FROM EMPLOYEE
WHERE DEPT_CODE IS NULL;
SELECT EMP_NAME AS �̸�, EMP_NO AS �ֹι�ȣ, SALARY AS �޿�,NVL(DEPT_CODE,'����') AS �μ��ڵ�
FROM EMPLOYEE
WHERE (SALARY BETWEEN 2000000 AND 3000000) 
--AND SUBSTR(EMP_NO,8,1) = '2' AND SUBSTR(EMP_NO,3,2) = '04'
AND EMP_NO LIKE '__04__-2%'
ORDER BY �ֹι�ȣ DESC;

-- ����6.
-- ���� ��� �� ���ʽ��� ���� ����� ���ñ��� �ٹ����� �����Ͽ� 
-- 1000�� ����(�Ҽ��� ����) 
-- �޿��� 10% ���ʽ��� ����Ͽ� �̸�,Ư�� ���ʽ� (��� �ݾ�) ����� ����Ͽ���.
-- ��, �̸� ������ ���� ���� �����Ͽ� ����Ͽ���.
SELECT EMP_NAME AS �̸�, FLOOR((SYSDATE-HIRE_DATE)/1000)*0.1*SALARY AS "Ư�� ���ʽ�"
FROM EMPLOYEE
--WHERE SUBSTR(EMP_NO,8,1) = 1 AND BONUS IS NULL
WHERE EMP_NO LIKE '%-1%' AND BONUS IS NULL
ORDER BY �̸� ASC;
