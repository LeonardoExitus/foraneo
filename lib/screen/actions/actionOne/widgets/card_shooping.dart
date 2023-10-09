import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/colors.dart';
import '../../../../provider/shooping_notifier.dart';

class CardShooping extends StatelessWidget {
  const CardShooping({super.key, required this.postContent});

  final PostContent postContent;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final shooping = context.read<ShoopingNotifier>();

    return InkWell(
      onTap: () {
        shooping.postContent = postContent;
        shooping.shoopingPage.jumpToPage(1);
      },
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        height: size.height * 0.1,
        width: size.width * 0.9,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [BoxShadow(blurRadius: 6, offset: Offset(1, 1))],
            gradient: LinearGradient(colors: [
              Color(0XFFFFE8AC),
              Color.fromARGB(255, 188, 250, 221),
              // Colors.white,

              // Color(0XFFFFB8F8),
              // Color.fromARGB(255, 188, 250, 221),
            ])),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
                child: Center(
              child: Icon(
                Icons.shopping_bag_outlined,
                size: size.width * 0.1,
              ),
            )),
            Expanded(
                flex: 4,
                child: Flex(
                  direction: Axis.vertical,
                  children: [
                    Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            postContent.title == ""
                                ? "Sin titulo"
                                : postContent.title,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        )),
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.list_alt,
                              size: size.width * 0.05,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              postContent.category,
                              style: const TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                        Text("Creado: ${postContent.create}",
                            style: const TextStyle(fontSize: 12))
                      ],
                    ))
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
