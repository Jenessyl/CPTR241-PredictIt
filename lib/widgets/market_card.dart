import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/market.dart';
import '../utils/formatters.dart';
import 'bet_sheet.dart';

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
          onTap: () {
            showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (_) => BetSheet(market: market),
            ); 
            // this MarketCard accepts an onTap callback. The most apparent benefit this provides is that it is easier to read and understand, especially since I am learning about onTap()
          },
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
                      Text(
                        market.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
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
