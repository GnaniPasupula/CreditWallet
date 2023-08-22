import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'api_helper.dart';

class AnalyticsPage extends StatefulWidget {
  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  List<dynamic> transactions = [];
  List<dynamic> filteredTransactions = [];
  String selectedTimeInterval = 'All time';
  List<FlSpot> lineChartSpots = [];
  
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
    _fetchTransactions().then((_) {
      _updateLineChartSpots();
    });  
  }

  Future<void> _fetchTransactions() async {
    try {
      final fetchedTransactions = await ApiHelper.getAllTransactions();
      setState(() {
          transactions = fetchedTransactions;
          transactions.sort((a, b) {
          DateTime dateA = DateTime.parse(a['date']);
          DateTime dateB = DateTime.parse(b['date']);
          return dateA.compareTo(dateB);
        });
      });
    } catch (e) {
      // Handle error
    }
  }

  void _updateLineChartSpots() {
    lineChartSpots = transactions.asMap().entries.map((entry) {
      int index = entry.key;
      var transaction = entry.value;
      return FlSpot(index.toDouble(), transaction['amount'].toDouble());
    }).toList();
  }

  final List<Color> gradientColor = [
    const Color(0xffffa31d),
    const Color(0xffef5454),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
      body: Center(
        child: Column(
          children: [
            _buildTimeFilterRow(),
            transactions.isNotEmpty
                ? _buildLineChart()
                : Text('No transactions available'),
            SizedBox(height: 20),
            Expanded(
              child: _buildTransactionList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeFilterRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimeFilterButton('All time'),
        _buildTimeFilterButton('1Y'),
        _buildTimeFilterButton('6M'),
        _buildTimeFilterButton('3M'),
        _buildTimeFilterButton('1M'),
        _buildTimeFilterButton('1W'),
      ],
    );
  }

  Widget _buildTimeFilterButton(String text) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedTimeInterval = text;

          // Calculate the start date of the selected time interval
          DateTime startDate;
          if (selectedTimeInterval == '1M') {
            startDate = DateTime.now().subtract(Duration(days: 30));
          } else if (selectedTimeInterval == '3M') {
            startDate = DateTime.now().subtract(Duration(days: 90));
          } else if (selectedTimeInterval == '6M') {
            startDate = DateTime.now().subtract(Duration(days: 180));
          } else if (selectedTimeInterval == '1Y') {
            startDate = DateTime.now().subtract(Duration(days: 365));
          } else if (selectedTimeInterval == '1W') {
            startDate = DateTime.now().subtract(Duration(days: 7));
          } else {
            startDate = DateTime(1900);
          }

          // Filter transactions based on the selected time interval
          filteredTransactions = transactions.where((transaction) {
            DateTime transactionDate = DateTime.parse(transaction['date']);
            return transactionDate.isAfter(startDate);
          }).toList();

          filteredTransactions = filteredTransactions.reversed.toList();

          // Update the line chart spots
          lineChartSpots = filteredTransactions.asMap().entries.map((entry) {
            int index = entry.key;
            var transaction = entry.value;
            return FlSpot(filteredTransactions.length - 1 - index.toDouble(), transaction['amount'].toDouble());
          }).toList();
        });
      },
      style: ElevatedButton.styleFrom(
        primary: selectedTimeInterval == text ? Colors.blue : Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Text(text),
    );
  }


  Widget _buildLineChart() {

    return Container(
      height: 300,
      color: Colors.black,
      padding: EdgeInsets.all(24),
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: true, border: Border.all()),
          gridData: FlGridData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: lineChartSpots,
              isCurved: true,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(show: false),
              barWidth: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
  // Calculate the start date of the selected time interval
  DateTime startDate;
  if (selectedTimeInterval == '1M') {
    startDate = DateTime.now().subtract(Duration(days: 30));
  } else if (selectedTimeInterval == '3M') {
    startDate = DateTime.now().subtract(Duration(days: 90));
  } else if (selectedTimeInterval == '6M') {
    startDate = DateTime.now().subtract(Duration(days: 180));
  } else if (selectedTimeInterval == '1Y') {
    startDate = DateTime.now().subtract(Duration(days: 365));
  }else if (selectedTimeInterval == '1W') {
    startDate = DateTime.now().subtract(Duration(days: 7));
  }else{
    startDate = DateTime(1900);
  }

  // Filter transactions based on the selected time interval
  filteredTransactions = transactions.where((transaction) {
    DateTime transactionDate = DateTime.parse(transaction['date']);
    return transactionDate.isAfter(startDate);
  }).toList();

  filteredTransactions=filteredTransactions.reversed.toList();

  return Container(
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      color: Colors.white,
    ),
    height: MediaQuery.of(context).size.height -
        (MediaQuery.of(context).size.width * 0.8),
    child: ListView.builder(
      itemCount: filteredTransactions.isNotEmpty ? filteredTransactions.length : 0,
      itemBuilder: (context, transactionIndex) {
        var transaction = filteredTransactions[transactionIndex];
        final transactionDate = DateTime.parse(transaction['date']);
        String formattedDate = DateFormat('d MMM h:mm a').format(transactionDate);
        if (transactionDate.year != DateTime.now().year) {
          formattedDate = DateFormat('d MMM y h:mm a').format(transactionDate);
        }
        var transactionCategory = transaction['category'];

        return Card(
          elevation: 0,
          color: Colors.grey[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              child: Icon(categoryIcons[transactionCategory] ?? Icons.question_mark),
              radius: 16,
            ),
            title: Text(
              transaction['title'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              transaction['note'],
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${transaction['amount'].toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  formattedDate, // Provide the formatted date here
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
}
