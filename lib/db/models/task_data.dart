import 'package:foraneo/db/tables_conection.dart';
import 'package:foraneo/provider/shooping_notifier.dart';
import 'package:sqflite/sqflite.dart';

class TaskData {
  ConectionDB conectionDB = ConectionDB();

  Future<List<Task>> getAllTaskDB() async {
    // Task(id_task INTEGER PRIMARY KEY AUTOINCREMENT, id_category INTEGER, product TEXT, price TEXT, active BOOLEAN)
    String rute = await conectionDB.loginDB();
    List<Task> taskList = [];
    Database database = await openDatabase(rute,
        version: 1, onCreate: (Database db, int version) async {});

    List<Map> list = await database.rawQuery('SELECT * FROM Task');

    for (Map element in list) {
      taskList.add(Task(
          element["id_task"],
          element["id_category"],
          element["product"],
          element["price"],
          element["active"] == "true" ? true : false,
          element["items_product"]));
    }
    await database.close();

    return taskList;
  }

  Future<List<Task>> getIdTaskDB(int id) async {
    // Task(id_task INTEGER PRIMARY KEY AUTOINCREMENT, id_category INTEGER, product TEXT, price TEXT, active BOOLEAN)
    String rute = await conectionDB.loginDB();
    List<Task> taskList = [];
    Database database = await openDatabase(rute,
        version: 1, onCreate: (Database db, int version) async {});

    List<Map> list =
        await database.rawQuery('SELECT * FROM Task WHERE id_category = $id');

    for (Map element in list) {
      taskList.add(Task(
          element["id_task"],
          element["id_category"],
          element["product"],
          element["price"],
          element["active"] == "true" ? true : false,
          element["items_product"]));
    }
    await database.close();

    return taskList;
  }

  Future<List<Map>> getTaskJsonDB() async {
    // Task(id_task INTEGER PRIMARY KEY AUTOINCREMENT, id_category INTEGER, product TEXT, price TEXT, active BOOLEAN)
    String rute = await conectionDB.loginDB();
    Database database = await openDatabase(rute,
        version: 1, onCreate: (Database db, int version) async {});

    List<Map> list = await database.rawQuery('SELECT * FROM Task');
    await database.close();

    return list;
  }

  Future<Task> insertTaskDB(TaskCategory category) async {
    // Task(id_task INTEGER PRIMARY KEY AUTOINCREMENT, id_category INTEGER, product TEXT, price TEXT, active BOOLEAN)
    String rute = await conectionDB.loginDB();
    Database database = await openDatabase(rute,
        version: 1, onCreate: (Database db, int version) async {});

    await database.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO Task (id_category, product, price, active, items_product) VALUES("${category.idTaskCategory}", "", "", false, 1)');
      // print('inserted: $id1');
    });
    List<Map> list = await database.rawQuery('SELECT * FROM Task');
    final element = list[list.length - 1];
    await database.close();
    print("Se inserto Tarea: $list");
    return Task(
        element["id_task"],
        element["id_category"],
        element["product"],
        element["price"],
        element["active"] == "true" ? true : false,
        element["items_product"]);
  }

  Future<String> deleteIdTaskDB(Task task) async {
    // Task(id_task INTEGER PRIMARY KEY AUTOINCREMENT, id_category INTEGER, product TEXT, price TEXT, active BOOLEAN)
    String rute = await conectionDB.loginDB();
    Database database = await openDatabase(rute,
        version: 1, onCreate: (Database db, int version) async {});

    await database
        .rawDelete('DELETE FROM Task WHERE id_task = ?', ['${task.idTask}']);
    // assert(count == 1);

// Close the database
    await database.close();
    return "Task Eliminado: Exitoso";
  }

  Future<String> updateTaskTitleDB(Task task) async {
    // Task(id_task INTEGER PRIMARY KEY AUTOINCREMENT, id_category INTEGER, product TEXT, price TEXT, active BOOLEAN)
    String rute = await conectionDB.loginDB();
    Database database = await openDatabase(rute,
        version: 1, onCreate: (Database db, int version) async {});

    await database.rawUpdate('UPDATE Task SET product = ? WHERE id_task = ?',
        [task.product, '${task.idTask}']);
    await database.close();
    return "Actualizado: Exitoso";
  }

  Future<String> updateTaskPriceDB(Task task) async {
    // Task(id_task INTEGER PRIMARY KEY AUTOINCREMENT, id_category INTEGER, product TEXT, price TEXT, active BOOLEAN)
    String rute = await conectionDB.loginDB();
    Database database = await openDatabase(rute,
        version: 1, onCreate: (Database db, int version) async {});

    await database.rawUpdate('UPDATE Task SET price = ? WHERE id_task = ?',
        [task.price, '${task.idTask}']);
    await database.close();
    return "Actualizado: Exitoso";
  }

  Future<String> updateTaskActiveDB(Task task) async {
    // Task(id_task INTEGER PRIMARY KEY AUTOINCREMENT, id_category INTEGER, product TEXT, price TEXT, active BOOLEAN)
    String rute = await conectionDB.loginDB();
    Database database = await openDatabase(rute,
        version: 1, onCreate: (Database db, int version) async {});

    await database.rawUpdate('UPDATE Task SET active = ? WHERE id_task = ?',
        ["${task.active}", '${task.idTask}']);
    await database.close();
    return "Actualizado: Exitoso";
  }

  Future<String> updateTaskItemDB(Task task) async {
    // Task(id_task INTEGER PRIMARY KEY AUTOINCREMENT, id_category INTEGER, product TEXT, price TEXT, active BOOLEAN)
    String rute = await conectionDB.loginDB();
    Database database = await openDatabase(rute,
        version: 1, onCreate: (Database db, int version) async {});

    await database.rawUpdate(
        'UPDATE Task SET items_product = ? WHERE id_task = ?',
        ["${task.itemProduct}", '${task.idTask}']);
    await database.close();
    return "Actualizado: Exitoso";
  }
}
