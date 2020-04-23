class Stock {
  final String name;
  final String exchange;
  final double buys;
  final double sells;
  final double price;
  final double percentage;

  Stock(this.name, this.exchange, this.buys, this.sells, this.price, this.percentage);
  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      json['shortName'],
      json['fullExchangeName'],
      json['ask'],
      json['bid'],
      json['regularMarketPrice'],
      json['regularMarketChangePercent'],
    );
  }
}
