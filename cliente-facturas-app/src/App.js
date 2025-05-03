import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import 'bootstrap/dist/css/bootstrap.min.css';
import Navbar from './components/Navbar';
import HomePage from './pages/HomePage';
import ClienteFacturasPage from './pages/ClienteFacturasPage';
import './App.css';

function App() {
  return (
    <Router>
      <div className="App">
        <Navbar />
        <Routes>
          <Route path="/" element={<HomePage />} />
          <Route path="/clientes/:id" element={<ClienteFacturasPage />} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;
