import 'dart:ffi';

import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurreny = 'USD';

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropDownItems = [];

    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropDownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurreny,
      items: dropDownItems,
      onChanged: (value) {
        setState(() {
          selectedCurreny = value;
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItemsList = [];

    for (String currency in currenciesList) {
      var newItem = Text(currency);
      pickerItemsList.add(newItem);
    }

    return CupertinoPicker(
        backgroundColor: Colors.deepPurple.shade900,
        itemExtent: 32.0,
        onSelectedItemChanged: (selectedIndex) {},
        children: pickerItemsList);
  }

  String bitCoinValueInUSD = '?';

  void getData() async {
    try {
      double data = await CoinData().getCoinData();

      setState(() {
        bitCoinValueInUSD = data.toStringAsFixed(5);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() { 
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.deepPurple.shade900,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = $bitCoinValueInUSD',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.deepPurple.shade900,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
