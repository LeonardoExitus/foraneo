import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:foraneo/utils/colors.dart';
import 'package:provider/provider.dart';

import '../provider/home_notifier.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final homeNotifier = context.read<HomeNotifier>();
    final page = homeNotifier.homePage;

    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        title: const Text("FORANEO"),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Container(
            //   height: size.height * 0.09,
            //   width: size.width,
            //   decoration: BoxDecoration(
            //       gradient: LinearGradient(colors: [
            //     Color(0xFF529EA3),
            //     Color(0xFFF0D860),
            //     Color(0xFF92E9F0),
            //     Color(0xFFF054E2),
            //   ])),
            // )
            CarouselSlider(
              options: CarouselOptions(
                enableInfiniteScroll: false,
                height: size.height * 0.3,
              ),
              items: List.generate(listCard().length, (index) {
                return InkWell(
                    onTap: () async {
                      print("vista: $index");

                      page.animateToPage(index + 1,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.decelerate);
                    },
                    child: listCard()[index]);
              }),
              // items: listCard().map((card) {
              //   return Builder(
              //     builder: (BuildContext context) {
              //       return card;
              //     },
              //   );
              // }).toList(),
            ),
            SizedBox(
              height: size.height * 0.35,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    child: const CardOtherAction(
                      iconOne: Icons.restaurant_menu,
                      iconTwo: Icons.location_on_outlined,
                      title: "Encuentra y registra tus lugares",
                      colorCard: AppColors.primary,
                    ),
                    onTap: () async {
                      
                    },
                  ),
                  const CardOtherAction(
                    iconTwo: Icons.calendar_month,
                    title: "Encuentra y registra tus lugares",
                    colorCard: AppColors.yellowOne,
                    colorTitle: Colors.black,
                  ),
                  const CardOtherAction(
                    iconTwo: Icons.emoji_objects_outlined,
                    title: "Encuentra y registra tus lugares",
                    colorCard: AppColors.cian,
                    colorTitle: Colors.black,
                  )
                ],
              ),
            )
            // CardAction()
          ],
        ),
      ),
    );
  }
}

class CardOtherAction extends StatelessWidget {
  const CardOtherAction(
      {super.key,
      this.iconOne,
      required this.iconTwo,
      required this.title,
      required this.colorCard,
      this.colorTitle,
      this.colorIcon});

  final IconData? iconOne;
  final IconData iconTwo;
  final String title;
  final Color? colorTitle;
  final Color? colorIcon;
  final Color colorCard;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.08,
      width: size.width * 0.9,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: colorCard,
          boxShadow: const [BoxShadow(blurRadius: 2, offset: Offset(2, 2))]),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
              child: Container(
            color: Colors.white,
            child: Stack(
              children: [
                Positioned(
                    left: -(size.width * 0.03),
                    bottom: -(size.width * 0.03),
                    child: iconOne != null
                        ? Icon(
                            iconOne,
                            size: size.width * 0.18,
                            color: colorIcon ?? colorCard,
                          )
                        : const Center()),
                Positioned(
                    top: -(size.width * 0.03),
                    right: (size.width * 0.02),
                    child: Icon(
                      iconTwo,
                      size: size.width * 0.24,
                      color: colorIcon ?? colorCard,
                      fill: BorderSide.strokeAlignCenter,
                    ))
              ],
            ),
          )),
          Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Encuentra y registra tus lugares",
                  style: TextStyle(color: colorTitle ?? Colors.white),
                ),
              ))
        ],
      ),
    );
  }
}

class CardAction extends StatelessWidget {
  const CardAction({
    super.key,
    required this.image,
    required this.title,
    required this.body,
  });

  final String image;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: Container(
        height: size.height * 0.2,
        width: size.width * 0.7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: const [BoxShadow(blurRadius: 4, offset: Offset(1, 1))],
        ),
        child: Flex(direction: Axis.vertical, children: [
          Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    image: DecorationImage(
                        image: AssetImage(image), fit: BoxFit.cover)),
                // child: Image(
                //   width: size.width * 0.7,
                //   image: AssetImage(image),
                //   fit: BoxFit.cover,
                // ),
              )),
          Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                alignment: Alignment.bottomLeft,
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              )),
          Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(10),
                child: Text(body),
              )),
        ]),
      ),
    );
  }
}

List<Widget> listCard() {
  return [
    const CardAction(
      image: "assets/images/lista-compras.png",
      title: "Lista de compras",
      body:
          "Alista tu lista para no olvidar que es lo que te falta para la semana",
    ),
    const CardAction(
      image: "assets/images/cocina.jpg",
      title: "Comidas de la semana",
      body:
          "Crea tu FoodList para saber que cosinar toda la semana y no dejarlo al ultimo",
    ),
    const CardAction(
      image: "assets/images/limpieza.jpg",
      title: "Tareas del hogar",
      body:
          "Crea rutinas para organizarte en tus tiempos libres y tener un espacio limpio",
    ),
    const CardAction(
      image: "assets/images/aceo.jpg",
      title: "Crea recordatorios",
      body: "Los pagos de servicios y gastos pueden ser dificil de olvidar",
    )
  ];
}
