# Backend & Database Architecture (Node.js + MySQL) - In-Depth Guide

Yeh document aapke Todo App ke custom backend aur database architecture ko detail mein explain karta hai. Kyunki aapka goal "seekhna aur samajhna" hai, isliye is document mein hum sirf code nahi, balki unke peeche ka **logic aur reason** samjhenge.

---

## 1. The Full-Stack Flow (System kaam kaise karega?)
Ek full-stack application mein data ka safar (journey) kuch is tarah hota hai:
1. **Frontend (Flutter):** User button dabata hai (e.g. "Save Task"). Flutter ek **HTTP POST Request** banata hai jisme task ka data JSON format mein hota hai.
2. **API Endpoint (Express.js Route):** Node.js server us request ko receive karta hai kisi specific URL (jaise `/api/tasks`) par.
3. **Controller Logic:** Server data ko check karta hai (validation) ki title khali toh nahi hai.
4. **ORM (Sequelize):** Controller Sequelize ko command deta hai: `Task.create(...)`.
5. **Database (MySQL):** Sequelize us JavaScript command ko ek SQL query (`INSERT INTO tasks...`) mein convert karta hai aur MySQL database mein save kar deta hai.
6. **Response:** Database success ka message deta hai, aur Node.js wapas Flutter ko ek **HTTP Response (Status 201 Created)** bhejta hai. Flutter UI ko update kar deta hai.

---

## 2. Tech Stack & unka Asli Kaam (Why are we using them?)

- **Node.js (Runtime):** JavaScript browser ke bahar run nahi hoti thi. Node.js ne JS ko server par run karne ki taqat di. Hum ise isliye use kar rahe hain taaki hum backend logic likh sakein.
- **Express.js (Framework):** Node.js mein API URLs (Routes) handle karna thoda complex hota hai. Express ek "web framework" hai jo HTTP requests (`GET`, `POST`, `PUT`, `DELETE`) ko asani se handle karta hai.
- **MySQL (Database):** Yeh ek Relational Database Management System (RDBMS) hai. Iska matlab data ko proper Tables (Rows aur Columns) mein save kiya jata hai. Hum isme Relations (jaise "Ek user ke bohot se tasks") design karna seekhenge.
- **Sequelize (ORM):** ORM ka matlab hai *Object-Relational Mapping*. Agar hum ORM na use karein, toh humein Node.js mein lambi lambi SQL queries string format mein likhni padengi (`"SELECT * FROM users WHERE id = 1"`). Sequelize ke sath, hum sirf JS objects aur functions use karte hain (`User.findAll({ where: { id: 1 } })`), aur Sequelize khud usko SQL mein convert kar leta hai. Isse code clean rehta hai aur SQL injection attacks se bachat hoti hai.

---

## 3. Detailed MySQL Schema (Sequelize Models)

Humare database mein 2 Tables banengi aur unke beech ek **One-to-Many Relationship** (1 User -> Many Tasks) setup hoga.

### A. Users Table (`models/User.js`)
Is table mein har user ki profile details rahengi.
```javascript
const User = sequelize.define('User', {
  id: { 
    type: DataTypes.STRING, 
    primaryKey: true // Primary Key ka matlab yeh har user ka unique ID hoga (Firebase UID)
  }, 
  email: { 
    type: DataTypes.STRING, 
    allowNull: false, // User ka email khali (null) nahi ho sakta
    unique: true      // Do users ka same email nahi ho sakta
  },
  displayName: { type: DataTypes.STRING }, // e.g. "Rahul Sharma"
  photoUrl: { type: DataTypes.STRING }     // Profile picture link
});
```

### B. Tasks Table (`models/Task.js`)
Is table mein tasks ka data rahega.
```javascript
const Task = sequelize.define('Task', {
  id: { 
    type: DataTypes.INTEGER, 
    primaryKey: true, 
    autoIncrement: true // Jab bhi naya task banega, ID apne aap 1, 2, 3.. badh jayegi
  },
  title: { type: DataTypes.STRING, allowNull: false },
  startTime: { type: DataTypes.DATE, allowNull: false }, // MySQL ka DATETIME datatype
  endTime: { type: DataTypes.DATE, allowNull: false },
  status: { 
    type: DataTypes.ENUM('active', 'done'), // ENUM ka matlab sirf in do values mein se ek hi save ho sakti hai
    defaultValue: 'active' 
  },
});
```

**Relation Setup:**
`User.hasMany(Task)` aur `Task.belongsTo(User)` likhne se, Sequelize apne aap `Tasks` table mein ek naya column bana dega jiska naam hoga `UserId`. Yeh **Foreign Key** banega, jo task ko uske malik (User) se connect karega.

---

## 4. API Architecture Pattern (MVC Pattern)
Hum apne backend code ko saaf rakhne ke liye **MVC (Model-View-Controller)** pattern follow karenge:
- **Models:** Database ka structure (`User.js`, `Task.js`).
- **Routes:** API URLs define karna (e.g., `router.post('/tasks')`).
- **Controllers:** Actual logic likhna (Database se data nikal kar Flutter ko bhejte waqt kya hoga).

---

## 5. Folder Structure (Monorepo in details)

Aapka main project folder (`e:\Project`) aise divide hoga taaki Frontend aur Backend aapas mein takrayein nahi:

```text
e:\Project\
 ┣ backend/          # Node.js Project (npm init)
 ┃ ┣ config/         # MySQL database connection ka setup
 ┃ ┣ models/         # User aur Task tables (Sequelize)
 ┃ ┣ routes/         # API URLs (e.g. taskRoutes.js)
 ┃ ┣ controllers/    # API ka logic (e.g. taskController.js)
 ┃ ┣ .env            # Secret keys (Database password, Port numbers)
 ┃ ┗ index.js        # Server ki starting file
 ┃
 ┣ frontend/         # Flutter App (flutter create)
 ┃ ┣ lib/
 ┃ ┃ ┣ models/       # Flutter mein JSON ko object banani wali class
 ┃ ┃ ┣ screens/      # UI files
 ┃ ┃ ┗ services/     # http package se backend ko call karne wali files
 ┃ ┗ pubspec.yaml
 ┃
 ┗ README.md
```

Isko refer karke jab hum code karenge, toh aapko exact pata hoga ki kaunsi file kis folder mein ja rahi hai aur uska wahan hone ka kya logic hai!
