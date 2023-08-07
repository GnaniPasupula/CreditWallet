const express = require('express');
const session = require('express-session');
const passport = require('passport');
const authRouter = require('./auth');
const creditCardRouter = require('./creditCard'); 
const mongoose = require('mongoose');
const { ensureAuthenticated } = require('./Middleware/authMiddleware'); 
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
  app.use(passport.initialize());
  app.use(passport.session());

  app.use('/auth', authRouter);
  app.use('/creditCard', creditCardRouter); 

  app.get('/', (req, res) => {
    if(req.isAuthenticated()){
      res.redirect('/creditCard/get');
    }else{
      res.send('<a href="/auth/google">Authenticate with Google</a>');
    }
  });

  const PORT = process.env.PORT || 3000;

  app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
  });

}