# LibrDB

CREATE DATABASE Mike_Library;
USE Mike_Library;

create table Books(
	isbn VARCHAR2(13) NOT NULL PRIMARY KEY,
	title VARCHAR2(200),
	summary VARCHAR2(2000),
	author VARCHAR2(200),
	date_published DATE DEFAULT sysdate,
	page_count NUMBER);

CREATE TABLE book_copies(
	barcode_id VARCHAR2(100) NOT NULL PRIMARY KEY,
	isbn VARCHAR2(13),
	CONSTRAINT isbn_FK FOREIGN KEY(isbn) REFERENCES books (isbn)
);

create table Customer(
	customer_id number(10) NOT NULL PRIMARY KEY,
	customerName varchar2(200),
	customer_email varchar2(200),
	customer_address varchar2(300));

create table Staff(
	staff_id number(10) NOT NULL PRIMARY KEY,
	staff_name varchar2(200),
	staff_address varchar2(200),
	staff_gender varchar2(10),
	staff_phone number(15));

create table Branch(
	branch_id number(10) NOT NULL PRIMARY KEY,
	issue_date date DEFAULT sysdate,
	expiry_date date,
	title varchar2(200),
	isbn number(10),
	CONSTRAINT book_id_FK1 FOREIGN KEY(isbn) REFERENCES Books (isbn));


create table ReturnInfo(
	return_id number(10) NOT NULL PRIMARY KEY,
	expiry_date date,
	issue_date date,
	isbn number(10),
	CONSTRAINT book_id_FK2 FOREIGN KEY(isbn) REFERENCES Books (isbn));
	

	

	
CREATE OR REPLACE PROCEDURE add_book (
	isbn_in IN VARCHAR2,
	barcode_id_in IN VARCHAR2, 
	title_in IN VARCHAR2, 
	author_in IN VARCHAR2,
	page_count_in IN NUMBER, 
	summary_in IN VARCHAR2 DEFAULT NULL,
	date_published_in IN DATE DEFAULT NULL)
AS
BEGIN
/* check for reasonable inputs */

IF isbn_in IS NULL
THEN
RAISE VALUE_ERROR;
END IF;

/* put a record in the "books" table */

INSERT INTO books (isbn, title, summary, author, date_published, page_count)
	VALUES (isbn_in, title_in, summary_in, author_in, date_published_in,
page_count_in);

/* if supplied, put a record in the "book_copies" table */

IF barcode_id_in IS NOT NULL
THEN
INSERT INTO book_copies (isbn, barcode_id)
VALUES (isbn_in, barcode_id_in);
END IF;
END add_book;
/


/* Summary update procedure */
create or replace procedure updateSummary( newSummary int)
as
var_rows number;
begin
update Books set summary = newSummary;
if SQL%FOUND then
	var_rows:=SQL%ROWCOUNT;
	dbms_output.put_line('The Summary of'||var_rows||'books was updated');
	else
	dbms_output.put_line('Some issue in updating');
	end if;
	end;
	
--Replace Trigger

CREATE TRIGGER REPLACE_OLD_DATA_FORMAT
	BEFORE INSERT ON Books
	for each row
BEGIN
	:new.isbn := REPLACE( :new.pers_id, ' ', '-' );
END;
/
