part of 'home_cubit.dart';

class HomeState extends Equatable {
  final double amount;
  final String targetCurrency;
  final double convertedAmount;
  final String sourceCurrency;

  final bool isLoading;
  final String? error;
  final Map<String, dynamic> exchangeRates;

  const HomeState({
    this.sourceCurrency = 'USD',
    this.amount = 0.0,
    this.targetCurrency = 'INR',
    this.convertedAmount = 0.0,
    this.isLoading = false,
    this.error,
    this.exchangeRates = const {},
  });

  @override
  List<Object> get props => [
        amount,
        targetCurrency,
        convertedAmount,
        isLoading,
        sourceCurrency,
        exchangeRates,
      ];

  HomeState copyWith({
    double? amount,
    String? targetCurrency,
    String? sourceCurrency,
    double? convertedAmount,
    bool? isLoading,
    String? error,
    Map<String, dynamic>? exchangeRates,
  }) {
    return HomeState(
      amount: amount ?? this.amount,
      targetCurrency: targetCurrency ?? this.targetCurrency,
      convertedAmount: convertedAmount ?? this.convertedAmount,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      sourceCurrency: sourceCurrency ?? this.sourceCurrency,
      exchangeRates: exchangeRates ?? this.exchangeRates,
    );
  }
}
