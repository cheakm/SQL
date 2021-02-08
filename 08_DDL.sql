
/* ***********************************************************************************

ddl : ������ ���̽� ���� ��ü�� �����Ѵ� : ����, ����, ����
    - ��ü : ���̺� ������ ��ǥ��. �����͸� �����ϱ� ���� ����?
    
-���� : create
-���� : alter
-���� : drop
    
���̺� ����
- ����
create table ���̺�_�̸�(
  �÷� ����
)

�������� ����  ��) �����̸Ӹ�Ű, ����Ű, ����ũ, üũŰ �� �����Ҷ��� �÷������� �����ؼ� �� ���� �ְ�, �ؿ� ���ε� ����!
- �÷� ���� ����
    - �÷� ������ ���� ����
- ���̺� ���� ���� ��) ����Ű�� ���� ������ �� �ؿ�.
    - �÷� �����ڿ� ���� ����

- �⺻ ���� : constraint ���������̸� ��������Ÿ�� : ������� ����ѵ� �÷������� �ϳ�, ���̺����� �ϳĿ� �ٶ� ���ݾ� �޶���.
- ���̺� ���� ���� ��ȸ
    - USER_CONSTRAINTS ��ųʸ� �信�� ��ȸ
    
���̺� ����
- ����
DROP TABLE ���̺��̸� [CASCADE CONSTRAINTS] : �θ����̺� ������ �� ���� cascade constraints�� ���̾�}
*********************************************************************************** */

create table parent_tb(
        no number primary key, -- constraint pk_parent_tb primary key : primary key ��ſ� �̷���, ����Ʈ����Ʈ ������ ���°��� �׳� �̸�. ���̴� �������ǿ� ���� �̸��� �־��� �ƴ� ����Ʈ������ �����ϳ�.
        name nvarchar2(30) not null, -- ������ ��ó�� ���ϰ� �׳� �̷���
        birthday date default sysdate, --�⺻�� �����Ѱ� : �μ�Ʈ�� ���� ���� ������ �μ�Ƽ�� �⺻��. ���糯¥�� �ְڴ�.
        email varchar2(100) constraint uk_parent_tb_email unique, -- unique ��������.(�׳� constraint~ ��� ����ũ�� �־ ��), null�� ������� �ߺ��� �� �ȵ�.
        gender char(1) not null constraint ck_parent_tb_gender check(gender in ('M', 'F')) --üũ���� ��ȣ�ȿ� ���� �ִµ�, �������ϰ� �Ȱ���/ ���������� Ư�� ���ǿ� �����ϴ� �ָ� �ϴ� �������� �ٶ� 
);
        
        --�� üũ : ���� ���� ��������.
create table parent_tb(
        no number constraint pk_parent_tb primary key,
        name nvarchar2(30) not null,
        birthday date default sysdate,
        email varchar2(100) constraint uk_parent_tb_email unique,
        gender char(1) not null constraint ck_parent_tb_gender check(gender in ('m','f'))
);



insert into parent_tb values(1,'ȫ�浿','2010/01/01','a@a.com','M');
insert into parent_tb (no,name,gender) values (2,'�̼���','M');
insert into parent_tb values(3,'ȫ�浿2',null,'b@a.com','M'); --�������̿� ���̸� ���� �ȳ����� �ƴ� ��������� ���� ������ ����Ʈ���� �ƴ� �ΰ��� �μ�Ʈ��
insert into parent_tb values(4,'ȫ�浿2',null,'b@a.com','M'); --���� �� �־ ���Ἲ �������� ������ ���µ�, �������� �̸��� ��� ������ ��� ���������� �� �� ����
insert into parent_tb values(5,'�迵��',null,'c@a.com','m'); --üũ�������� ����. �빮�� ���� ������ ���� �� ����

select * from parent_tb; -- ���� �ȳԾ ����Ʈ������ ����, �̸����� �ȳ־��µ� �γ���.

insert into dept values (10,'a','b'); --�ι������ϸ� �������µ�, ���⼭�� ���������� �̸��� �����ʾҾ���. �׷��� ����Ŭ�� ������� �������� �̸��� ���ͼ� � �� ������ �˱� �����.
 


create table child_tb(
        no number, --pk
        jumin_num char(14), --uk �ֹι�ȣ �ߺ� �ȵǴϱ�
        age number(3), -- 10~90���� �����ϰ� üũŰ �ٲ���.
        parent_no number, -- parent tb�� �����ϴ� fk�÷�.
        constraint pk_child_tb primary key(no), --�����ϴϱ��÷����� �˷����
        constraint uk_child_tb_jumin_num unique(jumin_num),
        constraint ck_child_tb_age check(age between 10 and 90),
        constraint fk_child_tb_parent_tb foreign key(parent_no) references parent_tb(no) -- �̸����� ����̺� �����ϴ����� �־���. �÷��� ���۷��� �Ʒ��� � ���̺� �����ϴ��� �˷��ְ� ��ȣ�ȿ� �÷���. ��ȣ �� �÷����� ���� ���� ������ �����̸Ӹ�Ű�ϱ�.
);



/* ************************************************************************************
ALTER : ���̺� ����

�÷� ���� ����

- �÷� �߰�
  ALTER TABLE ���̺��̸� ADD (�߰��� �÷����� [, �߰��� �÷�����])
  - �ϳ��� �÷��� �߰��� ��� ( ) �� ��������

- �÷� ����
  ALTER TABLE ���̺��̸� MODIFY (�������÷���  ���漳�� [, �������÷���  ���漳��])
	- �ϳ��� �÷��� ������ ��� ( )�� ���� ����
	- ����/���ڿ� �÷��� ũ�⸦ �ø� �� �ִ�.
		- ũ�⸦ ���� �� �ִ� ��� : ���� ���� ���ų� ��� ���� ���̷��� ũ�⺸�� ���� ���-> ���̴� �� �ȵȴٰ� ����.
	- �����Ͱ� ��� NULL�̸� ������Ÿ���� ������ �� �ִ�. (�� CHAR<->VARCHAR2 �� ����.)

- �÷� ����	
  ALTER TABLE ���̺��̸� DROP COLUMN �÷��̸� [CASCADE CONSTRAINTS]
    - CASCADE CONSTRAINTS : �����ϴ� �÷��� Primary Key�� ��� �� �÷��� �����ϴ� �ٸ� ���̺��� Foreign key ������ ��� �����Ѵ�.
	- �ѹ��� �ϳ��� �÷��� ���� ����.
	
  ALTER TABLE ���̺��̸� SET UNUSED (�÷��� [, ..])
  ALTER TABLE ���̺��̸� DROP UNUSED COLUMNS
	- SET UNUSED ������ �÷��� �ٷ� �������� �ʰ� ���� ǥ�ø� �Ѵ�. 
	- ������ �÷��� ����� �� ������ ���� ��ũ���� ����� �ִ�. �׷��� �ӵ��� ������.
	- DROP UNUSED COLUMNS �� SET UNUSED�� �÷��� ��ũ���� �����Ѵ�. 

- �÷� �̸� �ٲٱ�
  ALTER TABLE ���̺��̸� RENAME COLUMN �����̸� TO �ٲ��̸�;

**************************************************************************************  
���� ���� ���� ���� : �������� �ٲٴ� ���� ����. �ٲٷ����ϸ� �����ϰ� �ٽ� ������.
-�������� �߰�
  ALTER TABLE ���̺�� ADD CONSTRAINT �������� ����

- �������� ����
  ALTER TABLE ���̺�� DROP CONSTRAINT ���������̸�
  PRIMARY KEY ����: ALTER TABLE ���̺�� DROP PRIMARY KEY [CASCADE] : �� �����ϰ� ����.���̺�� �ϳ��� ������ �� �����ϱ�
	- CASECADE : �����ϴ� Primary Key�� Foreign key ���� �ٸ� ���̺��� Foreign key ������ ��� �����Ѵ�.

- NOT NULL <-> NULL ��ȯ�� �÷� ������ ���� �Ѵ�.
   - ALTER TABLE ���̺�� MODIFY (�÷��� NOT NULL),  - ALTER TABLE ���̺�� MODIFY (�÷��� NULL)  
************************************************************************************ */

-- customers ī���ؼ� cust��� ���̺� ���鶧 :����Ʈ ����� ������ ���̺� ������
-- ����Ʈ ��� ���� ���̺�� ����(������ ������ �ٸ� ���������� ī�ǰ� �ȵ�)
drop table cust;

create table cust
as
select * from customers;

select * from cust;


create table cust2
as 
select cust_id, cust_name, address from customers;-- ���� Į���� ���鶧

select * from cust2;

select * from customers
where 1 = 0; --false , ������� �ϳ��ϳ� ������ ���ͼ�, �ƹ��͵� �ȳ���


create table cust3 --�����ʹ� �Ȱ������� �÷��� ī���ϰԵ�
as
select * from customers
where 1 = 0;

select * from cust3;

--�߰�
alter table cust3 add(age number default 0 not null, point number); --�������� ����Ʈ �ΰ� �÷� �߰�
desc cust3;


--����
alter table cust3 modify (age number(3));
desc cust3;
alter table cust3 modify(cust_email null); --not null -> null
alter table cust3 modify(cust_email not null); 


--�÷��� ����
alter table cust3 rename column cust_email to email ;
alter table cust3 rename column cust_email to email;
desc cust3;

--�÷� ����
alter table cust3 drop column age;
desc cust3;

select * from cust;
desc cust;



alter table cust modify (cust_id number(2)); -- -99~99�� Ÿ������ �ٲ�°ǵ� �̹� 100~180���� �����Ѵ� �ֵ��� �־�/ �׷��� ������
alter table cust modify (cust_id number(5)); --�ø��°� ����
alter table cust add (age number(3) not null); --���� : �÷��� ���� ���� ���� ������ �ƴ�/���� ������ null�� ä�����ٵ�, ���� ������ �����鼭 not null�̶�� �ϴϱ� �÷� ���� ���� ����.
alter table cust add(age number(3)); --�̰Ŵ� ����
select * from cust;


alter table cust3 modify (cust_id number(2)); --��� ���� �����ϱ� �ٲܼ� ����

rollback;
desc cust; --cust_id(5) ���� �� ������ �ȵ�. commit �̳� rollback�� dml�� ����̰�, ddl�� ����� �ƴ϶�/ ddl�� ����Ǹ� ��




***************************************************

--- �������� ����
-- �� ���̺��� �������� ��ȸ : ����Ŭ���� �����ϴ� ���( r: ����, c:�����÷� �ƴϸ� üũŰ�÷�)
select * from user_constrains;
select * from user_constraints where table_name = 'CUST3'; --CUST3���̺��� �������� Ȯ��! �̰� �� �빮�ڷ� ���


alter table cust add constraint pk_cust primary key(cust_id); --cust���̺��� pk �� �߰�. cust_id�� �����̸Ӹ�Ű�� ��
alter table cust  add constraint uk_cust_cust_email unique(cust_email); --cust���̺��� uniqueŰ �߰�
alter table cust add constraint ck_cust_gender check(gender in ('M','F')); --CheckŰ �߰�

select * from user_constraints where table_name = 'CUST';


--����
alter table cust drop constraint ck_cust_gender;
alter table cust drop constraint pk_cust;
--alter table cust drop primary key : �̸����� �ʰ� �����̸Ӹ�Ű ���ﲨ��� �ص� ��.���̺�� �ϳ��ۿ� �����ϱ�


--TODO: emp ���̺��� ī���ؼ� emp2�� ����(Ʋ�� ī��)


create table emp2
as 
select * from emp
where 1 = 0;-- � �����̵� ���������̸� ��. ī���ϸ� ���� �������� ���� �� �������� �ʾ�/ 
 select * from emp2;

--TODO: gender �÷��� �߰�: type char(1) : add(�÷��� ������Ÿ�� ��������)

alter table emp2 add(gender char(1));
select * from emp2;

--TODO: email �÷� �߰�. type: varchar2(100),  not null  �÷�

alter table emp2 add(email varchar2(100) not null);
select * from emp2;
desc emp2;
--TODO: jumin_num(�ֹι�ȣ) �÷��� �߰�. type: char(14), null ���. ������ ���� ������ �÷�.


alter table emp2 add(jumin_num char(14) unique);
--
alter table emp2 add(jumin_num char(14) constraint uk_emp2_numin unique);
desc emp2;
select * from user_constraints where table_name = 'EMP2';

--TODO: emp_id �� primary key �� ����

alter table emp2 modify(emp_id primary key);

--
alter table emp2 drop column emp_id;
alter table emp2 add constraint pk_emp2 primary key(emp_id);

select * from user_constraints where table_name = 'EMP2';

--TODO: gender �÷��� M, F �����ϵ���  �������� �߰�
-- �� ���̺��� �������� ��ȸ : ����Ŭ���� �����ϴ� ���( r: ����, c:�����÷� �ƴϸ� üũŰ�÷�)

select * from user_constrains;
select * from user_constraints where table_name = 'CUST3'; --CUST3���̺��� �������� Ȯ��! �̰� �� �빮�ڷ� ���



alter table cust add constraint pk_cust primary key(cust_id); --cust���̺��� pk �� �߰�. cust_id�� �����̸Ӹ�Ű�� ��
alter table cust  add constraint uk_cust_cust_email unique(cust_email); --cust���̺��� uniqueŰ �߰�
alter table cust add constraint ck_cust_gender check(gender in ('M','F')); --CheckŰ �߰�

alter table emp2 add constraint ck_emp2_gender check(gender in ('M','F'));

 
--TODO: salary �÷��� 0�̻��� ���鸸 ������ �������� �߰�


alter table emp2 add constraint ck_emp2_salary check( salary>=0);
select * from user_constraints where table_name = 'EMP2';
--TODO: email �÷��� null�� ���� �� �ֵ� �ٸ� ��� ���� ���� ������ ���ϵ��� ���� ���� ����

alter table emp2 modify (email null);

--TODO: emp_name �� ������ Ÿ���� varchar2(100) ���� ��ȯ

alter table emp2 modify(emp_name varchar2(100)); --modify(�÷��� �ٲܳ���)
desc emp2;

--TODO: job_id�� not null �÷����� ����

alter table emp2 modify(job_id not null);


--TODO: dept_id�� not null �÷����� ����

alter table emp2 modify(dept_id not null);
desc emp2;

--TODO: job_id  �� null ��� �÷����� ����
alter table emp2 modify (job_id null);

alter table emp2 modify (job_id null);
--TODO: dept_id  �� null ��� �÷����� ����
alter table emp2 modify(dept_id null);


--TODO: ������ ������ jumin_email_uk ���� ������ ����
alter table emp2 drop constraint uk_emp2_jumin;




alter table cust drop constraint ck_cust_gender;
alter table cust drop constraint pk_cust;
--alter table cust drop primary key : �̸����� �ʰ� �����̸Ӹ�Ű ���ﲨ��� �ص� ��.���̺�� �ϳ��ۿ� �����ϱ�

alter table emp2 drop constraints pk_emp2;

--TODO: ������ ������ emp2_salary_ck ���� ������ ����

alter table emp2 drop constraint ck_emp2_salary;


--TODO: primary key �������� ����
alter table emp2 drop primary key;



--TODO: gender �÷�����
alter table emp2 drop column gender;
 alter table emp2 drop column gender;

--TODO: email �÷� ����
alter table emp2 drop column email;

alter table emp2 drop column email;

/* **************************************************************************************************************
������ : SEQUENCE ����Ŭ ����.
- �ڵ������ϴ� ���ڸ� �����ϴ� ����Ŭ ��ü-> �μ�Ʈ�Ҷ� ���� ��./ �۹�ȣ �ۼ���.
- ���̺� �÷��� �ڵ������ϴ� ������ȣ�� ������ ����Ѵ�.
	- �ϳ��� �������� ���� ���̺��� �����ϸ� �߰��� �� ������ �� �� �ִ�.

���� ����
CREATE SEQUENCE sequence�̸� -> ��������� �⺻����  ���̽��� range�� ���.
	[INCREMENT BY n]	
	[START WITH n]                		  
	[MAXVALUE n | NOMAXVALUE]   
	[MINVALUE n | NOMINVALUE]	
	[CYCLE | NOCYCLE(�⺻)]		
	[CACHE n | NOCACHE]		  

- INCREMENT BY n: ����ġ ����. ������ 1(�� n�� �����ڸ�)
- START WITH n: ���� �� ����. ������ 0
	- ���۰� ������
	 - ����: MINVALUE ���� ũĿ�� ���� ���̾�� �Ѵ�.
	 - ����: MAXVALUE ���� �۰ų� ���� ���̾�� �Ѵ�.
- MAXVALUE n: �������� ������ �� �ִ� �ִ밪�� ����
- NOMAXVALUE : �������� ������ �� �ִ� �ִ밪�� ���������� ��� 10^27 �� ��. ���������� ��� -1�� �ڵ����� ����. (10�� 27�±��� �����ϴϱ� ���� ���������� ���� �ǰ�, ��ƽ��� ��ν��� ����Ʈ��)
- MINVALUE n :�ּ� ������ ���� ���� -> ���ҽ�ų��
- NOMINVALUE :�������� �����ϴ� �ּҰ��� ���������� ��� 1, ���������� ��� -(10^26)���� ����
- CYCLE �Ǵ� NOCYCLE : �ִ�/�ּҰ����� ������ ��ȯ�� �� ����. NOCYCLE�� �⺻��(��ȯ�ݺ����� �ʴ´�.) ����Ŭ�� ó������ �ٽ� ������ ��(�ݺ�)
- CACHE|NOCACHE : ĳ�� ��뿩�� ����.(����Ŭ ������ �������� ������ ���� �̸� ��ȸ�� �޸𸮿� ����) NOCACHE�� �⺻��(CACHE�� ������� �ʴ´�. )
  -> ĳ���� �������� �ֱ� ���� ����� �޸𸮿� �̸� �����س��� ����. / �� ������������ ������ ĳ���� ������ ���� �� ����.


������ �ڵ������� ��ȸ
 - sequence�̸�.nextval  : ���� ����ġ ��ȸ
 - sequence�̸�.currval  : ���� �������� ��ȸ -> �ؽ�Ʈ���� �ݵ�� �ѹ� ���������.


������ ����
ALTER SEQUENCE ������ �������̸� : �ؿ��� �ٲܲ��� �־��ָ� ��.
	[INCREMENT BY n]	               		  
	[MAXVALUE n | NOMAXVALUE]   
	[MINVALUE n | NOMINVALUE]	
	[CYCLE | NOCYCLE(�⺻)]		
	[CACHE n | NOCACHE]	

������ �����Ǵ� ������ ������ �޴´�. (�׷��� start with ���� ��������� �ƴϴ�.)	  


������ ����
DROP SEQUENCE sequence�̸�
	
************************************************************************************************************** */

-- 1���� 1�� �ڵ������ϴ� ������
create sequence dept_id_seq; --dept_id�� ���� ������������ ���ڴٰ� �ϴ� �̸�����
select dept_id_seq.nextval from dual;
select dept_id_seq.currval from dual; --���簪�� �����


insert into dept values (dept_id_seq.nextval, '���μ�','����');
insert into dept values (dept_id_seq.nextval, '���μ�','����');
insert into dept values (dept_id_seq.nextval, '���μ�','����');
select * from dept order by dept_id;


insert into dept values (dept_id_seq.nextval, '���μ�'||dept_id_seq.currval, '����');
select * from dept order by dept_id;

-- 1���� 50���� 10�� �ڵ����� �ϴ� ������ (��ŸƮ : 1, �ƽ� :50, ����ġ:10)
create sequence ex1_seq 
    increment by 10 
    start with 1 
    maxvalue 40;
    
select ex1_seq.nextval from dual; --maxvalue �ɶ����� ���� ��.


-- 100 ���� 150���� 10�� �ڵ������ϴ� ������

 create sequence ex2_seq
        increment by 10
        start with 100
        maxvalue 150;
        
select ex2_seq.nextval from dual;

-- 100 ���� 150���� 10�� �ڵ������ϵ� �ִ밪�� �ٴٸ��� ��ȯ�ϴ� ������
--������ ��� ��ȯ(increment by ���)�� �� minvalue(�⺻�� : 1)���� ����.  
-- ��ȯ�Ҷ� ����(increment by ����) : �ƽ����(�⺻�� : -1)�������� ����.(ó���� �����Ҷ��� ��ŸƮ������ �����ϴ°Ű�)
create sequence ex3_seq
    increment by 10 --ĳ���� �� ���ں��� �۾ƾ���
    start with 100
    maxvalue 150
    cache 5
    cycle;
    
select ex3_seq.nextval from dual;
drop sequence ex3_seq;


-- -1���� �ڵ� �����ϴ� ������

create sequence ex4_seq
        increment by -1; --�ڵ����� : start with�⺻���� -1
select ex4_seq.nextval from dual;


-- -1���� -50���� -10�� �ڵ� �����ϴ� ������
create sequence ex5_seq
        increment by -10
        start with -1
        minvalue -50; --�����϶��� �κ����� ���Ѱ� ����
        
select ex5_seq.nextval from dual;
        

-- 100 ���� -100���� -100�� �ڵ� �����ϴ� ������
drop sequence ex6_seq;
create sequence ex6_seq
        increment by -100
        start with 100
        minvalue -100 --���ҽ� �ƽ������ ����Ʈ ���� -1 �� ���۰��� �ƽ�������� �� Ŀ�� ���� �� ���ҽ� �ƽ����>= ��ŸƮ��� , ���� : �ι��<= ��ŸƮ���
        maxvalue 100; --������� �ؾ� �����ȳ�

select ex6_seq.nextval from dual;
-- 15���� -15���� 1�� �����ϴ� ������ �ۼ�
create sequence ex7_seq
  increment by -1
  start with 15
  minvalue -15
  maxvalue 15;
  
select ex7_seq.nextval from dual;
-- -10 ���� 1�� �����ϴ� ������ �ۼ�
create sequence ex9_seq
        increment by 1
        start with -10 --�����϶�, �ι���� 1�� �⺻��. ���� ��ŸƮ���� 1���� �۾ƹ����� �ȵ� (�ι��<= ��ŸƮ��)
        minvalue -10;

select ex9_seq.nextval from dual;

-- Sequence�� �̿��� �� insert







-- TODO: �μ�ID(dept.dept_id)�� ���� �ڵ����� ��Ű�� sequence�� ����. 10 ���� 10�� �����ϴ� sequence
-- ������ ������ sequence�� ����ؼ�  dept_copy�� 5���� ���� insert.
create sequence dept_id_seq2 
        start with 10
        increment by 10;
        
create table dept_copy
as
select * from dept where 1<>1;

insert into dept_copy values (dept_id_seq2.nextval, '��ȹ��','����');

insert into dept_copy values (dept_id_seq2.nextval, '��ȹ��','����');

insert into dept_copy values (dept_id_seq2.nextval, '��ȹ��','����');
select * from dept_copy;
-- TODO: ����ID(emp.emp_id)�� ���� �ڵ����� ��Ű�� sequence�� ����. 10 ���� 1�� �����ϴ� sequence
-- ������ ������ sequence�� ����� emp_copy�� ���� 5�� insert   ***********emp2�� emp_id�� ��� �ȵ�
create sequence emp_id_seq2
        start with 10
        increment by 1;
        
insert into emp2 values(emp_id_seq2.nextval, 'ȫ�浿',null,null,'2021/01/05',6000,null,null,null);
insert into emp2 values(emp_id_seq2.nextval, 'ȫ�浿',null,null,'2021/01/05',6000,null,null,null);
insert into emp2 values(emp_id_seq2.nextval, 'ȫ�浿',null,null,'2021/01/05',6000,null,null,null);

desc emp2;

select * from emp2;

