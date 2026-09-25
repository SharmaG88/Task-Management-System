const mysql = require('mysql2/promise');
require('dotenv').config();

async function run() {
  try {
    const con = await mysql.createConnection({
      host: process.env.DB_HOST,
      user: process.env.DB_USER,
      password: process.env.DB_PASS
    });
    await con.query(`CREATE DATABASE IF NOT EXISTS \`${process.env.DB_NAME}\`;`);
    console.log('SUCCESS');
    await con.end();
  } catch (e) {
    console.error('ERROR:', e.message);
  }
}
run();
