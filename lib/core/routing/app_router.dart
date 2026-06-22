import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/mahasiswa/presentation/screens/biodata_screen.dart';
import '../../features/mahasiswa/presentation/screens/history_pendidikan_screen.dart';
import '../../features/mahasiswa/presentation/screens/nilai_screen.dart';
import '../../features/mahasiswa/presentation/screens/transkrip_screen.dart';
import '../../features/mahasiswa/presentation/screens/ticket_list_screen.dart';
import '../../features/mahasiswa/presentation/screens/create_ticket_screen.dart';
import '../../features/mahasiswa/presentation/screens/ticket_detail_screen.dart';


class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/biodata',
        name: 'biodata',
        builder: (context, state) => const BiodataScreen(),
      ),
      GoRoute(
        path: '/history-pendidikan',
        name: 'history-pendidikan',
        builder: (context, state) => const HistoryPendidikanScreen(),
      ),
      GoRoute(
        path: '/nilai',
        name: 'nilai',
        builder: (context, state) => const NilaiScreen(),
      ),
      GoRoute(
        path: '/transkrip',
        name: 'transkrip',
        builder: (context, state) => const TranskripScreen(),
      ),
      GoRoute(
        path: '/tickets',
        name: 'tickets',
        builder: (context, state) => const TicketListScreen(),
      ),
      GoRoute(
        path: '/tickets/create',
        name: 'tickets-create',
        builder: (context, state) => const CreateTicketScreen(),
      ),
      GoRoute(
        path: '/tickets/:id',
        name: 'tickets-detail',
        builder: (context, state) {
          final idStr = state.pathParameters['id'];
          final id = int.tryParse(idStr ?? '') ?? 0;
          return TicketDetailScreen(ticketId: id);
        },
      ),
    ],

  );
}

