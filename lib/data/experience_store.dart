import 'package:myportofolio_mobile/models/experience.dart';

class ExperienceStore {
  final List<Experience> _entries = [];

  List<Experience> get entries => List.unmodifiable(_entries);

  void add(Experience experience) {
    _entries.add(experience);
  }
}
final experienceStore = ExperienceStore();