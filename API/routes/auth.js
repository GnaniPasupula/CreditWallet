const express = require('express');
const bcrypt = require('bcrypt');
const User = require('../Models/User');

const router = express.Router();

router.post('/signup', async (req, res) => {
  try {
    const { email, password } = req.body;

    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ message: 'Email already exists' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const newUser = new User({ email, password: hashedPassword });
    await newUser.save();

    res.status(201).json({ message: 'User registered successfully' });
  } catch (error) {
    res.status(500).json({ message: 'An error occurred' });
  }
});

router.post('/signin', async (req, res) => {
    try {
      const { email, password } = req.body;
    
      const user = await User.findOne({ email });
    //   console.log('User from database:', user);
  
      if (!user) {
        return res.status(401).json({ message: 'User doesn\'t exist' });
      }
  
    //   console.log('Provided password:', password);
    //   console.log('Stored hashed password:', user.password);
  
      const isPasswordValid = await bcrypt.compare(password, user.password);
    //   console.log('Password comparison result:', isPasswordValid);
  
      if (!isPasswordValid) {
        return res.status(401).json({ message: 'Invalid email or password' });
      }
  
      req.session.user = user;
      res.status(200).json({ message: 'Signin successful' });
    } catch (error) {
      console.error('Error:', error);
      res.status(500).json({ message: 'An error occurred' });
    }
});
  
  

module.exports = router;
