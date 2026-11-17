import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/skill_form.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';

const Color pine = Color(0xFF2F4F4F);
const Color sage = Color(0xFF587A62);
const Color gold = Color(0xFFC9A227);
const Color ivory = Color(0xFFFBF8F1);
const Color ink = Color(0xFF1F2D2D);
const Color cream = Color(0xFFF5F1E8);
const Color softMint = Color(0xFFA9C5A0);

/// Halaman utama portofolio, termasuk profil, menu aksi, dan umpan balik.
class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final String npm = "2506614006";
  final String nama = "M. Rezky Syahputra";
  final String kelas = "PBP D";

  final List<ItemHomepage> items = [
    ItemHomepage(
      "Lihat Skills",
      Icons.psychology,
      pine,
      details: ["Java", "Python", "HTML5", "CSS3"],
      foregroundColor: Colors.white,
      iconColor: ivory,
    ),
    ItemHomepage(
      "Lihat Experience",
      Icons.work_outline,
      sage,
      details: [
        "Academic Staff & Tutor (Quantitative Reasoning)",
        "Staff Intern - Academic & Career Development",
        "Teaching Assistant - Univariate Calculus",
      ],
      foregroundColor: Colors.white,
      iconColor: ivory,
    ),
    ItemHomepage(
      "Tambah Skill",
      Icons.add_circle_outline,
      softMint,
      foregroundColor: ink,
      iconColor: pine,
    ),
    ItemHomepage(
      "Tambah Experience",
      Icons.note_add,
      gold,
      foregroundColor: ink,
      iconColor: pine,
    ),
  ];

  final ItemHomepage logoutItem = ItemHomepage(
    'Logout',
    Icons.logout,
    const Color(0xFFB23A48),
    foregroundColor: Colors.white,
    iconColor: Colors.white,
  );

  /// Meminta konfirmasi Logout, lalu menampilkan umpan balik setelah dialog ditutup.
  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (context.mounted) {
      final message = shouldLogout == true
          ? 'Kamu telah menekan tombol Logout! Fitur logout belum terhubung.'
          : 'Kamu telah menekan tombol Logout!';
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    }
  }

  /// Menampilkan umpan balik dan membuka detail bila item memilikinya.
  void _handleItemTap(BuildContext context, ItemHomepage item) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Kamu telah menekan tombol ${item.name}!'),
          action: item.details == null || item.details!.isEmpty
              ? null
              : SnackBarAction(
                  label: 'Lihat',
                  onPressed: () => _showItemDetails(context, item),
                ),
        ),
      );

    if (item.name == 'Tambah Skill') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SkillFormPage()),
      );
    }
  }

  /// Menampilkan rincian item dalam modal bottom sheet.
  void _showItemDetails(BuildContext context, ItemHomepage item) {
    final details = item.details;
    if (details == null || details.isEmpty) return;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: ivory,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: const TextStyle(
                  color: ink,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              ...details.map(
                (detail) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(item.icon, color: pine),
                  title: Text(detail, style: const TextStyle(color: ink)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold menyediakan struktur visual dasar halaman (AppBar, Body, SnackBar).
    return Scaffold(
      backgroundColor: cream,
      // AppBar menampilkan bar bagian atas halaman aplikasi.
      appBar: AppBar(
        title: const Text(
          'MyPortfolio',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: pine,
      ),
      drawer: LeftDrawer(
        onHome: () => Navigator.pop(context),
        onAddSkill: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SkillFormPage()),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [cream, softMint, cream],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: ivory,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: pine,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: InfoCard(title: 'Name', content: nama),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: InfoCard(title: 'NPM', content: npm),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: InfoCard(title: 'Class', content: kelas),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Selamat datang!',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                  color: ink,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Jelajahi keahlian dan pengalaman saya.',
                style: TextStyle(color: ink),
              ),
              const SizedBox(height: 24),
              const Text(
                'Menu Portofolio',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: ink,
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.45,
                children: items.map((ItemHomepage item) {
                  return ItemCard(
                    item,
                    onPressed: () => _handleItemTap(context, item),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 72,
                child: ItemCard(
                  logoutItem,
                  isCompact: true,
                  onPressed: () => _confirmLogout(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Kartu ringkas untuk satu informasi profil, seperti nama atau NPM.
class InfoCard extends StatelessWidget {
  // Kartu informasi yang menampilkan judul (title) dan isi (content).
  final String title;
  final String content;

  const InfoCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ivory,
      elevation: 0.5,
      margin: const EdgeInsets.only(bottom: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 11, color: sage)),
            Text(
              content,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
