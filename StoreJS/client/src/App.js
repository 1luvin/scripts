import React from 'react';
import {
  BrowserRouter as Router,
  Routes,
  Route
} from 'react-router-dom';

// Importing pages
import HomePage from './pages/homePage'
import AllProductsPage from './pages/allProductsPage';
import AllCategoriesPage from './pages/allCategoriesPage';
import CategoryPage from './pages/categoryPage';

import './App.css';

const App = () => {
  return (
    <Router>
      <Routes>
        <Route path='/' element={<HomePage />} />
        <Route path='/products' element={<AllProductsPage />} />
        <Route path='/categories' element={<AllCategoriesPage />} />
        <Route path='/products/:categoryName' element={<CategoryPage />} />
      </Routes>
    </Router>
  );
}

export default App;