# Backend & Database Architecture (Node.js + MySQL)

Yeh document aapke Todo App ke custom backend aur database architecture ko explain karta hai. Humne decide kiya hai ki hum MySQL (Relational Database) use karenge taaki aap tables aur relations banane ke concepts deeply seekh saken.

## 1. Tech Stack (Backend)
- **Runtime:** Node.js
- **Framework:** Express.js (REST APIs ke liye)
- **Database:** MySQL (Relational DB)
- **ORM (Object Relational Mapping):** Sequelize (JavaScript objects se MySQL query karne ke liye)
- **Authentication:** Firebase Auth (Sirf token generation ke liye, actual user data MySQL mein rahega)

## 2. API Endpoints (Flutter to Node.js)
Flutter app (Frontend) in endpoints par HTTP requests bhejjegi:

- **`POST /api/auth/login`**: Agar user naya hai toh MySQL mein insert karega, warna existing user fetch karega.
- **`GET /api/tasks`**: Logged-in user ke saare tasks lake dega (SELECT query).
- **`POST /api/tasks`**: Ek naya task banayega (INSERT query).
- **`PUT /api/tasks/:id`**: Task ko update karega (UPDATE query).
- **`DELETE /api/tasks/:id`**: Task ko delete karega (DELETE query).

## 3. MySQL Schema (Sequelize Models)

Humare database mein 2 Tables banengi aur unke beech ek **One-to-Many Relationship** (1 User -> Many Tasks) hoga.

### A. Users Table (`models/User.js`)
```javascript
const User = sequelize.define('User', {
  id: { type: DataTypes.STRING, primaryKey: true }, // Google Auth UID
  email: { type: DataTypes.STRING, allowNull: false },
  displayName: { type: DataTypes.STRING },
  photoUrl: { type: DataTypes.STRING }
});
```

### B. Tasks Table (`models/Task.js`)
```javascript
const Task = sequelize.define('Task', {
  id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  title: { type: DataTypes.STRING, allowNull: false },
  startTime: { type: DataTypes.DATE, allowNull: false },
  endTime: { type: DataTypes.DATE, allowNull: false },
  status: { type: DataTypes.ENUM('active', 'done'), defaultValue: 'active' },
  // Note: Sequelize automatically ek `UserId` foreign key add kar dega.
});
```

## 4. The "Late" Task Logic
Cost bachane aur server par load kam karne ke liye hum late hone ka logic **Frontend (Flutter)** par hi handle karenge.
1. MySQL mein task hamesha `'active'` status ke sath save hoga.
2. Jab Flutter app tasks display karegi, toh wo check karegi: `if (currentTime > task.endTime && task.status === 'active')`.
3. Agar yeh true hai, toh UI us task ko **Late (Red)** dikhayega.
4. "Mark as To Do" dabane par time aage badh jayega.

## 5. Folder Structure (Monorepo)
Kyunki ab Frontend aur Backend alag hain, humara project folder kuch aisa dikhega:

```text
e:\Project\
 ┣ backend/          # Yahan Node.js, Express, aur MySQL Sequelize models honge
 ┃ ┣ models/
 ┃ ┣ routes/
 ┃ ┣ controllers/
 ┃ ┗ index.js
 ┃
 ┣ frontend/         # Yahan Flutter app hogi
 ┃ ┣ lib/
 ┃ ┗ pubspec.yaml
 ┃
 ┗ README.md
```

Is documentation ko reference karke aap step-by-step apna Full-Stack Todo app bana sakte hain.
