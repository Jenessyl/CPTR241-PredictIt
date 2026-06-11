import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/market.dart';
import '../utils/formatters.dart';
import 'package:go_router/go_router.dart';

class MarketCard extends StatelessWidget {
  const MarketCard({
    super.key,
    required this.market,
  });

  final Market market;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Card(
        child: InkWell(
          onTap: () => context.push('/market/${market.id}'),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                SvgPicture.asset(
                  market.imageAsset,
                  width: 72,
                  height: 72,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: 'market-title-${market.id}',
                        child: Material(
                          type: MaterialType.transparency,
                          child: Text(
                            market.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('YES ${Formatters.price(market.yesPriceCents)}'),
                      const SizedBox(height: 4),
                      Text('${market.volumeShares} shares'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
