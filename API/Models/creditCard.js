const mongoose = require('mongoose');

const creditCardSchema = new mongoose.Schema({
  cardNumber: { type: String, required: true },
  limit: { type: Number, required: true },
  outStanding: { type: Number, required: true },
  expiryDate: { type: String, required: true },
  cardName: { type: String, required: true },
  bankName: { type: String, required: true },
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  transactions: [
    {
      date: { type: Date, default: Date.now },
      amount: { type: Number, required: true },
      title: {type:String , default: "Unknown"},
      category:{type: String, default: "Unknown"}
    },
  ],
});

module.exports = mongoose.model('CreditCard', creditCardSchema);
