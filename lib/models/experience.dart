import 'package:json_annotation/json_annotation.dart';

part 'experience.g.dart';

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

class ExperienceCategoryConverter
    implements JsonConverter<ExperienceCategory, String> {
  const ExperienceCategoryConverter();

  @override
  ExperienceCategory fromJson(String json) => ExperienceCategory.values
      .firstWhere((category) => category.value == json);

  @override
  String toJson(ExperienceCategory object) => object.value;
}

class DateOnlyConverter implements JsonConverter<DateTime, String> {
  const DateOnlyConverter();

  @override
  DateTime fromJson(String json) => DateTime.parse(json);

  @override
  String toJson(DateTime object) =>
      '${object.year.toString().padLeft(4, '0')}-'
      '${object.month.toString().padLeft(2, '0')}-'
      '${object.day.toString().padLeft(2, '0')}';
}

class NullableDateOnlyConverter implements JsonConverter<DateTime?, String?> {
  const NullableDateOnlyConverter();

  @override
  DateTime? fromJson(String? json) =>
      json == null ? null : DateTime.parse(json);

  @override
  String? toJson(DateTime? object) => object == null
      ? null
      : '${object.year.toString().padLeft(4, '0')}-'
            '${object.month.toString().padLeft(2, '0')}-'
            '${object.day.toString().padLeft(2, '0')}';
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Experience {
  const Experience({
    this.id,
    required this.title,
    required this.description,
    required this.startedAt,
    required this.organization,
    this.category = ExperienceCategory.fullTime,
    this.endedAt,
    this.thumbnail,
    this.imageUrl,
    this.isOngoing = false,
    this.starCount = 0,
    this.isStarred = false,
    this.starredByNames = '',
  });

  factory Experience.fromJson(Map<String, dynamic> json) =>
      _$ExperienceFromJson(json);

  @JsonKey(includeToJson: false)
  final String? id;

  final String title;
  final String organization;
  final String description;

  @ExperienceCategoryConverter()
  final ExperienceCategory category;

  @DateOnlyConverter()
  final DateTime startedAt;

  @NullableDateOnlyConverter()
  final DateTime? endedAt;

  final String? thumbnail;

  @JsonKey(includeToJson: false)
  final String? imageUrl;

  @JsonKey(includeToJson: false)
  final bool isOngoing;

  @JsonKey(includeToJson: false)
  final int starCount;

  @JsonKey(includeToJson: false)
  final bool isStarred;

  @JsonKey(includeToJson: false)
  final String starredByNames;

  Map<String, dynamic> toJson() => _$ExperienceToJson(this);

  bool get isCurrentlyOngoing => endedAt == null;
}
