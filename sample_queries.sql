--1.list of different price and category for particular show/event
SELECT 
    sp.category, 
    sp.price
FROM 
    Event e
JOIN Event_Schedule es ON e.event_id = es.event_id
JOIN Show_Pricing sp ON es.schedule_id = sp.schedule_id
WHERE 
    e.event_name = 'The Lost Treasure'
    AND es.event_datetime = '2025-05-01 10:00:00';

--2. Filter Events by Genre
SELECT 
    E.event_name, 
    E.event_genre, 
    ES.event_datetime, 
    V.venue_name, 
    RG.area
FROM 
    Event E
JOIN Event_Schedule ES ON E.event_id = ES.event_id
JOIN Room R ON ES.room_id = R.room_id
JOIN Venue V ON R.venue_id = V.venue_id
JOIN Region RG ON V.pincode = RG.pincode
WHERE 
    E.event_genre = 'Comedy';

-- 3. List top 5 most booked events (by total bookings)
SELECT e.event_name, COUNT(b.booking_id) AS total_bookings
FROM Booking b
JOIN Event_Schedule es ON b.schedule_id = es.schedule_id
JOIN Event e ON es.event_id = e.event_id
GROUP BY e.event_name
ORDER BY total_bookings DESC
LIMIT 5;

--4. top 3 manager by total revenue 
SELECT 
    a.account_id,
    a.username,
    CONCAT(a.firstname, ' ', a.surname) AS full_name,
    a.email,
    a.mobile_number,
    a.state,
    a.city,
    a.area,
    COUNT(b.booking_id) AS total_successful_bookings,
    SUM(pd.payment_amount) AS total_revenue
FROM Account a
JOIN Event_Schedule es ON a.account_id = es.manager_id
JOIN Booking b ON es.schedule_id = b.schedule_id
JOIN Payment_Details pd ON b.payment_id = pd.payment_id
WHERE pd.payment_status = 'Success'
GROUP BY a.account_id, a.username, a.firstname, a.surname, a.email, a.mobile_number, a.state, a.city, a.area
ORDER BY total_revenue DESC
LIMIT 3;

--5.how many seats are empty
SELECT 
    sp.category,
    sp.category_capacity - COALESCE(SUM(bs.seat_count), 0) AS available_seats
FROM 
    Event e
JOIN Event_Schedule es ON e.event_id = es.event_id
JOIN Show_Pricing sp ON es.schedule_id = sp.schedule_id
LEFT JOIN Booking b ON b.schedule_id = es.schedule_id
LEFT JOIN Booking_Show bs ON bs.booking_id = b.booking_id AND bs.catagory = sp.category
WHERE 
    e.event_name = 'The Lost Treasure'
    AND es.event_datetime = '2025-05-01 10:00:00'
GROUP BY sp.category, sp.category_capacity;

-- 6. Active users (who booked within last 30 days)
SELECT a.username, COUNT(b.booking_id) AS recent_bookings
FROM Account a
JOIN Booking b ON a.account_id = b.account_id
WHERE b.booking_time >= NOW() - INTERVAL '30 days'
GROUP BY a.username
ORDER BY recent_bookings DESC;

-- 7. Show seat utilization for each show (percentage)
SELECT e.event_name, es.event_datetime,
       ROUND((SUM(bs.seat_count)::decimal / SUM(sp.category_capacity)) * 100, 2) AS utilization_percent
FROM Event e
JOIN Event_Schedule es ON e.event_id = es.event_id
JOIN Show_Pricing sp ON es.schedule_id = sp.schedule_id
LEFT JOIN Booking_Show bs ON sp.schedule_id = bs.booking_id AND sp.category = bs.catagory
GROUP BY e.event_name, es.event_datetime
ORDER BY utilization_percent DESC;

-- 8. Events with the most notifications sent
SELECT e.event_name, COUNT(n.notification_id) AS notifications_sent
FROM Event e
JOIN Event_Schedule es ON e.event_id = es.event_id
JOIN Notification n ON es.schedule_id = n.schedule_id
GROUP BY e.event_name
ORDER BY notifications_sent DESC;

-- 9. Cities with the highest number of bookings
SELECT r.city, COUNT(b.booking_id) AS total_bookings
FROM Booking b
JOIN Account a ON b.account_id = a.account_id
JOIN Region r ON a.city = r.city AND a.state = r.state
GROUP BY r.city
ORDER BY total_bookings DESC;

-- 10. List bookings where coupons were not used despite being available
SELECT a.username, b.booking_id, e.event_name, pd.payment_amount
FROM Account a
JOIN Booking b ON a.account_id = b.account_id
JOIN Payment_Details pd ON b.payment_id = pd.payment_id
JOIN Event_Schedule es ON b.schedule_id = es.schedule_id
JOIN Event e ON es.event_id = e.event_id
WHERE a.account_id IN (
    SELECT account_id FROM Coupon WHERE redeemed_at IS NULL AND validity >= CURRENT_DATE
)
AND b.booking_time > (
    SELECT MIN(issued_at) FROM Coupon WHERE Coupon.account_id = a.account_id
);

-- 11. Users who referred others and have active coupons
SELECT a.username, COUNT(DISTINCT r.account_id) AS total_referred, COUNT(c.coupon_id) AS active_coupons
FROM Account a
LEFT JOIN Account r ON a.account_id = r.referred_by
LEFT JOIN Coupon c ON a.account_id = c.account_id AND c.redeemed_at IS NULL AND c.validity >= CURRENT_DATE
GROUP BY a.username
HAVING COUNT(DISTINCT r.account_id) > 0;

-- 12. Highest earning venue
SELECT v.venue_name, SUM(pd.payment_amount) AS total_earned
FROM Booking b
JOIN Payment_Details pd ON b.payment_id = pd.payment_id
JOIN Event_Schedule es ON b.schedule_id = es.schedule_id
JOIN Room ro ON es.room_id = ro.room_id
JOIN Venue v ON ro.venue_id = v.venue_id
GROUP BY v.venue_name
ORDER BY total_earned DESC
LIMIT 1;

-- 13. Find users who booked for the same event more than once
SELECT a.username, e.event_name, COUNT(*) AS booking_count
FROM Booking b
JOIN Account a ON b.account_id = a.account_id
JOIN Event_Schedule es ON b.schedule_id = es.schedule_id
JOIN Event e ON es.event_id = e.event_id
GROUP BY a.username, e.event_name
HAVING COUNT(*) > 1;

-- 14. Top referred user (who has brought the most people)
SELECT a.username, COUNT(*) AS referred_count
FROM Account a
JOIN Account r ON a.account_id = r.referred_by
GROUP BY a.username
ORDER BY referred_count DESC
LIMIT 1;

-- 15. Payment method popularity
SELECT payment_method, COUNT(*) AS total_transactions
FROM Payment_Details
GROUP BY payment_method
ORDER BY total_transactions DESC;

-- 16. Days with peak event schedules
SELECT DATE(event_datetime) AS event_date, COUNT(*) AS total_schedules
FROM Event_Schedule
GROUP BY DATE(event_datetime)
ORDER BY total_schedules DESC
LIMIT 5;

--17. Cities where a specific event (e.g., "Standup Night") is scheduled
SELECT DISTINCT r.city
FROM Event e
JOIN Event_Schedule es ON e.event_id = es.event_id
JOIN Room ro ON es.room_id = ro.room_id
JOIN Venue v ON ro.venue_id = v.venue_id
JOIN Region r ON v.pincode = r.pincode
WHERE e.event_name = 'Standup Night';

--18. State-wise revenue generated from bookings
SELECT r.state, SUM(pd.payment_amount) AS total_revenue
FROM Booking b
JOIN Payment_Details pd ON b.payment_id = pd.payment_id
JOIN Event_Schedule es ON b.schedule_id = es.schedule_id
JOIN Room ro ON es.room_id = ro.room_id
JOIN Venue v ON ro.venue_id = v.venue_id
JOIN Region r ON v.pincode = r.pincode
GROUP BY r.state
ORDER BY total_revenue DESC;

--19. Bookings Made by a Particular User
SELECT 
    B.booking_id, 
    E.event_name, 
    ES.event_datetime, 
    P.payment_amount
FROM 
    Booking B
JOIN Account A ON B.account_id = A.account_id
JOIN Event_Schedule ES ON B.schedule_id = ES.schedule_id
JOIN Event E ON ES.event_id = E.event_id
JOIN Payment_Details P ON B.payment_id = P.payment_id
WHERE 
    A.username = 'priya56';

-- 20. Revenue breakdown by category for a specific movie event
SELECT mp.catagory, SUM(mp.price) AS total_revenue
FROM Booking b
JOIN Booking_Movie bm ON b.booking_id = bm.booking_id
JOIN Movie_Pricing mp ON b.schedule_id = mp.schedule_id AND bm.catagory = mp.catagory
JOIN Event_Schedule es ON b.schedule_id = es.schedule_id
JOIN Event e ON es.event_id = e.event_id
WHERE e.event_name = 'The Lost Treasure'
GROUP BY mp.catagory;
