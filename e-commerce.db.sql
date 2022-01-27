--Find the most popular shipping method.
SELECT smt.name, COUNT(DISTINCT(ot.order_id)) as amount
FROM order_tab ot
LEFT JOIN shipping_methods_tab smt
	ON ot.shipping_method_id = smt.method_id
GROUP BY smt.name
ORDER BY amount DESC;

--Find the ratio of revenue generated in gmv_usd by Females to Males. Assign Predicted Male to Male and Predicted Female to Female.
SELECT gt.name, gt.gender_id, SUM(oit.gmv_usd) AS revenue
FROM order_item_tab oit
LEFT JOIN order_tab ot
	ON oit.order_id = ot.order_id
LEFT JOIN user_info_tab uit
	ON ot.user_id = uit.user_id
LEFT JOIN gender_tab gt
	ON uit.gender = gt.gender_id
GROUP BY gt.name
ORDER BY revenue DESC;
--Male revenue = 59829.8388999999 + 41391.53759999993 = 101221.3765
--Female revenue = 58354.51509999969+57819.2317999999 = 116173.7469
--Ratio of revenue = 116173.7469/101221.3765 = 1.14771949283

--Find the most popular item category in volume of items sold (i.e., SUM of sold).
SELECT ict.name, ict.category_id, SUM(oit.amount) as sum_sold
FROM order_item_tab oit
LEFT JOIN item_info_tab iit
	ON oit.item_id = iit.item_id
LEFT JOIN item_categories_tab ict
	ON iit.category_id = ict.category_id
GROUP BY ict.name
ORDER BY sum_sold DESC;

--Find the item category with the highest category revenue.
SELECT iit.category_id, ict.name, SUM(iit.price_usd * iit.sold) as cat_revenue
FROM item_info_tab iit
LEFT JOIN item_categories_tab ict
	ON iit.category_id = ict.category_id
GROUP BY iit.category_id
ORDER BY cat_revenue DESC;

--Find the most frequently used payment method for orders that have either been paid, shipped, or completed.
SELECT pmt.name, pmt.method_id, COUNT(DISTINCT(ot.order_id)) as orders
FROM order_tab ot
LEFT JOIN payment_methods_tab pmt
	ON ot.payment_method_id = pmt.method_id
LEFT JOIN order_status_tab ost
	ON ot.status = ost.status_id
WHERE ost.name IN ('Paid', 'Shipped', 'Completed')
GROUP BY pmt.method_id
ORDER BY orders DESC;

--Calculate the total transaction value of the most popular payment method (rounded to 2 decimal places) for orders that have either been paid, shipped, or completed.
SELECT pmt.name, pmt.method_id, SUM(oit.gmv_usd) as trans_value
FROM order_tab ot
LEFT JOIN order_item_tab oit
	ON ot.order_id = oit.order_id
LEFT JOIN order_status_tab ost
	ON ot.status = ost.status_id
LEFT JOIN payment_methods_tab pmt
	ON ot.payment_method_id = pmt.method_id
WHERE ost.name IN ('Paid', 'Shipped', 'Completed')
GROUP BY pmt.method_id
ORDER BY trans_value DESC;