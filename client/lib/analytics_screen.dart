import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; 
import 'api_helper.dart'; 

class AnalyticsPage extends StatefulWidget {
  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  List<dynamic> transactions = [];

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    try {
      final fetchedTransactions = await ApiHelper.getAllTransactions();
      setState(() {
        transactions = fetchedTransactions;
      });
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 20),
          transactions.isNotEmpty
              ? _buildBarChart()
              : Text('No transactions available'),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    List<BarChartGroupData> barChartGroupData = transactions.map((transaction) {
      return BarChartGroupData(
        x: transactions.indexOf(transaction),
        barRods: [
          BarChartRodData(
            toY: transaction['amount'].toDouble(),
          ),
        ],
      );
    }).toList();

    return Container(
      height: 300,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.center,
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: barChartGroupData,
        ),
      ),
    );
  }
}
