import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/portfolio_provider.dart';
import '../models/stock.dart';

class AddStockScreen extends StatefulWidget {
  final Stock? initialStock;
  const AddStockScreen({super.key, this.initialStock});

  @override
  State<AddStockScreen> createState() => _AddStockScreenState();
}

class _AddStockScreenState extends State<AddStockScreen> {
  final _symbolController = TextEditingController();
  final _quantityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<Stock> _searchResults = [];
  bool _isSearching = false;
  Timer? _debounce;
  final FocusNode _symbolFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.initialStock != null) {
      _symbolController.text = widget.initialStock!.symbol;
    }
    
    _symbolFocusNode.addListener(() {
      if (!_symbolFocusNode.hasFocus) {
        setState(() {
          _searchResults = [];
        });
      }
    });
  }

  @override
  void dispose() {
    _symbolController.dispose();
    _quantityController.dispose();
    _symbolFocusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSymbolChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.length >= 3) {
        _performSearch(query);
      } else {
        if (mounted) {
          setState(() {
            _searchResults = [];
            _isSearching = false;
          });
        }
      }
    });
  }

  Future<void> _performSearch(String query) async {
    if (!mounted) return;
    setState(() {
      _isSearching = true;
    });

    final provider = context.read<PortfolioProvider>();
    final results = await provider.searchStock(query);

    if (mounted) {
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final symbol = _symbolController.text.toUpperCase();
      final quantity = int.parse(_quantityController.text);

      final provider = context.read<PortfolioProvider>();
      
      final stock = Stock(symbol: symbol, name: symbol);

      await provider.addStock(stock, quantity);

      if (mounted) {
        if (provider.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(provider.errorMessage!)),
          );
        } else {
          Navigator.pop(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<PortfolioProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Add Stock')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _symbolController,
                focusNode: _symbolFocusNode,
                decoration: InputDecoration(
                  labelText: 'Stock Symbol or Name (min 3 chars)',
                  border: const OutlineInputBorder(),
                  suffixIcon: _isSearching 
                      ? const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: SizedBox(
                            width: 20, 
                            height: 20, 
                            child: CircularProgressIndicator(strokeWidth: 2)
                          ),
                        )
                      : null,
                ),
                textCapitalization: TextCapitalization.characters,
                onChanged: _onSymbolChanged,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a symbol';
                  }
                  return null;
                },
              ),
              
              if (_searchResults.isNotEmpty)
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  margin: const EdgeInsets.only(top: 4, bottom: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                    color: Theme.of(context).cardColor,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final stock = _searchResults[index];
                      return ListTile(
                        title: Text(stock.symbol, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(stock.name),
                        onTap: () {
                          setState(() {
                            _symbolController.text = stock.symbol;
                            _searchResults = [];
                          });
                          _symbolFocusNode.unfocus();
                        },
                      );
                    },
                  ),
                )
              else 
                const SizedBox(height: 16),
                
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quantity';
                  }
                  final parsed = int.tryParse(value);
                  if (parsed == null || parsed <= 0) {
                    return 'Please enter a valid positive number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: isLoading ? null : _submit,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Add to Portfolio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

