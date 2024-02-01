import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final Dio dio = Dio();

  HomeCubit() : super(const HomeState());

  void updateAmount(double amount) {
    emit(state.copyWith(amount: amount));
  }

  void updateSourceCurrency(String currencyCode) {
    emit(state.copyWith(sourceCurrency: currencyCode));
    fetchExchangeRates(currencyCode);
  }

  void updateTargetCurrency(String currencyCode) {
    emit(state.copyWith(targetCurrency: currencyCode));
  }

  void convertCurrency() async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      await fetchExchangeRates(state.sourceCurrency);
      final exchangeRates = state.exchangeRates;
      final targetCurrencyKey =
          '${state.sourceCurrency}${state.targetCurrency}';
      final conversionRate = exchangeRates[targetCurrencyKey] ?? 0.0;
      final convertedAmount = state.amount * conversionRate;
      print('convertedAmount: $convertedAmount');
      emit(state.copyWith(convertedAmount: convertedAmount));
    } catch (e) {
      print('Convert Currency Error: $e');
      emit(state.copyWith(error: 'Failed to convert currency'));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> fetchExchangeRates(String sourceCurrencyCode) async {
    try {
      final response = await dio.get(
        'http://api.currencylayer.com/live'
        '?access_key=22dab6c8c1729d855aeadd4da8a8cfb0'
        '&format=1'
        '&source=$sourceCurrencyCode',
      );

      if (response.data['success'] == true) {
        final quotes = response.data['quotes'];
        final exchangeRates = Map<String, dynamic>.from(quotes);
        emit(state.copyWith(exchangeRates: exchangeRates));
      } else {
        emit(state.copyWith(error: 'Failed to fetch exchange rates'));
      }
    } catch (e) {
      print('Fetch Exchange Rates Error: $e');
      emit(state.copyWith(error: 'Failed to fetch exchange rates'));
    }
  }
}
