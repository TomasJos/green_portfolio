import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/portfolio_provider.dart';
import '../widgets/portfolio_summary_card.dart';
import '../widgets/carbon_impact_widget.dart';
import '../widgets/stock_card.dart';
import 'add_stock_screen.dart';
import 'stock_detail_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // After build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PortfolioProvider>().refreshPortfolio();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PortfolioProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Green Portfolio'),
        actions: [
          IconButton(
            icon: Icon(provider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              provider.toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: provider.isLoading && provider.portfolio.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => provider.refreshPortfolio(),
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: PortfolioSummaryCard(),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CarbonImpactWidget(
                      totalCo2Emissions: provider.totalCo2Emissions,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your Holdings',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (provider.portfolio.isNotEmpty)
                          Text(
                            '${provider.portfolio.length} Assets',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (provider.portfolio.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          Icon(Icons.inventory_2_outlined, size: 60, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          Text(
                            'No stocks in your portfolio yet.',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const AddStockScreen()),
                              );
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Add your first stock'),
                          ),
                        ],
                      ),
                    )
                  else
                    ...provider.portfolio.map((item) {
                      return Dismissible(
                        key: Key(item.symbol),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Colors.red,
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          provider.removeStock(item.symbol);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${item.symbol} removed')),
                          );
                        },
                        child: StockCard(
                          item: item,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => StockDetailScreen(item: item),
                              ),
                            );
                          },
                        ),
                      );
                    }),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddStockScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
