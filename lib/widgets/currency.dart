import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 1. Currency Model
class Currency {
  final int id;
  final String code;
  final String name;
  final String symbol;
  final String flag;

  const Currency({
    required this.id,
    required this.code,
    required this.name,
    required this.symbol,
    required this.flag,
  });
}


// 3. Container Dropdown Selector


const _brandColor = Color(0xFF058E84);

// Opens the currency bottom sheet. Returns the chosen currency, or null if dismissed.
Future<Currency?> showCurrencyPickerSheet(
    BuildContext context, {
      required List<Currency> currencies,
      required Currency selected,
    }) {
  return showModalBottomSheet<Currency>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _CurrencySheet(currencies: currencies, selected: selected),
  );
}

// Read-only display of a currency: flag + code + symbol.
class CurrencyBadge extends StatelessWidget {
  final Currency currency;
  final bool showChevron;

  const CurrencyBadge({
    super.key,
    required this.currency,
    this.showChevron = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _brandColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
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
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          if (showChevron) ...[
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: _brandColor,
              size: 20,
            ),
          ],
        ],
      ),
    );
  }
}

// Drop-in replacement: same constructor, but opens a bottom sheet on tap.
class CurrencyContainerPicker extends StatelessWidget {
  final Currency selectedCurrency;
  final List<Currency> currencies;
  final ValueChanged<Currency> onCurrencySelected;

  const CurrencyContainerPicker({
    super.key,
    required this.selectedCurrency,
    required this.onCurrencySelected,
    required this.currencies,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        HapticFeedback.selectionClick();
        final picked = await showCurrencyPickerSheet(
          context,
          currencies: currencies,
          selected: selectedCurrency,
        );
        if (picked != null && picked.code != selectedCurrency.code) {
          onCurrencySelected(picked);
        }
      },
      child: CurrencyBadge(currency: selectedCurrency, showChevron: true),
    );
  }
}

class _CurrencySheet extends StatefulWidget {
  final List<Currency> currencies;
  final Currency selected;

  const _CurrencySheet({required this.currencies, required this.selected});

  @override
  State<_CurrencySheet> createState() => _CurrencySheetState();
}

class _CurrencySheetState extends State<_CurrencySheet> {
  String _query = '';

  List<Currency> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return widget.currencies;
    return widget.currencies
        .where((c) =>
    c.code.toLowerCase().contains(q) ||
        c.symbol.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final items = _filtered;

    return Padding(
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: media.size.height * 0.7),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 24, 12),
              child: Text(
                'Select currency',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),

            // Search only makes sense for longer lists
            if (widget.currencies.length > 6)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: TextField(
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: 'Search by code or symbol',
                    prefixIcon: const Icon(Icons.search_rounded),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

            Flexible(
              child: items.isEmpty
                  ? Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    'No currencies found',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
              )
                  : ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 20),
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final c = items[i];
                  final isSelected = c.code == widget.selected.code;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Material(
                      color: isSelected
                          ? _brandColor.withValues(alpha: 0.10)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          Navigator.pop(context, c);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Text(c.flag,
                                  style: const TextStyle(fontSize: 24)),
                              const SizedBox(width: 14),
                              Text(
                                c.code,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                c.symbol,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const Spacer(),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: _brandColor,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}