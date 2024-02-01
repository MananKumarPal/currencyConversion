import 'package:currencyapp/screens/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:currencyapp/widgets/custom_button.dart';

import '../../core/constants/url_const.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Currency Converter'),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: () {
                          _showCurrencyList(context, isFromCurrency: true);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            state.sourceCurrency.isNotEmpty
                                ? state.sourceCurrency
                                : "USD",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Amount',
                          hintStyle: TextStyle(color: Colors.grey),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          context
                              .read<HomeCubit>()
                              .updateAmount(double.parse(value));
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        _showCurrencyList(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          state.targetCurrency.isNotEmpty
                              ? state.targetCurrency
                              : "EUR",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Text(
                      state.convertedAmount.toStringAsFixed(2),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                Center(
                  child: CustomButton(
                    color: Colors.teal,
                    text: "Convert",
                    textColor: Colors.white,
                    onTap: () {
                      context.read<HomeCubit>().convertCurrency();
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                if (state.exchangeRates.isNotEmpty)
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Exchange Rates:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.teal.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: state.exchangeRates.entries
                                  .map(
                                    (entry) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${(entry.key).replaceAll(state.sourceCurrency, '')}:',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            entry.value.toStringAsFixed(5),
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (state.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (state.error != null)
                  Text(
                    'Error: ${state.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showCurrencyList(BuildContext context, {bool isFromCurrency = false}) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: Colors.white,
          child: ListView.builder(
            itemCount: currencyList.length,
            itemBuilder: (context, index) {
              final currency = currencyList[index];

              final currencyCode = currency.keys.first;
              final currencyName = currency.values.first;

              return ListTile(
                title: Text("$currencyCode - $currencyName"),
                onTap: () {
                  if (isFromCurrency) {
                    context
                        .read<HomeCubit>()
                        .updateSourceCurrency(currencyCode);
                  } else {
                    context
                        .read<HomeCubit>()
                        .updateTargetCurrency(currencyCode);
                  }
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }
}
