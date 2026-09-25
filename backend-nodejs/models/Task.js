const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

// 'Task' table ka structure (schema) define kar rahe hain jo MySQL mein banegi
const Task = sequelize.define('Task', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  title: {
    type: DataTypes.STRING,
    allowNull: false, // Task ka naam khali nahi ho sakta
  },
  time: {
    type: DataTypes.STRING,
    allowNull: false, // Time bhi zaroori hai
  },
  isDone: {
    type: DataTypes.BOOLEAN,
    defaultValue: false, // Naya task hamesha incomplete rahega
  }
});

module.exports = Task;
