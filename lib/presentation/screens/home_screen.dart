import 'dart:io';
import 'dart:async';
import 'dart:core';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_expenses_app/logic/expenses_helper.dart';
import 'package:personal_expenses_app/presentation/widgets/add_expense_widget.dart';
import 'package:http/http.dart' as http;
import 'package:personal_expenses_app/presentation/widgets/any_expense_widget%20copy.dart';
import 'package:personal_expenses_app/presentation/widgets/edit_expense_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

Future deletePost(String link) async {
  final url = Uri.parse(link);
  final response = await http.delete(url, headers: {
    'Content-Type': 'application/json; charset=UTF-8',
  });
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: false);
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset(0.0, 3.0),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticIn,
  ));

  List data = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    this.getJsonData();
    repeatOnce();
  }

  Future<String> getJsonData() async {
    var response = await http.get(
      Uri.http('172.23.224.1:8080', '/expenses'),
      //Encode URL
    );

    print(response.body);

    setState(() {
      var convertDataToJson = json.decode(response.body);
      ExpensesHelper().totalExpenses();
      data = convertDataToJson;
    });

    return "Success";
  }

  void repeatOnce() async {
    await _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    Future<String> downloadData() async {
      var totalExxpenses = await ExpensesHelper().totalExpenses();
      print("-----------------------------");
      print(totalExxpenses);
      return totalExxpenses.toString();
    }

    var sum;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: new AssetImage("lib/assets/images/background.jpg"),
            alignment: FractionalOffset.topCenter,
            fit: BoxFit.fitWidth,
          ),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Personal Expenses',
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontSize: 27,
                    )),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: FittedBox(
                    child: FloatingActionButton(
                      backgroundColor: Color(0xFF267b7b),
                      onPressed: () => showModalBottomSheet(
                        context: context,
                        builder: (_) => const AddNewExpense(),
                      ).then((_) {
                        setState(() {});
                      }),
                      child: const Icon(Icons.add),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              height: 200.0,
              width: 330.0,
              padding: const EdgeInsets.all(0.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Color(0xffd9d9d9),
                  width: 2,
                ),
                borderRadius: BorderRadius.all(Radius.circular(9.0)),
              ),
              child: new FutureBuilder<String>(
                future: downloadData(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text(
                      '${snapshot.data} \$',
                      style: const TextStyle(
                          fontSize: 40, fontWeight: FontWeight.bold),
                    );
                  } else {
                    if (snapshot.hasError)
                      return Center(child: Text('Error: ${snapshot.error}'));
                    else
                      return Center(
                          child: new Text(
                        '${snapshot.data} \$',
                        style: const TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ));
                  }
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Flexible(
              flex: 4,
              child: ListView.builder(
                itemCount: data == null ? 0 : data.length,
                itemBuilder: (ctx, index) {
                  return Dismissible(
                    key: UniqueKey(),
                    child: Container(
                      width: 200,
                      child: SlideTransition(
                        position: _offsetAnimation,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            child: Column(children: [
                              ListTile(
                                title: Text(
                                  data[index]['expenseTitle'],
                                ),
                                subtitle: Text(
                                  data[index]['date'],
                                ),
                                trailing: Text(
                                    data[index]['amount'].toString() + " \$"),
                                onLongPress: () => showModalBottomSheet(
                                  context: context,
                                  builder: (context) => AnyNewExpense(
                                      expenseTitle: data[index]['expenseTitle'],
                                      date: data[index]['date'],
                                      id: data[index]['id'],
                                      amount: data[index]['amount']),
                                ).then((_) {
                                  setState(() {});
                                }),
                              )
                            ]),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
