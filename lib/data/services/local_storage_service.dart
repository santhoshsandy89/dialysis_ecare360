import 'dart:convert';

import 'package:ecare360/data/models/bed_status_model.dart'; // Import BedStatusModel
import 'package:ecare360/data/models/doctor_model.dart';
import 'package:ecare360/data/models/patient_model.dart';
import 'package:ecare360/data/models/treatment_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/utils/logger.dart';

/// Local storage service using SharedPreferences
class LocalStorageService {
  static SharedPreferences? _prefs;
  static const String _prefix = 'ecare360_';
  static const String patientsKey = "patients";
  static const String treatmentsKey = "treatments";

  /// Initialize the service
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    AppLogger.info('LocalStorageService initialized');
  }

  /// Get SharedPreferences instance
  static SharedPreferences get _instance {
    if (_prefs == null) {
      throw Exception(
          'LocalStorageService not initialized. Call init() first.');
    }
    return _prefs!;
  }

  /// Store a string value
  static Future<bool> setString(String key, String value) async {
    try {
      final result = await _instance.setString('$_prefix$key', value);
      AppLogger.debug('Stored string: $key = $value');
      return result;
    } catch (e) {
      AppLogger.error('Failed to store string: $key', e);
      return false;
    }
  }

  /// Get a string value
  static Future<String?> getString(String key) async {
    try {
      final value = _instance.getString('$_prefix$key');
      AppLogger.debug('Retrieved string for key : $_prefix$key = $value');
      return value;
    } catch (e) {
      AppLogger.error('Failed to get string: $key', e);
      return null;
    }
  }

  /// Store an integer value
  static Future<bool> setInt(String key, int value) async {
    try {
      final result = await _instance.setInt('$_prefix$key', value);
      AppLogger.debug('Stored int: $key = $value');
      return result;
    } catch (e) {
      AppLogger.error('Failed to store int: $key', e);
      return false;
    }
  }

  /// Get an integer value
  static Future<int?> getInt(String key) async {
    try {
      final value = _instance.getInt('$_prefix$key');
      AppLogger.debug('Retrieved int: $key = $value');
      return value;
    } catch (e) {
      AppLogger.error('Failed to get int: $key', e);
      return null;
    }
  }

  /// Store a boolean value
  static Future<bool> setBool(String key, bool value) async {
    try {
      final result = await _instance.setBool('$_prefix$key', value);
      AppLogger.debug('Stored bool: $key = $value');
      return result;
    } catch (e) {
      AppLogger.error('Failed to store bool: $key', e);
      return false;
    }
  }

  /// Get a boolean value
  static Future<bool?> getBool(String key) async {
    try {
      final value = _instance.getBool('$_prefix$key');
      AppLogger.debug('Retrieved bool: $key = $value');
      return value;
    } catch (e) {
      AppLogger.error('Failed to get bool: $key', e);
      return null;
    }
  }

  /// Store a double value
  static Future<bool> setDouble(String key, double value) async {
    try {
      final result = await _instance.setDouble('$_prefix$key', value);
      AppLogger.debug('Stored double: $key = $value');
      return result;
    } catch (e) {
      AppLogger.error('Failed to store double: $key', e);
      return false;
    }
  }

  /// Get a double value
  static Future<double?> getDouble(String key) async {
    try {
      final value = _instance.getDouble('$_prefix$key');
      AppLogger.debug('Retrieved double: $key = $value');
      return value;
    } catch (e) {
      AppLogger.error('Failed to get double: $key', e);
      return null;
    }
  }

  /// Store a list of strings
  static Future<bool> setStringList(String key, List<String> value) async {
    try {
      final result = await _instance.setStringList('$_prefix$key', value);
      AppLogger.debug('Stored string list: $key = $value');
      return result;
    } catch (e) {
      AppLogger.error('Failed to store string list: $key', e);
      return false;
    }
  }

  /// Get a list of strings
  static Future<List<String>?> getStringList(String key) async {
    try {
      final value = _instance.getStringList('$_prefix$key');
      AppLogger.debug('Retrieved string list: $key = $value');
      return value;
    } catch (e) {
      AppLogger.error('Failed to get string list: $key', e);
      return null;
    }
  }

  /// Store a JSON object
  static Future<bool> setJson(String key, Map<String, dynamic> value) async {
    try {
      final jsonString = jsonEncode(value);
      final result = await setString(key, jsonString);
      AppLogger.debug('Stored JSON: $key = $value');
      return result;
    } catch (e) {
      AppLogger.error('Failed to store JSON: $key', e);
      return false;
    }
  }

  /// Get a JSON object
  static Future<Map<String, dynamic>?> getJson(String key) async {
    try {
      final jsonString = await getString(key);
      if (jsonString == null) return null;

      final value = jsonDecode(jsonString) as Map<String, dynamic>;
      AppLogger.debug('Retrieved JSON: $key = $value');
      return value;
    } catch (e) {
      AppLogger.error('Failed to get JSON: $key', e);
      return null;
    }
  }

  /// Remove a value
  static Future<bool> remove(String key) async {
    try {
      final result = await _instance.remove('$_prefix$key');
      AppLogger.debug('Removed: $key');
      return result;
    } catch (e) {
      AppLogger.error('Failed to remove: $key', e);
      return false;
    }
  }

  // New methods for storing/retrieving patient and doctor lists
  static const String _patientsKey = 'ecare360_patients_list';
  static const String _doctorsKey = 'ecare360_doctors_list';
  static const String _bedStatusesKey = 'ecare360_bed_status_list';
  static const String _keyEmail = "saved_email";
  static const String _keyPassword = "saved_password";
  static const String _keyRememberMe = "remember_me";

  static Future<void> savePatientsList(List<PatientModel> patients) async {
    final prefs = await _instance;
    final String encodedList =
        json.encode(patients.map((p) => p.toJson()).toList());
    await prefs.setString(_patientsKey, encodedList);
    AppLogger.debug('Patients list saved locally.');
  }

  static Future<List<PatientModel>> getPatientsList() async {
    final prefs = await _instance;
    final String? encodedList = prefs.getString(_patientsKey);
    if (encodedList == null) {
      return [];
    }
    final List<dynamic> decodedList = json.decode(encodedList);
    AppLogger.debug('Patients list retrieved locally.');
    return decodedList.map((json) => PatientModel.fromJson(json)).toList();
  }

  static Future<void> saveDoctorsList(List<DoctorModel> doctors) async {
    final prefs = await _instance;
    final String encodedList =
        json.encode(doctors.map((d) => d.toJson()).toList());
    await prefs.setString(_doctorsKey, encodedList);
    AppLogger.debug('Doctors list saved locally.');
  }

  static Future<List<DoctorModel>> getDoctorsList() async {
    final prefs = await _instance;
    final String? encodedList = prefs.getString(_doctorsKey);
    if (encodedList == null) {
      return [];
    }
    final List<dynamic> decodedList = json.decode(encodedList);
    AppLogger.debug('Doctors list retrieved locally.');
    return decodedList.map((json) => DoctorModel.fromJson(json)).toList();
  }

  // New methods for Bed Statuses
  static Future<void> saveBedStatuses(List<BedStatusModel> statuses) async {
    final prefs = _instance;
    final String encodedList =
        json.encode(statuses.map((s) => s.toJson()).toList());
    await prefs.setString(_bedStatusesKey, encodedList);
    AppLogger.debug('Bed statuses saved locally.');
  }

  static Future<List<BedStatusModel>> getBedStatuses() async {
    final prefs = await _instance;
    final String? encodedList = prefs.getString(_bedStatusesKey);
    if (encodedList == null) {
      return [];
    }
    final List<dynamic> decodedList = json.decode(encodedList);
    AppLogger.debug('Bed statuses retrieved locally.');
    return decodedList.map((json) => BedStatusModel.fromJson(json)).toList();
  }

  /// Clear all stored values
  static Future<bool> clear() async {
    try {
      final result = await _instance.clear();
      AppLogger.info('Cleared all stored values');
      return result;
    } catch (e) {
      AppLogger.error('Failed to clear storage', e);
      return false;
    }
  }

  // ---------- PATIENTS ----------
  static Future<List<PatientModel>> getPatients() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(patientsKey) ?? [];
    return data.map((e) => PatientModel.fromJson(jsonDecode(e))).toList();
  }

  static Future<void> savePatient(PatientModel patient) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(patientsKey) ?? [];
    existing.add(jsonEncode(patient.toJson()));
    await prefs.setStringList(patientsKey, existing);
  }

  // ---------- TREATMENTS ----------
  static Future<List<Treatment>> getTreatments() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(treatmentsKey) ?? [];
    return data
        .map((e) {
          try {
            final Map<String, dynamic> jsonMap = jsonDecode(e);
            if (jsonMap['patient'] is String) {
              jsonMap['patient'] = jsonDecode(jsonMap['patient']);
            }
            return Treatment.fromJson(jsonMap);
          } catch (err) {
            print("Invalid treatment entry removed: $e");
            return null;
          }
        })
        .whereType<Treatment>()
        .toList();
  }

  static Future<void> saveTreatment(Treatment treatment) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(treatmentsKey) ?? [];

    final jsonStr = jsonEncode(treatment.toJson());
    data.add(jsonStr);

    await prefs.setStringList(treatmentsKey, data);
  }

  /// Check if a key exists
  static bool containsKey(String key) {
    try {
      final result = _instance.containsKey('$_prefix$key');
      AppLogger.debug('Contains key: $key = $result');
      return result;
    } catch (e) {
      AppLogger.error('Failed to check key: $key', e);
      return false;
    }
  }

  /// Get all keys
  static Set<String> getKeys() {
    try {
      final keys = _instance
          .getKeys()
          .where((key) => key.startsWith(_prefix))
          .map((key) => key.substring(_prefix.length))
          .toSet();
      AppLogger.debug('Retrieved keys: $keys');
      return keys;
    } catch (e) {
      AppLogger.error('Failed to get keys', e);
      return <String>{};
    }
  }

  static Future<void> saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEmail, email);
  }

  static Future<String?> getSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }

  static Future<void> savePassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPassword, password);
  }

  static Future<String?> getSavedPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPassword);
  }

  static Future<void> setRememberMe(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyRememberMe, value);
  }

  static Future<bool?> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyRememberMe);
  }

  static Future<void> clearSavedLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyPassword);
    await prefs.remove(_keyRememberMe);
  }
}
