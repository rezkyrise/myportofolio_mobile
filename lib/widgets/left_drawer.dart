import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/theme/portfolio_colors.dart';

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
        ],
      ),
    );
  }
}
