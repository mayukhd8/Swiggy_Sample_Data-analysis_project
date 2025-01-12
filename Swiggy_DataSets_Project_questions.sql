select r_id , count(menu_id), sum(price) from menu
group by r_id
order by r_id

select type , count(f_name) from food
group by type

	''' Most Ordered Food Item '''
select count(o.f_id) , f.f_name from order_details o
join food f
on o.f_id = f.f_id
group by f.f_name
order by count(o.order_id) DESC

-- User With Highest Amount of orders total
select u.name ,count(order_id),sum(amount) from orders o
join users u on o.user_id = u.user_id
group by u.user_id
order by sum(amount) desc

select count(r_id ), (partner_id) from orders
group by  partner_id 

--------------------------------------------
	
SELECT sum(price) Total_price, count(f_name) total_items , f.type FROM menu m 
join food f
on f.f_id = m.f_id
group by f.type


--restaurants with total no of rating and the total sales highest to lowest 

select r_name , count(restaurant_rating) , sum(amount) from orders o
join restaurants r on r.r_id = o.r_id
group by r_name
order by count(restaurant_rating) DESC NULLS LAST

--delivery partner with Highest no of orders overall

select dp.partner_name , count(o.order_id) Total_delivery , sum(o.amount)
from orders o
join delivery_partner dp
on o.partner_id = dp.partner_id
group by dp.partner_name 
order by count(o.order_id) desc

-- User with total No of orders and not ordered 

select distinct users.name , count(orders.order_id) Total_orders from orders
right join users
on users.user_id = orders.user_id
group by users.name
order by count(orders.order_id) desc

-- delivery partners delivery time from fastest to loswest

SELECT r.r_name Restaurant_Name ,delivery_time ,d.partner_name FROM orders o 
join restaurants r 
on r.r_id = o.r_id
join delivery_partner d on d.partner_id = o.partner_id
where delivery_time < 50 
group by r.r_name  , delivery_time , d.partner_name
order by delivery_time
