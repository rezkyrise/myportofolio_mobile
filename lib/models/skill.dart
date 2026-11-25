import 'package:json_annotation/json_annotation.dart';

part 'skill.g.dart';

enum SkillCategory {
  language('language', 'Programming Language'),
  framework('framework', 'Framework & Developer Tool'),
  competency('competency', 'Core Competency');

  const SkillCategory(this.apiValue, this.label);

  final String apiValue;
  final String label;
}

enum SkillProficiency {
  beginner('beginner', 'Beginner'),
  intermediate('intermediate', 'Intermediate'),
  advanced('advanced', 'Advanced');

  const SkillProficiency(this.apiValue, this.label);

  final String apiValue;
  final String label;
}

class SkillCategoryConverter implements JsonConverter<SkillCategory, String> {
  const SkillCategoryConverter();

  @override
  SkillCategory fromJson(String json) =>
      SkillCategory.values.firstWhere((category) => category.apiValue == json);

  @override
  String toJson(SkillCategory object) => object.apiValue;
}

class SkillProficiencyConverter
    implements JsonConverter<SkillProficiency, String> {
  const SkillProficiencyConverter();

  @override
  SkillProficiency fromJson(String json) => SkillProficiency.values.firstWhere(
    (proficiency) => proficiency.apiValue == json,
  );

  @override
  String toJson(SkillProficiency object) => object.apiValue;
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Skill {
  const Skill({
    this.id,
    required this.name,
    this.category = SkillCategory.language,
    this.proficiency = SkillProficiency.intermediate,
    this.iconSlug = '',
    this.categoryDisplay,
    this.proficiencyDisplay,
    this.starCount = 0,
    this.isStarred = false,
    this.starredByNames = '',
  });

  factory Skill.fromJson(Map<String, dynamic> json) => _$SkillFromJson(json);

  @JsonKey(includeToJson: false)
  final String? id;

  final String name;

  @SkillCategoryConverter()
  final SkillCategory category;

  @SkillProficiencyConverter()
  final SkillProficiency proficiency;

  final String iconSlug;

  @JsonKey(includeToJson: false)
  final String? categoryDisplay;

  @JsonKey(includeToJson: false)
  final String? proficiencyDisplay;

  @JsonKey(includeToJson: false)
  final int starCount;

  @JsonKey(includeToJson: false)
  final bool isStarred;

  @JsonKey(includeToJson: false)
  final String starredByNames;

  Map<String, dynamic> toJson() => _$SkillToJson(this);
}
