const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
app.use(cors()); // Enables cross-origin connection for Flutter Web browser
app.use(express.json());

// MySQL Connection Configuration
const db = mysql.createConnection({
    host: '127.0.0.1',
    user: 'root',
    password: 'root123',
    database: 'mobile_app_db',
    port: 3306
});

db.connect((err) => {
    if (err) {
        console.error('Database connection failed: ' + err.stack);
        return;
    }
    console.log('Connected to MySQL Database successfully.');
});

// MODULE 1: PRODUCTS (CRUD OPERATIONS)
// 1. CREATE (Insert Product with Category and Quantity)
app.post('/api/products', (req, res) => {
    const { name, price, category, quantity } = req.body;
    const query = "INSERT INTO products (name, price, category, quantity) VALUES (?, ?, ?, ?)";
    
    db.query(query, [name, price || 0.0, category || 'General', quantity || '1 unit'], (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ message: 'Product created successfully', id: result.insertId });
    });
});

// 2. READ (Select All Products)
app.get('/api/products', (req, res) => {
    db.query("SELECT * FROM products", (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
    });
});

// 3. UPDATE (Update Product status, name, category, and quantity)
app.put('/api/products/:id', (req, res) => {
    const { name, price, category, quantity } = req.body;
    const { id } = req.params;
    const query = "UPDATE products SET name = ?, price = ?, category = ?, quantity = ? WHERE id = ?";
    
    db.query(query, [name, price, category, quantity, id], (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ message: 'Product updated successfully' });
    });
});

// 4. DELETE (Remove Product)
app.delete('/api/products/:id', (req, res) => {
    const { id } = req.params;
    db.query("DELETE FROM products WHERE id = ?", [id], (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ message: 'Product deleted successfully' });
    });
});

// MODULE 2: ORDERS (CRUD OPERATIONS)
app.post('/api/orders', (req, res) => {
    const { product_name, quantity } = req.body;
    const query = "INSERT INTO orders (product_name, quantity) VALUES (?, ?)";
    db.query(query, [product_name, quantity], (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ message: 'Order placed successfully', id: result.insertId });
    });
});

app.get('/api/orders', (req, res) => {
    db.query("SELECT * FROM orders", (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
    });
});

// Start backend engine
app.listen(3006, () => {
    console.log('Server running smoothly on port 3006');
});