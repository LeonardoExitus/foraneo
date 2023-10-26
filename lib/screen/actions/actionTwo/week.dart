class Week {
  final int idWeek;
  final String title;
  final String create;
  final List<Day> listDay;

  Week(
      {required this.idWeek,
      required this.title,
      required this.create,
      required this.listDay});
}

class Day {
  final int idDay;
  final int idWeek;
  final String nameDay;
  final List<Hour> listHour;

  Day(
      {required this.idDay,
      required this.idWeek,
      required this.nameDay,
      required this.listHour});
}

class Hour {
  final int idHour;
  final int idDay;
  final String nameHour;
  final List<Eat> listEat;

  Hour(
      {required this.idHour,
      required this.idDay,
      required this.nameHour,
      required this.listEat});
}

class Eat {
  final int idEat;
  final int idHour;
  final String nameEat;
  final String? description;
  final String? videoUrl;
  final List<String>? listSpecies;

  Eat(
      {required this.idEat,
      required this.idHour,
      required this.nameEat,
      this.description,
      this.videoUrl,
      this.listSpecies});
}

List days = [
  "Lunes",
  "Martes",
  "Miercoles",
  "Jueves",
  "Viernes",
  "Sabado",
  "Domingo"
];

List hours = ["Desayuno", "Comida", "Cena"];
