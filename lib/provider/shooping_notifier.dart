import "dart:convert";

import "package:flutter/material.dart";
import 'package:foraneo/apis/http_handler.dart';
import "package:foraneo/db/models/post_data.dart";
import "package:foraneo/db/models/task_data.dart";
import "package:foraneo/db/tables_conection.dart";
import "package:intl/intl.dart";
import "package:sqflite/sqflite.dart";

class ShoopingNotifier with ChangeNotifier {
  late PageController shoopingPage;
  late TextEditingController controllerTitle;
  late TextEditingController controllerTask;
  late TextEditingController controllerPrice;

  // late Database database;

  List<Category> listCategory = [
    Category(0, Icons.egg_alt_outlined, "Abarrotes", false),
    Category(1, Icons.water_drop_outlined, "Bebidas y licores", false),
    Category(2, Icons.baby_changing_station, "Bebés", false),
    Category(3, Icons.set_meal_outlined, "Carnes, pescados y mariscos", false),
    Category(4, Icons.icecream_outlined, "Congelados", false),
    Category(5, Icons.laptop_mac, "Electrónica", false),
    Category(6, Icons.medication_liquid_sharp, "Farmacia", false),
    Category(7, Icons.restaurant, "Frutas y verduras", false),
    Category(8, Icons.settings_suggest_outlined, "Higiene y belleza", false),
    Category(9, Icons.home_work_outlined, "Hogar y autos", false),
    Category(10, Icons.smart_toy_outlined, "Jugueteria y deportes", false),
    Category(11, Icons.clean_hands_outlined, "Limpieza del hogar", false),
    Category(12, Icons.pets, "Mascotas", false),
    Category(13, Icons.cookie_outlined, "Panadería y tortillería", false),
    Category(14, Icons.checkroom, "Ropa y zapatería", false),
    Category(15, Icons.label_outline_sharp, "Otros", false)
  ];

  void initListCategory() {
    listCategory = [
      Category(0, Icons.egg_alt_outlined, "Abarrotes", false),
      Category(1, Icons.water_drop_outlined, "Bebidas y licores", false),
      Category(2, Icons.baby_changing_station, "Bebés", false),
      Category(
          3, Icons.set_meal_outlined, "Carnes, pescados y mariscos", false),
      Category(4, Icons.icecream_outlined, "Congelados", false),
      Category(5, Icons.laptop_mac, "Electrónica", false),
      Category(6, Icons.medication_liquid_sharp, "Farmacia", false),
      Category(7, Icons.restaurant, "Frutas y verduras", false),
      Category(8, Icons.settings_suggest_outlined, "Higiene y belleza", false),
      Category(9, Icons.home_work_outlined, "Hogar y autos", false),
      Category(10, Icons.smart_toy_outlined, "Jugueteria y deportes", false),
      Category(11, Icons.clean_hands_outlined, "Limpieza del hogar", false),
      Category(12, Icons.pets, "Mascotas", false),
      Category(13, Icons.cookie_outlined, "Panadería y tortillería", false),
      Category(14, Icons.checkroom, "Ropa y zapatería", false),
      Category(15, Icons.label_outline_sharp, "Otros", false)
    ];
  }

  PostContent postContent = PostContent(0, "", "", "", []);
  bool save = false;
  bool visibility = false;
  bool totality = false;
  late ExpansionTileController expandedCtr;
  PostContent get getPost => postContent;

  set setPost(PostContent post) {
    postContent = post;
    notifyListeners();
  }

  set setTotality(bool value) {
    totality = value;
    notifyListeners();
  }

  List<PostContent> listCard = [];

  // Future<void> openDB() async {
  //   String rute = await ConectionDB().loginDB();
  //   database = await openDatabase(rute,
  //       version: 1, onCreate: (Database db, int version) async {});
  // }

  // Future<void> closeDB() async {
  //   await database.close();
  //   print(":: CLOSE DATA BASE ::");
  // }

  void updatePostContent(
      {int? idPost,
      String? category,
      String? title,
      String? create,
      List<TaskCategory>? listTaskCategory}) {
    postContent = PostContent(
        idPost ?? postContent.idPost,
        category ?? postContent.category,
        title ?? postContent.title,
        create ?? postContent.create,
        listTaskCategory ?? postContent.listTaskCategory);
    notifyListeners();
  }

  Future<void> insertNewPostDB() async {
    final formatOut = DateFormat("dd/MM/yyyy");
    final output = formatOut.format(DateTime.now());
    print(output);
    postContent = await PostData()
        .insertPostDB(PostContent(0, "Compras", "", output, []));
  }

  Future<void> updatePostContentDB() async {
    await PostData().updatePostDB(postContent);
  }

  Future<void> updateTaskTitleDB(Task task) async {
    await TaskData().updateTaskTitleDB(task);
  }

  Future<void> updateTaskPriceDB(Task task) async {
    await TaskData().updateTaskPriceDB(task);
  }

  Future<void> updateTaskActiveDB(Task task) async {
    await TaskData().updateTaskActiveDB(task);
  }

  Future<void> updateTaskItemDB(Task task) async {
    await TaskData().updateTaskItemDB(task);
  }

  void updateContainPost(
      {PostContent? post,
      TaskCategory? category,
      Task? task,
      bool listener = false}) {
    if (post != null) {
      postContent = post;
    }
    if (category != null) {
      List<TaskCategory> temp = [];
      for (TaskCategory element in postContent.listTaskCategory) {
        if (element.idTaskCategory == category.idTaskCategory) {
          temp.add(category);
        } else {
          temp.add(element);
        }
      }
      postContent = postContent.copyPostContent(listTaskCategory: temp);
      notifyListeners();
    }
    if (task != null) {
      List<TaskCategory> tempCat = [];
      for (TaskCategory element in postContent.listTaskCategory) {
        if (element.idTaskCategory == task.idTaskCategory) {
          List<Task> tempTask = [];
          for (Task tastElement in element.listTask) {
            if (tastElement.idTask == task.idTask) {
              tempTask.add(task);
            } else {
              tempTask.add(tastElement);
            }
          }
          tempCat.add(element.copyTaskCategory(listTask: tempTask));
          // temp.add(category);
        } else {
          tempCat.add(element);
        }
      }
      postContent = postContent.copyPostContent(listTaskCategory: tempCat);
    }
    if (listener == true) {
      notifyListeners();
    }
  }

  void deleteContaintPost({
    PostContent? post,
    TaskCategory? category,
    Task? task,
  }) {
    if (post != null) {
      for (var i = 0; i < listCard.length; i++) {
        if (listCard[i].idPost == post.idPost) {
          listCard.removeAt(i);
        }
      }
      notifyListeners();
    }

    if (category != null) {
      for (var i = 0; i < postContent.listTaskCategory.length; i++) {
        if (postContent.listTaskCategory[i].idTaskCategory ==
            category.idTaskCategory) {
          postContent.listTaskCategory.removeAt(i);
        }
      }
      notifyListeners();
    }

    if (task != null) {
      for (var x = 0; x < postContent.listTaskCategory.length; x++) {
        for (var i = 0;
            i < postContent.listTaskCategory[x].listTask.length;
            i++) {
          if (postContent.listTaskCategory[x].listTask[i].idTask ==
              task.idTask) {
            postContent.listTaskCategory[x].listTask.removeAt(i);
          }
        }
      }
      notifyListeners();
    }
  }

  String totalPrice() {
    String result = "";
    List<Task> tasks = [];
    for (TaskCategory element in postContent.listTaskCategory) {
      tasks.addAll(element.listTask);
    }
    double total = 0;
    for (Task element in tasks) {
      if (element.price != "") {
        total = total +
            (double.parse(element.price.replaceAll(",", "")) *
                element.itemProduct);
      }
    }
    result = total.toStringAsFixed(2);
    List<String> totalList = total.toStringAsFixed(2).split(".");
    if (totalList[0].length > 3) {
      String tempEnter = "";
      List<String> enter = totalList[0].split("");
      enter = enter.reversed.toList();
      for (var i = 0; i < enter.length; i++) {
        tempEnter = enter[i] + tempEnter;
        if (i == 2) {
          enter.removeRange(0, 3);
          if (enter.isNotEmpty) {
            tempEnter = ",$tempEnter";
          }
          i = -1;
        }
      }
      result = "$tempEnter.${totalList[1]}";
    }
    return result;
  }

  // --------------------------------------------------------------
  String dateTimeNow() {
    final now = DateTime.now();
    final format = DateFormat("dd/MM/yyyy").format(now);
    return format;
  }

  void fillInData(PostContent post) {
    postContent = post;
    notifyListeners();
  }

  void cleanPost() {
    listCard.clear();
    postContent = PostContent(0, "", "", "", []);
  }

  TaskCategory categoryUpdate(TaskCategory category, String value) {
    TaskCategory task = category;
    for (var i = 0; i < postContent.listTaskCategory.length; i++) {
      if (postContent.listTaskCategory[i].idTaskCategory ==
          task.idTaskCategory) {
        final taskCategory = postContent.listTaskCategory[i];
        postContent.listTaskCategory.replaceRange(
            i, i + 1, [task = taskCategory.copyTaskCategory(category: value)]);

        selectionCategory(taskCategory.category, false);
      }
    }
    notifyListeners();
    return task;
  }

  set setListCard(PostContent content) {
    listCard.add(content);
    notifyListeners();
  }

  List<PostContent> get getListCard => listCard;

  // List<Task> get getListTask => listTasks;

  void addTaskInCategory(Task task) {
    for (var i = 0; i < postContent.listTaskCategory.length; i++) {
      if (postContent.listTaskCategory[i].idTaskCategory ==
          task.idTaskCategory) {
        postContent.listTaskCategory[i].listTask.add(task);
      }
    }
    notifyListeners();
  }

  // List<TaskCategory> get getListTaskCategory => listTaskCategory;

  set setListTaskCategory(TaskCategory taskCategory) {
    postContent.listTaskCategory.add(taskCategory);
    notifyListeners();
  }

  void selectionCategory(String category, bool enable) {
    for (Category element in listCategory) {
      if (element.name == category) {
        listCategory.replaceRange(element.idCategory, element.idCategory + 1,
            [element.copyCategory(use: enable)]);
      }
    }
  }

  void initSelectionCategory(List<TaskCategory> listCat) {
    List<String> list = [];
    for (TaskCategory element in listCat) {
      list.add(element.category);
    }

    for (String content in list) {
      for (Category element in listCategory) {
        if (element.name == content) {
          listCategory.replaceRange(element.idCategory, element.idCategory + 1,
              [Category(element.idCategory, element.icon, element.name, true)]);
        }
      }
    }
  }

  Category? shearchCategory(String name) {
    for (Category element in listCategory) {
      if (element.name == name) {
        return element;
      }
    }
    return null;
  }

  List<Category> listUpdate() {
    List<Category> list = [];
    for (Category element in listCategory) {
      if (!element.use) {
        list.add(element);
      }
    }
    return list;
  }

  void newCategory(TaskCategory taskCategory) {
    postContent.listTaskCategory.add(taskCategory);
    notifyListeners();
  }

  // TaskContent getContent(String category){
  //   for (TaskCategory content in listTaskCategory) {
  //     if(content.category == category){
  //       return content.list[1].
  //     }

  //   }
  // }
  Future<String> getProductBarcode(String barcode) async {
    // try {
    final customResponse = await HttpHandler.post('https://gtincheck.gs1uk.org',
        headers: {"Authorization": "Bearer aaaaaaaaaaaaaaaaaaaa"},
        body: jsonEncode({
          "gtins": [barcode]
        }));
    if (customResponse.response.statusCode == 200) {
      final map =
          jsonDecode(customResponse.response.body) as Map<String, dynamic>;
      return map["GTINTestResults"][0]["ProductDescription"] ?? "-1";
    }
    return "error";
  }
}

class Task {
  final int idTask;
  final int idTaskCategory;
  final String product;
  final String price;
  final bool active;
  final int itemProduct;

  Task(this.idTask, this.idTaskCategory, this.product, this.price, this.active,
      this.itemProduct);

  Task copyTask(
      {int? idTask,
      int? idTaskCategory,
      String? product,
      String? price,
      bool? active,
      int? itemProduct}) {
    return Task(
        idTask ?? this.idTask,
        idTaskCategory ?? this.idTaskCategory,
        product ?? this.product,
        price ?? this.price,
        active ?? this.active,
        itemProduct ?? this.itemProduct);
  }
}

class TaskCategory {
  final int idTaskCategory;
  final int idPost;
  final String category;
  final List<Task> listTask;
  final bool expand;
  final ExpansionTileController expansionCtr;

  TaskCategory(this.idTaskCategory, this.idPost, this.category, this.listTask,
      this.expand, this.expansionCtr);

  TaskCategory copyTaskCategory(
      {int? idTaskCategory,
      int? idPost,
      String? category,
      List<Task>? listTask,
      bool? expand}) {
    return TaskCategory(
        idTaskCategory ?? this.idTaskCategory,
        idPost ?? this.idPost,
        category ?? this.category,
        listTask ?? this.listTask,
        expand ?? this.expand,
        expansionCtr);
  }
}

class PostContent {
  final int idPost;
  final String category;
  final String title;
  final String create;
  final List<TaskCategory> listTaskCategory;

  PostContent(this.idPost, this.category, this.title, this.create,
      this.listTaskCategory);

  PostContent copyPostContent({
    int? idPost,
    String? category,
    String? title,
    String? create,
    List<TaskCategory>? listTaskCategory,
  }) =>
      PostContent(
          idPost ?? this.idPost,
          category ?? this.category,
          title ?? this.title,
          create ?? this.create,
          listTaskCategory ?? this.listTaskCategory);
}

class Category {
  final int idCategory;
  final IconData icon;
  final String name;
  final bool use;

  Category(this.idCategory, this.icon, this.name, this.use);

  Category copyCategory({
    int? idCategory,
    IconData? icon,
    String? name,
    bool? use,
  }) =>
      Category(idCategory ?? this.idCategory, icon ?? this.icon,
          name ?? this.name, use ?? this.use);
}
