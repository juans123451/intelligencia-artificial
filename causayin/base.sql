-- Base de datos para el Agente Optimizador de Compras
-- Puedes importar este SQL en tu localhost

-- Crear la base de datos
CREATE DATABASE shopping_optimizer;
USE shopping_optimizer;

-- Tabla de tiendas/supermercados
CREATE TABLE stores (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de categorías de productos
CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de productos
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    category_id INT,
    store_id INT,
    price DECIMAL(10,2) NOT NULL,
    unit VARCHAR(20) DEFAULT 'unidad',
    brand VARCHAR(50),
    description TEXT,
    is_available BOOLEAN DEFAULT TRUE,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id),
    FOREIGN KEY (store_id) REFERENCES stores(id),
    INDEX idx_name (name),
    INDEX idx_price (price),
    INDEX idx_category (category_id)
);

-- Tabla para historial de precios
CREATE TABLE price_history (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    old_price DECIMAL(10,2),
    new_price DECIMAL(10,2),
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Insertar datos de ejemplo

-- Tiendas
INSERT INTO stores (name, address, phone) VALUES
('Supermercado A', 'Av. Principal 123', '555-0001'),
('Supermercado B', 'Calle Comercio 456', '555-0002'),
('Supermercado C', 'Plaza Central 789', '555-0003'),
('Mercado Local', 'Av. Mercado 321', '555-0004');

-- Categorías
INSERT INTO categories (name, description) VALUES
('lacteos', 'Productos lácteos y derivados'),
('panaderia', 'Pan y productos de panadería'),
('carnes', 'Carnes frescas y procesadas'),
('vegetales', 'Frutas y verduras frescas'),
('granos', 'Cereales, arroz, pasta y legumbres'),
('bebidas', 'Bebidas alcohólicas y no alcohólicas'),
('limpieza', 'Productos de limpieza del hogar'),
('cuidado_personal', 'Productos de higiene personal');

-- Productos con precios variados
INSERT INTO products (name, category_id, store_id, price, unit, brand) VALUES
-- Lácteos
('Leche', 1, 1, 3.50, 'litro', 'Marca A'),
('Leche', 1, 2, 3.20, 'litro', 'Marca A'),
('Leche', 1, 3, 3.80, 'litro', 'Marca A'),
('Leche', 1, 4, 3.10, 'litro', 'Marca B'),

('Huevos', 1, 1, 4.50, 'docena', 'Granja X'),
('Huevos', 1, 2, 4.20, 'docena', 'Granja X'),
('Huevos', 1, 3, 4.80, 'docena', 'Granja Y'),
('Huevos', 1, 4, 4.00, 'docena', 'Granja Z'),

('Queso', 1, 1, 6.50, 'kg', 'Lacteos S.A.'),
('Queso', 1, 2, 6.20, 'kg', 'Lacteos S.A.'),
('Queso', 1, 3, 6.80, 'kg', 'Lacteos Premium'),

-- Panadería
('Pan', 2, 1, 2.00, 'unidad', 'Panadería Local'),
('Pan', 2, 2, 1.80, 'unidad', 'Panadería Local'),
('Pan', 2, 3, 2.20, 'unidad', 'Pan Artesanal'),
('Pan', 2, 4, 1.60, 'unidad', 'Pan Casero'),

-- Carnes
('Pollo', 3, 1, 8.50, 'kg', 'Avícola Norte'),
('Pollo', 3, 2, 8.20, 'kg', 'Avícola Norte'),
('Pollo', 3, 3, 8.80, 'kg', 'Pollo Premium'),
('Pollo', 3, 4, 7.90, 'kg', 'Granja Familiar'),

('Carne de Res', 3, 1, 15.50, 'kg', 'Carnes Select'),
('Carne de Res', 3, 2, 15.20, 'kg', 'Carnes Select'),
('Carne de Res', 3, 3, 16.00, 'kg', 'Premium Beef'),

-- Vegetales
('Tomate', 4, 1, 3.00, 'kg', NULL),
('Tomate', 4, 2, 2.80, 'kg', NULL),
('Tomate', 4, 3, 3.20, 'kg', NULL),
('Tomate', 4, 4, 2.50, 'kg', NULL),

('Cebolla', 4, 1, 2.50, 'kg', NULL),
('Cebolla', 4, 2, 2.30, 'kg', NULL),
('Cebolla', 4, 3, 2.70, 'kg', NULL),
('Cebolla', 4, 4, 2.10, 'kg', NULL),

('Papas', 4, 1, 1.80, 'kg', NULL),
('Papas', 4, 2, 1.60, 'kg', NULL),
('Papas', 4, 3, 2.00, 'kg', NULL),

-- Granos
('Arroz', 5, 1, 5.00, 'kg', 'Arroz Premium'),
('Arroz', 5, 2, 4.75, 'kg', 'Arroz Premium'),
('Arroz', 5, 3, 5.25, 'kg', 'Arroz Select'),
('Arroz', 5, 4, 4.50, 'kg', 'Arroz Popular'),

('Pasta', 5, 1, 1.50, 'paquete', 'Pasta Italia'),
('Pasta', 5, 2, 1.30, 'paquete', 'Pasta Italia'),
('Pasta', 5, 3, 1.70, 'paquete', 'Pasta Gourmet'),

('Frijoles', 5, 1, 3.20, 'kg', NULL),
('Frijoles', 5, 2, 3.00, 'kg', NULL),
('Frijoles', 5, 3, 3.50, 'kg', NULL);

-- Vistas útiles para consultas optimizadas

-- Vista para obtener el precio más bajo por producto
CREATE VIEW cheapest_products AS
SELECT 
    p.name,
    p.category_id,
    c.name as category_name,
    MIN(p.price) as min_price,
    s.name as best_store,
    p.unit
FROM products p
JOIN categories c ON p.category_id = c.id
JOIN stores s ON p.store_id = s.id
WHERE p.is_available = TRUE
GROUP BY p.name, p.category_id;

-- Vista para comparación de precios
CREATE VIEW price_comparison AS
SELECT 
    p.name as product_name,
    s.name as store_name,
    p.price,
    p.unit,
    c.name as category,
    p.brand,
    RANK() OVER (PARTITION BY p.name ORDER BY p.price ASC) as price_rank
FROM products p
JOIN stores s ON p.store_id = s.id
JOIN categories c ON p.category_id = c.id
WHERE p.is_available = TRUE
ORDER BY p.name, p.price;

-- Procedimiento almacenado para algoritmo voraz
DELIMITER //
CREATE PROCEDURE GetOptimalShopping(IN product_list TEXT)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE product_name VARCHAR(100);
    DECLARE cur CURSOR FOR 
        SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(product_list, ',', numbers.n), ',', -1)) as product
        FROM (SELECT 1 n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5) numbers
        WHERE CHAR