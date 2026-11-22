import 'package:myportofolio_mobile/models/skill.dart';

class SkillStore {
  final List<Skill> _entries = [];

  List<Skill> get entries => List.unmodifiable(_entries);

  void add(Skill skill) {
    _entries.add(skill);
  }
}

final skillStore = SkillStore();
