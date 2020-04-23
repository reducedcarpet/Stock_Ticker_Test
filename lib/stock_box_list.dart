import 'package:flutter/material.dart';
import 'package:stocktestapp/stock.dart';

class StockBoxList extends StatelessWidget {
  final List<Stock> items;

  StockBoxList({Key key, this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return StockBox(
          item: items[index],
          selected: index == 0 ? true : false,
        );
      },
    );
  }
}

class StockBox extends StatefulWidget {
  StockBox({this.item, this.selected, Key key}) : super(key: key);

  final Stock item;
  final bool selected;

  @override
  _StockBoxState createState() {
    return _StockBoxState(item, selected);
  }
}

class _StockBoxState extends State<StockBox> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _StockBoxState(this.item, this.selected);
  final Stock item;
  bool selected;

  Widget build(BuildContext context) {
    bool negative = (this.item.percentage ?? 0) < 0;
    String formattedPercentage = (this.item.percentage ?? 0).toStringAsFixed(2);
    formattedPercentage =
        formattedPercentage.replaceAll('.', ','); // This should be a locale specific NumberFormat but I don't know what locale uses these constraints.

    return GestureDetector(
      onTap: () {
        setState(() {
          selected = !selected;
        });
      },
      child: Container(
        padding: EdgeInsets.all(0),
        child: Container(
          decoration: BoxDecoration(
            color: selected ? Colors.blue[100] : Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey[200], width: 1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                width: 150,
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(this.item.name ?? '', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(
                          formattedPercentage + '%',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: negative ? Colors.red : Colors.green),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: BuySellCard(item, negative, 'Sell'),
              ),
              Expanded(
                child: BuySellCard(item, negative, 'Buy'),
              ),
              Icon(
                Icons.chevron_right,
                size: 36,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BuySellCard extends StatelessWidget {
  final Stock item;
  final bool negative;
  final String tag;

  BuySellCard(this.item, this.negative, this.tag);

  @override
  Widget build(BuildContext context) {
    String value = '';
    if (tag == 'Buy') value = item.buys.toString();
    if (tag == 'Sell') value = item.sells.toString();

    value = value.replaceAll(',', ' ');
    value = value.replaceAll('.', ','); // This should be a locale specific NumberFormat but I don't know what locale uses these constraints.

    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              tag,
              style: TextStyle(color: Colors.blue[900], fontSize: 14),
            ),
            Text(
              value,
              style: TextStyle(color: negative ? Colors.black : Colors.red, fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
