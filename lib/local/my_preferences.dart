import 'package:shared_preferences/shared_preferences.dart';

class MyAppPreferences {
  static final MyAppPreferences _instance = MyAppPreferences._internal();

  factory MyAppPreferences() {
    return _instance;
  }

  MyAppPreferences._internal() {
    SharedPreferences.getInstance().then((value) => preferences = value);
  }

  late SharedPreferences preferences;

  static Future<void> setListPost(List<String> value) async {
    await _instance.preferences.setStringList("list-post", value);
  }

  static Future<void> setAddJsonPost(String json) async {
    final value = await getListPost();
    value.add(json);
    await _instance.preferences.setStringList("list-post", value);
  }

  // [1, 2, 3, 4]

  // index = 1

  static Future<void> setCreateTableShooping(bool value) async {
    await _instance.preferences.setBool("create-shooping1", value);
  }

  static Future<bool> getCreateTableShooping() async {
    return _instance.preferences.getBool("create-shooping1") ?? false;
  }

  static Future<void> updateListPost(String json, int index) async {
    final value = await getListPost();
    value.replaceRange(index, index+1, [json]);
    await _instance.preferences.setStringList("list-post", value);
  }

  static Future<List<String>> getListPost() async {
    return _instance.preferences.getStringList("list-post") ?? [];
  }

  static Future<void> setListTaskCategory(List<String> value) async {
    await _instance.preferences.setStringList("list-task-category", value);
  }

  static Future<List<String>> getListTaskCategory() async {
    return _instance.preferences.getStringList("list-task-category") ?? [];
  }

  static Future<void> setListTask(List<String> value) async {
    await _instance.preferences.setStringList("list-task", value);
  }

  static Future<List<String>> getListTask() async {
    return _instance.preferences.getStringList("list-task") ?? [];
  }
}
