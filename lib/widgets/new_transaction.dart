import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;
  DateTime _dateTime = DateTime(3000,2,1,10,20);


  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    widget.addTx(
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );

    Navigator.of(context).pop();
  }


 void _cuDatePicker(){
   CupertinoDatePicker(
     mode: CupertinoDatePickerMode.date,
     onDateTimeChanged: (pickedDate){
       if (pickedDate == null) {
         return;
       }
       setState(() {
         _selectedDate = pickedDate;
       });
     },
     initialDateTime: DateTime.now(),
     minimumDate: DateTime(2019),
     maximumDate: DateTime.now(),
   );
 }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
    print('...');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            right: 10,
            left: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(hintText: 'Title',
                prefixIcon: Icon(Icons.title),
                ),
                controller: _titleController,
                onSubmitted: (_) => _submitData(),
                // onChanged: (val) {
                //   titleInput = val;
                // },
              ),
              TextField(
                decoration: InputDecoration(hintText: 'Amount',
                prefixIcon: Icon(Icons.account_balance_wallet)
                ),
                controller: _amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
                // onChanged: (val) => amountInput = val,
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'No Date Chosen!'
                            : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}',
                      ),
                    ),
                     CupertinoButton(
                        padding: EdgeInsets.all(10),
                        color: Colors.blueGrey,
                        child: Text(
                          'Choose Date',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        onPressed: (){
                          showCupertinoModalPopup(
                              context: context,
                              builder: (BuildContext context)=> Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 200,
                                    child: Padding(
                                      padding:  EdgeInsets.only(
                                        top: 8,
                                        right: 8,
                                        left: 8,
                                        bottom: MediaQuery.of(context).viewInsets.bottom + 8,
                                      ),
                                      child: CupertinoDatePicker(
                                        mode: CupertinoDatePickerMode.date,
                                        backgroundColor: Colors.white,
                                        minimumYear: 2010,
                                        maximumYear: DateTime.now().year,
                                        initialDateTime: DateTime.now(),
                                          onDateTimeChanged: (pickedDate){
                                            if (pickedDate == null) {
                                              return;
                                            }
                                            print(_selectedDate);
                                            setState(() {
                                              _selectedDate = pickedDate;
                                            });
                                          },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          );
                        },
                      ),
                  ],
                ),
              ),
              SafeArea(
                child: CupertinoButton(
                  color: Colors.blueGrey,
                  padding: EdgeInsets.all(8),
                  child: Text('Add Transaction'),
                  onPressed: _submitData,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

