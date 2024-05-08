import React, { useEffect, useState } from 'react';
import axios from 'axios';

import Product from '../components/product/Product';

const AllProductsPage = () => {
    const [products, setProducts] = useState([]);

    useEffect(() => {
        axios.get('/products')
            .then(response => {
                setProducts(response.data);
            })
            .catch(error => {
                console.error(`Error fetching products: ${error}`);
            });
    }, []);

    return (
        <div>
            <h1>Products</h1>
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

export default AllProductsPage;