const db = require('./db');
const { Category, Product } = require('./models');

let categories_;
let products_;


function fillCategories() {
    categories_ = [
        {
            name: 'Pizza',
            productCount: 3
        },
        {
            name: 'Burgers',
            productCount: 3
        },
        {
            name: 'Drinks',
            productCount: 3
        },
    ];
}

function fillProducts(categories) {
    products_ = [
        {
            name: "Capriciossa",
            description: "Ham, mushrooms.",
            price: 9.99,
            category: categories[0]
        },
        {
            name: "Salami",
            description: "Salami, onion.",
            price: 9.99,
            category: categories[0]
        },
        {
            name: "Margheritta",
            description: "Sauce, Mozzarella cheese, oregano.",
            price: 8.99,
            category: categories[0]
        },
        {
            name: "Cheese and Bacon",
            description: "200 g. beef, bacon, Cheddar cheese, lettuce, tomato, cucumber, red onion, ketchup, mayonnaise.",
            price: 9.99,
            category: categories[1]
        },
        {
            name: "Chief",
            description: "200 g. beef, lettuce, tomato, canned cucumber, grilled red onion, grilled jalapeno pepper, bacon, Cheddar cheese, BBQ sauce, mayonnaise, ketchup.",
            price: 10.99,
            category: categories[1]
        },
        {
            name: "Classic",
            description: "180 g. beef, lettuce, tomato, cucumber, red onion, ketchup, mayonnaise.",
            price: 7.99,
            category: categories[1]
        },
        {
            name: "Coca-Cola",
            description: "500 ml.",
            price: 2.99,
            category: categories[2]
        },
        {
            name: "Lemonade",
            description: "500 ml.",
            price: 2.99,
            category: categories[2]
        },
        {
            name: "Orange Juice",
            description: "500 ml.",
            price: 3.99,
            category: categories[2]
        },
    ];
}

async function seed() {
    try {
        fillCategories();
        await Category.deleteMany({});
        await Category.insertMany(categories_);

        const categories = await Category.find();
        fillProducts(categories);
        await Product.deleteMany({});
        await Product.insertMany(products_);
    } catch (err) {
        console.error('Error seeding data:', err);
    } finally {
        db.close();
    }
}

seed();