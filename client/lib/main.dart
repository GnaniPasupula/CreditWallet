import 'dart:math';

import 'package:flutter/material.dart';
import 'api_helper.dart';
import 'credit_card_data.dart';
import 'credit_card_form.dart'; 

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
                    onPressed: () {
                      // Add your delete button functionality here
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
                              Spacer(),
                              Text(
                                card.cardName,
                                style: TextStyle(fontSize: 14),
                              ),
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
