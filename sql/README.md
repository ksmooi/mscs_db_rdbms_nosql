## Explanation of the schema:

- **Customers**: Stores customer data, including contact information and loyalty points.
- **Books**: Stores details of books in the bookstore, such as title, genre, price, stock quantity, and supplier details.
- **Suppliers**: Stores information about suppliers who provide books to the bookstore.
- **Orders**: Stores data about customer orders, including the customer who placed the order and shipping details.
- **OrderDetails**: This table handles the many-to-many relationship between orders and books, keeping track of which books were ordered and in what quantity.
- **Reviews**: Stores reviews left by customers for specific books, including a rating and comment.
- **Shipping**: Stores details of shipping for online orders, including shipping date and address.

The comments are aligned with the code to provide a clear explanation of each line.
