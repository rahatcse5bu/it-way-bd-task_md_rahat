import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/custom_card.dart';
import '../../../routes/app_pages.dart';
import '../models/contest_model.dart';

class ContestWidget extends GetWidget {
  final Contest contest;

  const ContestWidget(this.contest, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Get.toNamed(Routes.singleContest(contest.id)),
        child: CustomCard(
          title: contest.name??'',
          description: contest.description??'',
        ));

    //  Card(
    //     elevation: 2.3,
    //     margin: const EdgeInsets.all(8),
    //     child: ListTile(
    //       title: Text(contest.name),
    //       subtitle: Text(contest.description),
    //       trailing: Text('${contest.totalMarks} Marks'),
    //       onTap: () {
    //        log("clicked ${contest.id}");
    //      Get.toNamed(Routes.singleContest(contest.id));
    //       },
    //     ),
    //   );
  }
}
