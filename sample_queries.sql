--1.list of different price and category for particular movie
SELECT 
    mp.category, 
    mp.price
FROM 
    Event e
JOIN Event_Schedule es ON e.event_id = es.event_id
JOIN Movie_Pricing mp ON es.schedule_id = mp.schedule_id
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

--4.how many seats are empty
SELECT 
    sp.category,
    sp.category_capacity - COALESCE(SUM(bs.seat_count), 0) AS available_seats
FROM 
    Event e
JOIN Event_Schedule es ON e.event_id = es.event_id
JOIN Show_Pricing sp ON es.schedule_id = sp.schedule_id
LEFT JOIN Booking b ON b.schedule_id = es.schedule_id
LEFT JOIN Booking_Show bs ON bs.booking_id = b.booking_id AND bs.category = sp.category
WHERE 
    e.event_name = 'The Lost Treasure'
    AND es.event_datetime = '2025-05-01 10:00:00'
GROUP BY sp.category, sp.category_capacity;
