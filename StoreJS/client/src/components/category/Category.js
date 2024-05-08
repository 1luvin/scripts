import React from 'react';
import { Link } from 'react-router-dom';

import '../shared.css'
import './Category.css'

const Category = ({ name, productCount }) => {
    return (
        <Link to={`/products/${name.toLowerCase()}`} className='link-no-style'>
            <div className='card'>
                <p className='card-title'>{name}</p>
                <p className='category-open'>{productCount} products</p>
            </div>
        </Link>
    );
};

export default Category;