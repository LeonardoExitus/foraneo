import 'package:foraneo/db/tables_conection.dart';
import 'package:foraneo/provider/shooping_notifier.dart';
import 'package:sqflite/sqflite.dart';

class PostData {
  ConectionDB conectionDB = ConectionDB();

  Future<List<PostContent>> getPostDB(int id) async {
    // Post(id_post INTEGER PRIMARY KEY AUTOINCREMENT, category_post TEXT, title_post TEXT, create_post TEXT)
    String rute = await conectionDB.loginDB();
    List<PostContent> getList = [];
    Database database = await openDatabase(rute,
        version: 1, onCreate: (Database db, int version) async {});

    List<Map> list =
        await database.rawQuery('SELECT * FROM Post WHERE id_post = $id');
    for (Map element in list) {
      getList.add(PostContent(element["id_post"], element["category_post"],
          element["title_post"], element["create_post"], []));
    }

    return getList;
  }

  Future<List<PostContent>> getAllPostDB() async {
    // Post(id_post INTEGER PRIMARY KEY AUTOINCREMENT, category_post TEXT, title_post TEXT, create_post TEXT)
    String rute = await conectionDB.loginDB();
    List<PostContent> getList = [];
    Database database = await openDatabase(rute,
        version: 1, onCreate: (Database db, int version) async {});

    List<Map> list = await database.rawQuery('SELECT * FROM Post');
    for (Map element in list) {
      getList.add(PostContent(element["id_post"], element["category_post"],
          element["title_post"], element["create_post"], []));
    }

    return getList;
  }

  Future<List<Map>> getPostJsonDB() async {
    // Post(id_post INTEGER PRIMARY KEY AUTOINCREMENT, category_post TEXT, title_post TEXT, create_post TEXT)
    String rute = await conectionDB.loginDB();
    List<PostContent> getList = [];
    Database database = await openDatabase(rute,
        version: 1, onCreate: (Database db, int version) async {});

    List<Map> list = await database.rawQuery('SELECT * FROM Post');
    for (Map element in list) {
      getList.add(PostContent(element["id_post"], element["category_post"],
          element["title_post"], element["create_post"], []));
    }

    return list;
  }

  Future<PostContent> insertPostDB(PostContent post) async {
    // Post(id_post INTEGER PRIMARY KEY AUTOINCREMENT, category_post TEXT, title_post TEXT, create_post TEXT)
    String rute = await conectionDB.loginDB();
    Database database = await openDatabase(rute,
        version: 1, onCreate: (Database db, int version) async {});

    await database.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO Post (category_post, title_post, create_post) VALUES("${post.category}", "${post.title}", "${post.create}")');
      // print('inserted: $id1');
    });
    List<Map> list = await database.rawQuery('SELECT * FROM Post');
    final element = list[list.length - 1];

    return PostContent(element["id_post"], element["category_post"],
        element["title_post"], element["create_post"], []);
  }

  Future<String> updatePostDB(PostContent post) async {
    // Post(id_post INTEGER PRIMARY KEY AUTOINCREMENT, category_post TEXT, title_post TEXT, create_post TEXT)
    String rute = await conectionDB.loginDB();
    Database database = await openDatabase(rute,
        version: 1, onCreate: (Database db, int version) async {});

    await database.rawUpdate('UPDATE Post SET title_post = ? WHERE id_post = ?',
        [post.title, '${post.idPost}']);
    await database.rawUpdate(
        'UPDATE Post SET create_post = ? WHERE id_post = ?',
        [post.create, '${post.idPost}']);

    return "Actualizado: Exitoso";
  }
}
