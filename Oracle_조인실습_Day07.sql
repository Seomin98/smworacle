--@조인실습문제_kh
--1. 2022년 12월 25일이 무슨 요일인지 조회하시오.
SELECT TO_CHAR(TO_DATE(20221225), 'DAY') FROM DUAL;

--2. 주민번호가 1970년대 생이면서 성별이 여자이고, 성이 전씨인 직원들의 사원명, 주민번호, 부서명, 직급명을 조회하시오.

SELECT EMP_NAME AS 사원명, EMP_NO AS 주민번호, DEPT_TITLE AS 부서명, JOB_NAME AS 직급명
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN JOB USING(JOB_CODE)
WHERE (SUBSTR(EMP_NO,1,2)) BETWEEN '70' AND '79' AND SUBSTR(EMP_NO,8 ,1) IN('2','4') AND EMP_NAME LIKE '전%';

SELECT * FROM EMPLOYEE;
--3. 이름에 '형'자가 들어가는 직원들의 사번, 사원명, 부서명을 조회하시오.

SELECT EMP_ID AS 사번, EMP_NAME AS 사원명, DEPT_TITLE AS 부서명
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE EMP_NAME LIKE '%형%';

--4. 해외영업부에 근무하는 사원명, 직급명, 부서코드, 부서명을 조회하시오.

SELECT EMP_NAME AS 사원명, JOB_NAME AS 직급명, DEPT_CODE AS 부서코드, DEPT_TITLE AS 부서명
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID 
WHERE DEPT_TITLE LIKE '해외영업_부';

--5. 보너스포인트를 받는 직원들의 사원명, 보너스포인트, 부서명, 근무지역명을 조회하시오.

SELECT EMP_NAME AS 사원명, NVL(BONUS,0) AS 보너스포인트, DEPT_TITLE AS 부서명, LOCAL_NAME AS 근무지역명
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
WHERE BONUS IS NOT NULL;
SELECT * FROM DEPARTMENT, LOCATION;
SELECT * FROM LOCATION;

--6. 부서코드가 D2인 직원들의 사원명, 직급명, 부서명, 근무지역명을 조회하시오.

SELECT EMP_NAME AS 사원명, JOB_NAME AS 직급명, DEPT_TITLE AS 부서명, LOCAL_NAME AS 근무지역명
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
WHERE DEPT_CODE = 'D2';

--7. 급여등급테이블의 최대급여(MAX_SAL)보다 많이 받는 직원들의 사원명, 직급명, 급여, 연봉을 조회하시오.
-- (사원테이블과 급여등급테이블을 SAL_LEVEL컬럼기준으로 조인할 것)
--> 데이터 존재하지 않음!!!

--8. 한국(KO)과 일본(JP)에 근무하는 직원들의 사원명, 부서명, 지역명, 국가명을 조회하시오.

SELECT EMP_NAME AS 사원명, DEPT_TITLE AS 부서명, LOCAL_NAME AS 지역명, NATIONAL_NAME AS 국가명
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
JOIN NATIONAL USING(NATIONAL_CODE)
WHERE NATIONAL_NAME IN ('한국', '일본')
ORDER BY 1 ASC;

--9. 보너스포인트가 없는 직원들 중에서 직급이 차장과 사원인 직원들의 사원명, 직급명, 급여를 조회하시오. 단, join과 IN 사용할 것
SELECT EMP_NAME AS 사원명, JOB_NAME AS 직급명, SALARY AS 급여
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE) 
WHERE BONUS IS NULL AND JOB_NAME IN ('차장', '사원');

--10. 재직중인 직원과 퇴사한 직원의 수를 조회하시오.
-- 조인아니지만 풀어보세요!
SELECT DECODE(ENT_YN, 'Y','퇴직', 'N', '재직') AS 근속여부, COUNT(*) AS 직원수
FROM EMPLOYEE
GROUP BY DECODE(ENT_YN, 'Y','퇴직', 'N', '재직');
SELECT ENT_DATE, ENT_YN FROM EMPLOYEE;

-- ## 서브쿼리(subQuery)
--> 하나의 SQL문 안에 포함되어 있는 또 다른 SQL문(SELECT)
--> 메인쿼리가 서브쿼리를 포함하는 종속적인 관계
-- ### 특징
-- >> 서브쿼리는 연산자의 오른쪽에 위치해야 함
-- >> 서브쿼리는 반드시 소괄호로 묶어야 함 ( SELECT .... )

-- ex1) 전지연 직원의 관리자 이름을 출력하여라!!!!
SELECT EMP_ID, EMP_NAME, MANAGER_ID FROM EMPLOYEE;

-- STEP1. 전지연 직원의 관리자 ID는 무엇인가?
SELECT MANAGER_ID FROM EMPLOYEE
WHERE EMP_NAME = '전지연'; -- 214
-- STEP2. 관리자 ID로 직원의 이름을 구한다.
SELECT EMP_NAME FROM EMPLOYEE WHERE EMP_ID = 214;
-- 서브쿼리로 한방에!!
SELECT EMP_NAME FROM EMPLOYEE WHERE EMP_ID = 
(SELECT MANAGER_ID FROM EMPLOYEE WHERE EMP_NAME = '전지연');

--ex2) 전 직원의 평균 급여보다 많은 급여를 받고 있는 직원의 사번, 이름, 직급코드, 급여를 조회하시오
-- STEP1.평균 급여를 구한다
SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE; -- 3047662
-- STEP2. 평균 급여보다 많은 급여를 받는 직원을 조회한다.
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY FROM EMPLOYEE
WHERE SALARY > 3047662;
-- 한방에!!
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY FROM EMPLOYEE
WHERE SALARY > (SELECT FLOOR(AVG(SALARY)) FROM EMPLOYEE);

-- 서브쿼리(Sub Query)의 유형
-- 1. 단일행 서브쿼리
-- 2. 다중행 서브쿼리
-- 3. 다중열 서브쿼리
-- 4. 다중행 다중열 서브쿼리
-- 5. 상(호여)관 서브쿼리
-- 6. 스칼라 서브쿼리
-- ### 1. 단일행 서브쿼리
-- 서브쿼리의 조회 결과값(행, 튜플, 레코드)의 갯수가 1개 일때
-- ### 2. 다중행 서브쿼리
-- 서브쿼리의 조회 결과값(행, 튜플, 레코드)이 여러개 일 때
-- 다중행 서브쿼리 앞에는 일반 비교연산자 사용불가 ( IN/NOT IN, ANY, ALL, EXIST )
-- 2.1 IN
-- 쿼리의 비교 조건이 결과 중에서 하나라도 일치하는 것, OR
-- EX) 송종기나 박나라가 속한 부서에 속한 사원들 정보 출력
-- STEP1. 송종기 부서코드 구하고 박나라 부서코드 구해야함
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '송종기'; -- D9
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '박나라'; -- D5
-- STEP2. 구한 부서코드로 정보 출력
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D9', 'D5');
-- 한방에.
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE IN (SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME IN ('송종기', '박나라'));

--@실습문제
-- 1.차태연, 전지연 사원의 급여등급(employee테이블의 sal_level컬럼)과 같은 사원의 직급명, 사원명을 출력.
SELECT SAL_LEVEL FROM EMPLOYEE WHERE EMP_NAME = '차태연';
SELECT SAL_LEVEL FROM EMPLOYEE WHERE EMP_NAME = '전지연';
SELECT JOB_NAME AS 직급명, EMP_NAME AS 사원명 FROM EMPLOYEE JOIN JOB USING(JOB_CODE)
WHERE SAL_LEVEL IN (SELECT SAL_LEVEL FROM EMPLOYEE WHERE EMP_NAME IN ('차태연', '전지연'));

-- 2. Asia1지역에 근무하는 사원 정보출력, 부서코드, 사원명
-- 메인쿼리 조인사용
SELECT DEPT_CODE AS 부서코드, EMP_NAME AS 사원명
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
WHERE LOCAL_NAME = 'ASIA1';
-- 서브쿼리 사용
SELECT DEPT_CODE AS 부서코드, EMP_NAME AS 사원명
FROM EMPLOYEE
WHERE DEPT_CODE IN (SELECT DEPT_ID FROM DEPARTMENT
JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
WHERE LOCAL_NAME = 'ASIA1');



--2.2 NOT IN
-- 쿼리의 비교조건이 결과 중에서 하나도 일치하지 않는 것
--@ 실습문제
-- 직급이 대표, 부사장이 아닌 모든 사원을 부서별로 출력.
-- STEP1. 대표, 부사장 JOB_CODE 구하기
SELECT JOB_CODE FROM JOB WHERE JOB_NAME IN ('대표', '부사장');
-- STEP2. 구한 JOB_CODE 조건절에 넣기

-- 한방에
SELECT DEPT_CODE, EMP_NAME
FROM EMPLOYEE
WHERE JOB_CODE NOT IN (SELECT JOB_CODE FROM JOB WHERE JOB_NAME IN ('대표', '부사장'))
--GROUP BY DEPT_CODE, EMP_NAME
ORDER BY 1;

-- ## 3. 다중열 서브쿼리
-- ## 4. 다중행 다중열 서브쿼리
-- ## 5. 상(호연)관 서브쿼리
-- >> 메인쿼리의 값을 서브쿼리에 주고 서브쿼리를 수행한 다음 그 결과를
-- 다시 메인쿼리로 반환해서 수행하는 쿼리
-- > 서브 쿼리의 WHERE절 수행을 위해서는 메인쿼리가 먼저 수행되는 구조
-- > 메인 쿼리 테이블의 레코드(행)에 따라 서브쿼리의 결과 값도 바뀜
-- 구분하기! : 메인쿼리에 있는 것을 서브쿼리에 가져다 쓰면 상관 서브쿼리
-- 그렇지 않고 서브쿼리가 단독으로 사용되면 일반 서브쿼리
SELECT EMP_NAME, SALARY
FROM EMPLOYEE WHERE JOB_CODE = (SELECT JOB_CODE FROM JOB WHERE JOB_NAME = '대표');

SELECT * FROM EMPLOYEE WHERE '1' = '2';

-- 부하직원이 한명이라도 있는 직원, 매니저를 출력하시오
SELECT EMP_NAME,EMP_ID, MANAGER_ID, SALARY
FROM EMPLOYEE E WHERE EXISTS(SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = E.EMP_ID);
SELECT DISTINCT MANAGER_ID FROM EMPLOYEE;

SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = 209;

-- DEPT_CODE가 없는 사람을 출력하시오.
SELECT EMP_NAME FROM EMPLOYEE WHERE DEPT_CODE IS NULL;
SELECT EMP_NAME FROM EMPLOYEE E 
WHERE NOT EXISTS(SELECT 1 FROM DEPARTMENT WHERE DEPT_ID = E.DEPT_CODE );
-- 메인쿼리에서 가져다 써야하는 컬럼은 무엇인가? DEPT_CODE
-- 그 값은 어느 테이블에서 써야되는가? DEPARTMENT

-- 가장 많은 급여를 받는 사원을 EXISTS 상관 서브쿼리를 이용해서 구하라
SELECT EMP_NAME FROM EMPLOYEE E
WHERE NOT EXISTS(SELECT 1 FROM EMPLOYEE WHERE SALARY > E.SALARY);
SELECT EMP_NAME FROM EMPLOYEE WHERE SALARY = (SELECT MAX(SALARY) FROM EMPLOYEE);
-- 가장 적은 급여를 받는 사원을 EXISTS 상관 서브쿼리를 이용해서 구하라
SELECT EMP_NAME FROM EMPLOYEE E
WHERE NOT EXISTS(SELECT 1 FROM EMPLOYEE WHERE SALARY < E.SALARY);
SELECT EMP_NAME FROM EMPLOYEE WHERE SALARY = (SELECT MIN(SALARY) FROM EMPLOYEE);

-- 직급이 J1, J2, J3이 아닌 사원중에서 자신의 부서별 평균 급여보다 많은 급여를 받는 사원출력.
-- 부서코드, 사원명, 급여, 부서별 급여평균

-- ## 6. 스칼라 서브 쿼리
-- 결과 값이 1개인 상관서브쿼리, SELECT문에서 사용됨
-- ### 6.1 스칼라 서브쿼리 - SELECT절
-- EX) 모든 사원의 사번, 이름, 관리자사번, 관리자명을 조회하세요
SELECT EMP_ID, EMP_NAME, MANAGER_ID, 
(SELECT EMP_NAME FROM EMPLOYEE M WHERE M.EMP_ID = E.MANAGER_ID)
FROM EMPLOYEE E;

--@실습문제
--1. 사원명, 부서명, 부서별 평균임글을 스칼라 서브쿼리를 이용해서 출력하세요.
SELECT EMP_NAME AS 사원명, DEPT_TITLE AS 부서명
, (SELECT ROUND(AVG(SALARY)) FROM EMPLOYEE WHERE DEPT_CODE = D.DEPT_ID) "부서별 평균임금"
FROM EMPLOYEE
JOIN DEPARTMENT D ON DEPT_CODE = DEPT_ID;
-- ### 6.2 스칼라 서브쿼리 - WHERE절
-- EX) 자신이 속한 직급의 평균 급여보다 많이 받는 직원의 이름, 직급, 급여를 조회하세요

-- ### 6.3 스칼라 서브쿼리 - ORDER BY절
-- EX) 모든 직원의 사번, 이름, 소속부서를 조회후 부서명을 오름차순으로 정렬하세요

-- ## 7. 인라인 뷰(FROM절에서의 서브쿼리)
-- FROM절에 서브쿼리를 사용한 것을 인라인뷰(INLINE-VIEW)라고 함
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

-- ** VIEW란??
-- 실제테이블을 근거한 논리적인 가상의 테이블(사용자에게 하나의 테이블처럼 사용가능하게 함)
-- *** VIEW의 종류
-- 1. Stored View : 영구적으로 사용가능 -> 오라클 객체
-- 2. Inline View : FROM절에 사용하는 서브쿼리, 1회용
SELECT * FROM EMPLOYEE;

--@실습문제
--1. employee테이블에서 2010년도에 입사한 사원의 사번, 사원명, 입사년도를 인라인뷰를 사용해서 출력하라.
SELECT 사번, 사원명, 입사년도 -- EMP_ID,EMP_NAME,HIRE_DATE 사용하면 안됨! AS 값으로 한걸로 써줘야됨
FROM(SELECT EMP_ID AS 사번, EMP_NAME AS 사원명, 
EXTRACT (YEAR FROM HIRE_DATE) AS 입사년도 FROM EMPLOYEE )
WHERE (입사년도 - 2010) BETWEEN 0 AND 9;
--2. employee테이블에서 사원중 30대, 40대인 여자사원의 사번, 부서명, 성별, 나이를 인라인뷰를 사용해서 출력하라.
SELECT *
FROM
(SELECT EMP_ID AS 사번
, (SELECT DEPT_TITLE FROM DEPARTMENT WHERE DEPT_ID = E.DEPT_CODE) AS 부서명
, DECODE(SUBSTR(EMP_NO,8,1), '1','남', '3','남','여') 성별
-- 2022 - 1963 = 59
, EXTRACT(YEAR FROM SYSDATE) - (1900 + TO_NUMBER(SUBSTR(EMP_NO,1,2))) AS 나이
FROM EMPLOYEE E)
--JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID)
WHERE 성별 = '여' AND FLOOR(나이/10) IN (3, 4);

SELECT EMP_ID AS 사번
, (SELECT DEPT_TITLE FROM DEPARTMENT WHERE DEPT_ID = E.DEPT_CODE) AS 부서명
, DECODE(SUBSTR(EMP_NO,8,1), '1','남', '3','남','여') 성별
-- 2022 - 1963 = 59
, EXTRACT(YEAR FROM SYSDATE) - (1900 + TO_NUMBER(SUBSTR(EMP_NO,1,2))) AS 나이
FROM EMPLOYEE E
--JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID)
WHERE DECODE(SUBSTR(EMP_NO,8,1), '1','남', '3','남','여') = '여'
AND FLOOR ((EXTRACT(YEAR FROM SYSDATE) - (1900 + TO_NUMBER(SUBSTR(EMP_NO,1,2))))/10) IN (3, 4);

-- ## 고급쿼리
-- ### 1. TOP-N 분석
-- ### 2. WITH
-- ### 3. 계층형 쿼리(Hiererchical Query)
-- ### 4. 윈도우 함수
-- #### 4.1 순위 함수

-- ## JOIN의 종류3
-- 1. 상호조인(CROSS JOIN)
-- 2. 셀프조인(SELF JOIN)

-- # 제약조건
-- ## 1. CHECK
-- ## 2. DEFAULT