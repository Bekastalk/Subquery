--1--
--китептердин атын, чыккан жылын, жанрын чыгарыныз
select name, published_year, genre from books ;

--2--
--авторлордун мамлеткетттери уникалдуу болсун
select  country from authors  group by country having count(country)<2;

--3--
--2020-2023 жылдардын арасындагы  китептер чыксын
select name,published_year from books where published_year  between '2020/01/01' and '2023/12/31';

--4--
--Детектив китептер жана алардын аттары чыксын
select name, genre from books where genre='DETECTIVE'

--5--
--Автордун аты-жону бир калонкага чыксын
select concat(first_name, last_name) as auhtor from authors;

--6--
Германиядан жана франциядан болгон авторлорду толук аты жону менен сорттоп чыгарыныз
select first_name, last_name from authors where country in ('Germany','France') order by first_name, last_name;

--7--
--Романдан башка жана 500 дон аз болгон китептердин аты олкосу чыккан жылы бaасы жанры чыксын
select name, country, published_year, price, genre from books where  genre <> 'ROMANCE' and price<500;

--8--
--баардык кыз авторлордун биринчи 3 сун чыгарыныз
select * from authors where gender='Female' limit 3;

--9--
--почтасы .com менен буткон, аты 4 тамгадан турган кыз авторлорду чыгарыныз
select * from authors where email like '%com' and first_name like '____';

--10--
select country,count(country) from authors group by country;

--11--
select country,count(country) from authors group by country having count(country)=3 order by country;

--12--
select genre,count(genre) from books group by  genre;

--13--
select (select concat(genre ,' ', price) as pomance from books where genre='DETECTIVE' order by price limit 1),(select concat(genre,' ', price) as pomance from books where genre='ROMANCE' order by price limit 1) from books limit 1 ;

--14--
select (select concat(genre,' ', count(genre='BIOGRAPHY')) from books where genre='BIOGRAPHY' group by genre ),(select concat(genre,' ', count(genre='HISTORY')) from books where genre='HISTORY' group by genre) from books limit 1;

--15--
select b.name,p.name, l.language from books b join publishers p on b.publisher_id=p.id join languages l on b.language_id=l.id;

--16--
select p.name, a.* from books b join publishers p on b.publisher_id=p.id right join authors a on b.author_id=a.id;

--17--
select a.first_name, a.last_name, b.name from books b right join authors a on b.author_id=a.id;

--18--
select l.language, count(b.name) from books b  join languages l on b.language_id=l.id group by l.language order by count(b.name);

--19--
select  p.name,  b.publisher_id, round(avg(b.price))  from books b join publishers p on b.publisher_id=p.id group by p.name,  b.publisher_id;

--20--
select b.name, a.first_name,a.last_name,b.published_year  from books b join authors a on b.author_id=a.id where b.published_year between '2010-01-01' and '2015-12-31';


--21--
select a.first_name,a.last_name, sum(b.price) from books b join authors a on b.author_id=a.id where b.published_year between '2010-01-01' and '2015-12-31' group by a.first_name,a.last_name;






















































create table if not exists devices
(
    id             serial primary key,
    device_name    varchar,
    device_company varchar,
    price          numeric,
    date_of_issue  date
);

create table if not exists customer
(
    id   serial primary key,
    name varchar
);
create table if not exists basket
(
    id            serial primary key,
    device_id     int references devices (id),
    customer_id   int references customer (id),
    date_of_issue date
    );
alter table basket
    add column price varchar;

insert into devices(device_name, device_company, price, date_of_issue)
VALUES ('Iphone', 'Apple', 10000, '1-2-2023'),
       ('Samsung 123', 'Samsung', 105000, '2-2-2023'),
       ('Iphone 14 ', 'Apple', 150000, '1-6-2023'),
       ('Redmi 10', 'Xiaomi', 1000, '1-7-2023'),
       ('Iphone 12 mini', 'Apple', 12000, '1-4-2023'),
       ('Samsung a 51', 'Samsung', 110000, '1-9-2023');

insert into customer(name)
values ('Zhanuzak'),
       ('Daniel'),
       ('Eldan');

insert into basket(device_id, customer_id,price, date_of_issue)
VALUES (
           (select id from devices where device_name='Iphone 12 mini'),
           (select id from customer where name='Daniel'),
           (select id from devices where devices.price=12000),
           '1-4-2023'
       ),
       (
           (select id from devices where device_company='Iphone'),
           (select id from customer where name='Eldan'),
           (select id from devices where devices.price=1000),
           '1-9-2023'
       );

select * from basket where price=(select id from devices where devices.price=1000);


create type DeviceType as enum('PHONE','LAPTOP', 'TABLET');

alter table devices add column device_type DeviceType;

update devices set device_type='PHONE' where id=1;

update devices set device_type='PHONE' where id in(2,2,5);

-----------------------------------------------------------
-----------------------------------------------------------
-----------------------------------------------------------

create table if not exists publishers(
                                         id             serial primary key,
                                         name varchar
);
drop table publishers cascade ;
create table if not exists authors(
                                      id             serial primary key,
                                      first_name varchar,
                                      last_name varchar,
                                      email varchar,
                                      date_of_birth date,
                                      country varchar,
                                      gender Gender
);
drop table authors cascade ;
create type Genre  as enum('DETECTIVE','DRAMA','HISTORY','ROMANCE','BIOGRAPHY','FANTASY');

create type Gender as enum('Male','Female');

create table books (
                       id serial primary key ,
                       name varchar,
                       country varchar,
                       published_year date,
                       price numeric,
                       genre Genre
);
drop table books;


create table languages(
                          id serial primary key ,
                          language varchar
);
drop table languages;


--Not null кошуу учун
alter table languages alter column language set not null;


--unique кошуу учун
alter table authors add constraint uk_authors_email unique (email);

alter table books add column author_id int references authors(id);
alter table books add column publisher_id int references publishers(id);
alter table books add column language_id int references languages(id);
alter table books drop column author_id;
alter table books drop column publisher_id;

insert into publishers(name)
values ('RELX Group'),
       ('Thomson Reuters'),
       ('Holtzbrinck Publishing Group'),
       ('Shanghai Jiao Tong University Press'),
       ('Wolters Kluwer'),
       ('Hachette Livre'),
       ('Aufbau-Verlag'),
       ('Macmillan'),
       ('Harper Collins'),
       ('China Publishing Group'),
       ('Springer Nature'),
       ('Grupo Planeta'),
       ('Books.Ru Ltd.St Petersburg'),
       ('The Moscow Times'),
       ('Zhonghua Book Company');

insert into authors(first_name, last_name, email, date_of_birth, country, gender)
values ('Sybilla', 'Toderbrugge', 'stoderbrugge0@jugem.jp', '9/10/1968', 'France', 'Female'),
       ('Patti', 'Walster', 'pwalster1@addtoany.com', '10/11/1965', 'China', 'Female'),
       ('Sonnie', 'Emmens', 'semmens2@upenn.edu', '5/6/1980', 'Germany', 'Male'),
       ('Brand', 'Burel', 'bburel3@ovh.net', '4/4/1964', 'United States', 'Male'),
       ('Silvan', 'Smartman', 'ssmartman4@spiegel.de', '7/3/1967', 'France', 'Male'),
       ('Alexey', 'Arnov', 'larnoldi5@writer.com', '12/2/1964', 'Russia', 'Male'),
       ('Bunni', 'Aggio', 'baggio6@yahoo.co.jp', '12/11/1983', 'China', 'Female'),
       ('Viole', 'Sarath', 'vsarath7@elegantthemes.com', '1/9/1960', 'United States', 'Female'),
       ('Boigie', 'Etridge', 'betridge8@ed.gov', '11/7/1978', 'France', 'Male'),
       ('Hilliard', 'Burnsyde', 'hburnsyde9@omniture.com', '9/8/1962', 'Germany', 'Male'),
       ('Margarita', 'Bartova', 'mbartova@example.com', '12/3/1984', 'Russia', 'Female'),
       ('Innis', 'Hugh', 'ihughb@marriott.com', '8/8/1983', 'Germany', 'Male'),
       ('Lera', 'Trimnella', 'ltrimnellc@msn.com', '3/8/1980', 'Russia', 'Female'),
       ('Jakob', 'Bransby', 'jbransbyd@nasa.gov', '8/5/1966', 'Spain', 'Male'),
       ('Loretta', 'Gronaver', 'lgronavere@technorati.com', '10/7/1962', 'United States', 'Female');

insert into languages(language)
values ('English'),
       ('French'),
       ('German'),
       ('Chinese'),
       ('Russian'),
       ('Spanish');

insert into books(name, country, published_year, price, genre, language_id, publisher_id, author_id)
values ('Taina', 'Russia', '11/12/2021', '568', 'DETECTIVE', '5', '12', '6'),
       ('Zvezdopad', 'Russia', '12/9/2004', '446', 'ROMANCE', '5', '13', '11'),
       ('Homo Faber', 'Germany', '4/10/2022', '772', 'FANTASY', '3', '5', '3'),
       ('Der Richter und Sein Henker', 'Germany', '2/1/2011', '780', 'DETECTIVE', '3', '3', '10'),
       ('Lord of the Flies', 'United States', '7/11/2015', '900', 'FANTASY', '1', '2', '4'),
       ('Un soir au club', 'France', '1/12/2018', '480', 'DRAMA', '2', '1', '1'),
       ('Voina', 'Russia', '12/6/2004', '880', 'HISTORY', '5', '4', '13'),
       ('Sun Tzu', 'China', '9/5/2022', '349', 'HISTORY', '4', '4', '2'),
       ('Emil und die Detektive', 'Germany', '6/11/2010', '228', 'DETECTIVE', '3', '5', '10'),
       ('Coule la Seine', 'France', '3/1/2015', '732', 'FANTASY', '2', '6', '1'),
       ('Love and hatred', 'Russia', '2/3/2012', '763', 'ROMANCE', '5', '14', '13'),
       ('Fantastic Mr Fox', 'United States', '3/10/2018', '309', 'FANTASY', '1', '9', '8'),
       ('Contes de la Bécasse', 'France', '10/5/2019', '378', 'ROMANCE', '2', '6', '9'),
       ('“The Death of Ivan Ilyich', 'Russia', '9/4/2000', '814', 'DRAMA', '5', '6', '6'),
       ('Bonjour Tristesse', 'France', '8/2/2015', '502', 'ROMANCE', '2', '8', '5'),
       ('Die Verwandlung', 'Germany', '6/9/2008', '305', 'DETECTIVE', '3', '7', '12'),
       ('The Inspector Barlach Mysteries', 'Germany', '3/10/2007', '566', 'DETECTIVE', '3', '3', '3'),
       ('LÉtranger', 'France', '11/4/2017', '422', 'ROMANCE', '2', '8', '5'),
       ('Lao Tse', 'China', '7/6/2005', '900', 'FANTASY', '4', '4', '2'),
       ('Semya', 'Russia', '4/12/2004', '194', 'DRAMA', '5', '13', '11'),
       ('Empty World', 'United States', '1/4/2008', '324', 'FANTASY', '1', '11', '15'),
       ('Domainer', 'Germany', '1/6/2020', '420', 'ROMANCE', '3', '5', '10'),
       ('The Fault in Our Stars', 'United States', '2/3/2008', '396', 'ROMANCE', '1', '9', '4'),
       ('Die R uber', 'Germany', '6/5/2020', '300', 'ROMANCE', '3', '7', '12'),
       ('Jung Chang', 'China', '5/4/2021', '600', 'HISTORY', '4', '10', '7'),
       ('Les Aventures de Tintin', 'France', '4/10/2015', '582', 'DRAMA', '2', '1', '5'),
       ('Unvollendete Geschichte', 'Germany', '12/12/2010', '269', 'DETECTIVE', '3', '5', '10'),
       ('Amy Tan', 'China', '1/9/2023', '486', 'DRAMA', '4', '4', '7'),
       ('Krasnaya luna', 'Russia', '2/7/2020', '550', 'FANTASY', '5', '12', '11'),
       ('Emma', 'United States', '10/11/2021', '599', 'BIOGRAPHY', '1', '2', '15');


