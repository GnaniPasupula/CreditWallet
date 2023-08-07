const express = require('express');
const router = express.Router();
const mongoose = require('mongoose');

const creditCardSchema = new mongoose.Schema({
  cardNumber: { type: String, required: true },
  limit: { type: Number, required: true },
  outStanding: { type: Number, required: true },
  expiryDate: { type: String, required: true },
  cardName: { type: String, required: true },
  bankName: { type: String, required: true },
});

const CreditCard = mongoose.model('CreditCard', creditCardSchema);

router.post('/add', async (req, res) => {
  const { cardNumber, limit, outStanding,expiryDate, cardName, bankName } = req.body;

    const newCreditCard = new CreditCard({
      cardNumber,
      limit,
      outStanding,
      expiryDate,
      cardName,
      bankName,
    });
  
    try {
      const savedCard = await newCreditCard.save();
      console.log('Credit card saved:', savedCard);
      res.status(201).send(savedCard);
    } catch (err) {
      console.error('Error saving credit card:', err);
      res.status(500).send('Error saving credit card. Please try again.');
    }
  
});

module.exports = router;
module.exports = CreditCard;
