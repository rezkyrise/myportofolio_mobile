import 'package:myportofolio_mobile/models/experience.dart';

/// Menyimpan Experience selama sesi aplikasi, tanpa persistensi lokal.
class ExperienceStore {
  final List<Experience> _entries = [];

  /// Mengembalikan daftar baca-saja agar perubahan dilakukan lewat [add].
  List<Experience> get entries => List.unmodifiable(_entries);

  void add(Experience experience) {
    _entries.add(experience);
  }
}
final experienceStore = ExperienceStore();
