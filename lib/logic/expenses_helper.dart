import 'package:personal_expenses_app/data/models/expense_model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:core';
import 'dart:convert';
import 'dart:developer';

class ExpensesHelper {
  String summing = "";

  getJsonData() async {
    var response = await http.get(
      Uri.http('172.23.224.1:8080', '/expenses'),

      //Encode URL
    );
    var convertDataToJson = json.decode(response.body);
    return convertDataToJson;
  }

  Future<double> totalExpenses() async {
    double sum = 0;
    List data = await getJsonData();
    for (int i = 0; i < data.length; i++) {
      sum += data[i]["amount"];
    }
    return sum;
  }
}
