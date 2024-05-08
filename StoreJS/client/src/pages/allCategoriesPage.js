import React, { useEffect, useState } from 'react';
import axios from 'axios';

import Category from '../components/category/Category';

const AllCategoriesPage = () => {
    const [categories, setCategories] = useState([]);

    useEffect(() => {
        axios.get('/categories')
            .then(response => {
                setCategories(response.data);
            })
            .catch(error => {
                console.error(`Error fetching categories: ${error}`);
            });
    }, []);

    return (
        <div>
            <h1>Categories</h1>
            {categories.map(category => (
                <Category
                    name={category.name}
                    productCount={category.productCount}
                />
            ))}
        </div>
    )
};

export default AllCategoriesPage;