const express = require('express');
const router = express.Router();
const CreditCard = require('../Models/creditCard'); // Import the CreditCard schema
const bodyParser = require('body-parser'); // Import body-parser
const app = express();

app.use(bodyParser.json());
// Add credit card
router.post('/add', async (req, res) => {
  const { cardNumber, limit, outStanding, expiryDate, cardName, bankName } = req.body;

  const userId = req.user.userId; // Extracted from the JWT token

  // Create a new credit card document
  const newCreditCard = new CreditCard({
    cardNumber,
    limit,
    outStanding,
    expiryDate,
    cardName,
    bankName,
    user: userId,
  });

  try {
    const savedCard = await newCreditCard.save();
    console.log('Credit card saved:', savedCard);
    res.status(201).json(savedCard);
  } catch (err) {
    console.error('Error saving credit card:', err);
    res.status(500).send('Error saving credit card. Please try again.');
  }
});

// Get credit cards
router.get('/get', async (req, res) => {
  const userId = req.user.userId; // Extracted from the JWT token
  // console.log(userId+" userId");
  try {
    const creditCards = await CreditCard.find({ user: userId });
    res.json(creditCards);
  } catch (err) {
    console.error('Error getting credit cards:', err);
    res.status(500).send('Error getting credit cards. Please try again.');
  }
});


// Update credit card with cardNumber
router.put('/update/:cardNumber', async (req, res) => {
  const { cardNumber } = req.params;
  const { limit, outStanding, expiryDate, cardName, bankName } = req.body;
  const userId = req.user.userId; // Extracted from the JWT token

  try {
    const updatedCard = await CreditCard.findOneAndUpdate(
      { cardNumber, user: userId }, // Use both cardNumber and userId to find the document
      {
        limit,
        outStanding,
        expiryDate,
        cardName,
        bankName,
      },
      { new: true } // Return the updated document
    );
    console.log('Credit card updated:', updatedCard);
    res.status(200).json(updatedCard);
  } catch (err) {
    console.error('Error updating credit card:', err);
    res.status(500).send('Error updating credit card. Please try again.');
  }
});

// Delete credit card with cardNumber
router.delete('/delete/:cardNumber', async (req, res) => {
  const { cardNumber } = req.params;
  const userId = req.user.userId; // Extracted from the JWT token

  try {
    const deletedCard = await CreditCard.findOneAndDelete({
      cardNumber,
      user: userId,
    }); // Use both cardNumber and userId to find the document
    console.log('Credit card deleted:', deletedCard);
    res.status(200).send(deletedCard);
  } catch (err) {
    console.error('Error deleting credit card:', err);
    res.status(500).send('Error deleting credit card. Please try again.');
  }
});

// Add transaction amount to already existing outstanding balance with cardNumber
router.put('/addTransaction/:cardNumber', async (req, res) => {
  const { cardNumber } = req.params;
  const { transactionAmount,transactionTitle,transactionCategory,transactionDate , transactionNote } = req.body;
  const userId = req.user.userId; // Extracted from the JWT token

  try {
    const updatedCard = await CreditCard.findOneAndUpdate(
      { cardNumber, user: userId },
      {
        $inc: { outStanding: transactionAmount  },
        $push: { transactions: { amount:transactionAmount,title:transactionTitle,category:transactionCategory,date:transactionDate,note:transactionNote } }, // Include all transaction details
      },
      { new: true }
    );

    console.log('Credit card updated:', updatedCard);
    res.status(201).json({
      transactionDate: transactionDate,
      transactionAmount: transactionAmount,
      transactionTitle: transactionTitle,
      transactionCategory: transactionCategory,
      transactionNote: transactionNote,
    });
    } catch (err) {
    console.error('Error updating credit card:', err);
    res.status(500).send('Error updating credit card. Please try again.');
  }
});

// Delete a transaction from a credit card
router.delete('/transactions/:cardNumber/:transactionDate', async (req, res) => {
  const { cardNumber, transactionDate } = req.params;
  const userId = req.user.userId;

  try {
    const updatedCard = await CreditCard.findOneAndUpdate(
      { cardNumber, user: userId },
      { $pull: { transactions: { date: transactionDate } } },
      { new: true }
    );

    console.log('Credit card updated:', updatedCard);
    res.status(200).json(updatedCard);
  } catch (err) {
    console.error('Error updating credit card:', err);
    res.status(500).send('Error updating credit card. Please try again.');
  }
});


// Get all transactions of a specific credit card
router.get('/transactions/:cardNumber', async (req, res) => {
  const { cardNumber } = req.params;
  const userId = req.user.userId; // Extracted from the JWT token

  try {
    const creditCard = await CreditCard.findOne({ cardNumber, user: userId });
    if (!creditCard) {
      return res.status(404).send('Credit card not found');
    }

    res.status(200).json(creditCard.transactions);
  } catch (err) {
    console.error('Error getting credit card transactions:', err);
    res.status(500).send('Error getting credit card transactions. Please try again.');
  }
});

// Get all transactions of a specific user
router.get('/transactions/', async (req, res) => {
  const userId = req.user.userId; // Extracted from the JWT token

  try {
    // console.log('Fetching transactions for user ID:', userId);

    const creditCards = await CreditCard.find({ user: userId }).populate('transactions');
    if (!creditCards) {
      console.log('Credit cards not found for user ID:', userId);
      return res.status(404).send('Credit cards not found');
    }

    const allTransactions = creditCards.flatMap(creditCard => creditCard.transactions);

    // console.log('Found credit cards and transactions for user ID:', userId);
    res.status(200).json(allTransactions);
  } catch (err) {
    console.error('Error getting transactions:', err);
    res.status(500).send('Error getting transactions. Please try again.');
  }
});




module.exports = router;
