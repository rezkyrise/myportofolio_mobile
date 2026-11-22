import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/screens/skill_form.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/data/experience_store.dart';
import 'package:myportofolio_mobile/theme/portfolio_colors.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _startDateKey = GlobalKey<FormFieldState<DateTime>>();
  final _endDateKey = GlobalKey<FormFieldState<DateTime>>();
  final _titleController = TextEditingController();
  final _organizationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _thumbnailController = TextEditingController();
  ExperienceCategory _category = ExperienceCategory.fullTime;

  @override
  void dispose() {
    _titleController.dispose();
    _organizationController.dispose();
    _descriptionController.dispose();
    _thumbnailController.dispose();
    super.dispose();
  }

  Widget _buildDateField({
    required GlobalKey<FormFieldState<DateTime>> fieldKey,
    required String label,
    required String? Function(DateTime?) validator,
    DateTime? Function()? firstDate,
    bool canClear = false,
  }) {
    return FormField<DateTime>(
      key: fieldKey,
      validator: validator,
      builder: (field) {
        final date = field.value;
        final displayText = date == null
            ? 'Pilih tanggal'
            : MaterialLocalizations.of(context).formatMediumDate(date);

        return InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            errorText: field.errorText,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  icon: const Icon(Icons.calendar_today_outlined),
                  label: Text(displayText),
                  onPressed: () async {
                    final earliestDate = firstDate?.call() ?? DateTime(1900);
                    final previousOrToday =
                        date ?? DateUtils.dateOnly(DateTime.now());
                    final initialDate = previousOrToday.isBefore(earliestDate)
                        ? earliestDate
                        : previousOrToday;
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: initialDate,
                      firstDate: earliestDate,
                      lastDate: DateTime(2100, 12, 31),
                    );

                    if (field.mounted && picked != null) {
                      field.didChange(picked);
                    }
                  },
                ),
              ),
              if (canClear && date != null)
                IconButton(
                  tooltip: 'Kosongkan tanggal selesai',
                  icon: const Icon(Icons.clear),
                  onPressed: () => field.didChange(null),
                ),
            ],
          ),
        );
      },
    );
  }

  void _submitExperience() {
    if (!_formKey.currentState!.validate()) return;

    final thumbnail = _thumbnailController.text.trim();
    final experience = Experience(
      title: _titleController.text.trim(),
      organization: _organizationController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _category,
      startedAt: _startDateKey.currentState!.value!,
      endedAt: _endDateKey.currentState!.value,
      thumbnail: thumbnail.isEmpty ? null : thumbnail,
    );
    experienceStore.add(experience);

    final dates = MaterialLocalizations.of(context);
    final start = dates.formatMediumDate(experience.startedAt);
    final endDate = experience.endedAt;
    final end = endDate == null
        ? 'Masih berlangsung'
        : dates.formatMediumDate(endDate);

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Ringkasan Experience'),
        scrollable: true,
        content: Text(
          [
            'Judul: ${experience.title}',
            'Organisasi: ${experience.organization}',
            'Kategori: ${experience.category.label}',
            'Deskripsi: ${experience.description}',
            'Tanggal mulai: $start',
            'Tanggal selesai: $end',
            'URL thumbnail: ${experience.thumbnail ?? 'Tidak diisi'}',
          ].join('\n\n'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String? get _validThumbnailUrl {
    final text = _thumbnailController.text.trim();
    if (text.isEmpty) return null;

    final uri = Uri.tryParse(text);
    if (uri == null ||
        (uri.scheme != 'http' && uri.scheme != 'https') ||
        uri.host.isEmpty ||
        text.contains(RegExp(r'\s'))) {
      return null;
    }

    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        title: const Text('Tambah Experience'),
        backgroundColor: pine,
        foregroundColor: onDark,
      ),
      drawer: LeftDrawer(
        onHome: () {
          Navigator.popUntil(context, (route) => route.isFirst);
        },
        onAddSkill: () {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const SkillFormPage()),
          );
        },
        onAddExperience: () => Navigator.pop(context),
      ),
      body: DecoratedBox(
        decoration: portfolioBackground,
        child: SafeArea(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Judul pengalaman',
                    hintText: 'Contoh: Asisten Praktikum',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    final title = value?.trim() ?? '';
                    if (title.isEmpty) return 'Judul wajib diisi.';
                    if (title.runes.length > 255) {
                      return 'Judul maksimal 255 karakter.';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),
                DropdownButtonFormField<ExperienceCategory>(
                  initialValue: _category,
                  decoration: const InputDecoration(
                    labelText: 'Kategori',
                    border: OutlineInputBorder(),
                  ),
                  items: ExperienceCategory.values.map((category) {
                    return DropdownMenuItem<ExperienceCategory>(
                      value: category,
                      child: Text(category.label),
                    );
                  }).toList(),
                  onChanged: (category) {
                    if (category == null) return;
                    setState(() => _category = category);
                  },
                ),

                const SizedBox(height: 16),
                TextFormField(
                  controller: _organizationController,
                  decoration: const InputDecoration(
                    labelText: 'Organisasi',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    final organization = value?.trim() ?? '';
                    if (organization.isEmpty) {
                      return 'Nama organisasi wajib diisi.';
                    }
                    if (organization.runes.length > 255) {
                      return 'Nama organisasi maksimal 255 karakter.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi',
                    hintText: 'Ceritakan peran dan kontribusimu.',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  minLines: 3,
                  maxLines: 6,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Deskripsi wajib diisi.';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),
                _buildDateField(
                  fieldKey: _startDateKey,
                  label: 'Tanggal mulai',
                  validator: (date) {
                    if (date == null) return 'Tanggal mulai wajib diisi.';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildDateField(
                  fieldKey: _endDateKey,
                  label: 'Tanggal selesai (opsional)',
                  canClear: true,
                  firstDate: () => _startDateKey.currentState?.value,
                  validator: (endedAt) {
                    final startedAt = _startDateKey.currentState?.value;
                    if (startedAt != null &&
                        endedAt != null &&
                        endedAt.isBefore(startedAt)) {
                      return 'Tanggal selesai tidak boleh sebelum tanggal mulai.';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),
                TextFormField(
                  controller: _thumbnailController,
                  decoration: const InputDecoration(
                    labelText: 'URL thumbnail (opsional)',
                    hintText: 'https://contoh.com/foto.jpg',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.url,
                  onChanged: (_) => setState(() {}),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) return null;

                    final uri = Uri.tryParse(text);
                    if (uri == null ||
                        (uri.scheme != 'http' && uri.scheme != 'https') ||
                        uri.host.isEmpty ||
                        text.contains(RegExp(r'\s'))) {
                      return 'Masukkan URL lengkap, misalnya https://contoh.com/foto.jpg.';
                    }

                    return null;
                  },
                ),
                if (_validThumbnailUrl case final imageUrl?) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 96,
                        alignment: Alignment.center,
                        color: ivory,
                        child: const Text(
                          'Gambar tidak dapat dimuat. Periksa URL dan koneksi.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _submitExperience,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Simpan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
