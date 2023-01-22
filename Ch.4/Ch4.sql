-- 4.2 JOIN

SELECT *
	FROM users u INNER JOIN orders o ON u.id = o.user_id
	ORDER BY u.id asc 
	;

SELECT *
	FROM users u LEFT JOIN orders o ON u.id = o.user_id
	;


SELECT u.id, u.username, u.country, o.id, o.user_id, o.order_date 
	FROM users u LEFT JOIN orders o ON u.id = o.user_id
	;

SELECT *
	FROM users u LEFT JOIN orders o ON u.id = o.user_id
	WHERE o.id is null
	;

SELECT *
	FROM users u RIGHT JOIN orders o ON u.id = o.user_id
	;

SELECT *
	FROM users u CROSS JOIN orders o 
	order by u.id asc
	;

# ------- 4.2 연습문제   


SELECT u.id, u.username, u.city, u.country, s.last_name, s.first_name 
	FROM
		users u 
	LEFT JOIN ## INNER JOIN 사용가능  
		staff s
	ON u.id = s.user_id 
	;

SELECT s.id, s.last_name, o.id,  o.user_id, o.order_date 
	FROM 
	    staff s
	LEFT JOIN
	    orders o 
	ON s.id = o.staff_id
	WHERE s.id in (3, 5)
	;

## OR

SELECT s.id, s.last_name, o.id,  o.user_id, o.order_date 
	FROM 
	    staff s
	INNER JOIN
	    orders o 
	ON s.id = o.staff_id
	WHERE s.id in (3, 5)
	;


# Q#. 회원 국가별 주문건수를 내림차순으로 출력해주세요.
SELECT u.country, count(distinct o.id) as ordCnt
	FROM 
		users u
	LEFT JOIN
		orders o 
	ON u.id = o.user_id
	GROUP BY u.country
	ORDER BY ordCnt desc 
	;	

SELECT 
  o.user_id
  , SUM(price * quantity) as sumPrice
  , SUM(discount_price * quantity) as sumDiscountPrice
    FROM 
        orders o 
    LEFT JOIN 
        orderdetails od 
    ON o.id = od.order_id 
    INNER JOIN 
        products p 
    ON od.product_id = p.id
    GROUP BY o.user_id
    ORDER BY sumPrice desc
    ;
	;
		

   # -------- # -------- # -------- # -------- # -------- # -------- # -------- # --------

-- 4.3  UNION

(
    SELECT *
        FROM users
)
UNION
(
    SELECT *
        FROM users

)
ORDER BY id asc


(
    SELECT *
        FROM users
)
UNION ALL
(
    SELECT *
        FROM users
)
ORDER BY id asc



(
    SELECT id, phone, city, country
        FROM users
)
UNION ALL
(
    SELECT id, phone, city, country
        FROM users
)
ORDER BY id asc


(
    SELECT id, phone, city, country
        FROM users
        WHERE country = 'Mexico'
)
UNION ALL
(
    SELECT id, phone, city, country
        FROM users
        WHERE country = 'Korea'
)
ORDER BY country asc
    


# ------- 4.3 연습문제   

(
    SELECT *
        FROM  orders
        WHERE  order_date >= '2015-10-01' AND order_date < '2015-11-01'
)
UNION ALL 
(
    SELECT *
        FROM  orders
        WHERE  order_date >= '2015-12-01' AND order_date < '2016-01-01'
)
ORDER BY order_date desc	


#Q

select *
	from users

(
    SELECT id, phone, city, country, is_marketing_agree
        FROM users
        WHERE country = 'USA' AND is_marketing_agree = 1
)
UNION ALL
(
    SELECT id, phone, city, country, is_marketing_agree
        FROM users
        WHERE country = 'France' AND is_marketing_agree = 0
)
ORDER BY country asc

#Q

select *
	from orderdetails
	
select *
	from products p 

(
    SELECT *
        FROM 
            orderdetails o
        LEFT JOIN
            products p 
        ON o.product_id = p.id 
)
UNION 
(
    SELECT *
        FROM 
            orderdetails o
        RIGHT JOIN
            products p 
        ON o.product_id = p.id 
)
	


   # -------- # -------- # -------- # -------- # -------- # -------- # -------- # --------

-- 4.4SUB QUERY

SELECT count(*) as cnt, max(id)
    FROM users
    
## 스칼라 서브쿼
SELECT *, (select count(*) as cnt from users) as totalUserCnt
    FROM users
    ;
-- 오답 예시 select *, count(*) as cnt

SELECT *, 77 as totalUserCnt
    FROM users
    ;   

## 인라인뷰
SELECT *
    FROM
    (
        SELECT city, count(distinct id) as cntUser
            FROM users
            GROUP BY city
    ) a
    WHERE cntUser >= 3
    ORDER BY cntUser desc
    ;
        
SELECT *
    FROM orders
    WHERE staff_id in (
                        SELECT id
                            FROM staff
                            WHERE id in (3, 5)
    )   
  
SELECT *
    FROM orders
    WHERE (staff_id, user_id) in (
                        SELECT id, user_id
                            FROM staff
                            WHERE id in (3, 5)
    )
    
SELECT *
    FROM
    (
        SELECT *
            FROM orders
            WHERE order_date >= '2015-07-01' and order_date < '2015-08-01'    
    ) o
    INNER JOIN
    (
        SELECT *
            FROM orderdetails
            WHERE quantity >= 50 
    ) od
    ON o.id = od.order_id

    
  
# ------- 4.4 연습문제     

SELECT *, round(discount_price / (select max(discount_price) from products), 3) as ratioPerMaxPrc
    FROM products
	;

SELECT u.id, u.phone, u.country, s.id, s.last_name, s.first_name
    FROM
    (
        SELECT *
            FROM users
            WHERE country in ('Korea', 'Italy')
    ) u
    INNER JOIN
    (
        SELECT *
            FROM staff
            WHERE birth_date < '1990-01-01'
    ) s
    ON u.id = s.user_id
    ;
    
SELECT *
    FROM
    (
        SELECT country, count(distinct id) as cntUser
            FROM users
            GROUP BY country
    ) a
    WHERE cntUser >= 5
    ORDER BY cntUser desc
    ;

   
SELECT *
    FROM products
    WHERE price IN (
                    SELECT min(price) 
                        FROM products
        )
    ;
   
SELECT *
    FROM users
    WHERE id IN (
                    SELECT user_id
                        FROM orders
                        WHERE order_date BETWEEN '2016-01-01' and '2016-12-31'    
        )
   ;
   
    