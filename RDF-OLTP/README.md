# RDF-OLTP
## How to try this out

INSERT INTO SaaS_EMP_VIEW(EMPNO, ENAME, JOB, HIREDATE, SALARY, COMM) VALUES(7369, 'SMITH',  'CLERK',    '17-DEC-1980',  800, NULL);
INSERT INTO SaaS_EMP_VIEW(EMPNO, ENAME, JOB, HIREDATE, SALARY, COMM) VALUES(7499, 'ALLEN',  'SALESMAN', '20-FEB-1981', 1600, NULL);
INSERT INTO SaaS_EMP_VIEW(EMPNO, ENAME, JOB, HIREDATE, SALARY, COMM) VALUES(7521, 'WARD',   'SALESMAN', '22-FEB-1981', 1250,  500);
INSERT INTO SaaS_EMP_VIEW(EMPNO, ENAME, JOB, HIREDATE, SALARY, COMM) VALUES(7566, 'JONES',  'MANAGER',  '2-APR-1981',  2975, NULL);
INSERT INTO SaaS_EMP_VIEW(EMPNO, ENAME, JOB, HIREDATE, SALARY, COMM) VALUES(7654, 'MARTIN', 'SALESMAN', '28-SEP-1981', 1250, 1400);
INSERT INTO SaaS_EMP_VIEW(EMPNO, ENAME, JOB, HIREDATE, SALARY, COMM) VALUES(7698, 'BLAKE',  'MANAGER',  '1-MAY-1981',  2850, NULL);
INSERT INTO SaaS_EMP_VIEW(EMPNO, ENAME, JOB, HIREDATE, SALARY, COMM) VALUES(7782, 'CLARK',  'MANAGER',  '9-JUN-1981',  2450, NULL);
INSERT INTO SaaS_EMP_VIEW(EMPNO, ENAME, JOB, HIREDATE, SALARY, COMM) VALUES(7788, 'SCOTT',  'ANALYST',  '09-DEC-1982', 3000, NULL);
INSERT INTO SaaS_EMP_VIEW(EMPNO, ENAME, JOB, HIREDATE, SALARY, COMM) VALUES (7839, 'KING',   'PRESIDENT', '17-NOV-1981', 5000, NULL);
INSERT INTO SaaS_EMP_VIEW(EMPNO, ENAME, JOB, HIREDATE, SALARY, COMM) VALUES(7844, 'TURNER', 'SALESMAN', '8-SEP-1981',  1500, NULL);
INSERT INTO SaaS_EMP_VIEW(EMPNO, ENAME, JOB, HIREDATE, SALARY, COMM) VALUES(7876, 'ADAMS',  'CLERK',    '12-JAN-1983', 1100, NULL);
INSERT INTO SaaS_EMP_VIEW(EMPNO, ENAME, JOB, HIREDATE, SALARY, COMM) VALUES(7900, 'JAMES',  'CLERK',    '3-DEC-1981',   950, NULL);
INSERT INTO SaaS_EMP_VIEW(EMPNO, ENAME, JOB, HIREDATE, SALARY, COMM) VALUES(7902, 'FORD',   'ANALYST',  '3-DEC-1981',  3000, NULL);
INSERT INTO SaaS_EMP_VIEW(EMPNO, ENAME, JOB, HIREDATE, SALARY, COMM) VALUES(7934, 'MILLER', 'CLERK',    '23-JAN-1982', 1300, NULL);

INSERT INTO SaaS_DEPT_VIEW (DEPTNO, DNAME, LOC) VALUES (10, 'ACCOUNTING', 'NEW YORK');
INSERT INTO SaaS_DEPT_VIEW (DEPTNO, DNAME, LOC) VALUES (20, 'RESEARCH',   'DALLAS');
INSERT INTO SaaS_DEPT_VIEW (DEPTNO, DNAME, LOC) VALUES (30, 'SALES',      'CHICAGO');
INSERT INTO SaaS_DEPT_VIEW (DEPTNO, DNAME, LOC) VALUES (40, 'OPERATIONS', 'BOSTON');

update SaaS_EMP_VIEW set mgr_uri = '<http://SaaS.org/Emp_7902>' where emp_uri = 'http://SaaS.org/Emp_7369';
update SaaS_EMP_VIEW set mgr_uri = '<http://SaaS.org/Emp_7698>' where emp_uri = 'http://SaaS.org/Emp_7499';
update SaaS_EMP_VIEW set mgr_uri = '<http://SaaS.org/Emp_7698>' where emp_uri = 'http://SaaS.org/Emp_7521';
update SaaS_EMP_VIEW set mgr_uri = '<http://SaaS.org/Emp_7839>' where emp_uri = 'http://SaaS.org/Emp_7566'; 
update SaaS_EMP_VIEW set mgr_uri = '<http://SaaS.org/Emp_7698>' where emp_uri = 'http://SaaS.org/Emp_7654';
update SaaS_EMP_VIEW set mgr_uri = '<http://SaaS.org/Emp_7839>' where emp_uri = 'http://SaaS.org/Emp_7698';   
update SaaS_EMP_VIEW set mgr_uri = '<http://SaaS.org/Emp_7839>' where emp_uri = 'http://SaaS.org/Emp_7782';   
update SaaS_EMP_VIEW set mgr_uri = '<http://SaaS.org/Emp_7566>' where emp_uri = 'http://SaaS.org/Emp_7788';  
update SaaS_EMP_VIEW set mgr_uri = '<http://SaaS.org/Emp_7698>' where emp_uri = 'http://SaaS.org/Emp_7844'; 
update SaaS_EMP_VIEW set mgr_uri = '<http://SaaS.org/Emp_7788>' where emp_uri = 'http://SaaS.org/Emp_7876';    
update SaaS_EMP_VIEW set mgr_uri = '<http://SaaS.org/Emp_7698>' where emp_uri = 'http://SaaS.org/Emp_7900';     
update SaaS_EMP_VIEW set mgr_uri = '<http://SaaS.org/Emp_7566>' where emp_uri = 'http://SaaS.org/Emp_7902';  
update SaaS_EMP_VIEW set mgr_uri = '<http://SaaS.org/Emp_7782>' where emp_uri = 'http://SaaS.org/Emp_7934';  

update SaaS_EMP_VIEW set dept_uri = '<http://SaaS.org/Dept_20>' where emp_uri = 'http://SaaS.org/Emp_7369';
update SaaS_EMP_VIEW set dept_uri = '<http://SaaS.org/Dept_30>' where emp_uri = 'http://SaaS.org/Emp_7499';
update SaaS_EMP_VIEW set dept_uri = '<http://SaaS.org/Dept_30>' where emp_uri = 'http://SaaS.org/Emp_7521';
update SaaS_EMP_VIEW set dept_uri = '<http://SaaS.org/Dept_20>' where emp_uri = 'http://SaaS.org/Emp_7566'; 
update SaaS_EMP_VIEW set dept_uri = '<http://SaaS.org/Dept_30>' where emp_uri = 'http://SaaS.org/Emp_7654';
update SaaS_EMP_VIEW set dept_uri = '<http://SaaS.org/Dept_30>' where emp_uri = 'http://SaaS.org/Emp_7698';   
update SaaS_EMP_VIEW set dept_uri = '<http://SaaS.org/Dept_10>' where emp_uri = 'http://SaaS.org/Emp_7782';   
update SaaS_EMP_VIEW set dept_uri = '<http://SaaS.org/Dept_20>' where emp_uri = 'http://SaaS.org/Emp_7788';    
update SaaS_EMP_VIEW set dept_uri = '<http://SaaS.org/Dept_10>' where emp_uri = 'http://SaaS.org/Emp_7839'; 
update SaaS_EMP_VIEW set dept_uri = '<http://SaaS.org/Dept_30>' where emp_uri = 'http://SaaS.org/Emp_7844'; 
update SaaS_EMP_VIEW set dept_uri = '<http://SaaS.org/Dept_20>' where emp_uri = 'http://SaaS.org/Emp_7876';    
update SaaS_EMP_VIEW set dept_uri = '<http://SaaS.org/Dept_30>' where emp_uri = 'http://SaaS.org/Emp_7900';     
update SaaS_EMP_VIEW set dept_uri = '<http://SaaS.org/Dept_20>' where emp_uri = 'http://SaaS.org/Emp_7902';  
update SaaS_EMP_VIEW set dept_uri = '<http://SaaS.org/Dept_10>' where emp_uri = 'http://SaaS.org/Emp_7934';

select empno, ename, job, salary, hiredate, salary, comm, training, dname, location, award from SaaS_EMP_VIEW order by dname;
select * from SaaS_EMP_VIEW order by dname; 

select * from SaaS_DEPT_VIEW;

update SaaS_EMP_VIEW set training = 'Yes' where dname = 'ACCOUNTING';

update SaaS_EMP_RULE set emp_uri = 'Run' ;

delete from SaaS_EMP_VIEW;

delete from SaaS_DEPT_VIEW;
