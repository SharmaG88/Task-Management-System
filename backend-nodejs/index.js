const express = require('express');
const cors = require('cors');
require('dotenv').config();
const sequelize = require('./config/database');
const Task = require('./models/Task');

const app = express();

// --- Middlewares ---
app.use(cors()); // Flutter frontend ko is API se connect karne ke liye permission deta hai
app.use(express.json()); // Frontend se aane wale JSON data ko padhne ke liye

// Test Route
app.get('/', (req, res) => {
  res.send('Todo App Backend is Running perfectly!');
});

// --- API Endpoints (CRUD) ---

// 1. GET /tasks (Saare tasks mangwana)
app.get('/tasks', async (req, res) => {
  try {
    const tasks = await Task.findAll(); // MySQL se sab task nikal lo
    res.json(tasks);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching tasks' });
  }
});

// 2. POST /tasks (Naya task banana)
app.post('/tasks', async (req, res) => {
  try {
    const { title, time, isDone } = req.body;
    
    // Naya task database mein insert karna
    const newTask = await Task.create({ title, time, isDone: isDone === 'true' || isDone === true });
    
    res.status(201).json(newTask); 
  } catch (error) {
    res.status(500).json({ message: 'Error creating task' });
  }
});

// 3. PUT /tasks/:id (Task ko update karna - Edit ya Checkbox ke liye)
app.put('/tasks/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { title, time, isDone } = req.body;
    
    const task = await Task.findByPk(id); // Id se purana task dhoondo
    if (!task) return res.status(404).json({ message: 'Task not found' });
    
    // Agar frontend ne nayi value bheji hai, toh usko update karo warna purani rakho
    task.title = title !== undefined ? title : task.title;
    task.time = time !== undefined ? time : task.time;
    if (isDone !== undefined) {
      task.isDone = isDone === 'true' || isDone === true;
    }
    
    await task.save(); // Changes ko MySQL mein save karo
    res.json(task);
  } catch (error) {
    res.status(500).json({ message: 'Error updating task' });
  }
});

// 4. DELETE /tasks/:id (Task ko delete karna)
app.delete('/tasks/:id', async (req, res) => {
  try {
    const { id } = req.params;
    await Task.destroy({ where: { id } }); // Id ke hisaab se row delete karo
    res.json({ message: 'Task deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: 'Error deleting task' });
  }
});

// Database se connect karna aur server start karna
// alter: true ka matlab hai agar database mein koi naya column add hua hai toh wo apne aap adjust ho jayega
sequelize.sync({ alter: true }).then(() => {
  console.log('✅ Database (MySQL) is connected and synced.');
  const PORT = process.env.PORT || 3000;
  app.listen(PORT, () => {
    console.log(`🚀 Server is running on http://localhost:${PORT}`);
  });
}).catch(err => {
  console.error('❌ Failed to connect to MySQL. Ensure MySQL/XAMPP is running.', err.message);
});
