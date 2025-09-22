-- Table Pizza
CREATE TABLE pizza (
    id_pizza SERIAL PRIMARY KEY,
    name_pizza VARCHAR(50) UNIQUE NOT NULL,
    price_pizza NUMERIC(15,2) NOT NULL,
    image BYTEA
);

-- Table Size
CREATE TABLE size (
    id_size SERIAL PRIMARY KEY,
    name_size VARCHAR(50) NOT NULL,
    coeff DOUBLE PRECISION NOT NULL
);

-- Table Ingredient
CREATE TABLE ingredient (
    id_ingredient SERIAL PRIMARY KEY,
    name_ingredient VARCHAR(50) NOT NULL
);

-- Table Customer
CREATE TABLE customer (
    id_customer SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email_address VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    wallet NUMERIC(15,2) NOT NULL,
    is_admin BOOLEAN NOT NULL
);

-- Table Invoice
CREATE TABLE invoice (
    id_invoice SERIAL PRIMARY KEY,
    date_ TIMESTAMP NOT NULL,
    total_amount NUMERIC(15,2) NOT NULL,
    id_customer INT NOT NULL,
    CONSTRAINT fk_invoice_customer FOREIGN KEY (id_customer)
        REFERENCES customer(id_customer)
        ON DELETE CASCADE
);

-- Table OrderLine
CREATE TABLE order_line (
    id_pizza INT NOT NULL,
    id_size INT NOT NULL,
    id_invoice INT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (id_pizza, id_size, id_invoice),
    CONSTRAINT fk_orderline_pizza FOREIGN KEY (id_pizza)
        REFERENCES pizza(id_pizza),
    CONSTRAINT fk_orderline_size FOREIGN KEY (id_size)
        REFERENCES size(id_size),
    CONSTRAINT fk_orderline_invoice FOREIGN KEY (id_invoice)
        REFERENCES invoice(id_invoice)
);

-- Table Contain (Pizza ↔ Ingredient)
CREATE TABLE contain (
    id_pizza INT NOT NULL,
    id_ingredient INT NOT NULL,
    PRIMARY KEY (id_pizza, id_ingredient),
    CONSTRAINT fk_contain_pizza FOREIGN KEY (id_pizza)
        REFERENCES pizza(id_pizza),
    CONSTRAINT fk_contain_ingredient FOREIGN KEY (id_ingredient)
        REFERENCES ingredient(id_ingredient)
);

-- ==========================
-- Insertion client admin
-- ==========================
INSERT INTO customer (first_name, last_name, email_address, password, wallet, is_admin)
VALUES ('Hassen', 'GHAZEL', 'hassen0805@gmail.com', '123456789', 365, TRUE)
ON CONFLICT (email_address) DO NOTHING;

-- ==========================
-- Insertion ingrédients neutres
-- ==========================
INSERT INTO ingredient (name_ingredient) VALUES
('Tomato'), ('Cheese'), ('Olives')
ON CONFLICT (name_ingredient) DO NOTHING;

-- ==========================
-- Insertion pizza connue : Margherita
-- ==========================
INSERT INTO pizza (name_pizza, price_pizza) VALUES
('Margherita', 8.50)
ON CONFLICT (name_pizza) DO NOTHING;

-- ==========================
-- Lier pizza aux ingrédients
-- ==========================
INSERT INTO contain (id_pizza, id_ingredient)
SELECT p.id_pizza, i.id_ingredient
FROM pizza p, ingredient i
WHERE p.name_pizza = 'Margherita'
ON CONFLICT DO NOTHING;

-- ==========================
-- Insertion tailles
-- ==========================
INSERT INTO size (name_size, coeff) VALUES
('Small', 0.6667),
('Medium', 1.0),
('Large', 1.3333)
ON CONFLICT (name_size) DO NOTHING;