# Full-Stack Todo App - Step-by-Step Instruction Manual

Bhai, yeh manual aapko zero se lekar full-stack app complete karne tak har ek line ka code aur uska logic sikhayega. Hum ise bilkul basic se start karenge.

---

## Step 0: Folder Structure Setup (Monorepo)

Sabse pehle hum apne project ko 2 hisso mein baatenge: Backend (Node.js) aur Frontend (Flutter).

**Terminal Commands:**
```bash
# Apne project folder mein jayein
cd e:\Project

# Backend folder banayein aur usme jayein
mkdir backend
cd backend

# Node.js project initialize karein (-y ka matlab yes to all defaults)
npm init -y

# Wapas bahar aayein
cd ..

# Frontend (Flutter) project banayein
flutter create frontend
```

---

## Step 1: Backend Setup (Node.js + Express)

Ab humara server banayenge jo requests listen karega.

**1. Dependencies Install karein:**
Terminal mein `backend` folder ke andar yeh run karein:
```bash
cd backend
npm install express mysql2 sequelize cors dotenv
```
*   `express`: Web server banane ke liye.
*   `mysql2`: MySQL database se connect hone ka driver.
*   `sequelize`: ORM jo JS ko SQL mein convert karega.
*   `cors`: Security feature, taaki Flutter frontend hamare backend API ko call kar sake.
*   `dotenv`: Secrets (password) hide rakhne ke liye.

**2. `index.js` (Server ki starting file) banayein:**
`backend/index.js` naam ki file banayein aur yeh code likhein:

```javascript
// Express framework import kar rahe hain
const express = require('express');
// CORS import kar rahe hain cross-origin requests allow karne ke liye
const cors = require('cors'); 

// Express app initialize kar rahe hain
const app = express();
const PORT = 3000;

// Middleware setup
app.use(cors()); // Flutter ko allow karega
app.use(express.json()); // JSON format ka data receive karne ke liye

// Ek basic route testing ke liye
app.get('/test', (req, res) => {
    // Jab koi /test par aayega, toh yeh JSON response jayega
    res.json({ message: "Bhai, Server bilkul mast chal raha hai!" });
});

// Server ko start karte hain
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
```
*Run karein:* `node index.js`. Browser mein `http://localhost:3000/test` open karke check karein.

---

## Step 2: Database & Models (MySQL + Sequelize)

Ab hum MySQL se connect karenge aur apne Tables banayenge.

**1. Database Configuration:**
Ek file banayein `backend/config/db.js`:
```javascript
const { Sequelize } = require('sequelize');

// Sequelize connection string: 'database', 'username', 'password'
const sequelize = new Sequelize('todo_db', 'root', '', {
    host: 'localhost',
    dialect: 'mysql' // Hum bata rahe hain ki database MySQL hai
});

// Check karte hain connection successful hai ya nahi
sequelize.authenticate()
    .then(() => console.log('Database connected successfully.'))
    .catch((err) => console.log('Database error:', err));

module.exports = sequelize;
```

**2. Task Table (Model) banayein:**
Ek file banayein `backend/models/Task.js`:
```javascript
const { DataTypes } = require('sequelize');
// Upar wali db.js file se connection laye hain
const sequelize = require('../config/db'); 

// Task Model define kar rahe hain
const Task = sequelize.define('Task', {
    // Title column
    title: {
        type: DataTypes.STRING,
        allowNull: false // Yeh empty nahi ho sakta
    },
    startTime: {
        type: DataTypes.DATE,
        allowNull: false
    },
    endTime: {
        type: DataTypes.DATE,
        allowNull: false
    },
    status: {
        type: DataTypes.ENUM('active', 'done'),
        defaultValue: 'active' // By default naya task active rahega
    }
});

module.exports = Task;
```
*(Yahan humne User table abhi skip ki hai taaki aap pehle Tasks par focus karke CRUD seekh sakein, baad mein hum auth aur relation jodne ka seekhenge).*

---

## Step 3: API Routes (Frontend se baat karne ka raasta)

Ab hum endpoints banayenge jinhe Flutter call karega.
Ek file banayein `backend/routes/taskRoutes.js`:

```javascript
const express = require('express');
const router = express.Router();
const Task = require('../models/Task'); // Task Model import kiya

// GET: Saare tasks fetch karna
router.get('/', async (req, res) => {
    try {
        // Sequelize database se saare tasks nikal layega (SELECT * FROM Tasks)
        const tasks = await Task.findAll(); 
        res.json(tasks); // Flutter ko wapas JSON bhej dega
    } catch (error) {
        res.status(500).json({ error: 'Server mein kuch issue hai' });
    }
});

// POST: Naya task create karna
router.post('/', async (req, res) => {
    try {
        // Flutter jo data bhejeha wo req.body mein hoga
        const { title, startTime, endTime } = req.body;
        
        // Sequelize us data ko table mein save kar dega (INSERT INTO...)
        const newTask = await Task.create({ title, startTime, endTime });
        
        // Success code 201 aur naya task wapas bhejenge
        res.status(201).json(newTask); 
    } catch (error) {
        res.status(400).json({ error: 'Data save nahi hua' });
    }
});

module.exports = router;
```

Ab is `taskRoutes.js` ko apne `index.js` mein add kijiye:
```javascript
// index.js mein app.use(express.json()) ke baad add karein:
const taskRoutes = require('./routes/taskRoutes');
const sequelize = require('./config/db');

// /api/tasks se start hone wale sabhi requests taskRoutes handle karega
app.use('/api/tasks', taskRoutes);

// Server start karne se pehle Tables create karte hain (Sync)
sequelize.sync().then(() => {
    console.log("Database tables synchronized.");
});
```

---

## Step 4: Frontend (Flutter HTTP Integration)

Ab hum Flutter ko Node.js se connect karna seekhenge.

**1. http package install karein:**
```bash
cd frontend
flutter pub add http
```

**2. API Service File (`frontend/lib/services/api_service.dart`)**
Flutter mein JSON bhejna aur padhna seekhein:

```dart
import 'dart:convert'; // JSON ko encode/decode karne ke liye
import 'package:http/http.dart' as http;

class ApiService {
  // Aapke Node.js server ka URL (Emulator par 10.0.2.2 ya apne IP ka use karein)
  static const String baseUrl = 'http://localhost:3000/api/tasks';

  // GET Request (Tasks lana)
  Future<List<dynamic>> fetchTasks() async {
    // Server ko hit kiya
    final response = await http.get(Uri.parse(baseUrl));

    // Agar status 200 (OK) hai
    if (response.statusCode == 200) {
      // JSON data ko Dart List mein convert karke return kar diya
      return json.decode(response.body); 
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  // POST Request (Naya task save karna)
  Future<void> addTask(String title, String startTime, String endTime) async {
    await http.post(
      Uri.parse(baseUrl),
      // Server ko bata rahe hain ki hum JSON bhej rahe hain
      headers: {'Content-Type': 'application/json'},
      // Dart Map ko JSON String mein convert kiya `jsonEncode` se
      body: jsonEncode({
        'title': title,
        'startTime': startTime,
        'endTime': endTime,
      }),
    );
  }
}
```

---

### Aapka Agla Kadam!
Bhai, aap is manual ko step-by-step follow kijiye.
**Start with Step 1**: Apna Node.js server locally run karke dekhiye ki "Bhai, Server bilkul mast chal raha hai!" aata hai ya nahi. 
Jab yahan tak pahonch jayein, toh mujhe batana, fir hum Flutter ke bache huye UI parts complete karenge!
