SET search_path TO ShowNexus;

-- 1. Account (10 accounts: 6 Users, 2 Organizers, 2 Owners)
INSERT INTO Account (account_id, name, password, mobile_number, dateofbirth, role, referral_code, referred_by)
OVERRIDING SYSTEM VALUE VALUES 
(1, 'John Doe', 'hashed_pw_1', '9876543210', '1990-01-01', 'USER', 'JOHNDOE', NULL),
(2, 'Alice Organizer', 'hashed_pw_2', '8765432109', '1985-05-15', 'ORGANIZER', 'ALICEORG', 1),
(3, 'Bob Owner', 'hashed_pw_3', '7654321098', '1980-08-20', 'OWNER', 'BOBOWNER', NULL),
(4, 'Priya Patel', 'hashed_pw_4', '9123456789', '1995-10-12', 'USER', 'PRIYA95', 1),
(5, 'Rahul Sharma', 'hashed_pw_5', '9988776655', '1992-11-22', 'USER', 'RAHUL92', 4),
(6, 'Amit Shah', 'hashed_pw_6', '9871234560', '1988-02-14', 'USER', 'AMIT88', NULL),
(7, 'Sneha Desai', 'hashed_pw_7', '8761234567', '1998-07-30', 'USER', 'SNEHA98', 4),
(8, 'Vikram Singh', 'hashed_pw_8', '7651234568', '1991-04-18', 'USER', 'VIKRAM91', NULL),
(9, 'Neha Organizer', 'hashed_pw_9', '9998887776', '1987-12-05', 'ORGANIZER', 'NEHAORG', NULL),
(10, 'Karan Owner', 'hashed_pw_10', '8887776665', '1983-09-25', 'OWNER', 'KARANOWN', NULL);

-- 2. Coupon Category
INSERT INTO Coupon_Category (coupon_category_id, category_name, description)
OVERRIDING SYSTEM VALUE VALUES
(1, 'Welcome', 'Welcome bonus for new users'),
(2, 'Festival', 'Festival special discount'),
(3, 'Weekend', 'Special weekend offer'),
(4, 'Student', 'Discount for college students');

-- 3. Coupon
INSERT INTO Coupon (coupon_id, account_id, coupon_category_id, amount, validity, issued_at, redeemed_at)
OVERRIDING SYSTEM VALUE VALUES
(1, 1, 1, 50.00, '2026-12-31', CURRENT_TIMESTAMP, NULL),
(2, 4, 1, 50.00, '2026-12-31', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(3, 5, 2, 100.00, '2026-10-31', CURRENT_TIMESTAMP, NULL),
(4, 6, 3, 20.00, '2026-08-31', CURRENT_TIMESTAMP, NULL),
(5, 7, 4, 150.00, '2026-12-31', CURRENT_TIMESTAMP, NULL);

-- Genre
INSERT INTO Genre (genre) VALUES
('Action'), ('Comedy'), ('Drama'), ('Music'), ('Standup'), ('Sci-Fi'), ('Thriller'), ('Romance'), ('Horror');

-- Language
INSERT INTO Language (language) VALUES
('Gujarati'), ('Hindi'), ('English'), ('Tamil'), ('Telugu');

-- 4. Event (10 Events)
INSERT INTO Event (event_id, event_name, event_description, poster_link, trailer_link, duration, age_restriction)
OVERRIDING SYSTEM VALUE VALUES
(1, 'Gujarati Blockbuster', 'A family drama movie in Gujarati.', 'http://poster/1', 'http://trailer/1', '2 hours 30 minutes', 0),
(2, 'Nikol Comedy Night', 'Live standup comedy show in Nikol.', 'http://poster/2', 'http://trailer/2', '1 hour 45 minutes', 16),
(3, 'Sci-Fi Epic', 'Mind-bending space exploration movie.', 'http://poster/3', 'http://trailer/3', '3 hours', 13),
(4, 'Bollywood Romance', 'A classic love story.', 'http://poster/4', 'http://trailer/4', '2 hours 15 minutes', 0),
(5, 'Rock Concert', 'Live music performance by popular band.', 'http://poster/5', 'http://trailer/5', '4 hours', 18),
(6, 'Horror Nights', 'Terrifying supernatural thriller.', 'http://poster/6', 'http://trailer/6', '1 hour 50 minutes', 18),
(7, 'Gujarati Natak', 'A hilarious stage play.', 'http://poster/7', 'http://trailer/7', '2 hours', 0),
(8, 'Action Thriller 3', 'High octane car chases and explosions.', 'http://poster/8', 'http://trailer/8', '2 hours 10 minutes', 16),
(9, 'Indie Music Fest', 'Showcasing upcoming indie artists.', 'http://poster/9', 'http://trailer/9', '5 hours', 16),
(10, 'Magic Show', 'Illusion and magic for the whole family.', 'http://poster/10', 'http://trailer/10', '1 hour 30 minutes', 0);

-- Event_Language
INSERT INTO Event_Language (event_id, language) VALUES
(1, 'Gujarati'), (1, 'Hindi'), (2, 'Gujarati'), (2, 'Hindi'),
(3, 'English'), (3, 'Hindi'), (4, 'Hindi'), (5, 'English'),
(6, 'English'), (7, 'Gujarati'), (8, 'Hindi'), (8, 'Tamil'),
(9, 'Hindi'), (9, 'English'), (10, 'English'), (10, 'Gujarati');

-- Event_Genre
INSERT INTO Event_Genre (event_id, genre) VALUES
(1, 'Drama'), (2, 'Comedy'), (2, 'Standup'), (3, 'Sci-Fi'),
(4, 'Romance'), (4, 'Drama'), (5, 'Music'), (6, 'Horror'),
(6, 'Thriller'), (7, 'Comedy'), (8, 'Action'), (8, 'Thriller'),
(9, 'Music'), (10, 'Comedy');

-- Movie_Event (Events 1, 3, 4, 6, 8)
INSERT INTO Movie_Event (event_id, imdb_rating, release_date) VALUES
(1, 8.5, '2026-08-15'),
(3, 9.1, '2026-07-20'),
(4, 7.2, '2026-08-01'),
(6, 6.8, '2026-08-10'),
(8, 8.0, '2026-09-05');

-- Show_Event (Events 2, 5, 7, 9, 10)
INSERT INTO Show_Event (event_id, organizer_id, audience_interaction) VALUES
(2, 2, TRUE), (5, 9, TRUE), (7, 2, FALSE), (9, 9, TRUE), (10, 2, TRUE);

-- Artist
INSERT INTO Artist (artist_id, artist_name)
OVERRIDING SYSTEM VALUE VALUES
(1, 'Malhar Thakar'), (2, 'Zakir Khan'), (3, 'Arijit Singh'), 
(4, 'Siddharth Randeria'), (5, 'Darshan Raval'), (6, 'Amit Tandon'),
(7, 'Nolan Director'), (8, 'Shahrukh Khan'), (9, 'Suhani Shah'), (10, 'Local Indie Band');

-- Show_Performers
INSERT INTO Show_Performers (artist_id, event_id) VALUES
(2, 2), (6, 2), (3, 5), (5, 5), (4, 7), (10, 9), (9, 10);

-- Region (Gujarat, near Ahmedabad)
INSERT INTO Region (region_id, pincode, city, state, area)
OVERRIDING SYSTEM VALUE VALUES
(1, 382350, 'Ahmedabad', 'Gujarat', 'Nikol'),
(2, 380038, 'Ahmedabad', 'Gujarat', 'Bapunagar'),
(3, 382330, 'Ahmedabad', 'Gujarat', 'Naroda'),
(4, 380054, 'Ahmedabad', 'Gujarat', 'SG Highway'),
(5, 380015, 'Ahmedabad', 'Gujarat', 'Vastrapur'),
(6, 380060, 'Ahmedabad', 'Gujarat', 'Science City'),
(7, 382481, 'Ahmedabad', 'Gujarat', 'Gota'),
(8, 380008, 'Ahmedabad', 'Gujarat', 'Maninagar'),
(9, 382007, 'Gandhinagar', 'Gujarat', 'Infocity'),
(10, 382011, 'Gandhinagar', 'Gujarat', 'Sector 11'),
(11, 382421, 'Gandhinagar', 'Gujarat', 'Sargasan');

-- Venue (11 Venues)
INSERT INTO Venue (venue_id, venue_name, owner_id, region_id, address, latitude, longitude)
OVERRIDING SYSTEM VALUE VALUES
(1, 'PVR Nikol', 3, 1, '4th Floor, Pavilion Mall, Nikol', 23.044000, 72.668500),
(2, 'City Gold Bapunagar', 10, 2, 'City Gold Complex, Bapunagar', 23.033200, 72.636600),
(3, 'Naroda Amphitheater', 3, 3, 'Lake Side, Naroda', 23.064500, 72.663100),
(4, 'Cinepolis SG Highway', 10, 4, 'Alpha One Mall, SG Highway', 23.039800, 72.528800),
(5, 'Vastrapur Lake Open Air', 3, 5, 'Vastrapur Lake Garden', 23.035100, 72.525700),
(6, 'Science City IMAX', 10, 6, 'Science City Campus', 23.072200, 72.498800),
(7, 'Gota Community Hall', 3, 7, 'Gota Cross Road', 23.092100, 72.540100),
(8, 'Maninagar Kankaria Carnival', 10, 8, 'Kankaria Lake Front', 22.996100, 72.600900),
(9, 'City Pulse Infocity', 3, 9, 'Infocity IT Metropolis', 23.188500, 72.627900),
(10, 'Mahatma Mandir Convention', 10, 10, 'Sector 13', 23.232300, 72.651700),
(11, 'Pramukh Arcade Theatre', 3, 11, 'Sargasan Cross Road', 23.176400, 72.618600);

-- Room
INSERT INTO Room (room_id, venue_id, room_no, screen_type, capacity)
OVERRIDING SYSTEM VALUE VALUES
(1, 1, 1, 'IMAX', 150),
(2, 1, 2, 'Standard', 100),
(3, 1, 3, '4DX', 80),
(4, 2, 1, 'Standard', 200),
(5, 3, 1, 'Open Air Stage', 500),
(6, 4, 1, 'IMAX', 250),
(7, 4, 2, 'Standard', 120),
(8, 5, 1, 'Lawn Stage', 1000),
(9, 6, 1, 'Dome Screen', 300),
(10, 7, 1, 'Indoor Hall', 150),
(11, 8, 1, 'Arena Stage', 800),
(12, 9, 1, 'Standard', 120),
(13, 9, 2, 'IMAX', 200),
(14, 10, 1, 'Auditorium', 1500),
(15, 11, 1, 'Standard', 100);

-- Category
INSERT INTO Category (category) VALUES
('VIP'), ('Gold'), ('Silver'), ('Balcony'), ('Box'), ('General Standing');

-- Seat (Seeding Room 1 in PVR Nikol and Room 6 in SG Highway)
-- Room 1: 5 VIP, 5 Gold
INSERT INTO Seat (room_id, seat_number, seat_row, category) VALUES
(1, 'A1', 'A', 'VIP'), (1, 'A2', 'A', 'VIP'), (1, 'A3', 'A', 'VIP'), (1, 'A4', 'A', 'VIP'), (1, 'A5', 'A', 'VIP'),
(1, 'B1', 'B', 'Gold'), (1, 'B2', 'B', 'Gold'), (1, 'B3', 'B', 'Gold'), (1, 'B4', 'B', 'Gold'), (1, 'B5', 'B', 'Gold'),
-- Room 6: 5 VIP, 5 Balcony
(6, 'A1', 'A', 'VIP'), (6, 'A2', 'A', 'VIP'), (6, 'A3', 'A', 'VIP'), (6, 'A4', 'A', 'VIP'), (6, 'A5', 'A', 'VIP'),
(6, 'B1', 'B', 'Balcony'), (6, 'B2', 'B', 'Balcony'), (6, 'B3', 'B', 'Balcony'), (6, 'B4', 'B', 'Balcony'), (6, 'B5', 'B', 'Balcony'),
-- Room 12: Gandhinagar City Pulse
(12, 'A1', 'A', 'VIP'), (12, 'A2', 'A', 'VIP'), (12, 'A3', 'A', 'VIP'),
(12, 'B1', 'B', 'Gold'), (12, 'B2', 'B', 'Gold'), (12, 'B3', 'B', 'Gold');

-- Event_Schedule (15 schedules)
INSERT INTO Event_Schedule (schedule_id, event_id, manager_id, room_id, lifecycle_status, booking_availability, event_datetime)
OVERRIDING SYSTEM VALUE VALUES
(1, 1, 2, 1, 'Completed', 'Closed', '2026-08-16 10:00:00'),
(2, 1, 2, 1, 'Scheduled', 'Open', '2026-08-20 18:00:00'),
(3, 1, 2, 2, 'Scheduled', 'Open', '2026-08-20 21:00:00'),
(4, 2, 9, 10, 'Scheduled', 'Open', '2026-08-21 20:00:00'),
(5, 3, 2, 6, 'Scheduled', 'Open', '2026-08-22 15:00:00'),
(6, 3, 2, 9, 'Scheduled', 'Sold_Out', '2026-08-23 18:00:00'),
(7, 4, 9, 7, 'Scheduled', 'Open', '2026-08-24 12:00:00'),
(8, 5, 2, 8, 'Scheduled', 'Open', '2026-09-10 19:00:00'),
(9, 6, 9, 3, 'Cancelled', 'Closed', '2026-08-25 23:00:00'),
(10, 7, 2, 5, 'Scheduled', 'Open', '2026-08-28 19:30:00'),
(11, 8, 9, 4, 'Scheduled', 'Open', '2026-09-06 14:00:00'),
(12, 10, 2, 11, 'Scheduled', 'Open', '2026-09-15 18:00:00'),
(13, 1, 9, 12, 'Scheduled', 'Open', '2026-08-21 18:30:00'),
(14, 4, 9, 13, 'Scheduled', 'Open', '2026-08-22 20:00:00'),
(15, 2, 2, 14, 'Scheduled', 'Open', '2026-08-25 19:00:00');

-- Movie_Pricing
INSERT INTO Movie_Pricing (schedule_id, category, price) VALUES
(1, 'VIP', 500.00), (1, 'Gold', 250.00),
(2, 'VIP', 500.00), (2, 'Gold', 250.00),
(3, 'VIP', 400.00), (3, 'Gold', 200.00),
(5, 'VIP', 800.00), (5, 'Balcony', 400.00),
(6, 'VIP', 800.00), (6, 'Balcony', 400.00),
(7, 'VIP', 300.00), (7, 'Silver', 150.00),
(9, 'VIP', 600.00), (9, 'Box', 1000.00),
(11, 'Gold', 350.00), (11, 'Silver', 250.00),
(13, 'VIP', 400.00), (13, 'Gold', 200.00),
(14, 'VIP', 600.00), (14, 'Gold', 300.00);

-- Show_Pricing
INSERT INTO Show_Pricing (schedule_id, category, category_capacity, price) VALUES
(4, 'VIP', 50, 1000.00), (4, 'Gold', 100, 500.00),
(8, 'VIP', 200, 2500.00), (8, 'General Standing', 800, 999.00),
(10, 'VIP', 100, 700.00), (10, 'Gold', 400, 400.00),
(12, 'VIP', 200, 500.00), (12, 'Silver', 600, 200.00),
(15, 'VIP', 500, 1500.00), (15, 'Balcony', 1000, 800.00);

-- Payment_Details
INSERT INTO Payment_Details (payment_id, transaction_id, payment_method, payment_status, payment_amount, payment_time)
OVERRIDING SYSTEM VALUE VALUES
(1, 'TXN001', 'UPI', 'Completed', 500.00, '2026-08-10 10:00:00'),
(2, 'TXN002', 'Credit Card', 'Completed', 1000.00, '2026-08-12 11:30:00'),
(3, 'TXN003', 'Debit Card', 'Completed', 800.00, '2026-08-14 15:45:00'),
(4, 'TXN004', 'Net Banking', 'Failed', 400.00, '2026-08-15 09:20:00'),
(5, 'TXN005', 'UPI', 'Refunded', 600.00, '2026-08-16 12:00:00'),
(6, 'TXN006', 'Credit Card', 'Completed', 2500.00, '2026-08-18 20:10:00');

-- Booking
INSERT INTO Booking (booking_id, schedule_id, account_id, payment_id, booking_status, review, rating, booking_time)
OVERRIDING SYSTEM VALUE VALUES
(1, 1, 4, 1, 'Confirmed', 'Amazing movie, loved it!', 5, '2026-08-10 10:05:00'),
(2, 4, 5, 2, 'Confirmed', NULL, NULL, '2026-08-12 11:35:00'),
(3, 5, 6, 3, 'Confirmed', NULL, NULL, '2026-08-14 15:50:00'),
(4, 7, 7, 4, 'Cancelled', NULL, NULL, '2026-08-15 09:25:00'),
(5, 9, 8, 5, 'Refunded', 'Show was cancelled, got my refund.', NULL, '2026-08-16 12:05:00'),
(6, 8, 1, 6, 'Confirmed', NULL, NULL, '2026-08-18 20:15:00');

-- Booking_Movie (Bookings 1, 3, 4, 5)
INSERT INTO Booking_Movie (booking_id, room_id, seat_number) VALUES
(1, 1, 'A1'), (1, 1, 'A2'), -- Guj Blockbuster
(3, 6, 'A1'), (3, 6, 'A2'); -- Sci-Fi Epic

-- Booking_Show (Bookings 2, 6)
INSERT INTO Booking_Show (booking_id, category, seat_count) VALUES
(2, 'VIP', 1), -- Nikol Comedy Night
(6, 'VIP', 1); -- Rock Concert

-- User_Notification
INSERT INTO User_Notification (notification_id, account_id, schedule_id, notification_type, title, message, is_read)
OVERRIDING SYSTEM VALUE VALUES
(1, 4, 1, 'BOOKING_CONFIRMED', 'Booking Confirmed!', 'Your booking for Gujarati Blockbuster is confirmed.', TRUE),
(2, 5, 4, 'PAYMENT_SUCCESS', 'Payment Received', 'We have received your payment of 1000.00.', FALSE),
(3, 8, 9, 'SHOW_CANCELLED', 'Horror Nights Cancelled', 'Unfortunately the show has been cancelled. Refund initiated.', TRUE),
(4, 8, 9, 'REFUND_SUCCESS', 'Refund Processed', 'Your refund of 600.00 is complete.', FALSE),
(5, 1, 8, 'SHOW_REMINDER', 'Upcoming Rock Concert', 'Don''t forget your Rock Concert is coming up soon!', FALSE);
