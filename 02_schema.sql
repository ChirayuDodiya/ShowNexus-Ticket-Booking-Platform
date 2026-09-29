-- Create schema
CREATE SCHEMA IF NOT EXISTS ShowNexus;

SET search_path TO ShowNexus;

CREATE TYPE role_type AS ENUM (
    'USER',
    'ORGANIZER',
    'OWNER'
);

-- 1. ACCOUNT TABLE
CREATE TABLE Account (
    account_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    mobile_number VARCHAR(10) UNIQUE NOT NULL,
    dateofbirth DATE,
    role role_type NOT NULL,
    referral_code VARCHAR(20) UNIQUE,
    referred_by BIGINT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (referred_by) REFERENCES Account(account_id)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- 2. COUPON CATEGORY TABLE
CREATE TABLE Coupon_Category (
    coupon_category_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category_name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT
);

-- 3. COUPON TABLE
CREATE TABLE Coupon (
    coupon_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    account_id BIGINT NOT NULL,
    coupon_category_id INT NOT NULL,
    amount DECIMAL(8,2) NOT NULL CHECK (amount >= 0),
    validity DATE NOT NULL,
    issued_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    redeemed_at TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES Account(account_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (coupon_category_id) REFERENCES Coupon_Category(coupon_category_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- GENRE TABLE
CREATE TABLE Genre (
    genre VARCHAR(50) PRIMARY KEY
);

-- 4. EVENT TABLE
CREATE TABLE Event (
    event_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    event_name VARCHAR(100) NOT NULL,
    event_description TEXT,
    poster_link TEXT,
    trailer_link TEXT,
    duration INTERVAL,
    age_restriction INT CHECK (age_restriction >= 0)
);

CREATE TABLE Language (
    language VARCHAR(50) PRIMARY KEY
);

CREATE TABLE Event_Language (
    event_id BIGINT,
    language VARCHAR(50),
    PRIMARY KEY (event_id, language),
    FOREIGN KEY (event_id) REFERENCES Event(event_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (language) REFERENCES Language(language)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Event_Genre (
    event_id BIGINT,
    genre VARCHAR(50),
    PRIMARY KEY (event_id, genre),
    FOREIGN KEY (event_id) REFERENCES Event(event_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (genre) REFERENCES Genre(genre)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 5. MOVIE_EVENT TABLE
CREATE TABLE Movie_Event (
    event_id BIGINT PRIMARY KEY,
    imdb_rating DECIMAL(3,1) CHECK (imdb_rating BETWEEN 0 AND 10),
    release_date DATE,
    FOREIGN KEY (event_id) REFERENCES Event(event_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- 6. SHOW_EVENT TABLE
CREATE TABLE Show_Event (
    event_id BIGINT PRIMARY KEY,
    organizer_id BIGINT NOT NULL,
    audience_interaction BOOLEAN NOT NULL,
    FOREIGN KEY (event_id) REFERENCES Event(event_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (organizer_id) REFERENCES Account(account_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 7. ARTIST TABLE
CREATE TABLE Artist (
    artist_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    artist_name VARCHAR(100) NOT NULL
);

-- 8. SHOW PERFORMERS
CREATE TABLE Show_Performers (
    artist_id BIGINT,
    event_id BIGINT,
    PRIMARY KEY (artist_id, event_id),
    FOREIGN KEY (artist_id) REFERENCES Artist(artist_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (event_id) REFERENCES Show_Event(event_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- 9. REGION INFO TABLE
CREATE TABLE Region (
    region_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    pincode INT NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    area VARCHAR(50) NOT NULL,
    UNIQUE (pincode, area)
);

-- 10. VENUE TABLE
CREATE TABLE Venue (
    venue_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    venue_name VARCHAR(100) NOT NULL,
    owner_id BIGINT NOT NULL,
    region_id INT NOT NULL,   
    address TEXT NOT NULL,
    latitude DECIMAL(10,7) NOT NULL CHECK (latitude BETWEEN -90 AND 90),
    longitude DECIMAL(10,7) NOT NULL CHECK (longitude BETWEEN -180 AND 180),
    FOREIGN KEY (owner_id) REFERENCES Account(account_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (region_id) REFERENCES Region(region_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 11. ROOM TABLE
CREATE TABLE Room (
    room_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    venue_id BIGINT NOT NULL,
    room_no INT NOT NULL,
    screen_type VARCHAR(50),
    capacity INT NOT NULL CHECK (capacity > 0),
    UNIQUE (venue_id, room_no),
    FOREIGN KEY (venue_id) REFERENCES Venue(venue_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- 12. SEAT CATEGORY TABLE
CREATE TABLE Category (
    category VARCHAR(50) PRIMARY KEY
);

-- 13. SEAT TABLE
CREATE TABLE Seat (
    room_id BIGINT,
    seat_number VARCHAR(10),
    seat_row CHAR(2),
    category VARCHAR(50),
    PRIMARY KEY (room_id, seat_number),
    FOREIGN KEY (room_id) REFERENCES Room(room_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (category) REFERENCES Category(category)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 14. EVENT SCHEDULE TABLE
CREATE TABLE Event_Schedule (
    schedule_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    event_id BIGINT NOT NULL,
    manager_id BIGINT NOT NULL,
    room_id BIGINT NOT NULL,
    lifecycle_status VARCHAR(20) NOT NULL CHECK (lifecycle_status IN ('Scheduled', 'Cancelled', 'Completed')),
    booking_availability VARCHAR(20) NOT NULL CHECK (booking_availability IN ('Open', 'Closed', 'Sold_Out')),
    event_datetime TIMESTAMP NOT NULL,
    FOREIGN KEY (event_id) REFERENCES Event(event_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (manager_id) REFERENCES Account(account_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (room_id) REFERENCES Room(room_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 16. USER NOTIFICATIONS
CREATE TYPE notification_type_enum AS ENUM (
    'BOOKING_CONFIRMED',
    'PAYMENT_SUCCESS',
    'SHOW_CANCELLED',
    'SHOW_REMINDER',
    'REFUND_SUCCESS',
    'COUPON_ISSUED'
);

CREATE TABLE User_Notification (
    notification_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    account_id BIGINT NOT NULL,
    schedule_id BIGINT,
    notification_type notification_type_enum,
    title VARCHAR(100),
    message TEXT,
    is_read BOOLEAN DEFAULT FALSE,
    read_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (account_id)
        REFERENCES Account(account_id)
        ON DELETE CASCADE,

    FOREIGN KEY (schedule_id)
        REFERENCES Event_Schedule(schedule_id)
        ON DELETE CASCADE
);

-- 17. SHOW EVENT PRICING TABLE
CREATE TABLE Show_Pricing (
    schedule_id BIGINT,
    category VARCHAR(50),
    category_capacity INT CHECK (category_capacity > 0),
    price DECIMAL(8,2) NOT NULL CHECK (price > 0),
    PRIMARY KEY (schedule_id, category),
    FOREIGN KEY (schedule_id) REFERENCES Event_Schedule(schedule_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (category) REFERENCES Category(category)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 18. MOVIE EVENT PRICING TABLE
CREATE TABLE Movie_Pricing (
    schedule_id BIGINT,
    category VARCHAR(50),
    price DECIMAL(8,2) NOT NULL CHECK (price > 0),
    PRIMARY KEY (schedule_id, category),
    FOREIGN KEY (schedule_id) REFERENCES Event_Schedule(schedule_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (category) REFERENCES Category(category)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Enumerated types for payment details
CREATE TYPE payment_method_type AS ENUM (
    'Credit Card',
    'Debit Card',
    'UPI',
    'Net Banking'
);

CREATE TYPE payment_status_type AS ENUM (
    'Pending',
    'Completed',
    'Failed',
    'Refunded',
    'Cancelled'
);

-- 19. PAYMENT DETAILS TABLE
CREATE TABLE Payment_Details (
    payment_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    transaction_id VARCHAR(100) NOT NULL UNIQUE,
    payment_method payment_method_type NOT NULL,
    payment_status payment_status_type NOT NULL,
    payment_amount DECIMAL(10,2) NOT NULL CHECK (payment_amount > 0),
    payment_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TYPE booking_status_type AS ENUM (
    'Confirmed',
    'Cancelled',
    'Expired',
    'Refunded'
);

-- 20. BOOKING TABLE
CREATE TABLE Booking (
    booking_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    schedule_id BIGINT NOT NULL,
    account_id BIGINT NOT NULL,
    payment_id BIGINT NOT NULL,
    booking_status booking_status_type NOT NULL,
    review TEXT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
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
    booking_id BIGINT PRIMARY KEY,
    category VARCHAR(50) NOT NULL,
    seat_count INT NOT NULL CHECK (seat_count > 0),
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (category) REFERENCES Category(category)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 22. BOOKING MOVIE TABLE
CREATE TABLE Booking_Movie (
    booking_id BIGINT,
    room_id BIGINT NOT NULL,
    seat_number VARCHAR(10) NOT NULL,
    PRIMARY KEY (booking_id, room_id, seat_number),
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (room_id, seat_number) REFERENCES Seat(room_id, seat_number)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- List all tables in the current schema
SELECT table_name
FROM information_schema.tables
WHERE table_schema = current_schema()
  AND table_type = 'BASE TABLE';

-- 23. INDEXES
CREATE INDEX idx_booking_account ON Booking(account_id);
CREATE INDEX idx_schedule_datetime ON Event_Schedule(event_datetime);
CREATE INDEX idx_schedule_room ON Event_Schedule(room_id);
CREATE INDEX idx_notification_account ON User_Notification(account_id);
CREATE INDEX idx_coupon_account ON Coupon(account_id);
CREATE INDEX idx_venue_region ON Venue(region_id);
CREATE INDEX idx_booking_schedule ON Booking(schedule_id);
CREATE INDEX idx_schedule_event ON Event_Schedule(event_id);
CREATE INDEX idx_event_genre ON Event_Genre(genre);
