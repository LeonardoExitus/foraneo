import 'package:foraneo/db/models/category_data.dart';
import 'package:foraneo/db/models/post_data.dart';
import 'package:foraneo/db/models/task_data.dart';
import 'package:foraneo/provider/shooping_notifier.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class ConectionDB {
  Future<String> loginDB() async {
    var databasesPath = await getDatabasesPath();
    return path.join(databasesPath, 'foraneo_test.db');
  }

  Future<void> createTables() async {
    String rute = await loginDB();
    Database database = await openDatabase(rute, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      // await db.execute(
      //     'CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
    });

    await database.execute(
        'CREATE TABLE Post(id_post INTEGER PRIMARY KEY AUTOINCREMENT, category_post TEXT, title_post TEXT, create_post TEXT)');
    await database.execute(
        'CREATE TABLE Category(id_category INTEGER PRIMARY KEY AUTOINCREMENT, id_post INTEGER, task_category TEXT)');
    await database.execute(
        'CREATE TABLE Task(id_task INTEGER PRIMARY KEY AUTOINCREMENT, id_category INTEGER, product TEXT, price TEXT, active BOOLEAN)');

    List<Map> list = await database.rawQuery('SELECT * FROM Post');

    List<Map> list1 = await database.rawQuery('SELECT * FROM Category');

    List<Map> list2 = await database.rawQuery('SELECT * FROM Task');

    print(list);
    print(list1);
    print(list2);
  }

  Future<List<PostContent>> getContentAllShoopingDB() async {
    List<PostContent> listContent = [];

    PostData postData = PostData();
    CategoryData categoryData = CategoryData();
    TaskData taskData = TaskData();

    List listPost = await postData.getAllPostDB();

    for (PostContent post in listPost) {
      // var postTemp = post;
      List<TaskCategory> tempListCategory = [];
      List listCategory = await categoryData.getIdCategoryDB(post.idPost);
      for (TaskCategory category in listCategory) {
        List<Task> listTask =
            await taskData.getIdTaskDB(category.idTaskCategory);
        tempListCategory.add(category.copyTaskCategory(listTask: listTask));
      }
      listContent.add(post.copyPostContent(listTaskCategory: tempListCategory));
    }
    return listContent;
  }

  Future<List<PostContent>> deletePostDB(PostContent post) async {
    // Post(id_post INTEGER PRIMARY KEY AUTOINCREMENT, category_post TEXT, title_post TEXT, create_post TEXT)
    // Category(id_category INTEGER PRIMARY KEY AUTOINCREMENT, id_post INTEGER, task_category TEXT)
    // Task(id_task INTEGER PRIMARY KEY AUTOINCREMENT, id_category INTEGER, product TEXT, price TEXT, active BOOLEAN)

    String rute = await loginDB();
    Database database = await openDatabase(rute,
        version: 1, onCreate: (Database db, int version) async {});
    await database
        .rawDelete('DELETE FROM Post WHERE id_post = ?', ['${post.idPost}']);

    List<TaskCategory> list = await CategoryData().getIdCategoryDB(post.idPost);
    await database.rawDelete(
        'DELETE FROM Category WHERE id_post = ?', ['${post.idPost}']);

    for (TaskCategory element in list) {
      await database.rawDelete('DELETE FROM Task WHERE id_category = ?',
          ['${element.idTaskCategory}']);
    }

    return await getContentAllShoopingDB();
  }

  Future<void> closeDB()async{
  }
}
