# **Flexcar – Inventory & Promotions Engine (API)**

This project implements an **API-based inventory, cart, and promotions engine** for a B2B e-commerce platform.  
The system supports flexible promotion rules while keeping the data model and pricing logic **simple, explicit, and maintainable**.

---

## **Approach & Design Overview**

The core goal of the design is to **separate responsibilities clearly**:

- **Models** define structure and relationships  
- **Services** handle pricing and promotion logic  
- **Controllers** remain thin and orchestration-only  
- **Rules & actions** make promotions extensible without branching logic explosion  

The system favors **explicit data over implicit assumptions**, especially for weight-based pricing.

---

## **Key Design Decisions**

### **Quantity vs Weight Items**

Items can be sold either by:

- **Quantity** (e.g., shirts, bottles)  
- **Weight** (e.g., grains, dry fruits)  

This is implemented using:

- `Item.unit_type` enum (`quantity`, `weight`)  
- A single `CartItem.quantity` column  

**Interpretation of `quantity`:**

- Quantity items → number of units  
- Weight items → grams (normalized base unit)  

This avoids duplicating columns while keeping logic centralized.

---

### **Categories & Brands**

- Items belong to **one category** and **one brand**  
- Categories are used directly in promotion rules  
- Simple one-to-many relationships were chosen intentionally to avoid unnecessary complexity  

---

### **Promotion Architecture**

Promotions are split into three components:

| Component          | Responsibility                 |
|--------------------|--------------------------------|
| Promotion          | Validity window and type       |
| PromotionRule      | Eligibility conditions         |
| PromotionAction    | Discount logic                 |

This separation enables:

- Category-level or item-level promotions  
- Weight threshold discounts using `min_value`  
- Easy extension for future promotion types  

Only **one promotion can apply per item**, but multiple items in a cart may each receive a promotion.

---

### **Promotion Evaluation Strategy**

- Each cart item is evaluated independently  
- All eligible promotions are considered  
- The **best discount** is selected  
- Evaluation occurs at **item-add time**  

This avoids unnecessary full-cart recalculations.

---

### **API-Only Architecture**

The application is built in **Rails API mode**:

- No views  
- JSON-only responses  
- Versioned endpoints (`/api/v1`)  

This aligns with the B2B platform requirement and keeps the system frontend-agnostic.

---

## **Setup Instructions**

### **Requirements**

- Ruby **3.x**  
- Rails **8**  
- PostgreSQL  

---

## **Project Overview**

**Assumptions Made**

- **Weight** is normalized to grams  
- **Item price** represents price per base unit  
- **Taxes** are intentionally excluded  
- **Cart** belongs to a single logical session/user  
- **Inventory stock management** is out of scope  
- **No authentication or authorization** is included  

---

**Why Certain Choices Were Made**

- **Single quantity column** – avoids schema bloat and keeps promotion logic uniform  
- **Service-based pricing** – keeps controllers simple and testable  
- **Explicit units** – prevents silent pricing bugs  
- **One promotion per item** – avoids unpredictable discount stacking  
- **Rails Omakase RuboCop config** – prioritizes consistency over stylistic debates  

---

**Code Quality**

The project uses **Rubocop** with Rails-approved **Omakase** defaults for style consistency.

To check and auto-correct code style violations, run:

```bash
bundle exec rubocop -A
```

**Installation**

Run the following commands to set up the project:

```bash
# Install Ruby gems
bundle install

# Create the database
rails db:create

# Run migrations
rails db:migrate

# Seed initial data
rails db:seed
```

**Seed Data Includes**

- Brands
- Categories
- Quantity-based and weight-based items
- Sample promotions with rules and actions

**Running the Server**

To start the Rails API server:
```bash
rails server
```
The server will run at:

```bash
http://localhost:3000
```

# API Examples
**1. List of items**

Endpoint
```bash
GET /api/v1/items
```

Response
```json
[
    {
        "active": true,
        "brand_id": 3,
        "category_id": 1,
        "id": 1,
        "name": "Item 1",
        "price": "10.0",
        "unit_type": "weight"
    },
    {
        "active": true,
        "brand_id": 5,
        "category_id": 4,
        "id": 2,
        "name": "Item 2",
        "price": "15.0",
        "unit_type": "quantity"
    }
]
```

**2. Add Item to Cart**

Endpoint
```bash
POST /api/v1/carts/new/cart_items
POST /api/v1/carts/:cart_id/cart_items
```

Payload (quantity-based item)
```json
{
  "item_id": 2,(item ids you can get from above API 1)
  "quantity": 2
}
```

Payload (weight-based item, grams)
```json
{
  "item_id": 3,
  "quantity": 500
}
```

Note: For weight-based items, quantity is interpreted as grams.

**3. View Cart**

Endpoint
```bash
GET /api/v1/carts/:id
```

Response Example
```json

{
  "cart_id": 5,
  "items": [
    {
      "cart_item_id": 4,
      "item_id": 3,
      "name": "Item 3",
      "quantity": 5.0,
      "unit_type": "quantity",
      "final_price": 100.0,
      "applied_promotion": "Buy 2 Get 1 Free"
    },
    {
      "cart_item_id": 6,
      "item_id": 1,
      "name": "Item 1",
      "quantity": 10.0,
      "unit_type": "weight",
      "final_price": 90.0,
      "applied_promotion": null
    }
  ],
  "total_price": 190.0
}


```
**4. Remove Item from Cart**

Endpoint
```bash
DELETE /api/v1/carts/:cart_id/cart_items/:id
```
Response Example
```json
{
  "message": "Item removed from cart"
}
```

# Running Specs

**Run all tests**

```bash
bundle exec rspec
```

**What Is Covered by RSpec**

- View Cart
- Add Item to Cart
- Remove Item from Cart

**Each test verifies**

- Correct HTTP status
- Cart items returned
- Pomotions applied correctly
- Best possible price calculation
- Updated total_price


**Assumptions Made**

- Weight is normalized to grams
- Item price represents price per base unit
- Taxes are intentionally excluded
- Cart belongs to a single logical session/user
- Inventory stock management is out of scope
- No authentication or authorization is included

**Why Certain Choices Were Made**

- Single quantity column – avoids schema bloat and keeps promotion logic uniform
- Service-based pricing – keeps controllers simple and testable
- Explicit units – prevents silent pricing bugs
- One promotion per item – avoids unpredictable discount stacking
- Rails Omakase RuboCop config – prioritizes consistency over stylistic debates

**Conclusion**

This solution prioritizes:

- Clarity over cleverness
- Explicit data over assumptions
- Predictable pricing behavior
- Clean separation of concerns

The system is intentionally designed to be easy to extend without rewriting core pricing logic.

**Final Thoughts**

This project focuses on clean domain modeling, predictable promotion logic, and API clarity rather than UI concerns.

Controllers are thin, business logic lives in services, and data integrity is enforced at the database and model layers.
