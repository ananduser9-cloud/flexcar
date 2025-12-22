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

### **1. Quantity vs Weight Items**

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

### **2. Explicit Units for Weight Pricing**

To avoid ambiguity (grams vs kilograms), weight-based items store:

- `unit` (e.g., `gram`, `kg`)  

Pricing is **normalized internally to grams**, ensuring:

- Consistent promotion evaluation  
- Predictable pricing calculations  

---

### **3. Categories & Brands**

- Items belong to **one category** and **one brand**  
- Categories are used directly in promotion rules  
- Simple one-to-many relationships were chosen intentionally to avoid unnecessary complexity  

---

### **4. Promotion Architecture**

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

### **5. Promotion Evaluation Strategy**

- Each cart item is evaluated independently  
- All eligible promotions are considered  
- The **best discount** is selected  
- Evaluation occurs at **item-add time**  

This avoids unnecessary full-cart recalculations.

---

### **6. API-Only Architecture**

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

### **Installation**

```bash
bundle install
rails db:create
rails db:migrate
rails db:seed
