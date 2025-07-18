-- Create schema
CREATE SCHEMA IF NOT EXISTS ShowNexus;
SET search_path TO ShowNexus;

-- 1. ACCOUNT TABLE
CREATE TABLE Account (
    account_id INT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    mobile_number VARCHAR(10) NOT NULL,
    dateofbirth DATE,
    gender VARCHAR(10),
    role DECIMAL(1,0) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    state VARCHAR(50),
    city VARCHAR(50),
    area VARCHAR(50),
    firstname VARCHAR(50) NOT NULL,
    middlename VARCHAR(50),
    surname VARCHAR(50) NOT NULL,
    referral_code VARCHAR(20) UNIQUE,
    referred_by INT NULL,
    FOREIGN KEY (referred_by) REFERENCES Account(account_id)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- 2. COUPON CATEGORY TABLE
CREATE TABLE Coupon_Category (
    coupon_category_id INT PRIMARY KEY,
    category_name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT
);

-- 3. COUPON TABLE
CREATE TABLE Coupon (
    coupon_id INT PRIMARY KEY,
    account_id INT NOT NULL,
    coupon_category_id INT NOT NULL,
    amount DECIMAL(8,2) NOT NULL,
    validity DATE NOT NULL,
    issued_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    redeemed_at TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES Account(account_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (coupon_category_id) REFERENCES Coupon_Category(coupon_category_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 4. EVENT TABLE
CREATE TABLE Event (
    event_id INT PRIMARY KEY,
    event_name VARCHAR(100) NOT NULL,
    event_description TEXT,
    poster_link TEXT,
    trailer_link TEXT,
    duration TIME,
    age_restriction INT,
    language VARCHAR(50),
    event_genre VARCHAR(50)
);

-- 5. MOVIE_EVENT TABLE
CREATE TABLE Movie_Event (
    event_id INT PRIMARY KEY,
    imdb_rating DECIMAL(3,1),
    release_date DATE,
    FOREIGN KEY (event_id) REFERENCES Event(event_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- 6. SHOW_EVENT TABLE
CREATE TABLE Show_Event (
    event_id INT PRIMARY KEY,
    audience_interaction BOOLEAN,
    FOREIGN KEY (event_id) REFERENCES Event(event_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- 7. ARTIST TABLE
CREATE TABLE Artist (
    artist_id INT PRIMARY KEY,
    artist_name VARCHAR(100) NOT NULL
);

-- 8. SHOW PERFORMERS
CREATE TABLE Show_Performers (
    artist_id INT,
    event_id INT,
    PRIMARY KEY (artist_id, event_id),
    FOREIGN KEY (artist_id) REFERENCES Artist(artist_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (event_id) REFERENCES Show_Event(event_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- 9. REGION INFO TABLE
CREATE TABLE Region (
    pincode INT PRIMARY KEY,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    area VARCHAR(50) NOT NULL
);

-- 10. VENUE TABLE
CREATE TABLE Venue (
    venue_id INT PRIMARY KEY,
    venue_name VARCHAR(100) NOT NULL,
    pincode INT NOT NULL,
    FOREIGN KEY (pincode) REFERENCES Region(pincode)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 11. ROOM TABLE
CREATE TABLE Room (
    room_id INT PRIMARY KEY,
    venue_id INT NOT NULL,
    room_no INT NOT NULL,
    screen_type VARCHAR(50),
    capacity INT NOT NULL,
    FOREIGN KEY (venue_id) REFERENCES Venue(venue_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- 12. SEAT CATEGORY TABLE
CREATE TABLE Category (
    category VARCHAR(50) PRIMARY KEY
);

-- 13. SEAT TABLE
CREATE TABLE Seat (
    room_id INT,
    seat_number VARCHAR(10),
    seat_row INT,
    category VARCHAR(50),
    PRIMARY KEY (room_id, seat_number),
    FOREIGN KEY (room_id) REFERENCES Room(room_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (category) REFERENCES Category(category)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 14. EVENT SCHEDULE TABLE
CREATE TABLE Event_Schedule (
    schedule_id INT PRIMARY KEY,
    event_id INT NOT NULL,
    manager_id INT NOT NULL,
    room_id INT NOT NULL,
    event_datetime TIMESTAMP NOT NULL,
    sponsored_money DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (event_id) REFERENCES Event(event_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (manager_id) REFERENCES Account(account_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (room_id) REFERENCES Room(room_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 15. NOTIFICATION TABLE
CREATE TABLE Notification (
    notification_id INT PRIMARY KEY,
    schedule_id INT,
    message TEXT,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (schedule_id) REFERENCES Event_Schedule(schedule_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- 16. USER NOTIFICATIONS
CREATE TABLE User_Notifications (
    account_id INT,
    notification_id INT,
    PRIMARY KEY (account_id, notification_id),
    FOREIGN KEY (account_id) REFERENCES Account(account_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (notification_id) REFERENCES Notification(notification_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- 17. SHOW EVENT PRICING TABLE
CREATE TABLE Show_Pricing (
    schedule_id INT,
    category VARCHAR(50),
    category_capacity INT,
    price DECIMAL(8,2) NOT NULL,
    PRIMARY KEY (schedule_id, category),
    FOREIGN KEY (schedule_id) REFERENCES Event_Schedule(schedule_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (category) REFERENCES Category(category)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 18. MOVIE EVENT PRICING TABLE
CREATE TABLE Movie_Pricing (
    schedule_id INT,
    category VARCHAR(50),
    price DECIMAL(8,2) NOT NULL,
    PRIMARY KEY (schedule_id, category),
    FOREIGN KEY (schedule_id) REFERENCES Event_Schedule(schedule_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (category) REFERENCES Category(category)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 19. PAYMENT DETAILS TABLE
CREATE TABLE Payment_Details (
    payment_id INT PRIMARY KEY,
    transaction_id VARCHAR(100) UNIQUE,
    payment_method VARCHAR(50) NOT NULL,
    payment_status VARCHAR(20) NOT NULL,
    payment_amount DECIMAL(10,2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 20. BOOKING TABLE
CREATE TABLE Booking (
    booking_id INT PRIMARY KEY,
    schedule_id INT NOT NULL,
    account_id INT NOT NULL,
    payment_id INT NOT NULL,
    review TEXT,
    booking_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES Account(account_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (schedule_id) REFERENCES Event_Schedule(schedule_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (payment_id) REFERENCES Payment_Details(payment_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 21. BOOKING SHOW TABLE
CREATE TABLE Booking_Show (
    booking_id INT PRIMARY KEY,
    category VARCHAR(50) NOT NULL,
    seat_count INT NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (category) REFERENCES Category(category)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 22. BOOKING MOVIE TABLE
CREATE TABLE Booking_Movie (
    booking_id INT,
    seat_number VARCHAR(10) NOT NULL,
    category VARCHAR(50) NOT NULL,
    PRIMARY KEY (booking_id, seat_number),
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (category) REFERENCES Category(category)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- List all tables in the current schema
SELECT table_name
FROM information_schema.tables
WHERE table_schema = current_schema()
  AND table_type = 'BASE TABLE';
