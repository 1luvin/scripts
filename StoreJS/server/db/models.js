const mongoose = require('mongoose');

const categorySchema = new mongoose.Schema({
    name: String,
    productCount: Number
});

const productSchema = new mongoose.Schema({
    name: String,
    description: String,
    price: Number,
    category: categorySchema,
});

const Category = mongoose.model('Category', categorySchema);
const Product = mongoose.model('Product', productSchema);

module.exports = { Category, Product };