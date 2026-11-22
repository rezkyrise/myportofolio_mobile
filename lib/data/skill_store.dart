import 'package:myportofolio_mobile/models/skill.dart';

/// Menyimpan Skill selama sesi aplikasi, tanpa persistensi lokal.
class SkillStore {
  final List<Skill> _entries = [];

  /// Mengembalikan daftar baca-saja agar perubahan dilakukan lewat [add].
  List<Skill> get entries => List.unmodifiable(_entries);

  void add(Skill skill) {
    _entries.add(skill);
  }
}

final skillStore = SkillStore();
