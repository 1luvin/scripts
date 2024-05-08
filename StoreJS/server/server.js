const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const db = require('./db/db');

// Initializing express app
const app = express();
const PORT = process.env.PORT || 5000;

app.use(bodyParser.json());
app.use(cors());

app.get('/', (req, res) => {
    res.send('Hello from Express!');
});

// Defining routes
const productRoutes = require('./routes/productRoutes');
const categoryRoutes = require('./routes/categoryRoutes');

app.use('/products', productRoutes);
app.use('/categories', categoryRoutes);

// Starting the server
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});