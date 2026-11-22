enum SkillCategory {
  language('Programming Language'),
  framework('Framework & Developer Tool'),
  competency('Core Competency');

  const SkillCategory(this.label);

  final String label;
}

enum SkillProficiency {
  beginner('Beginner'),
  intermediate('Intermediate'),
  advanced('Advanced');

  const SkillProficiency(this.label);

  final String label;
}

class Skill {
  const Skill({
    required this.name,
    this.category = SkillCategory.language,
    this.proficiency = SkillProficiency.intermediate,
  });

  final String name;
  final SkillCategory category;
  final SkillProficiency proficiency;
}
