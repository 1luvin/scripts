import React, { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import axios from 'axios';

import Product from '../components/product/Product';

function capitalize(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
}

const CategoryPage = () => {
    let { categoryName } = useParams();
    categoryName = capitalize(categoryName);

    const [products, setProducts] = useState([]);

    useEffect(() => {
        axios.get('/products')
            .then(response => {
                const products = response.data;
                const productsInCategory = products.filter(product => product.category.name === categoryName);
                setProducts(productsInCategory);
            })
            .catch(error => {
                console.error(`Error fetching products: ${error}`);
            });
    }, [categoryName]);

    return (
        <div>
            <h1>{categoryName}</h1>
            {products.map(product => (
                <Product
                    name={product.name}
                    description={product.description}
                    price={product.price}
                />
            ))}
        </div>
    );
};

export default CategoryPage;