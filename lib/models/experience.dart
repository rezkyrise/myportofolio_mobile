enum ExperienceCategory {
  internship('internship', 'Internship'),
  research('research', 'Research'),
  volunteer('volunteer', 'Volunteer'),
  partTime('part-time', 'Part-Time'),
  fullTime('full-time', 'Full-Time'),
  freelance('freelance', 'Freelance');

  const ExperienceCategory(this.value, this.label);

  final String value;
  final String label;
}

class Experience {
  const Experience({
    required this.title,
    required this.description,
    required this.startedAt,
    required this.organization,
    this.category = ExperienceCategory.fullTime,
    this.endedAt,
    this.thumbnail,
  });

  final String title;
  final String organization;
  final String description;
  final ExperienceCategory category;
  final DateTime startedAt;
  final DateTime? endedAt;
  final String? thumbnail;

  bool get isOngoing => endedAt == null;
}