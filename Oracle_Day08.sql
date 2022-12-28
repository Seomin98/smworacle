--@DQL종합실습문제

--문제1
--기술지원부에 속한 사람들의 사람의 이름,부서코드,급여를 출력하시오.
SELECT EMP_NAME AS 이름, DEPT_CODE AS 부서코드, SALARY AS 급여
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE DEPT_TITLE = '기술지원부';
--문제2
--기술지원부에 속한 사람들 중 가장 연봉이 높은 사람의 이름,부서코드,급여를 출력하시오

SELECT EMP_NAME AS 이름, DEPT_CODE AS 부서코드, SALARY AS 급여
FROM EMPLOYEE
JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
WHERE DEPT_TITLE = '기술지원부' 
AND SALARY = (SELECT MAX(SALARY) FROM EMPLOYEE JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID 
WHERE DEPT_TITLE = '기술지원부');


--문제3
--매니저가 있는 사원중에 월급이 전체사원 평균을 넘고 
--사번,이름,매니저 이름, 월급을 구하시오.
-- > 어제 했으며 매니저이름 구하는게 포인트
SELECT EMP_ID AS 사번, EMP_NAME AS 이름
, (SELECT EMP_NAME FROM EMPLOYEE WHERE EMP_ID = E.MANAGER_ID) AS "매니저 이름", SALARY AS 월급
FROM EMPLOYEE E
WHERE MANAGER_ID IS NOT NULL AND SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE);



-- ## 고급쿼리
-- ### 1. TOP-N 분석
-- ### 2. WITH
-- ### 3. 계층형 쿼리(Hiererchical Query)
-- ### 4. 윈도우 함수
-- #### 4.1 순위 함수

-- ## JOIN의 종류3
-- 1. 상호조인(CROSS JOIN)
-- 카테이션 곱(Cartensial product)라고 함
-- 조인되는 테이블의 각 행들이 모두 매핑된 조인 방법
-- 다시말해, 한쪽 테이블의 모든 행과 다른쪽 테이블의 모든 행을 조인 시킴
-- 모든 경우의 수를 구하므로 결과는 두 테이블의 컬럼수를 곱한 개수가 나옴.
-- 4 * 3 = ?
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE CROSS JOIN DEPARTMENT;
--@실습문제
--아래처럼 나오도록 하세요.
----------------------------------------------------------------
-- 사원번호    사원명     월급    평균월급    월급-평균월급
----------------------------------------------------------------
SELECT EMP_ID AS 사원번호, EMP_NAME AS 사원명, SALARY AS 월급
, AVG_SAL AS 평균월급
, (CASE WHEN SALARY-AVG_SAL > 0 THEN '+' END) || (SALARY-AVG_SAL) AS "월급-평균월급"
FROM EMPLOYEE
CROSS JOIN (SELECT ROUND(AVG(SALARY)) "AVG_SAL" FROM EMPLOYEE);

-- 2. 셀프조인(SELF JOIN)
--매니저가 있는 사원중에 월급이 전체사원 평균을 넘고 사번,이름,매니저 이름, 월급을 구하시오.
SELECT EMP_ID AS 사번, EMP_NAME AS 이름
, (SELECT EMP_NAME FROM EMPLOYEE WHERE EMP_ID = E.MANAGER_ID) AS "매니저 이름", SALARY AS 월급
FROM EMPLOYEE E
WHERE MANAGER_ID IS NOT NULL AND SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE);
-- 상관쿼리를 이용한 매니저 이름 구하기 결과 같은 것은 셀프 조인을 이용해서 구할 수 있음.
SELECT E.EMP_ID, E.EMP_NAME, M.EMP_NAME, E.SALARY
FROM EMPLOYEE E
JOIN EMPLOYEE M
ON M.EMP_ID = E.MANAGER_ID;

SELECT EMP_ID, EMP_NAME, MANAGER_ID FROM EMPLOYEE;


-- # 제약조건
-- ## 1. CHECK
-- 1. 테이블 USER_CHECK, CHAR(1) 실수
-- 2. CHAR(1) -> CHAR(3)
-- 3. INSERT INTO, 4개행 삽입
-- 4. CHECK 적용, 이미 만들어진 테이블이라서 ALTER TABLE
-- 5. BUT M,F가 들어가 있어서 DELETE FROM, 4개행 삭제
-- 6. ALTER TABLE ADD로 제약조건 추가
-- 7. INSERT INTO 해서 M, F는 못들어가는 것 확인('남','여'만 들어감)

CREATE TABLE USER_CHECK (
    USER_NO NUMBER PRIMARY KEY,
    USER_NAME VARCHAR2(30) NOT NULL,
    USER_GENDER CHAR(1) CONSTRAINT GENDER_VAL CHECK (USER_GENDER IN('남', '여'))
);
-- 이미 테이블을 만들어 놓은 상태에서 제약조건을 수정하는 방법
ALTER TABLE USER_CHECK 
MODIFY USER_GENDER CHAR(3);
-- 이미 테이블을 만들어 놓은 상태에서 제약조건을 추가하는 방법
DELETE FROM USER_CHECK;
-- 4개 행 이(가) 삭제되었습니다.
ALTER TABLE USER_CHECK
ADD CONSTRAINT GENDER_VAL CHECK (USER_GENDER IN('남', '여'));


INSERT INTO USER_CHECK VALUES('1', '일용자', '남');
INSERT INTO USER_CHECK VALUES('2', '이용자', '여');
INSERT INTO USER_CHECK VALUES('3', '삼용자', 'M');
INSERT INTO USER_CHECK VALUES('4', '사용자', 'F');

-- ## 2. DEFAULT
-- DDL, DML, DCL, TCL
CREATE TABLE USER_DEFAULT(
    USER_NO NUMBER CONSTRAINT USERNO_PK PRIMARY KEY,
    USER_NAME VARCHAR2(30) NOT NULL,
    USER_DATA DATE DEFAULT SYSDATE,
    USER_YN CHAR(1) DEFAULT 'Y'
);
-- 가입날짜, 회원여부 등의 컬럼의 기본값을 설정할 수 있음
-- Table USER_DEFAULT이(가) 생성되었습니다.
DROP TABLE USER_DEFAULT;
-- Table USER_DEFAULT이(가) 삭제되었습니다.
ALTER TABLE USER_DEFAULT
ADD USER_DATE DEFAULT SYSDATE;
-- DROP이 부담되면 ALTER TABLE 사용
INSERT INTO USER_DEFAULT VALUES(1, '일용자', '2022-12-23', 'Y');
INSERT INTO USER_DEFAULT VALUES(2, '일용자', 'SYSDATE', 'N');

-- TCL

INSERT INTO USER_DEFAULT VALUES(1, '일용자', DEFAULT, DEFAULT);
INSERT INTO USER_DEFAULT VALUES(2, '이용자', DEFAULT, DEFAULT);
INSERT INTO USER_DEFAULT VALUES(3, '삼용자', DEFAULT, DEFAULT);
INSERT INTO USER_DEFAULT VALUES(4, '사용자', DEFAULT, DEFAULT); -- 최종 커밋, 트랜잭션 종료
INSERT INTO USER_DEFAULT VALUES(5, '오용자', DEFAULT, DEFAULT); -- 임시저장 SAVEPOINT temp1
SAVEPOINT temp1;
INSERT INTO USER_DEFAULT VALUES(6, '육용자', DEFAULT, DEFAULT);
INSERT INTO USER_DEFAULT VALUES(7, '칠용자', DEFAULT, DEFAULT);
SAVEPOINT temp1;
ROLLBACK;
ROLLBACK TO temp1;
COMMIT; -- 최종저장
SELECT * FROM USER_DEFAULT;

-- TCL
-- 트랜잭션이란?
-- 한꺼번에 수행되어야 할 최소의 작업 단위를 말함, 
-- 하나의 트랜잭션으로 이루어진 작업들은 반드시 한꺼번에 완료가 되어야 하며,
-- TCL
-- 트랜잭션이란?
-- 한꺼번에 수행되어야 할 최소의 작업 단위를 말함, 
-- 하나의 트랜잭션으로 이루어진 작업들은 반드시 한꺼번에 완료가 되어야 하며,
-- 그렇지 않은 경우에는 한꺼번에 취소 되어야 함
-- TCL의 종류
-- 1. COMMIT : 트랜잭션 작업이 정상 완료 되면 변경 내용을 영구히 저장 (모든 savepoint 삭제)
-- 2. ROLLBACK : 트랜잭션 작업을 모두 취소하고 가장 최근 commit 시점으로 이동
-- 3. SAVEPOINT : 현재 트랜잭션 작업 시점에 이름을 지정함, 하나의 트랜잭션 안에서 구역을 나눌수 있음
-- >> ROLLBACK TO 세이브포인트명 : 트랜잭션 작업을 취소하고 savepoint 시점으로 이동

-- # DCL(Data Control Language)
-- 데이터 제어어 --> System계정에서 해야만 함
-- DB에 대한 보안, 무결성, 복구 등 DBSM를 제어하기 위한 언어
-- 무결성이란? 정확성, 일관성을 유지하는 것
-- 사용자의 권한이나 관리자 설정 등을 처리
-- DCL의 종류
-- 1. GRANT : 권한 부여
-- 2. REVOKE : 권한 회수
-- GRANT CONNECT, RESOURCE TO STUDENT; -- System계정을 연결해서 하세요!!
-- CONNECT, RESOURCE 롤이다. 롤은 권한이 여러개가 모여있다.
-- 롤은 필요한 권한을 묶어서 관리할 때 편하고 부여, 수정, 회수할 때 편하다!!
-- ROLE
-- CONNECT롤 : CREATE SESSION;
-- RESOURCE롤 : CREATE CLUSTER, CREATE PROCEDURE, CREATE SEQUENCE, CREATE TABLE
--             CREATE TRIGGER, CREATE TYPE, CREATE INDEXTYPE, CREATE OPERATOR;



SELECT DISTINCT OBJECT_TYPE FROM ALL_OBJECTS;
-- ### 1. VIEW
-- > 하나 이상의 테이블에서 원하는 데이터를 선택하여 가상의 테이블을 만들어 주는것
-- 다른 테이블에 있는 데이터를 보여줄 뿐이며, 데이터 자체를 포함하고 있는 것은 아님
-- 즉, 저장장치 내에 물리적으로 존재하지 않고 가상테이블로 만들어짐
-- 물리적인 실제 테이블과의 링크 개념
--> 뷰를 사용하며 특정 사용자가 원본 테이블에 접근하여 모든 데이터를 보게 하는 것을 방지할 수 있음.
-- 다시말해, 원본 테이블이 아닌 뷰를 통한 특정 데이터만 보여지게 만듬
--> 뷰를 만들기 위해서는 권한이 필요함. RESOURCE롤에는 포함되어있지 않음!!!(주의)
-- GRANT CREATE VIEW TO KH; (시스템 계정에서 실행)
-- Grant을(를) 성공했습니다.

-- VIEW 생성
CREATE VIEW V_EMPLOYEE
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE;
SELECT * FROM( SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE 
FROM EMPLOYEE);

SELECT * FROM V_EMPLOYEE
WHERE EMP_ID = 200;

-- VIEW 수정
UPDATE V_EMPLOYEE
SET DEPT_CODE = 'D8'
WHERE EMP_ID = 200;

-- 원본테이블 확인
SELECT * FROM EMPLOYEE WHERE EMP_ID = 200;
--> VIEW는 수정 가능함!!

-- VIEW 수정2
UPDATE V_EMPLOYEE
SET SALARY = 600000
WHERE EMP_ID = 200;
-- ORA-00904: "SALARY": invalid identifier, 안된다!

-- VIEW 삭제하기
DROP VIEW V_EMPLOYEE;



CREATE VIEW V_EMP_READ
AS SELECT EMP_ID, DEPT_TITLE FROM EMPLOYEE JOIN DEPARTMENT
ON DEPT_CODE = DEPT_ID;

SELECT * FROM V_EMP_READ;

-- ### 2. Sequence(시퀀스)
-- 순차적으로 정수 값을 자동으로 생성하는 객체로 자동 번호 발생기(채번기)의 역할을 함
-- CREATE SEQUENCE 시퀀스명
-- 생략가능한 옵션이 6개가 있음! START WITH, INCREMENT BY, MAXVALUE, MINVALUE, CYCLE, CACHE
SELECT * FROM USER_DEFAULT;
COMMIT;
DELETE FROM USER_DEFAULT;
INSERT INTO USER_DEFAULT VALUES(1, '일용자', 2022-12-23, DEFAULT);
-- 시퀀스 생성
CREATE SEQUENCE SEQ_USERNO;
-- 시퀀스 삭제
DROP SEQUENCE SEQ_USERNO;
-- 만들어진 시퀀스 확인
SELECT * FROM USER_SEQUENCES;
-- 그럼 어떻게 써야 하지?
INSERT INTO USER_DEFAULT VALUES(SEQ_USERNO.NEXTVAL, '오용자', DEFAULT, DEFAULT);
SELECT SEQ_USERNO.CURRVAL FROM DUAL;
-- 시퀀스로 INSERT할 때 오류가 나도 시퀀스값은 증가함!!

SELECT * FROM USER_DEFAULT;
SELECT * FROM USER_DEFAULT ORDER BY 1;

--NEXTVAL, CURRVAL 사용할 수 있는 경우
-- 1. 서브쿼리가 아닌 SELECT문
-- 2. INSERT문의 SELECT절
-- 3. INSERT문의 VALUES절
-- 4. UPDATE문의 SET절

-- CURRVAL을 사용할 때 주의할 점
-- NEXTVAL을 무조건 1번 실행한 후에 CURRVAL을 할 수 있음.

-- 시퀀스 수정
-- START WITH값은 변경이 불가능하기 때문에 변경하려면 삭제 후 다시 생성해야함.
CREATE SEQUENCE SEQ_SAMPLE1;
SELECT * FROM USER_SEQUENCES;
ALTER SEQUENCE SEQ_SAMPLE1
INCREMENT BY 11;
-- Sequence SEQ_SAMPLE1이(가) 변경되었습니다.
SELECT SEQ_SAMPLE2.NEXTVAL FROM DUAL;
SELECT LAST_NUMBER FROM USER_SEQUENCES WHERE SEQUENCE_NAME = 'SEQ_USERNO';
SELECT SEQ_SAMPLE2.CURRVAL FROM DUAL;
-- 1. VIEW
-- 2. SEQUENCE


-- Day07에 있던 문제(상)
-- 직급이 J1, J2, J3이 아닌 사원중에서 자신의 부서별 평균 급여보다 많은 급여를 받는 사원출력.
-- 부서코드, 사원명, 급여, 부서별 급여평균
SELECT 
    E.DEPT_CODE AS 부서코드
    , E.EMP_NAME AS 사원명
    , E.SALARY AS 급여
    , AVG_SAL AS "부서별 급여평균"
FROM EMPLOYEE E
JOIN (SELECT DEPT_CODE, CEIL(AVG(SALARY)) "AVG_SAL"
        FROM EMPLOYEE 
        GROUP BY DEPT_CODE) A ON E.DEPT_CODE = A.DEPT_CODE
WHERE JOB_CODE NOT IN('J1', 'J2', 'J3') AND E.SALARY > AVG_SAL;

SELECT DEPT_CODE, CEIL(AVG(SALARY)) "AVG_SAL"
FROM EMPLOYEE
GROUP BY DEPT_CODE;