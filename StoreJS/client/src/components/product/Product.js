import React from 'react';

import '../shared.css'
import './Product.css';

const Product = ({ name, description, price }) => {
  return (
    <div className='card'>
      <p className='card-title'>{name}</p>
      <p className='product-description'>{description}</p>
      <p className='product-price'>${price}</p>
    </div>
  );
};

export default Product;