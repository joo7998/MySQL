use sakila;

show full tables;

select count(*) from actor;
select * from actor limit 100;

-- 1a. Display the first and last names of all actors from the table actor. 
select first_name, last_name
from actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. 
--     Name the column Actor Name. 
select upper(concat(first_name,' ',last_name)) as 'Actor Name' from actor;

-- 2a. ID, first, last name of an actor, of whom you know only the first name, "Joe" ?
select actor_id, first_name, last_name 
from actor
where first_name = "Joe";

select count(*) from film_actor;
select * from film_actor;
select * from film_actor where actor_id = 23;

-- 2b. Find all actors whose last name contain the letters GEN:
select actor_id, first_name, last_name 
from actor 
where last_name like '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI.
--  	 order the rows by last name and first name, in that order:
select actor_id, first_name, last_name 
from actor
where last_name like '%LI%'
order by last_name, first_name;

select count(*) from city;
select * from city limit 30;
select * from city where city like 'S%';

select * from customer limit 30;
select last_name, first_name from customer where not store_id=2; 
select last_name, first_name from customer where address_id not in(5);
select customer_id, last_name, create_date from customer where last_name like '%TT%';

select count(*) from film;
select * from film limit 30;
select title, release_year,length from film where length>=120 OR length<=60;
select title, release_year, length from film where length in (90, 60, 120);
select title, release_year, length from film where length between 30 and 60;
select avg(length) from film;
select title, avg(length) from film group by title; 
select title, length, release_year from film order by length desc;

select count(*) from inventory;
select * from inventory limit 100;

select count(*) from language;
select * from language;
select count(*) from film where language_id=1;
select count(*) from film;

select count(*) from payment;
select * from payment limit 50;
select rental_id, amount from payment where amount>=10.99;
select payment_id, staff_id, rental_id, amount from payment where amount>=5.99 and staff_id=2;
select payment_id, staff_id, rental_id, amount from payment where staff_id is null;
select AVG(amount) from payment;

select * from store;

select count(*) from customer;

select * from payment limit 100;
select customer_id, sum(amount) from payment group by customer_id order by customer_id;

select customer_id as '고객 ID', sum(amount) as '총금액' from payment group by customer_id order by sum(amount) desc;

select * from customer limit 100;

select first_name, last_name, amount from customer, payment;

# inner join : 고객 id별 , 총 금액 
select customer.first_name, customer.last_name, sum(amount) from customer, payment 
where customer.customer_id=payment.customer_id
group by customer.first_name, customer.last_name 
order by sum(amount) desc;

# inner join / where=on 
select concat (concat(cs.first_name,' '), cs.last_name) as '고객명', sum(amount) as '총 금액' 
from payment pm join customer cs on pm.customer_id = cs.customer_id 
group by 고객명 
order by sum(amount) desc;

# 고객 ID별 총 대여수(asc)
select count(*) from rental;
select * from rental limit 50;
select customer_id, count(rental_id) from rental group by customer_id order by count(rental_id) desc;

# 확인
select count(*) from rental where customer_id=236;

# 고객 ID 대신, 고객 first & last name
select concat (concat(cs.first_name, ' '), cs.last_name) as '고객명', count(rental_id) as '총 대여수'
from rental rt 
join customer cs on rt.customer_id = cs.customer_id
group by 고객명
order by count(rental_id) desc;

# 액션 분야 영화의 속성들 - film_id, title, description, 분야(actoion) , release_year, language(language_id)
select count(*) from film;
select * from film limit 15;
select * from category limit 10;  # category_id=1  action 
select * from film_category limit 30; # film_id 별 category 

-- select film_id, title, description, category_id, release_year, language_id from film, category
-- where category_id=1 and language_id=1 ;

-- select film_category.film_id, category.category_id from category, film_category
-- where category.category_id=1;

select FL.film_id as 필름번호, FL.title as 제목, FL.description as 설명, CG.name as 분야, FL.release_year as 발매년도, LG.name as 언어
from film as FL 
join film_category as FC on FL.film_id = FC.film_id
join category as CG on FC.category_id = CG.category_id
join language as LG on FL.language_id = LG.language_id
where CG.name = 'action';
# join 순서 = 적은 데이터 먼저 (성능) 

# 출연작이 많은 순으로 배우의 firs,last name, 작품수
select * from film limit 50;
select * from actor limit 50;
select * from film_actor limit 50;

select concat (concat(A.first_name,' '), A.last_name) as '배우명', count(A.actor_id) as '작품수'
from actor as A 
join film_actor FA on A.actor_id = FA.actor_id
group by 배우명, A.actor_id
order by count(actor_id) desc;

# 확인
select count(*) from actor where actor_id=4;

# 예시 답
select A.actor_id, A.first_name, A.last_name, count(FA.film_id) as "작품수"
from film_actor FA join actor as A
on FA.actor_id = A.actor_id
group by A.actor_id, A.first_name, A.last_name
#order by A.first_name, A.last_name;    # 동명이인 찾기 (susan davis)
order by count(FA.film_id) desc;

# mary keitel 의 출여작을 영화제목 오름차순으로 출력 - fisrt_name, last_name, 영화제목, 출시년, 대여 비용 
select AC.first_name, AC.last_name, FL.title, FL.release_year, FL.rental_rate
from actor AC 
join film_actor FA on AC.actor_id = FA.actor_id
join film FL on FA.film_id = FL.film_id
where AC.first_name = 'MARY' and AC.last_name = 'KEITEL'
order by FL.title;

# 배우의 R등급 영화 작품 수 카운트, 가장 많은 작품수를 가지는 배우부터 출력 - actor_id, first_name, last_name, R등급 작품수 
select A.actor_id, A.first_name, A.last_name, count(F.title)
from actor A
join film_actor FA on A.actor_id = FA.actor_id
join film F on FA.film_id = F.film_id
where F.rating ='R'
group by A.actor_id, A.first_name, A.last_name
order by count(F.title) desc;

# R 등급 출현한 적 없는 배우 first, last name, 출연영화 제목, 출시년 

# 정답 x 
-- select A.actor_id, A.first_name, A.last_name, F.title, F.release_year
-- from actor A
-- join film_actor FA on A.actor_id = FA.actor_id
-- join film F on FA.film_id = F.film_id
-- where F.rating !='R'
-- group by A.actor_id, A.first_name, A.last_name, F.title, F.release_year
-- order by A.actor_id desc;

select AC.first_name, AC.last_name, FL.title, FL.release_year
from film FL 
join film_actor FA on FL.film_id = FA.film_id
join actor AC on AC.actor_id = FA.actor_id
where AC.actor_id not in 
						(select FA.actor_id 
                        from film FL 
                        join film_actor FA 
                        on FL.film_id = FA.film_id 
                        where rating = 'R')
order by FL.release_year;

-- 10. Agent Trueman 을 가지고 있는 매장 정보 출력 
-- 영화제목, 매장id, 매장 staff name_name & last_name, 매장 address, address2, district, city, country, 해당영화 보유수량 count(I.film_id)
select * from inventory limit 50;

select FL.title, ST.store_id, SF.first_name, SF.last_name, AD.address, AD.address2, AD.district, CT.city, CU.country, count(FL.title) as "보유수량"
from film FL 
join inventory IV on FL.film_id = IV.film_id
join store ST on IV.store_id = ST.store_id
join staff SF on ST.store_id = SF.store_id
join address AD on ST.address_id = AD.address_id
join city CT on AD.city_id = CT.city_id
join country CU on CT.country_id = CU.country_id
where FL.title = 'AGENT TRUMAN'
group by FL.title, ST.store_id, SF.first_name, SF.last_name, AD.address, AD.address2, AD.district, CT.city, CU.country;

-- 11. Agent Trueman 을 가지고 있는 매장 정보 & 해당 타이틀 대여 정보 (없으면 null) 출력 
-- 영화제목, 매장id, 매장 staff name_name & last_name, 매장 address, address2, district, city, country, 
-- 대여일자, 회수일자, 대여 고객 first & last name 
select FL.title, ST.store_id, IV.inventory_id, AD.address, AD.address2, AD.district, CT.city, CU.country, RT.rental_date, RT.return_date, CS.first_name, CS.last_name
from film FL 
join inventory IV on FL.film_id = IV.film_id
join store ST on IV.store_id = ST.store_id
join address AD on ST.address_id = AD.address_id
join city CT on AD.city_id = CT.city_id
join country CU on CT.country_id = CU.country_id

left join rental RT on IV.inventory_id = RT.inventory_id
join customer CS on RT.customer_id = CS.customer_id
where FL.title = 'AGENT TRUMAN';

-- 12. 대여된 영화 타이틀, 대여 회수 (내림차)  
-- 						SUM, COUNT 
select FL.title, sum(rental_info.rental_cnt)
from inventory IV join (select inventory_id, count(rental_id) as rental_cnt
						from rental
						group by inventory_id) as rental_info
on IV.inventory_id = rental_info.inventory_id 
join film FL on FL.film_id = IV.film_id
group by FL.title
order by sum(rental_info.rental_cnt) desc;

-- 13. 고객의 지불정보 = 내림차, 고객 first name, last name, 총지불금액, 고객의 주소, address2, disctrict, city, country 
select CUS.first_name, CUS.last_name, sum(P.amount) as '총지불금액', AD.address, AD.address2, AD.district, CY.city, CT.country
from customer CUS 
join address AD on CUS.customer_id = AD.address_id 
join city CY on AD.city_id = CY.city_id
join country CT on CY.country_id = CT.country_id
left join payment P on CUS.customer_id = P.customer_id
group by CUS.customer_id
		-- 	NOT	 CUS.first_name, CUS.last_name, AD.address, AD.address2, AD.district, CY.city, CT.country
order by sum(P.amount) desc;

-- 14. (CASE) 총 지불 금액(많은순서로) 별 고객등급 출력  
-- 		고객 first,last name, 총지불금액(많은순서로), 등급 ('A'>=200  100<='B'<200  100>'C')		
select CUS.first_name, CUS.last_name, sum(P.amount) as '총지불금액', 
	case 
		when sum(P.amount) >= 200 then 'A'
		when 100 <= sum(P.amount) < 200 then 'B'
		else 'C'
	end as '등급'
from customer CUS
join payment P on CUS.customer_id = P.customer_id
group by CUS.first_name, CUS.last_name
order by sum(P.amount) desc;

-- 15. (CASE) DVD 대여 후 아직 반납하지 않은 고객정보 출력 
-- 		title, inventory_id, store_id, CUS.first_name, last_name, 대여일자, 고객등급
-- 		select * from rental where return_date is null; (NULL)
select FL.title, IV.inventory_id, IV.store_id, CS.first_name, CS.last_name, RT.rental_date, 
case 
	when (sum(PM.amount) >= 200) then 'A'
	when (sum(PM.amount) >= 100) then 'B'
	else 'C' 
end as '등급'
from rental RT 
join customer CS on RT.customer_id = CS.customer_id
join inventory IV on RT.inventory_id = IV.inventory_id
join film FL on IV.film_id = FL.film_id
join store ST on IV.store_id = ST.store_id
join payment PM on CS.customer_id = PM.customer_id
where RT.return_date is null
group by FL.title, IV.inventory_id, IV.store_id, CS.first_name, CS.last_name, RT.rental_date;

-- 16. 2005-08-01 ~ 2005-08-15 Canada(country) Alberta(disctrict) 에서 
-- 		대여일, F.title, inventory_id, store_id, 매장 주소 AD.address, AD.address2, AD.district, CY.city, CT.country
select RT.rental_date, FL.title, IV.inventory_id, IV.store_id, AD.address, AD.address2, AD.district, CT.city, CU.country
from rental RT 
join inventory IV on RT.inventory_id = IV.inventory_id
join store ST on IV.store_id = ST.store_id
join address AD on ST.address_id = AD.address_id
join city CT on AD.city_id = CT.city_id
join country CU on CT.country_id = CU.country_id
join film FL on IV.film_id = FL.film_id
where rental_date between '2005-08-01' and '2005-08-15'
		and AD.district = 'Alberta'
		and CU.country = 'Canada';

-- 17. 도시별 horror 영화 대여정보 = 도시명(오름차), 대여수(내림차) 
select CT.city, count(FL.title)
from film FL 
join film_category FC on FL.film_id = FC.film_id
join category CG on FC.category_id = CG.category_id
join inventory IV on FL.film_id = IV.film_id
join rental RT on IV.inventory_id = RT.inventory_id
join customer CS on RT.customer_id = CS.customer_id
join address AD on CS.address_id = AD.address_id
join city CT on AD.city_id = CT.city_id
join country CU on CT.country_id = CU.country_id
where CG.name = 'Horror'
group by CT.city
order by count(FL.title) desc, CT.city;

-- 18. 각 store id 별 총 대여 금액 
select ST.store_id, sum(amount)
from rental RT 
join payment PM on RT.rental_id = PM.rental_id
join inventory IV on RT.inventory_id = IV.inventory_id
join store ST on IV.store_id = ST.store_id
group by ST.store_id;

-- 19. 대여된 영화 중 대여기간이 연체된 건을 조회
-- F.title IV.inventory_id, rental_date, return_date, 기준대여기간, 실제대여기간
-- 아직 반납이 되지 않은 경우 : 실제대여기간 칼럼에 unknown 
select FL.title, IV.inventory_id, RT.rental_date, RT.return_date, FL.rental_duration as '기준 대여기간'
		, IFNULL(DATEDIFF(RT.return_date, RT.rental_date), 'Unknown') as '실제 대여기간'
from rental RT 
join inventory IV on RT.inventory_id = IV.inventory_id
join film FL on IV.film_id = FL.film_id
where DATEDIFF(IFNULL(RT.return_date, curdate()), RT.rental_date) > FL.rental_duration;
				# ifnull(RT.return_date, curdate())
                # if RT.return_date 가 null => curdate를 써라 
                # datediff(a,b) = a-b


#select * from rental limit 5;
#select * from film limit 10;