-- ORA-01031: insufficient privileges  = ������� ����
CREATE TABLE STUDENT_TBL(
    STUDENT_NAME VARCHAR2(20),
    STUDENT_AGE NUMBER,
    STUDENT_GRADE NUMBER,
    STUDENT_ADDRESS VARCHAR2(100)
);
-- TABLE�� �����͸� �ִ� ���! -> ȸ������
INSERT INTO STUDENT_TBL(STUDENT_NAME, STUDENT_AGE, STUDENT_GRADE, STUDENT_ADDRESS)
VALUES('�Ͽ���', 11, 1, '����� �߱�');
-- �÷��� ���� ����!
INSERT INTO STUDENT_TBL VALUES('�̿���', 22, 2, '����� ���α�');
INSERT INTO STUDENT_TBL VALUES('�����', 33, 3, '����� ���빮��');
INSERT INTO STUDENT_TBL VALUES('�����', 44, 4, '����� ���빮��');

UPDATE STUDENT_TBL
SET STUDENT_AGE = 99
WHERE STUDENT_GRADE = 2;

DELETE FROM STUDENT_TBL
WHERE STUDENT_GRADE = 2;

INSERT INTO STUDENT_TBL
VALUES(' ', 55, 5, NULL);
-- �����͸� �����غ��� -> ȸ��Ż��
DELETE FROM STUDENT_TBL;





CREATE TABLE DATATYPE_TBL (
    MOONJJA CHAR(10), 
    -- ���ĺ� 10����, �ѱ� 3����
    MOONJJAYUL VARCHAR2(100), 
    -- ���ĺ� 100����, �ѱ� 33����
    SOOJJA NUMBER,
    NALJJA DATE,
    NALJJA2 TIMESTAMP
);