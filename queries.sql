-- find user details for current account
SELECT 
    account_id, 
    name, 
    mobile_number, 
    dateofbirth, 
    role, 
    referral_code
FROM 
    Account
WHERE 
    account_id = 4; -- Example account_id for Priya Patel


-- find user recently booked tickets history for current account
SELECT 
    b.booking_id,
    e.event_name,
    v.venue_name,
    es.event_datetime,
    pd.payment_amount,
    ROUND((earth_distance(ll_to_earth(v.latitude, v.longitude), ll_to_earth(23.0225, 72.5714)) / 1000)::numeric, 2) AS distance_km
FROM Booking b
JOIN Event_Schedule es ON b.schedule_id = es.schedule_id
JOIN Event e ON es.event_id = e.event_id
JOIN Room r ON es.room_id = r.room_id
JOIN Venue v ON r.venue_id = v.venue_id
JOIN Payment_Details pd ON b.payment_id = pd.payment_id
WHERE 
    b.account_id = 4
    AND b.booking_status = 'Confirmed'
ORDER BY es.event_datetime DESC;


-- find coupon for current account
SELECT 
    c.coupon_id,
    cc.category_name,
    c.amount,
    c.validity,
    c.issued_at
FROM 
    Coupon c
JOIN 
    Coupon_Category cc ON c.coupon_category_id = cc.coupon_category_id
WHERE 
    c.account_id = 4
    AND c.redeemed_at IS NULL
    AND c.validity >= CURRENT_DATE;


-- Find nearest screenings for a specific movie, including ticket prices
SELECT 
    v.venue_name,
    es.event_datetime,
    mp.category, 
    mp.price,
    ROUND((earth_distance(ll_to_earth(v.latitude, v.longitude), ll_to_earth(23.0225, 72.5714)) / 1000)::numeric, 2) AS distance_km
FROM 
    Event e
JOIN Event_Schedule es ON e.event_id = es.event_id
JOIN Room r ON es.room_id = r.room_id
JOIN Venue v ON r.venue_id = v.venue_id
JOIN Movie_Pricing mp ON es.schedule_id = mp.schedule_id
WHERE 
    e.event_name = 'Gujarati Blockbuster'
ORDER BY 
    distance_km ASC;


-- Filter Events by Genre and sort by nearest venue
SELECT 
    E.event_name, 
    EG.genre, 
    ES.event_datetime, 
    V.venue_name, 
    ROUND((earth_distance(ll_to_earth(V.latitude, V.longitude), ll_to_earth(23.0225, 72.5714)) / 1000)::numeric, 2) AS distance_km
FROM 
    Event E
JOIN Event_Genre EG ON E.event_id = EG.event_id
JOIN Event_Schedule ES ON E.event_id = ES.event_id
JOIN Room R ON ES.room_id = R.room_id
JOIN Venue V ON R.venue_id = V.venue_id
WHERE 
    EG.genre = 'Comedy'
ORDER BY 
    distance_km ASC;


-- Search for Venues within a 15 KM radius of my location
SELECT 
    v.venue_name, 
    v.address, 
    rg.area,
    ROUND((earth_distance(ll_to_earth(v.latitude, v.longitude), ll_to_earth(23.0225, 72.5714)) / 1000)::numeric, 2) AS distance_km
FROM Venue v
JOIN Region rg ON v.region_id = rg.region_id
WHERE 
    earth_distance(ll_to_earth(v.latitude, v.longitude), ll_to_earth(23.0225, 72.5714)) < 15000 -- 15,000 meters
ORDER BY 
    distance_km ASC;


-- How many seats are empty for a Live Show for perticular room
SELECT 
    v.venue_name,
    sp.category,
    sp.category_capacity - COALESCE(SUM(bs.seat_count), 0) AS available_seats,
    ROUND((earth_distance(ll_to_earth(v.latitude, v.longitude), ll_to_earth(23.0225, 72.5714)) / 1000)::numeric, 2) AS distance_km
FROM 
    Event e
JOIN Event_Schedule es ON e.event_id = es.event_id
JOIN Room r ON es.room_id = r.room_id
JOIN Venue v ON r.venue_id = v.venue_id
JOIN Show_Pricing sp ON es.schedule_id = sp.schedule_id
LEFT JOIN Booking b ON b.schedule_id = es.schedule_id AND b.booking_status = 'Confirmed'
LEFT JOIN Booking_Show bs ON bs.booking_id = b.booking_id AND bs.category = sp.category
WHERE 
    e.event_name = 'Nikol Comedy Night'
GROUP BY 
    v.venue_name, v.latitude, v.longitude, sp.category, sp.category_capacity
ORDER BY 
    distance_km ASC;


-- howmany seats are not booked for movie for perticular room 
SELECT 
    s.seat_number,
    s.category,
    CASE WHEN bm.booking_id IS NULL THEN 'Available' ELSE 'Booked' END AS status
FROM 
    Event_Schedule es
JOIN Room r ON es.room_id = r.room_id
JOIN Seat s ON r.room_id = s.room_id
LEFT JOIN Booking b ON b.schedule_id = es.schedule_id AND b.booking_status = 'Confirmed'
LEFT JOIN Booking_Movie bm ON bm.booking_id = b.booking_id AND bm.seat_number = s.seat_number AND bm.room_id = r.room_id
WHERE 
    es.schedule_id = 1
ORDER BY 
    s.seat_row, s.seat_number;

-- Check total revenue generated for a specific event schedule (For Organizers)
SELECT 
    es.schedule_id,
    e.event_name,
    COALESCE(SUM(pd.payment_amount), 0) AS total_revenue
FROM Event_Schedule es
JOIN Event e ON es.event_id = e.event_id
LEFT JOIN Booking b ON b.schedule_id = es.schedule_id AND b.booking_status = 'Confirmed'
LEFT JOIN Payment_Details pd ON b.payment_id = pd.payment_id AND pd.payment_status = 'Completed'
WHERE 
    es.schedule_id = 1
GROUP BY 
    es.schedule_id, e.event_name;


-- List upcoming events in the next 30 days
SELECT 
    e.event_name, 
    es.event_datetime, 
    v.venue_name,
    ROUND((earth_distance(ll_to_earth(v.latitude, v.longitude), ll_to_earth(23.0225, 72.5714)) / 1000)::numeric, 2) AS distance_km
FROM Event e
JOIN Event_Schedule es ON e.event_id = es.event_id
JOIN Room r ON es.room_id = r.room_id
JOIN Venue v ON r.venue_id = v.venue_id
WHERE 
    es.event_datetime BETWEEN CURRENT_TIMESTAMP AND CURRENT_TIMESTAMP + INTERVAL '30 days'
    AND es.lifecycle_status = 'Scheduled'
ORDER BY 
    es.event_datetime ASC;
