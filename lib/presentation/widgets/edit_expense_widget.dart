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

String title = "";

class EditNewExpense extends StatefulWidget {
  final expenseTitle;
  final date;
  final id;
  final amount;

  const EditNewExpense(
      {Key? key, this.expenseTitle, this.date, this.id, this.amount})
      : super(key: key);
  @override
  _EditNewExpenseState createState() =>
      _EditNewExpenseState(this.expenseTitle, this.date, this.id, this.amount);
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

class _EditNewExpenseState extends State<EditNewExpense> {
  final _formKey = GlobalKey<FormState>();
  final expenseTitle;
  final date;
  final id;
  final amount;
  _EditNewExpenseState(this.expenseTitle, this.date, this.id, this.amount);

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
    return Material(
      child: Container(
        color: Color(0xFFcbefef),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(5),
                child: TextFormField(
                  controller: expensesAmountController,
                  decoration: InputDecoration(
                    hintText: amount.toString(),
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.grey[400],
                      fontSize: 19,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 3),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter valid amount";
                    } else if (double.parse(value) <= 0) {
                      return "Amount can't be negative or equal to 0";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(5),
                child: TextFormField(
                  controller: expensesTitleController,
                  decoration: InputDecoration(
                    hintText: expenseTitle,
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.grey[400],
                      fontSize: 19,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 3),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter valid title";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat.yMMMd().format(dateTime),
                  ),
                  SizedBox(
                    width: 135,
                    child: ElevatedButton(
                        onPressed: () => _showDatePicker(context),
                        child: Text(
                          "Pick Date",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 19,
                          ),
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFF267b7b)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )))),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: 135,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await createPost(
                                "http://172.23.224.1:8080/update-expense",
                                id,
                                expensesTitleController.text,
                                int.parse(expensesAmountController.text),
                                dateTime.toString());
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const HomeScreen()));
                          }
                        },
                        child: Text("EDIT",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 19,
                            )),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFF267b7b)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )))),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
