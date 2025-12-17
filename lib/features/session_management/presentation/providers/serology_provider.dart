import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecare360/data/models/session_data_model.dart';
import 'package:ecare360/main.dart'; // For sharedPreferencesProvider

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
    SerologyResults newState;
    switch (key) {
      case 'hcvResult':
        newState = SerologyResults(
            hcvResult: value,
            hbsagResult: state.hbsagResult,
            hivResult: state.hivResult,
            hcvRnaResult: state.hcvRnaResult,
            pcrResult: state.pcrResult);
        break;
      case 'hbsagResult':
        newState = SerologyResults(
            hcvResult: state.hcvResult,
            hbsagResult: value,
            hivResult: state.hivResult,
            hcvRnaResult: state.hcvRnaResult,
            pcrResult: state.pcrResult);
        break;
      case 'hivResult':
        newState = SerologyResults(
            hcvResult: state.hcvResult,
            hbsagResult: state.hbsagResult,
            hivResult: value,
            hcvRnaResult: state.hcvRnaResult,
            pcrResult: state.pcrResult);
        break;
      case 'hcvRnaResult':
        newState = SerologyResults(
            hcvResult: state.hcvResult,
            hbsagResult: state.hbsagResult,
            hivResult: state.hivResult,
            hcvRnaResult: value,
            pcrResult: state.pcrResult);
        break;
      case 'pcrResult':
        newState = SerologyResults(
            hcvResult: state.hcvResult,
            hbsagResult: state.hbsagResult,
            hivResult: state.hivResult,
            hcvRnaResult: state.hcvRnaResult,
            pcrResult: value);
        break;
      default:
        newState = state; // No change if key is not recognized
    }
    state = newState;
    _saveSerologyResults();
  }
}

final serologyProvider = StateNotifierProvider<SerologyNotifier, SerologyResults>(
  (ref) {
    final prefs = ref.watch(sharedPreferencesProvider);
    return SerologyNotifier(prefs);
  },
);
