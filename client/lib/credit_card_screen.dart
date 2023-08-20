import 'package:client/spend_dialog.dart';
import 'package:flutter/material.dart';
import 'analytics_screen.dart';
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
  bool _isSpendDialogVisible = false;
  static const int _searchTabIndex = 0;
  static const int _analyticsTabIndex = 1;

  int _currentIndex = _searchTabIndex; // Initial index



  final Map<String, IconData> categoryIcons = {
    'Fashion': Icons.shopping_bag_outlined,
    'Food': Icons.restaurant_outlined,
    'Health': Icons.local_hospital_outlined,
    'Fuel': Icons.local_gas_station_outlined,
    'Travel': Icons.flight_outlined,
    'Entertainment': Icons.movie_filter,
    'EMI': Icons.attach_money_outlined,
    'Bills': Icons.receipt_long_outlined,
    'Others': Icons.category_outlined,
  };

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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Dashboard',
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              // Handle notification icon press
            },
            icon: Icon(Icons.notifications),
          ),
        ],
      ),
      body: Stack ( children:[ Column(
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
                          return CreditCardForm(
                            onCardAdded: () {
                              if(currentIndex<0){
                                currentIndex++;
                              }
                              _fetchCreditCardData(); // Update the creditCards list
                            },
                            isEditing: false,
                          ); // Show the credit card form as a bottom sheet
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
                      child: Icon(Icons.add,
                      color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                        final updatedCreditCard = await showModalBottomSheet<CreditCardData?>(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return CreditCardForm(
                            onCardAdded: () {
                              _fetchCreditCardData(); // Update the creditCards list
                            },
                            isEditing: true,
                            creditCard: creditCards[currentIndex]
                          ); // Show the credit card form as a bottom sheet
                        },
                      );
                        if (updatedCreditCard != null) {
                          setState(() {
                            // Update the credit card data in your list with the updated data
                            creditCards[currentIndex] = updatedCreditCard;
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
                      child: Icon(Icons.edit,
                      color: Colors.black,
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
                          if (currentIndex == creditCards.length) {
                            currentIndex--;
                          }
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
                      child: Icon(Icons.delete,
                      color: Colors.black,
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
                child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: creditCards.length,
                  onPageChanged: onPageChanged,
                  itemBuilder: (context, index) {
                    final card = creditCards[index];

                    LinearGradient cardGradient;

                    if (card.cardNumber.startsWith('4')) {
                      cardGradient = LinearGradient(
                        colors: [Color(0xffde6262), Color(0xffffb88c)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      );
                    } else if (card.cardNumber.startsWith('5')) {
                      cardGradient = LinearGradient(
                        colors: [Colors.blueAccent, Colors.indigo],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      );
                    } else if (card.cardNumber.startsWith('3')) {
                      cardGradient = LinearGradient(
                        colors: [Color(0xff7bc393), Color(0xff31b7c2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      );
                    } else if (card.cardNumber.startsWith('6')) {
                      cardGradient = LinearGradient(
                        colors: [Color(0xffffa31d), Color(0xffef5454)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      );
                    } else {
                      cardGradient = LinearGradient(
                        colors: [Color(0xffcc2b5e), Color(0xff753a88)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      );
                    }          
                    Widget  getCardType(String cardNumber) {
                      if (cardNumber.startsWith('4')) {
                        return Image.asset('../web/icons/visa.png', width: 28, height: 28); 
                      } else if (cardNumber.startsWith('5')) {
                        return Image.asset('../web/icons/mastercard.png', width: 36, height: 36); 
                      } else if (cardNumber.startsWith('3')) {
                        return Image.asset('../web/icons/amex.png', width: 36, height: 36); 
                      } else if (cardNumber.startsWith('6')) {
                        return Image.asset('../web/icons/rupay.png', width: 36, height: 36);
                      } else {
                        return Image.asset('../web/icons/mastercard.png', width: 36, height: 36); 
                      }
                  }
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: Colors.transparent, // Set color to transparent to allow gradient to show
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: cardGradient, // Set the determined gradient here
                          ),
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
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          card.cardNumber,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14
                                          )                                              
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    // Text(
                                    //   getCardType(card.cardNumber),
                                    //   style: const TextStyle(
                                    //     color: Colors.white,
                                    //   ),
                                    // ),
                                    getCardType(card.cardNumber), // Display the card icon here
                                  ],
                                ),                        
                              Spacer(), // Vertically center the following elements
                              const Text(
                                'Spent',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '\$${card.outStanding.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Spacer(),
                              Row(
                                children: [
                                  Text(
                                    card.cardName,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    'Balance:\$${card.limit-card.outStanding}',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
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
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), 
                topRight: Radius.circular(16), 
              ),
              color: Colors.white,
            ),
            height: MediaQuery.of(context).size.height - ((MediaQuery.of(context).size.width * 0.8)), // Adjust the height as needed
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'All Transactions', // Transaction text at top left
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          // Show the SpendDetailsDialog and wait for the result
                          showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return SpendDetailsDialog(
                                onSave: (transaction) {
                                  setState(() {
                                    creditCards[currentIndex].transactions.add(transaction);
                                    creditCards[currentIndex].outStanding += transaction.amount;
                                  });
                                },
                                creditCards: creditCards,
                                currentIndex: currentIndex, // Pass the creditCards list
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.add_circle), // Circular "+" button
                        color: Colors.yellow,
                        iconSize: 36,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: creditCards.isNotEmpty ? creditCards[currentIndex].transactions.length : 0,
                    itemBuilder: (context, transactionIndex) {
                      final transaction = creditCards[currentIndex].transactions[transactionIndex];
                      final transactionCategory = transaction.category;
                      final now = DateTime.now();
                      final transactionDate = transaction.date;
                      String formattedDate;

                      if (transactionDate.year == now.year &&
                          transactionDate.month == now.month &&
                          transactionDate.day == now.day) {
                        // Show time in 12hr format along with the date if it's today
                        formattedDate = DateFormat('d MMM h:mm a').format(transactionDate);
                      } else if (transactionDate.year == now.year &&
                          transactionDate.month == now.month &&
                          transactionDate.day == now.day - 1) {
                        // Show "Yesterday" along with the time if it's yesterday
                        formattedDate = 'Yesterday ' + DateFormat.jm().format(transactionDate);
                      } else {
                        // Show date in the format "day Month" along with the time
                        formattedDate = DateFormat('d MMM').format(transactionDate) +
                            ' ' +
                            DateFormat.jm().format(transactionDate);
                      }

                        return Dismissible(
                            key: Key(transaction.date.toString()), // Use a unique identifier for each transaction
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: AlignmentDirectional.centerEnd,
                              color: Colors.red,
                              child: Padding(
                                padding: EdgeInsets.only(right: 16.0),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onDismissed: (direction) async {
                              final transaction = creditCards[currentIndex].transactions[transactionIndex];
                              try {
                                // Delete the transaction from the API
                                await ApiHelper.deleteCreditCardTransaction(
                                  creditCards[currentIndex].cardNumber, // Pass the cardNumber
                                  transaction.date.toIso8601String(), // Assuming the date is a DateTime object
                                );

                                // Update the local list of transactions
                                setState(() {
                                  creditCards[currentIndex].transactions.removeAt(transactionIndex);
                                  creditCards[currentIndex].outStanding -= transaction.amount;
                                });
                              } catch (e) {
                                print('Error deleting transaction: $e');
                              }
                            },
                      child:Card(
                        elevation: 0,
                        color: Colors.grey[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 16), // Adjust content padding
                          leading: CircleAvatar(
                            child:Icon(categoryIcons[transactionCategory] ?? Icons.question_mark),
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
                                transaction.note,
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
                      )
                        );
                    },
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
        Positioned(
          left: MediaQuery.of(context).size.width / 2 - 64,
          right: MediaQuery.of(context).size.width / 2 - 64,
          bottom: 16, // Adjust this value for the desired distance from the bottom
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex = 0;
                    });
                  },
                  icon: Icon(Icons.search_outlined),
                  color: Color.fromARGB(255, 0, 0, 0),
                  iconSize: 30,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex = 1;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AnalyticsPage()),
                    );
                  },
                  icon: Icon(Icons.analytics_outlined),
                  color: Color.fromARGB(255, 0, 0, 0),
                  iconSize: 30,
                ),
              ],
            ),
          ),
        ),

      ]
      )

    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CreditCardScreen(),
  ));
}
