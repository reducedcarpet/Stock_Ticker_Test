import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stocktestapp/stock.dart';
import 'package:stocktestapp/stock_box_list.dart';

void main() {
  runApp(MyApp());
}

List<Stock> parseStocks(String responseBody) {
  final parsed = Map.from(json.decode(responseBody));
  final results = parsed['quoteResponse']['result'];
  return results.map<Stock>((json) => Stock.fromJson(json)).toList();
}

Future<List<Stock>> fetchStocks() async {
  String url = 'https://apidojo-yahoo-finance-v1.p.rapidapi.com/market/get-quotes?region=US&lang=en&symbols=COG,GOLD,HUN,USA,OIL,XOM,RGLD,DGAZ,IWM';

  Map<String, String> headers = {
    "x-rapidapi-host": "apidojo-yahoo-finance-v1.p.rapidapi.com",
    "x-rapidapi-key": "ef9582345dmsh2a3cce430393441p16b430jsn13d40ffd9697"
  };

  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    return parseStocks(response.body);
  } else {
    throw Exception('Unable to fetch stocks from the REST API - ' + response.body.toString());
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Stocks Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StockPage(
        title: 'Popular instruments',
        stocks: fetchStocks(),
      ),
    );
  }
}

class StockPage extends StatelessWidget {
  StockPage({Key key, this.title, this.stocks}) : super(key: key);

  final String title;

  final Future<List<Stock>> stocks;

  @override
  Widget build(BuildContext context) {
    Widget titleBar = DropdownButton<String>(
      value: title,
      icon: Icon(
        Icons.keyboard_arrow_down,
        color: Colors.white,
        size: 32,
      ),
      underline: Container(),
      iconSize: 32,
      elevation: 16,
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
      onChanged: (String value) {},
      items: <String>[title, 'Various', 'Stock', 'Instruments', 'That', 'Can Be', 'Chosen'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: titleBar,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset(
              'assets/income.png',
              color: Colors.grey[300],
              fit: BoxFit.fitHeight,
            ),
          )
        ],
      ),
      body: Center(
        child: FutureBuilder<List<Stock>>(
          future: stocks,
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData ? StockBoxList(items: snapshot.data) : Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
