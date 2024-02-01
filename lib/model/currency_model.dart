class CurrencyModel {
  CurrencyModel({
    this.currencyCode,
    this.exchangeRate,
  });

  String? currencyCode;
  double? exchangeRate;

  factory CurrencyModel.fromJson(Map<String, dynamic> json) => CurrencyModel(
        currencyCode: json["currency_code"],
        exchangeRate: json["exchange_rate"].toDouble(),
      );
}
