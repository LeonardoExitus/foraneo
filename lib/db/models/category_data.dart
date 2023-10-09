import 'package:foraneo/db/tables_conection.dart';
import 'package:foraneo/provider/shooping_notifier.dart';
import 'package:sqflite/sqflite.dart';

class CategoryData {
  ConectionDB conectionDB = ConectionDB();

  Future<List<TaskCategory>> getAllCategoryDB() async {
    // Category(id_category INTEGER PRIMARY KEY AUTOINCREMENT, id_post INTEGER, task_category TEXT)
    String rute = await conectionDB.loginDB();
    List<TaskCategory> categoryList = [];
    Database database = await openDatabase(rute,
        version: 1, onCreate: (Database db, int version) async {});

    List<Map> list = await database.rawQuery('SELECT * FROM Category');
    print(list);
    for (Map element in list) {
      categoryList.add(TaskCategory(element["id_category"], element["id_post"],
          element["task_category"], []));
    }

    return categoryList;
  }

  Future<List<TaskCategory>> getIdCategoryDB(int idPost) async {
    // Category(id_category INTEGER PRIMARY KEY AUTOINCREMENT, id_post INTEGER, task_category TEXT)
    String rute = await conectionDB.loginDB();
    List<TaskCategory> categoryList = [];
    Database database = await openDatabase(rute,
        version: 1, onCreate: (Database db, int version) async {});

    List<Map> list =
        await database.rawQuery('SELECT * FROM Category WHERE id_post = $idPost');
        
    for (Map element in list) {
      categoryList.add(TaskCategory(element["id_category"], element["id_post"],
          element["task_category"], []));
    }

    return categoryList;
  }

  Future<List<Map>> getCategoryJsonDB() async {
    // Category(id_category INTEGER PRIMARY KEY AUTOINCREMENT, id_post INTEGER, task_category TEXT)
    String rute = await conectionDB.loginDB();
    Database database = await openDatabase(rute,
        version: 1, onCreate: (Database db, int version) async {});

    List<Map> list = await database.rawQuery('SELECT * FROM Category');

    return list;
  }

  Future<TaskCategory> insertCategoryDB(PostContent post) async {
    // Category(id_category INTEGER PRIMARY KEY AUTOINCREMENT, id_post INTEGER, task_category TEXT)
    String rute = await conectionDB.loginDB();
    Database database = await openDatabase(rute,
        version: 1, onCreate: (Database db, int version) async {});

    await database.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO Category (id_post, task_category) VALUES("${post.idPost}", "")');
      // print('inserted: $id1');
    });

    List<Map> list = await database.rawQuery('SELECT * FROM Category');

    final element = list[list.length - 1];

    return TaskCategory(element["id_category"], element["id_post"],
        element["task_category"], []);
  }

  Future<void> updateCategoryDB(TaskCategory category) async {
    // Category(id_category INTEGER PRIMARY KEY AUTOINCREMENT, id_post INTEGER, task_category TEXT)
    String rute = await conectionDB.loginDB();
    Database database = await openDatabase(rute,
        version: 1, onCreate: (Database db, int version) async {});

    await database.rawUpdate(
        'UPDATE Category SET task_category = ? WHERE id_category = ?',
        [category.category, '${category.idTaskCategory}']);

    print(category.idTaskCategory);
    print(category.category);
    // return "Actualizado: Exitoso";
  }
}
