import 'package:flutter/material.dart';

// 1. Currency Model
class Currency {
  final String code;
  final String name;
  final String symbol;
  final String flag;

  const Currency({
    required this.code,
    required this.name,
    required this.symbol,
    required this.flag,
  });
}

// 2. Currencies List
const List<Currency> currencies = [
  Currency(code: 'USD', name: 'US Dollar', symbol: '\$', flag: '🇺🇸'),
  Currency(code: 'EUR', name: 'Euro', symbol: '€', flag: '🇪🇺'),
  Currency(code: 'DZD', name: 'Algerian Dinar', symbol: 'DA', flag: '🇩🇿'),
  Currency(code: 'GBP', name: 'British Pound', symbol: '£', flag: '🇬🇧'),
  Currency(code: 'CAD', name: 'Canadian Dollar', symbol: 'CA\$', flag: '🇨🇦'),
  Currency(code: 'SAR', name: 'Saudi Riyal', symbol: 'SR', flag: '🇸🇦'),
  Currency(code: 'AED', name: 'UAE Dirham', symbol: 'AED', flag: '🇦🇪'),
];

// 3. Container Dropdown Selector
class CurrencyContainerPicker extends StatelessWidget {
  final Currency selectedCurrency;
  final ValueChanged<Currency> onCurrencySelected;

  const CurrencyContainerPicker({
    super.key,
    required this.selectedCurrency,
    required this.onCurrencySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Currency>(
          value: selectedCurrency,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF058E84)),
          isExpanded: false,
          borderRadius: BorderRadius.circular(12),
          dropdownColor: Colors.white,
          elevation: 3,
          onChanged: (Currency? newCurrency) {
            if (newCurrency != null) {
              onCurrencySelected(newCurrency);
            }
          },
          items: currencies.map<DropdownMenuItem<Currency>>((Currency currency) {
            return DropdownMenuItem<Currency>(
              value: currency,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(currency.flag, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    currency.code,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${currency.symbol})',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}