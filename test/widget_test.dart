import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/experience_form.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> login(WidgetTester tester) async {
  await tester.enterText(find.byType(TextFormField).at(0), 'testuser');
  await tester.enterText(find.byType(TextFormField).at(1), 'password');
  await tapVisible(tester, find.widgetWithText(FilledButton, 'Login'));
}

ApiClient createTestApiClient() {
  final skills = <Map<String, dynamic>>[];
  final experiences = <Map<String, dynamic>>[];

  http.Response jsonResponse(Object body, int statusCode) {
    return http.Response(
      jsonEncode(body),
      statusCode,
      headers: {'content-type': 'application/json'},
    );
  }

  return ApiClient(
    client: MockClient((request) async {
      final path = request.url.path;

      if (path == '/api/v1/auth/token/') {
        return jsonResponse({'token': 'test-token'}, 200);
      }

      if (path == '/api/v1/auth/logout/') {
        return http.Response('', 204);
      }

      if (request.method == 'GET' && path == '/api/v1/skills/') {
        return jsonResponse(skills, 200);
      }

      if (request.method == 'POST' && path == '/api/v1/skills/') {
        final skill = jsonDecode(request.body) as Map<String, dynamic>;
        final createdSkill = {
          ...skill,
          'id': 'skill-${skills.length + 1}',
          'category_display': skill['category'],
          'proficiency_display': skill['proficiency'],
          'star_count': 0,
          'is_starred': false,
          'starred_by_names': '',
        };
        skills.add(createdSkill);
        return jsonResponse(createdSkill, 201);
      }

      if (request.method == 'GET' && path == '/api/v1/experiences/') {
        return jsonResponse(experiences, 200);
      }

      if (request.method == 'POST' && path == '/api/v1/experiences/') {
        final experience = jsonDecode(request.body) as Map<String, dynamic>;
        final createdExperience = {
          ...experience,
          'id': 'experience-${experiences.length + 1}',
          'category_display': experience['category'],
          'image_url': null,
          'is_ongoing': experience['ended_at'] == null,
          'star_count': 0,
          'is_starred': false,
          'starred_by_names': '',
        };
        experiences.add(createdExperience);
        return jsonResponse(createdExperience, 201);
      }

      return jsonResponse({'detail': 'Unexpected request: $path'}, 404);
    }),
  );
}

void main() {
  testWidgets('Daftar awal kosong dan skill valid tersimpan sekali', (
    tester,
  ) async {
    await tester.pumpWidget(MyApp(apiClient: createTestApiClient()));

    Future<void> tap(Finder finder) => tapVisible(tester, finder);

    await tap(find.text('Lihat Skills'));
    await tap(find.text('Lihat'));
    expect(find.text('Belum ada skill.'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    await tap(find.text('Tambah Skill'));
    await login(tester);
    final nameField = find.byType(TextFormField);
    final saveButton = find.text('Simpan');

    await tester.enterText(nameField, '   ');
    await tap(saveButton);
    expect(find.text('Nama skill tidak boleh kosong!'), findsOneWidget);
    expect(find.byType(AlertDialog), findsNothing);

    await tester.enterText(nameField, 'a' * 101);
    await tap(saveButton);
    expect(find.text('Nama skill maksimal 100 karakter.'), findsOneWidget);

    await tester.enterText(nameField, '  Flutter  ');
    await tap(find.text('Programming Language').hitTestable());
    await tap(find.text('Framework & Developer Tool').last);
    await tap(find.text('Intermediate').hitTestable());
    await tap(find.text('Advanced').last);
    await tap(saveButton);
    expect(find.text('Nama skill: Flutter'), findsOneWidget);
    expect(find.text('Kategori: Framework & Developer Tool'), findsOneWidget);
    expect(find.text('Tingkat kemahiran: Advanced'), findsOneWidget);
    await tap(find.text('OK'));

    await tester.enterText(nameField, 'Dart');
    await tap(saveButton);
    expect(find.text('Kategori: Programming Language'), findsOneWidget);
    expect(find.text('Tingkat kemahiran: Intermediate'), findsOneWidget);
    await tap(find.text('OK'));

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    for (var visit = 0; visit < 2; visit++) {
      await tap(find.text('Lihat Skills'));
      await tap(find.text('Lihat'));
      final rows = find.descendant(
        of: find.byType(BottomSheet),
        matching: find.byType(ExpansionTile),
      );
      final titles = tester
          .widgetList<ExpansionTile>(rows)
          .map((tile) => (tile.title as Text).data)
          .toList();

      expect(titles, ['Flutter', 'Dart']);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
    }
  });

  for (final width in [320.0, 390.0]) {
    testWidgets('Kartu Tambah Experience dapat dibuka pada lebar $width', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(Size(width, 740));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(MyApp(apiClient: createTestApiClient()));
      await tapVisible(tester, find.text('Tambah Experience'));
      await login(tester);
      expect(find.byType(ExperienceFormPage), findsOneWidget);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Lihat Experience'), findsOneWidget);
    });
  }

  testWidgets(
    'Experience dari drawer divalidasi, diringkas, dan disimpan sekali',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1150));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(MyApp(apiClient: createTestApiClient()));
      Future<void> tap(Finder finder) => tapVisible(tester, finder);

      Future<void> openDrawerItem(String name) async {
        await tap(find.byType(DrawerButton));
        await tap(
          find.descendant(of: find.byType(Drawer), matching: find.text(name)),
        );
      }

      Future<void> enter(String label, String value) async {
        final field = find.widgetWithText(TextFormField, label);
        await tester.ensureVisible(field);
        await tester.enterText(field, value);
      }

      await tap(find.text('Lihat Experience'));
      await tap(find.text('Lihat'));
      expect(find.text('Belum ada pengalaman.'), findsOneWidget);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      await openDrawerItem('Tambah Experience');
      await login(tester);
      await enter('Judul pengalaman', 'Tutor Kalkulus');
      await enter('Organisasi', '   ');
      await enter('Deskripsi', 'Mengajar kalkulus');
      await enter('URL thumbnail (opsional)', 'foto.jpg');
      await tap(find.text('Simpan'));
      expect(find.text('Nama organisasi wajib diisi.'), findsOneWidget);
      expect(find.text('Tanggal mulai wajib diisi.'), findsOneWidget);
      expect(find.textContaining('Masukkan URL lengkap'), findsOneWidget);
      expect(find.byType(AlertDialog), findsNothing);

      await enter('Organisasi', 'Fasilkom UI');
      await enter('URL thumbnail (opsional)', 'https://example.org/foto.jpg');
      await tap(find.text('Full-Time'));
      await tap(find.text('Research').last);
      await tap(find.text('Pilih tanggal').first);
      final picker = tester.widget<DatePickerDialog>(
        find.byType(DatePickerDialog),
      );
      final dates = MaterialLocalizations.of(
        tester.element(find.byType(DatePickerDialog)),
      );
      final day = dates.formatMediumDate(picker.initialDate!);
      await tap(find.text('OK'));
      await tap(find.text('Pilih tanggal'));
      await tap(find.text('OK'));

      Future<void> saveAndCheck(String title, String end) async {
        await tap(find.text('Simpan'));
        expect(
          find.text(
            [
              'Judul: $title',
              'Organisasi: Fasilkom UI',
              'Kategori: Research',
              'Deskripsi: Mengajar kalkulus',
              'Tanggal mulai: $day',
              'Tanggal selesai: $end',
              'URL thumbnail: https://example.org/foto.jpg',
            ].join('\n\n'),
          ),
          findsOneWidget,
        );
        await tap(find.text('OK'));
        expect(find.byType(ExperienceFormPage), findsOneWidget);
      }

      await saveAndCheck('Tutor Kalkulus', day);
      await enter('Judul pengalaman', 'Asisten Praktikum');
      await tap(find.byTooltip('Kosongkan tanggal selesai'));
      await saveAndCheck('Asisten Praktikum', 'Masih berlangsung');
      await openDrawerItem('Home');

      await tap(find.text('Lihat Experience').first);
      await tap(find.text('Lihat'));
      final rows = find.descendant(
        of: find.byType(BottomSheet),
        matching: find.byType(ExpansionTile),
      );
      final titles = tester
          .widgetList<ExpansionTile>(rows)
          .map((tile) => (tile.title as Text).data)
          .toList();

      expect(titles, ['Tutor Kalkulus', 'Asisten Praktikum']);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
    },
  );
}
