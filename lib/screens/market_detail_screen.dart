import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../data/market_repository.dart';
import '../models/market.dart';
import '../widgets/bet_sheet.dart';

class MarketDetailScreen extends StatefulWidget {
  const MarketDetailScreen({super.key, required this.id});

  final String id;

  @override
  State<MarketDetailScreen> createState() => _MarketDetailScreenState();
}

class _MarketDetailScreenState extends State<MarketDetailScreen> {
  late final Future<Market?> _marketFuture;

  @override
  void initState() {
    super.initState();
    _marketFuture = MarketRepository().findById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Market')),
      body: FutureBuilder<Market?>(
        future: _marketFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final market = snapshot.data;
          if (market == null) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('Market not found.'),
              ),
            );
          }

          return _DetailBody(market: market);
        },
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.market});

  final Market market;

  @override
  Widget build(BuildContext context) {
    final List<FlSpot> spots = market.priceHistory.asMap().entries.map((entry) {
      final index = entry.key;
      final point = entry.value;
      return FlSpot(index.toDouble(), point.yesPriceCents.toDouble());
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'market-title-${market.id}',
            child: Material(
              type: MaterialType.transparency,
              child: Text(
                market.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(market.description),
          Text(
            'Closes at: ${market.closesAt.toLocal()}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 240,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                  ),
                ],
                minY: 0,
                maxY: 100,
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: 22,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: const Color.fromARGB(255, 108, 140, 167),
                  ),
                ),
                gridData: const FlGridData(
                  show: false,
                ),
                backgroundColor: const Color.fromARGB(255, 202, 224, 235),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => BetSheet(market: market),
                );
              },
              child: const Text('Place a bet'),
            ),
          ),
        ],
      ),
    );
  }
}
