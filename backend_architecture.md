# Backend & Database Architecture (Node.js + MongoDB)

Yeh document aapke Todo App (Google Calendar Style) ke custom backend aur database architecture ko detail mein explain karta hai. Humne Firebase Database ki jagah Node.js aur MongoDB use karne ka decision liya hai, jisse aap proper Full-Stack development seekh saken.

## 1. Tech Stack (Backend)
- **Runtime:** Node.js
- **Framework:** Express.js (REST APIs banane ke liye)
- **Database:** MongoDB (Mongoose ODM ke through)
- **Authentication:** Firebase Auth (Sirf login manage karne aur UID generate karne ke liye, baki data MongoDB mein jayega)

## 2. API Endpoints (Flutter to Node.js)
Flutter app ab direct database se baat nahi karegi. Uski jagah wo in APIs par HTTP requests bhejjegi:

- **`POST /api/auth/login`**: User verify karke MongoDB mein save karega agar naya user hai.
- **`GET /api/tasks`**: Logged-in user ke saare tasks lake dega.
- **`POST /api/tasks`**: Ek naya task banayega.
- **`PUT /api/tasks/:id`**: Task ko update karega (jaise Done mark karna).
- **`DELETE /api/tasks/:id`**: Task ko database se delete karega.

## 3. MongoDB Schema (Data Structure)

Humare backend mein do main Mongoose models banenge:

### A. User Model
```javascript
const userSchema = new mongoose.Schema({
  uid: { type: String, required: true, unique: true }, // Firebase UID
  email: { type: String, required: true },
  displayName: String,
  photoUrl: String,
}, { timestamps: true });
```

### B. Task Model
```javascript
const taskSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  title: { type: String, required: true },
  startTime: { type: Date, required: true },
  endTime: { type: Date, required: true },
  status: { type: String, enum: ['active', 'done'], default: 'active' },
}, { timestamps: true });
```

## 4. The "Late" Task Logic
Server (Node.js) par background job (Cron) chalane se bachne ke liye, hum "Late" hone ka logic abhi bhi **Frontend** par hi handle karenge.
1. MongoDB mein task hamesha `"active"` state mein save hoga.
2. Jab Flutter app tasks fetch karegi (`GET /api/tasks`), toh UI mein check hoga: `if (current_time > task.endTime && task.status === 'active')`.
3. Agar true hai, toh Flutter us task ko Red (Late) mark karke dikhayega.

## 5. Folder Structure (Monorepo)
Kyunki ab humare paas Frontend aur Backend dono hain, aapka main project folder (`e:\Project`) aise divide hoga:

```text
e:\Project\
 ┣ backend/          # Yahan Node.js, Express, aur MongoDB models ka code hoga
 ┃ ┣ models/
 ┃ ┣ routes/
 ┃ ┣ controllers/
 ┃ ┗ index.js
 ┃
 ┣ frontend/         # Yahan aapki Flutter app (my_todo_app) banegi
 ┃ ┣ lib/
 ┃ ┗ pubspec.yaml
 ┃
 ┗ README.md
```

---
*Tip: Aap is file ko git par commit kar sakte hain taaki naya architecture save ho jaye.*
