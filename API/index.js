require("dotenv").config()
const express = require('express');
const session = require('express-session');
const creditCardRouter = require('./creditCard'); 
const mongoose = require('mongoose');
const cors = require('cors'); 

mongoose.connect(process.env.MONGO_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
}).then(() => {
  console.log('Connected to MongoDB');
  startServer();
}).catch((err) => {
  console.error('Error connecting to MongoDB', err);
});

function startServer() {
  const app = express();

  app.use(express.json());
  app.use(session({
    secret: 'cats', 
    resave: false,
    saveUninitialized: true
  }));

  app.use(cors())

  app.use('/creditCard', creditCardRouter); 

  app.get('/', (req, res) => {
    res.redirect('/creditCard/get');
  });

  const PORT = process.env.PORT || 3000;

  app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
  });

}