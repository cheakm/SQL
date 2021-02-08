
/* ***********************************************************************************

ddl : 데이터 베이스 안의 객체를 관리한다 : 생성, 수정, 삭제
    - 객체 : 테이블 같은게 대표적. 데이터를 관리하기 위한 도구?
    
-생성 : create
-수정 : alter
-삭제 : drop
    
테이블 생성
- 구문
create table 테이블_이름(
  컬럼 설정
)

제약조건 설정  예) 프라이머리키, 포린키, 유니크, 체크키 등 설정할때는 컬럼설정과 연결해서 할 수도 있고, 밑에 따로도 가능!
- 컬럼 레벨 설정
    - 컬럼 설정에 같이 설정
- 테이블 레벨 설정 예) 포린키에 대한 설정은 맨 밑에.
    - 컬럼 설정뒤에 따로 설정

- 기본 문법 : constraint 제약조건이름 제약조건타입 : 여기까지 비슷한데 컬럼레벨이 하냐, 테이블레벨에 하냐에 다라 조금씩 달라짐.
- 테이블 제약 조건 조회
    - USER_CONSTRAINTS 딕셔너리 뷰에서 조회
    
테이블 삭제
- 구분
DROP TABLE 테이블이름 [CASCADE CONSTRAINTS] : 부모테이블 삭제할 땐 보통 cascade constraints를 같이씀}
*********************************************************************************** */

create table parent_tb(
        no number primary key, -- constraint pk_parent_tb primary key : primary key 대신에 이렇게, 컨스트레인트 다음에 오는것은 그냥 이름. 차이는 제약조건에 내가 이름을 주었냐 아님 디폴트값으로 설정하냐.
        name nvarchar2(30) not null, -- 낫널은 위처럼 안하고 그냥 이렇게
        birthday date default sysdate, --기본값 설정한것 : 인서트시 값을 넣지 않으면 인서티될 기본값. 현재날짜로 넣겠다.
        email varchar2(100) constraint uk_parent_tb_email unique, -- unique 제약조건.(그냥 constraint~ 대신 유니크만 넣어도 되), null은 관계없이 중복된 값 안돼.
        gender char(1) not null constraint ck_parent_tb_gender check(gender in ('M', 'F')) --체크절에 괄호안에 조건 넣는데, 웨어절하고 똑같아/ 젠더값으로 특정 조건에 만족하는 애만 하는 제약조건 줄때 
);
        
        --즉 체크 : 값에 대한 제약조건.
create table parent_tb(
        no number constraint pk_parent_tb primary key,
        name nvarchar2(30) not null,
        birthday date default sysdate,
        email varchar2(100) constraint uk_parent_tb_email unique,
        gender char(1) not null constraint ck_parent_tb_gender check(gender in ('m','f'))
);



insert into parent_tb values(1,'홍길동','2010/01/01','a@a.com','M');
insert into parent_tb (no,name,gender) values (2,'이순신','M');
insert into parent_tb values(3,'홍길동2',null,'b@a.com','M'); --벌스데이에 널이면 값을 안넣은게 아님 명시적으로 널을 넣으면 디폴트값이 아닌 널값이 인서트됨
insert into parent_tb values(4,'홍길동2',null,'b@a.com','M'); --같은 값 넣어서 무결성 제약조건 오류가 나는데, 제약조건 이름을 줬기 때문에 어디서 에러났는지 알 수 있지
insert into parent_tb values(5,'김영수',null,'c@a.com','m'); --체크제약조건 위배. 대문자 엠과 에프만 넣을 수 있지

select * from parent_tb; -- 생년 안넜어서 디폴트값으로 들어가고, 이메일은 안넣었는데 널나옴.

insert into dept values (10,'a','b'); --두번실행하면 오류나는데, 여기서는 제약조건의 이름을 주지않았었음. 그래서 오라클이 만들어준 제약조건 이름이 나와서 어떤 걸 어겼는지 알기 어려움.
 


create table child_tb(
        no number, --pk
        jumin_num char(14), --uk 주민번호 중복 안되니까
        age number(3), -- 10~90세만 가능하게 체크키 줄꺼임.
        parent_no number, -- parent tb를 참조하는 fk컬럼.
        constraint pk_child_tb primary key(no), --따로하니까컬럼명을 알려줘야
        constraint uk_child_tb_jumin_num unique(jumin_num),
        constraint ck_child_tb_age check(age between 10 and 90),
        constraint fk_child_tb_parent_tb foreign key(parent_no) references parent_tb(no) -- 이름에서 어떤테이블 참조하는지도 넣어줌. 플러스 레퍼런스 아레에 어떤 테이블 참조하는지 알려주고 괄호안에 컬럼명. 괄호 안 컬럼명은 생략 가능 어차피 프라이머리키니까.
);



/* ************************************************************************************
ALTER : 테이블 수정

컬럼 관련 수정

- 컬럼 추가
  ALTER TABLE 테이블이름 ADD (추가할 컬럼설정 [, 추가할 컬럼설정])
  - 하나의 컬럼만 추가할 경우 ( ) 는 생략가능

- 컬럼 수정
  ALTER TABLE 테이블이름 MODIFY (수정할컬럼명  변경설정 [, 수정할컬럼명  변경설정])
	- 하나의 컬럼만 수정할 경우 ( )는 생략 가능
	- 숫자/문자열 컬럼은 크기를 늘릴 수 있다.
		- 크기를 줄일 수 있는 경우 : 열에 값이 없거나 모든 값이 줄이려는 크기보다 작은 경우-> 줄이는 건 안된다고 생각.
	- 데이터가 모두 NULL이면 데이터타입을 변경할 수 있다. (단 CHAR<->VARCHAR2 는 가능.)

- 컬럼 삭제	
  ALTER TABLE 테이블이름 DROP COLUMN 컬럼이름 [CASCADE CONSTRAINTS]
    - CASCADE CONSTRAINTS : 삭제하는 컬럼이 Primary Key인 경우 그 컬럼을 참조하는 다른 테이블의 Foreign key 설정을 모두 삭제한다.
	- 한번에 하나의 컬럼만 삭제 가능.
	
  ALTER TABLE 테이블이름 SET UNUSED (컬럼명 [, ..])
  ALTER TABLE 테이블이름 DROP UNUSED COLUMNS
	- SET UNUSED 설정시 컬럼을 바로 삭제하지 않고 삭제 표시를 한다. 
	- 설정된 컬럼은 사용할 수 없으나 실제 디스크에는 저장되 있다. 그래서 속도가 빠르다.
	- DROP UNUSED COLUMNS 로 SET UNUSED된 컬럼을 디스크에서 삭제한다. 

- 컬럼 이름 바꾸기
  ALTER TABLE 테이블이름 RENAME COLUMN 원래이름 TO 바꿀이름;

**************************************************************************************  
제약 조건 관련 수정 : 제약조건 바꾸는 것은 없음. 바꾸려고하면 삭제하고 다시 만드어야.
-제약조건 추가
  ALTER TABLE 테이블명 ADD CONSTRAINT 제약조건 설정

- 제약조건 삭제
  ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건이름
  PRIMARY KEY 제거: ALTER TABLE 테이블명 DROP PRIMARY KEY [CASCADE] : 더 간단하게 가능.테이블당 하나만 지정할 수 있으니까
	- CASECADE : 제거하는 Primary Key를 Foreign key 가진 다른 테이블의 Foreign key 설정을 모두 삭제한다.

- NOT NULL <-> NULL 변환은 컬럼 수정을 통해 한다.
   - ALTER TABLE 테이블명 MODIFY (컬럼명 NOT NULL),  - ALTER TABLE 테이블명 MODIFY (컬럼명 NULL)  
************************************************************************************ */

-- customers 카피해서 cust라는 테이블 만들때 :셀렉트 결과를 가지고 테이블 만들어라
-- 셀렉트 결과 셋을 테이블로 생성(낫널을 제외한 다른 제약조건은 카피가 안됨)
drop table cust;

create table cust
as
select * from customers;

select * from cust;


create table cust2
as 
select cust_id, cust_name, address from customers;-- 세개 칼럼만 만들때

select * from cust2;

select * from customers
where 1 = 0; --false , 모든행이 하나하나 폴스가 나와서, 아무것도 안나와


create table cust3 --데이터는 안가져오고 컬럼명만 카피하게돼
as
select * from customers
where 1 = 0;

select * from cust3;

--추가
alter table cust3 add(age number default 0 not null, point number); --에이지와 포인트 두개 컬럼 추가
desc cust3;


--수정
alter table cust3 modify (age number(3));
desc cust3;
alter table cust3 modify(cust_email null); --not null -> null
alter table cust3 modify(cust_email not null); 


--컬럼명 변경
alter table cust3 rename column cust_email to email ;
alter table cust3 rename column cust_email to email;
desc cust3;

--컬럼 삭제
alter table cust3 drop column age;
desc cust3;

select * from cust;
desc cust;



alter table cust modify (cust_id number(2)); -- -99~99인 타입으로 바뀌는건데 이미 100~180까지 범위넘는 애들이 있어/ 그래서 에러남
alter table cust modify (cust_id number(5)); --늘리는건 가능
alter table cust add (age number(3) not null); --오류 : 컬럼을 만든 거지 값을 넣은게 아님/따라서 값들은 null로 채워질텐데, 값을 주지도 않으면서 not null이라고 하니까 컬럼 만들 수가 없음.
alter table cust add(age number(3)); --이거는 가능
select * from cust;


alter table cust3 modify (cust_id number(2)); --얘는 값이 없으니까 바꿀수 있음

rollback;
desc cust; --cust_id(5) 만든 건 변경이 안돼. commit 이나 rollback은 dml이 대상이고, ddl은 대상이 아니라서/ ddl은 실행되면 끝




***************************************************

--- 제약조건 변경
-- 각 테이블의 제약조건 조회 : 오라클에서 제공하는 기능( r: 참조, c:낫널컬럼 아니면 체크키컬럼)
select * from user_constrains;
select * from user_constraints where table_name = 'CUST3'; --CUST3테이블의 제약조건 확인! 이건 꼭 대문자로 줘야


alter table cust add constraint pk_cust primary key(cust_id); --cust테이블의 pk 를 추가. cust_id가 프라이머리키가 됨
alter table cust  add constraint uk_cust_cust_email unique(cust_email); --cust테이블의 unique키 추가
alter table cust add constraint ck_cust_gender check(gender in ('M','F')); --Check키 추가

select * from user_constraints where table_name = 'CUST';


--제거
alter table cust drop constraint ck_cust_gender;
alter table cust drop constraint pk_cust;
--alter table cust drop primary key : 이름주지 않고 프라이머리키 지울꺼라고 해도 됨.테이블당 하나밖에 없으니까


--TODO: emp 테이블을 카피해서 emp2를 생성(틀만 카피)


create table emp2
as 
select * from emp
where 1 = 0;-- 어떤 조건이든 거짓조건이면 됨. 카피하면 낫널 제약조건 뺴고 다 가져오지 않아/ 
 select * from emp2;

--TODO: gender 컬럼을 추가: type char(1) : add(컬럼명 데이터타입 제약조건)

alter table emp2 add(gender char(1));
select * from emp2;

--TODO: email 컬럼 추가. type: varchar2(100),  not null  컬럼

alter table emp2 add(email varchar2(100) not null);
select * from emp2;
desc emp2;
--TODO: jumin_num(주민번호) 컬럼을 추가. type: char(14), null 허용. 유일한 값을 가지는 컬럼.


alter table emp2 add(jumin_num char(14) unique);
--
alter table emp2 add(jumin_num char(14) constraint uk_emp2_numin unique);
desc emp2;
select * from user_constraints where table_name = 'EMP2';

--TODO: emp_id 를 primary key 로 변경

alter table emp2 modify(emp_id primary key);

--
alter table emp2 drop column emp_id;
alter table emp2 add constraint pk_emp2 primary key(emp_id);

select * from user_constraints where table_name = 'EMP2';

--TODO: gender 컬럼의 M, F 저장하도록  제약조건 추가
-- 각 테이블의 제약조건 조회 : 오라클에서 제공하는 기능( r: 참조, c:낫널컬럼 아니면 체크키컬럼)

select * from user_constrains;
select * from user_constraints where table_name = 'CUST3'; --CUST3테이블의 제약조건 확인! 이건 꼭 대문자로 줘야



alter table cust add constraint pk_cust primary key(cust_id); --cust테이블의 pk 를 추가. cust_id가 프라이머리키가 됨
alter table cust  add constraint uk_cust_cust_email unique(cust_email); --cust테이블의 unique키 추가
alter table cust add constraint ck_cust_gender check(gender in ('M','F')); --Check키 추가

alter table emp2 add constraint ck_emp2_gender check(gender in ('M','F'));

 
--TODO: salary 컬럼에 0이상의 값들만 들어가도록 제약조건 추가


alter table emp2 add constraint ck_emp2_salary check( salary>=0);
select * from user_constraints where table_name = 'EMP2';
--TODO: email 컬럼을 null을 가질 수 있되 다른 행과 같은 값을 가지지 못하도록 제약 조건 변경

alter table emp2 modify (email null);

--TODO: emp_name 의 데이터 타입을 varchar2(100) 으로 변환

alter table emp2 modify(emp_name varchar2(100)); --modify(컬럼명 바꿀내용)
desc emp2;

--TODO: job_id를 not null 컬럼으로 변경

alter table emp2 modify(job_id not null);


--TODO: dept_id를 not null 컬럼으로 변경

alter table emp2 modify(dept_id not null);
desc emp2;

--TODO: job_id  를 null 허용 컬럼으로 변경
alter table emp2 modify (job_id null);

alter table emp2 modify (job_id null);
--TODO: dept_id  를 null 허용 컬럼으로 변경
alter table emp2 modify(dept_id null);


--TODO: 위에서 지정한 jumin_email_uk 제약 조건을 제거
alter table emp2 drop constraint uk_emp2_jumin;




alter table cust drop constraint ck_cust_gender;
alter table cust drop constraint pk_cust;
--alter table cust drop primary key : 이름주지 않고 프라이머리키 지울꺼라고 해도 됨.테이블당 하나밖에 없으니까

alter table emp2 drop constraints pk_emp2;

--TODO: 위에서 지정한 emp2_salary_ck 제약 조건을 제거

alter table emp2 drop constraint ck_emp2_salary;


--TODO: primary key 제약조건 제거
alter table emp2 drop primary key;



--TODO: gender 컬럼제거
alter table emp2 drop column gender;
 alter table emp2 drop column gender;

--TODO: email 컬럼 제거
alter table emp2 drop column email;

alter table emp2 drop column email;

/* **************************************************************************************************************
시퀀스 : SEQUENCE 오라클 문법.
- 자동증가하는 숫자를 제공하는 오라클 객체-> 인서트할때 많이 씀./ 글번호 작성시.
- 테이블 컬럼이 자동증가하는 고유번호를 가질때 사용한다.
	- 하나의 시퀀스를 여러 테이블이 공유하면 중간이 빈 값들이 들어갈 수 있다.

생성 구문
CREATE SEQUENCE sequence이름 -> 여기까지가 기본구문  파이썬의 range와 비슷.
	[INCREMENT BY n]	
	[START WITH n]                		  
	[MAXVALUE n | NOMAXVALUE]   
	[MINVALUE n | NOMINVALUE]	
	[CYCLE | NOCYCLE(기본)]		
	[CACHE n | NOCACHE]		  

- INCREMENT BY n: 증가치 설정. 생략시 1(즉 n은 숫자자리)
- START WITH n: 시작 값 설정. 생략시 0
	- 시작값 설정시
	 - 증가: MINVALUE 보다 크커나 같은 값이어야 한다.
	 - 감소: MAXVALUE 보다 작거나 같은 값이어야 한다.
- MAXVALUE n: 시퀀스가 생성할 수 있는 최대값을 지정
- NOMAXVALUE : 시퀀스가 생성할 수 있는 최대값을 오름차순의 경우 10^27 의 값. 내림차순의 경우 -1을 자동으로 설정. (10의 27승까지 지정하니까 거의 무제한으로 보면 되고, 노맥스와 노민스가 디폴트값)
- MINVALUE n :최소 시퀀스 값을 지정 -> 감소시킬때
- NOMINVALUE :시퀀스가 생성하는 최소값을 오름차순의 경우 1, 내림차순의 경우 -(10^26)으로 설정
- CYCLE 또는 NOCYCLE : 최대/최소값까지 갔을때 순환할 지 여부. NOCYCLE이 기본값(순환반복하지 않는다.) 싸이클은 처음부터 다시 돌리는 것(반복)
- CACHE|NOCACHE : 캐쉬 사용여부 지정.(오라클 서버가 시퀀스가 제공할 값을 미리 조회해 메모리에 저장) NOCACHE가 기본값(CACHE를 사용하지 않는다. )
  -> 캐쉬는 빨리빨리 주기 위해 몇개까지 메모리에 미리 저장해놓을 꺼냐. / 단 비정상적으로 꺼질때 캐쉬가 문제가 잇을 수 있음.


시퀀스 자동증가값 조회
 - sequence이름.nextval  : 다음 증감치 조회
 - sequence이름.currval  : 현재 시퀀스값 조회 -> 넥스트발을 반드시 한번 먼저해줘야.


시퀀스 수정
ALTER SEQUENCE 수정할 시퀀스이름 : 밑에는 바꿀꺼만 넣어주면 됨.
	[INCREMENT BY n]	               		  
	[MAXVALUE n | NOMAXVALUE]   
	[MINVALUE n | NOMINVALUE]	
	[CYCLE | NOCYCLE(기본)]		
	[CACHE n | NOCACHE]	

수정후 생성되는 값들이 영향을 받는다. (그래서 start with 절은 수정대상이 아니다.)	  


시퀀스 제거
DROP SEQUENCE sequence이름
	
************************************************************************************************************** */

-- 1부터 1씩 자동증가하는 시퀀스
create sequence dept_id_seq; --dept_id의 값을 시퀀스값으로 쓰겠다고 하는 이름관례
select dept_id_seq.nextval from dual;
select dept_id_seq.currval from dual; --현재값을 계속줌


insert into dept values (dept_id_seq.nextval, '새부서','서울');
insert into dept values (dept_id_seq.nextval, '새부서','서울');
insert into dept values (dept_id_seq.nextval, '새부서','서울');
select * from dept order by dept_id;


insert into dept values (dept_id_seq.nextval, '새부서'||dept_id_seq.currval, '서울');
select * from dept order by dept_id;

-- 1부터 50까지 10씩 자동증가 하는 시퀀스 (스타트 : 1, 맥스 :50, 증감치:10)
create sequence ex1_seq 
    increment by 10 
    start with 1 
    maxvalue 40;
    
select ex1_seq.nextval from dual; --maxvalue 될때까지 값을 줌.


-- 100 부터 150까지 10씩 자동증가하는 시퀀스

 create sequence ex2_seq
        increment by 10
        start with 100
        maxvalue 150;
        
select ex2_seq.nextval from dual;

-- 100 부터 150까지 10씩 자동증가하되 최대값에 다다르면 순환하는 시퀀스
--증가일 경우 순환(increment by 양수)할 때 minvalue(기본값 : 1)에서 시작.  
-- 순환할때 감소(increment by 음수) : 맥스밸류(기본값 : -1)에서부터 시작.(처음에 시작할때만 스타트값에서 시작하는거고)
create sequence ex3_seq
    increment by 10 --캐쉬가 이 숫자보다 작아야해
    start with 100
    maxvalue 150
    cache 5
    cycle;
    
select ex3_seq.nextval from dual;
drop sequence ex3_seq;


-- -1부터 자동 감소하는 시퀀스

create sequence ex4_seq
        increment by -1; --자동감소 : start with기본값이 -1
select ex4_seq.nextval from dual;


-- -1부터 -50까지 -10씩 자동 감소하는 시퀀스
create sequence ex5_seq
        increment by -10
        start with -1
        minvalue -50; --감소일때는 민벨류로 제한값 설정
        
select ex5_seq.nextval from dual;
        

-- 100 부터 -100까지 -100씩 자동 감소하는 시퀀스
drop sequence ex6_seq;
create sequence ex6_seq
        increment by -100
        start with 100
        minvalue -100 --감소시 맥스밸류의 디폴트 값은 -1 즉 시작값이 맥스밸류보다 더 커서 에러 즉 감소시 맥스밸류>= 스타트밸류 , 증가 : 민밸류<= 스타트밸류
        maxvalue 100; --여기까지 해야 오류안나

select ex6_seq.nextval from dual;
-- 15에서 -15까지 1씩 감소하는 시퀀스 작성
create sequence ex7_seq
  increment by -1
  start with 15
  minvalue -15
  maxvalue 15;
  
select ex7_seq.nextval from dual;
-- -10 부터 1씩 증가하는 시퀀스 작성
create sequence ex9_seq
        increment by 1
        start with -10 --증가일땐, 민밸류가 1이 기본값. 따라서 스타트값이 1보다 작아버리면 안돼 (민밸류<= 스타트값)
        minvalue -10;

select ex9_seq.nextval from dual;

-- Sequence를 이용한 값 insert







-- TODO: 부서ID(dept.dept_id)의 값을 자동증가 시키는 sequence를 생성. 10 부터 10씩 증가하는 sequence
-- 위에서 생성한 sequence를 사용해서  dept_copy에 5개의 행을 insert.
create sequence dept_id_seq2 
        start with 10
        increment by 10;
        
create table dept_copy
as
select * from dept where 1<>1;

insert into dept_copy values (dept_id_seq2.nextval, '기획부','서울');

insert into dept_copy values (dept_id_seq2.nextval, '기획부','서울');

insert into dept_copy values (dept_id_seq2.nextval, '기획부','서울');
select * from dept_copy;
-- TODO: 직원ID(emp.emp_id)의 값을 자동증가 시키는 sequence를 생성. 10 부터 1씩 증가하는 sequence
-- 위에서 생성한 sequence를 사용해 emp_copy에 값을 5행 insert   ***********emp2에 emp_id가 없어서 안됨
create sequence emp_id_seq2
        start with 10
        increment by 1;
        
insert into emp2 values(emp_id_seq2.nextval, '홍길동',null,null,'2021/01/05',6000,null,null,null);
insert into emp2 values(emp_id_seq2.nextval, '홍길동',null,null,'2021/01/05',6000,null,null,null);
insert into emp2 values(emp_id_seq2.nextval, '홍길동',null,null,'2021/01/05',6000,null,null,null);

desc emp2;

select * from emp2;

