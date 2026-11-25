import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/theme/portfolio_colors.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

class LeftDrawer extends StatelessWidget {
  final VoidCallback onHome;
  final VoidCallback onAddSkill;
  final VoidCallback onAddExperience;

  const LeftDrawer({
    super.key,
    required this.onHome,
    required this.onAddSkill,
    required this.onAddExperience,
  });

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<AuthState>().isLoggedIn;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            constraints: const BoxConstraints(minHeight: 160),
            padding: const EdgeInsets.all(16),
            color: pine,
            child: const SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Portfolio',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: onDark,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Jelajahi keahlian dan pengalaman saya.',
                    style: TextStyle(fontSize: 15, color: onDark),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: onHome,
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Tambah Skill'),
            onTap: onAddSkill,
          ),
          ListTile(
            leading: const Icon(Icons.work_outline),
            title: const Text('Tambah Experience'),
            onTap: onAddExperience,
          ),
          ListTile(
            leading: Icon(isLoggedIn ? Icons.logout : Icons.login),
            title: Text(isLoggedIn ? 'Logout' : 'Login'),
            onTap: () async {
              Navigator.pop(context);

              if (isLoggedIn) {
                await context.read<AuthState>().logout();
              } else {
                await Navigator.push<bool>(
                  context,
                  MaterialPageRoute<bool>(builder: (_) => const LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
