import 'dart:convert';
import 'package:ecare360/features/session_management/presentation/providers/bp_entry_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecare360/data/models/session_data_model.dart';

class SerologyNotifier extends StateNotifier<SerologyResults> {
  final SharedPreferences _prefs;
  static const String _serologyKey = 'serology_results';

  SerologyNotifier(this._prefs) : super(SerologyResults()) {
    _loadSerologyResults();
  }

  Future<void> _loadSerologyResults() async {
    final serologyJson = _prefs.getString(_serologyKey);
    if (serologyJson != null && serologyJson.isNotEmpty) {
      state = SerologyResults.fromMap(json.decode(serologyJson));
    }
  }

  Future<void> _saveSerologyResults() async {
    await _prefs.setString(_serologyKey, json.encode(state.toMap()));
  }

  void updateSerologyResult(String key, String? value) {
    state = state.copyWith(
      hcvResult: key == 'hcvResult' ? value : state.hcvResult,
      hbsagResult: key == 'hbsagResult' ? value : state.hbsagResult,
      hivResult: key == 'hivResult' ? value : state.hivResult,
      hcvRnaResult: key == 'hcvRnaResult' ? value : state.hcvRnaResult,
      pcrResult: key == 'pcrResult' ? value : state.pcrResult,
    );
    _saveSerologyResults();
  }
}

final serologyProvider =
    StateNotifierProvider<SerologyNotifier, SerologyResults>(
  (ref) {
    final prefs = ref.watch(sharedPreferencesProvider);
    return SerologyNotifier(prefs);
  },
);
