const { Sequelize } = require('sequelize');
require('dotenv').config();

// MySQL database se connection banane ke liye Sequelize ka use kar rahe hain
const sequelize = new Sequelize(
  process.env.DB_NAME, 
  process.env.DB_USER, 
  process.env.DB_PASS, 
  {
    host: process.env.DB_HOST,
    dialect: 'mysql',
    logging: false, // Isse console mein extra SQL commands print nahi hongi (terminal clean rahega)
  }
);

module.exports = sequelize;
