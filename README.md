# ShowNexus

ShowNexus is a database system inspired by BookMyShow. It enables efficient booking of event and movie tickets, supporting features like category-based and seat-based ticketing, venue management, and multi-location scheduling. The system is designed using PostgreSQL and normalized up to BCNF for optimal performance and data integrity.

---

## 📌 Features

- 🎬 **Dual Booking System**:
  - **Movies**: Seat-based booking.
  - **Events**: Category-based booking (e.g., VIP, Regular).
  
- 🏟️ **Venue Management**:
  - Fixed seating arrangements per venue.
  - City-wise venue and show scheduling.
  
- 🎫 **Flexible Pricing Model**:
  - Different prices per event/movie, location, and category.
  
- 👤 **User & Booking Management**:
  - User registration and ticket booking history tracking.

- ⚙️ **BCNF-Compliant Schema**:
  - Designed with best database normalization practices.
  - Avoids redundancy and ensures data consistency.

---

## 🗂️ Project Structure

```
ShowNexus/
├── schema.sql               # Full DDL script with table definitions
├── insert_data.sql          # Sample realistic data for all tables
├── queries.sql       # Sample queries (joins, aggregations, etc.)
├── README.md               # Project overview and documentation
├── ER_diagram.pdf          # Entity-Relationship Diagrams
├── query_output_1.jpg      # Query execution screenshots
├── query_output_2.jpg      # Query execution screenshots
├── query_output_3.jpg      # Query execution screenshots
└── Relational_Database.pdf # Complete project documentation
```

---

## 🛠️ Tech Stack

- **Database**: PostgreSQL
- **Admin Tool**: pgAdmin 4
- **Normalization**: Up to BCNF
- **Design Pattern**: Relational schema with subclassing for booking and pricing

---

## 🚀 Getting Started

### Prerequisites
- PostgreSQL (version 12 or higher)
- pgAdmin 4 or any PostgreSQL client

### Installation Steps

1. **Clone the repository**:
   ```bash
   git clone https://github.com/ChirayuDodiya/ShowNexus-Ticket-Booking-System.git
    cd ShowNexus-Ticket-Booking-System
   ```

2. **Create a new database**:
   - Open pgAdmin and create a new database
   - Name it: `shownexus`

3. **Run the schema**:
   - Open `schema.sql` in pgAdmin
   - Execute the script to create all tables

4. **Insert sample data**:
   - Run `insert_data.sql` to populate the tables with realistic Indian show and movie data

5. **Test with sample queries**:
   - Execute queries from `sample_queries.sql` to verify the setup

---

## 📊 Sample Queries

Examples of what you can do with ShowNexus:

- **get list of different price and category for particular movie**
- **Filter Events by Genre**
- **List top 5 most booked events (by total bookings)**
- **how many seats are empty**

Check the `sample_queries.sql` file for complete query implementations!

---

## 🤝 Contributing

Want to extend ShowNexus with more features? We welcome contributions!

### Potential Enhancements
- Admin dashboard and management interface
- Payment gateway integration
- Mobile app API endpoints
- Notification system for bookings

### How to Contribute
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---
*Happy Booking! 🎬🎪*
