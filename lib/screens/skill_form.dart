import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/data/skill_store.dart';
import 'package:myportofolio_mobile/models/skill.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';

import 'package:myportofolio_mobile/theme/portfolio_colors.dart';

class SkillFormPage extends StatefulWidget {
  const SkillFormPage({super.key});

  @override
  State<SkillFormPage> createState() => _SkillFormPageState();
}

class _SkillFormPageState extends State<SkillFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _skillNameController = TextEditingController();

  SkillCategory _category = SkillCategory.language;
  SkillProficiency _level = SkillProficiency.intermediate;

  @override
  void dispose() {
    _skillNameController.dispose();
    super.dispose();
  }

  void _showSkillSummary() {
    if (!_formKey.currentState!.validate()) return;

    final skill = Skill(
      name: _skillNameController.text.trim(),
      category: _category,
      proficiency: _level,
    );
    skillStore.add(skill);

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Skill berhasil ditambahkan!'),
        scrollable: true,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama skill: ${skill.name}'),
            Text('Kategori: ${skill.category.label}'),
            Text('Tingkat kemahiran: ${skill.proficiency.label}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _formKey.currentState!.reset();
              _skillNameController.clear();
              setState(() {
                _category = SkillCategory.language;
                _level = SkillProficiency.intermediate;
              });
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        title: const Text('Tambah Skill'),
        backgroundColor: pine,
        foregroundColor: onDark,
      ),
      drawer: LeftDrawer(
        onHome: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
        onAddSkill: () => Navigator.pop(context),
        onAddExperience: () {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ExperienceFormPage()),
          );
        },
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: portfolioBackground,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: TextFormField(
                        controller: _skillNameController,
                        decoration: InputDecoration(
                          labelText: 'Nama Skill',
                          hintText: 'Contoh: Flutter',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        validator: (value) {
                          final name = value?.trim() ?? '';
                          if (name.isEmpty) {
                            return 'Nama skill tidak boleh kosong!';
                          }
                          if (name.runes.length > 100) {
                            return 'Nama skill maksimal 100 karakter.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: DropdownButtonFormField<SkillCategory>(
                        initialValue: SkillCategory.language,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: 'Kategori Skill',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        items: SkillCategory.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(category.label),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _category = value);
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: DropdownButtonFormField<SkillProficiency>(
                        initialValue: SkillProficiency.intermediate,
                        decoration: InputDecoration(
                          labelText: 'Tingkat Kemahiran',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        items: SkillProficiency.values
                            .map(
                              (level) => DropdownMenuItem(
                                value: level,
                                child: Text(level.label),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) setState(() => _level = value);
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: ElevatedButton(
                          onPressed: _showSkillSummary,
                          child: const Text('Simpan'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
