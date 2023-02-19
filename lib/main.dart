import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';
import './models/transaction.dart';
import 'widgets/info.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Expenses',
      home: MyHomePage(),
      routes: <String, WidgetBuilder>{
        "info": (BuildContext context) => Info()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  // String titleInput;
  // String amountInput;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'New Shoes',
    //   amount: 69.99,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'Weekly Groceries',
    //   amount: 16.53,
    //   date: DateTime.now(),
    // ),
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: NewTransaction(_addNewTransaction),
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  bool _showChart = false;

  @override
  Widget build(BuildContext context) {
    var cSwitch = CupertinoSwitch(
        value: _showChart,
        onChanged: (newVal){
          setState(() {
            _showChart = newVal;
          });
        });
    var mSwitch = Switch(
        value: _showChart,
        onChanged: (newVal){
          setState(() {
            _showChart = newVal;
          });
        });
    final mq = MediaQuery.of(context);
    final isLandscape = mq.orientation == Orientation.landscape;
    var cuNBar =  CupertinoNavigationBar(
      middle: const Text('Personal Expenses'),
      trailing: IconButton(
        onPressed: () => _startAddNewTransaction(context),
        icon: const Icon(CupertinoIcons.add),
      ),
    );
    var mappBar = AppBar(
      title: const Text(
        'Personal Expenses',
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        ),
      ],
    );
    var txListWidget = SizedBox(
      height: (mq.size.height -
          mappBar.preferredSize.height -
          mq.padding.top) *
          0.7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );
    return Scaffold(
      appBar: Platform.isIOS? cuNBar:mappBar,
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if(!isLandscape)
              SizedBox(
                height: (mq.size.height -
                    mappBar.preferredSize.height -
                    mq.padding.top) *
                    0.3,
                child: Chart(_recentTransactions),
              ),
            if(!isLandscape)
            txListWidget,
            if(isLandscape)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Show Chart"),
                Platform.isIOS?cSwitch:mSwitch,
              ],
            ),
            if(isLandscape) _showChart == true?
            SafeArea(
              child: SizedBox(
                height: (mq.size.height -
                        mappBar.preferredSize.height -
                        mq.padding.top) *
                    0.6,
                child: Chart(_recentTransactions),
              ),
            ): txListWidget,
          ],
        ),
      ),

      floatingActionButtonLocation:FloatingActionButtonLocation.endFloat,
      floatingActionButton: Platform.isIOS?Container():FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        child:  Icon(Icons.info_outlined),
        onPressed: (){},
      ),
    );
  }
}
