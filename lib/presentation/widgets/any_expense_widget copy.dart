import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:io';
import 'dart:async';
import 'dart:core';
import 'dart:convert';
import 'dart:developer';
import 'package:personal_expenses_app/data/models/expense_model.dart';
import 'package:personal_expenses_app/logic/expenses_helper.dart';
import 'package:http/http.dart' as http;
import 'package:personal_expenses_app/presentation/screens/home_screen.dart';
import 'package:personal_expenses_app/presentation/widgets/edit_expense_widget.dart';

Future deletePost(String link) async {
  final url = Uri.parse(link);
  final response = await http.delete(url, headers: {
    'Content-Type': 'application/json; charset=UTF-8',
  });
}

class AnyNewExpense extends StatefulWidget {
  final expenseTitle;
  final date;
  final id;
  final amount;

  const AnyNewExpense(
      {Key? key, this.expenseTitle, this.date, this.id, this.amount})
      : super(key: key);
  @override
  _AnyNewExpenseState createState() =>
      _AnyNewExpenseState(this.expenseTitle, this.date, this.id, this.amount);
}

Future createPost(
    String link, int id, String expenseTitle, int amount, String date) async {
  final url = Uri.parse(link);
  final response = await http.put(
    url,
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'id': id,
      'expenseTitle': expenseTitle,
      'amount': amount,
      'date': date,
    }),
  );
  return response.body;
}

class _AnyNewExpenseState extends State<AnyNewExpense> {
  final _formKey = GlobalKey<FormState>();
  final expenseTitle;
  final date;
  final id;
  final amount;
  _AnyNewExpenseState(this.expenseTitle, this.date, this.id, this.amount);

  DateTime dateTime = DateTime.now();
  TextEditingController expensesTitleController = TextEditingController();
  TextEditingController expensesAmountController = TextEditingController();
  TextEditingController expensesIDController = TextEditingController();
  ExpensesHelper helper = ExpensesHelper();

  void _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020 - 12 - 31),
      lastDate: DateTime(2025),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        dateTime = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        color: Color(0xFFcbefef),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(expenseTitle,
                  style: GoogleFonts.poppins(
                    color: Colors.grey[700],
                    fontSize: 27,
                  )),
              const SizedBox(
                height: 30,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("Expense Amount",
                    style: GoogleFonts.poppins(
                      color: Colors.grey[700],
                      fontSize: 20,
                    )),
                Text(amount.toString() + " \$",
                    style: GoogleFonts.poppins(
                      color: Colors.grey[700],
                      fontSize: 20,
                    ))
              ]),
              const SizedBox(
                height: 10,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("Date:",
                    style: GoogleFonts.poppins(
                      color: Colors.grey[700],
                      fontSize: 20,
                    )),
                Text(date.substring(0, date.indexOf(' ')),
                    style: GoogleFonts.poppins(
                      color: Colors.grey[700],
                      fontSize: 20,
                    ))
              ]),
              const SizedBox(
                height: 90,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                FloatingActionButton(
                  backgroundColor: Color(0xFF267b7b),
                  onPressed: () => showModalBottomSheet(
                    context: context,
                    builder: (_) => EditNewExpense(
                        expenseTitle: expenseTitle,
                        date: date,
                        id: id,
                        amount: amount),
                  ).then((_) {
                    setState(() {});
                  }),
                  child: Icon(
                    Icons.edit,
                  ),
                ),
                FloatingActionButton(
                  backgroundColor: Color(0xFF267b7b),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text("Are you sure?"),
                      content:
                          Text("Do you really want to delete this expense?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("NO"),
                        ),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                var val = id.toString();
                                deletePost(
                                    'http://172.23.224.1:8080/delete-expense/$val');
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const HomeScreen()));
                              });
                            },
                            child: Text("YES"))
                      ],
                    ),
                  ),
                  child: Icon(Icons.delete_forever),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
