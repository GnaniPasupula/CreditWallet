import 'package:flutter/material.dart';
import 'api_helper.dart';
import 'credit_card_data.dart';
import 'credit_card_form.dart'; 
import 'package:intl/intl.dart';

class CreditCardScreen extends StatefulWidget {
  @override
  _CreditCardScreenState createState() => _CreditCardScreenState();
}

class _CreditCardScreenState extends State<CreditCardScreen> {
  List<CreditCardData> creditCards = [];
  late PageController _pageController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentIndex);
    _fetchCreditCardData();
  }

   void onPageChanged(int newIndex) {
    setState(() {
      currentIndex = newIndex;
      print('current index is $currentIndex');
    });
  }

  Future<void> _fetchCreditCardData() async {
    try {
      final List<CreditCardData> cards = await ApiHelper.fetchCreditCardData();
      setState(() {
        creditCards = cards;
      });
    } catch (e) {
      print(e);
      // Handle error and show a proper error message to the user
    }
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Credit Card Data'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return CreditCardForm(); // Show the credit card form as a bottom sheet
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.black, width: 1.5),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '+',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8), // Add spacing between buttons
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // Add your delete button functionality here
                      final deletedCard = await ApiHelper.deleteCreditCard(creditCards[currentIndex].cardNumber);
                      if (deletedCard != null) {
                        setState(() {
                          creditCards.removeAt(currentIndex);
                        });
                      }

                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.black, width: 1.5),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: (MediaQuery.of(context).size.width * 0.63) - 16,
                child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: creditCards.length,
                  onPageChanged: onPageChanged,
                  itemBuilder: (context, index) {
                    final card = creditCards[index];
                    String getCardType(String cardNumber) {
                    if (cardNumber.startsWith('4')) {
                      return 'VISA';
                    } else if (cardNumber.startsWith('5')) {
                      return 'MasterCard';
                    } else if (cardNumber.startsWith('3')) {
                      return 'AMERICANEXPRESS';
                    } else if (cardNumber.startsWith('6')) {
                      return 'RuPay';
                    } else {
                      return 'Unknown';
                    }
                  }
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              
                                Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          card.bankName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          card.cardNumber,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Text(getCardType(card.cardNumber)),
                                  ],
                                ),                        
                              Spacer(), // Vertically center the following elements
                              Text(
                                'Spent',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                '\$${card.outStanding.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              Row(
                                children: [
                                  Text(
                                    card.cardName,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Spacer(),
                                  Text(
                                    'Balance:\$${card.limit-card.outStanding}'
                                  )
                                ],
                              )
                            
                              
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - ((MediaQuery.of(context).size.width * 0.85)), // Adjust the height as needed
            child: ListView.builder(
              itemCount: creditCards.isNotEmpty ? creditCards[currentIndex].transactions.length : 0,
              itemBuilder: (context, transactionIndex) {
                final transaction = creditCards[currentIndex].transactions[transactionIndex];

                final now = DateTime.now();
                final transactionDate = transaction.date;
                String formattedDate;

                if (transactionDate.year == now.year &&
                    transactionDate.month == now.month &&
                    transactionDate.day == now.day) {
                  // Show time in 12hr format if it's today
                  formattedDate = DateFormat.jm().format(transactionDate);
                } else if (transactionDate.year == now.year &&
                    transactionDate.month == now.month &&
                    transactionDate.day == now.day - 1) {
                  // Show "Yesterday" if it's yesterday
                  formattedDate = 'Yesterday';
                } else {
                  // Show date in the format "day Month"
                  formattedDate = DateFormat('d MMM').format(transactionDate);
                }

                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      // You can replace this with the actual picture data
                      child: Icon(Icons.account_balance_wallet),
                      radius: 16,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          transaction.category,
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${transaction.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          formattedDate,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),       
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CreditCardScreen(),
  ));
}
