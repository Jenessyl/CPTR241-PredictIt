import 'package:go_router/go_router.dart';
import 'screens/market_list_screen.dart';
import 'screens/market_detail_screen.dart';

// Routes are made with IDs not objects. Makes deeplinks and redirects possible for later.
final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MarketListScreen(),
    ),
    GoRoute(
      path: '/market/:id',
      builder: (context, state) =>
          MarketDetailScreen(id: state.pathParameters['id']!),
    ),
  ],
);
