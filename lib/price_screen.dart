import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';

  DropdownButton androidDropdown() {
    List<DropdownMenuItem<String>> dropDownItems = [];

    for (String currency in currenciesList) {
      dropDownItems.add(DropdownMenuItem(
        child: Text(currency),
        value: currency,
      ));
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropDownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData();
        });
      },
    );
  }

  CupertinoPicker iosPicker() {
    List<Text> pickerItems = [];

    for (String currency in currenciesList) {
      pickerItems.add(Text(
        currency,
        style: TextStyle(
          color: Colors.white,
        ),
      ));
    }

    return CupertinoPicker(
        backgroundColor: Colors.lightBlue,
        onSelectedItemChanged: (int index) {
          setState(() {
            selectedCurrency = currenciesList[index];
            getData();
          });
        },
        children: pickerItems,
        itemExtent: 32.0 //height,
        );
  }

  Map<String, String> coinValues = {};
  bool isWaiting = false;

  CoinData coinData = CoinData();

  void getData() async {
    isWaiting = true;

    try {
      var data = await coinData.getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        coinValues = data;
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

  List<CryptoCard> generateCards() {
    List<CryptoCard> cardList = [];

    for (String crypto in cryptoList) {
      cardList.add(CryptoCard(
        cryptocurrency: crypto,
        selectedCurrency: selectedCurrency,
        value: isWaiting ? '?' : coinValues[crypto],
      ));
    }

    return cardList;
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: generateCards(),
          ),
          Container(
            height: 120.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: (Platform.isAndroid) ? androidDropdown() : iosPicker(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  final String value;
  final String selectedCurrency;
  final String cryptocurrency;

  const CryptoCard({
    this.value,
    this.selectedCurrency,
    this.cryptocurrency,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptocurrency = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
