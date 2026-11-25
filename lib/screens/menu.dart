import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/skill_form.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/action_card.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:provider/provider.dart';
import 'package:myportofolio_mobile/theme/portfolio_colors.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';

/// Halaman utama portofolio, termasuk profil, menu aksi, dan umpan balik.
class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final String npm = "2506614006";
  final String nama = "M. Rezky Syahputra";
  final String kelas = "PBP D";

  final List<ItemHomepage> items = [
    ItemHomepage("Lihat Skills", Icons.psychology, pine, iconColor: ivory),
    ItemHomepage(
      "Lihat Experience",
      Icons.work_outline,
      sage,
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

  /// Meminta konfirmasi Logout, lalu menampilkan umpan balik setelah dialog ditutup.
  Future<void> _confirmLogout(BuildContext context) async {
    final authState = context.read<AuthState>();
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

    if (shouldLogout == true) {
      await authState.logout();
    }

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          shouldLogout == true ? 'Logout berhasil.' : 'Logout dibatalkan.',
        ),
      ),
    );
  }

  /// Menampilkan umpan balik dan membuka detail bila item memilikinya.
  Future<void> _handleItemTap(BuildContext context, ItemHomepage item) async {
    if (item.name == 'Tambah Skill') {
      if (!await ensureLoggedIn(context) || !context.mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SkillFormPage()),
      );
    } else if (item.name == 'Tambah Experience') {
      if (!await ensureLoggedIn(context) || !context.mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ExperienceFormPage()),
      );
    } else {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('Kamu telah menekan tombol ${item.name}!'),
            action:
                item.name == 'Lihat Skills' || item.name == 'Lihat Experience'
                ? SnackBarAction(
                    label: 'Lihat',
                    onPressed: () => _showItemDetails(context, item),
                  )
                : null,
          ),
        );
    }
  }

  Future<List<Map<String, Object?>>> _loadItemDetails(
    BuildContext context,
    ItemHomepage item,
  ) async {
    final apiClient = context.read<ApiClient>();

    if (item.name == 'Lihat Skills') {
      final skills = await apiClient.getSkills();

      return skills
          .map(
            (skill) => <String, Object?>{
              'title': skill.name,
              'subtitle':
                  '${skill.category.label} · ${skill.proficiency.label}',
              'details': <String>[
                'Kategori: ${skill.category.label}',
                'Tingkat kemahiran: ${skill.proficiency.label}',
                if (skill.iconSlug.isNotEmpty) 'Icon slug: ${skill.iconSlug}',
              ],
            },
          )
          .toList();
    }

    final experiences = await apiClient.getExperiences();

    return experiences
        .map(
          (entry) => <String, Object?>{
            'title': entry.title,
            'subtitle': entry.organization,
            'details': <String>[
              'Kategori: ${entry.category.label}',
              'Deskripsi: ${entry.description}',
              'Mulai: ${entry.startedAt.toIso8601String().split('T').first}',
              'Selesai: ${entry.endedAt?.toIso8601String().split('T').first ?? 'Masih berlangsung'}',
            ],
            'thumbnail': entry.thumbnail,
          },
        )
        .toList();
  }

  /// Menampilkan rincian item dalam modal bottom sheet.
  void _showItemDetails(BuildContext context, ItemHomepage item) {
    var detailsFuture = _loadItemDetails(context, item);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: ivory,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => SafeArea(
          child: FutureBuilder<List<Map<String, Object?>>>(
            future: detailsFuture,
            builder: (context, snapshot) {
              final details = snapshot.data ?? const <Map<String, Object?>>[];

              return RefreshIndicator(
                onRefresh: () async {
                  final refreshedFuture = _loadItemDetails(context, item);
                  setModalState(() {
                    detailsFuture = refreshedFuture;
                  });

                  try {
                    await refreshedFuture;
                  } catch (_) {
                    // FutureBuilder menampilkan error dari request yang gagal.
                  }
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
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
                    if (snapshot.connectionState == ConnectionState.waiting)
                      const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (snapshot.hasError)
                      Text('Gagal memuat data: ${snapshot.error}')
                    else if (details.isEmpty)
                      Text(
                        item.name == 'Lihat Skills'
                            ? 'Belum ada skill.'
                            : 'Belum ada pengalaman.',
                      )
                    else
                      ...details.map((entry) {
                        final detailLines = entry['details']! as List<String>;
                        final thumbnail = entry['thumbnail'] as String?;

                        return Card(
                          color: ivory,
                          child: ExpansionTile(
                            leading: Icon(item.icon, color: pine),
                            title: Text(entry['title']! as String),
                            subtitle: Text(entry['subtitle']! as String),
                            children: [
                              ...detailLines.map(
                                (line) =>
                                    ListTile(dense: true, title: Text(line)),
                              ),
                              if (thumbnail != null && thumbnail.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Image.network(
                                    thumbnail,
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => const Text(
                                      'Thumbnail tidak dapat dimuat.',
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold menyediakan struktur visual dasar halaman (AppBar, Body, SnackBar).
    final isLoggedIn = context.watch<AuthState>().isLoggedIn;
    return Scaffold(
      backgroundColor: cream,
      // AppBar menampilkan bar bagian atas halaman aplikasi.
      appBar: AppBar(
        title: const Text(
          'MyPortfolio',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: pine,
        foregroundColor: onDark,
      ),
      drawer: LeftDrawer(
        onHome: () => Navigator.pop(context),
        onAddSkill: () async {
          Navigator.pop(context);
          if (!await ensureLoggedIn(context) || !context.mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SkillFormPage()),
          );
        },
        onAddExperience: () async {
          Navigator.pop(context);
          if (!await ensureLoggedIn(context) || !context.mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ExperienceFormPage()),
          );
        },
      ),
      body: Container(
        decoration: portfolioBackground,
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
                        child: Icon(Icons.person, color: onDark, size: 32),
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
                mainAxisExtent: 152,
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
                  ItemHomepage(
                    isLoggedIn ? 'Logout' : 'Login',
                    isLoggedIn ? Icons.logout : Icons.login,
                    isLoggedIn ? logoutRed : pine,
                  ),
                  isCompact: true,
                  onPressed: () {
                    if (isLoggedIn) {
                      _confirmLogout(context);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    }
                  },
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
