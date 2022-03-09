import 'package:flutter/material.dart';
import 'package:tripd_travel_app/components/domain/plan_item.dart';
import 'package:tripd_travel_app/components/widgets/century_gothic_text.dart';
import 'package:tripd_travel_app/models/plan.dart';
import 'package:tripd_travel_app/theme/resources/color_code.dart';
import 'package:tripd_travel_app/theme/resources/custom_scroll_behaviour.dart';

class ViewPlanLayout extends StatelessWidget {
  const ViewPlanLayout({Key? key, required this.plans}) : super(key: key);
  final List<Plan>? plans;

  @override
  Widget build(BuildContext context) {
    Color color1 = HexColor("6700E3");

    return plans!.isEmpty
        ? Container(
            alignment: Alignment.center,
            child: CenturyGothicText(data: 'No Plans Yet', fontSize: 22.5),
          )
        : Container(
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: GlowingOverscrollIndicator(
                axisDirection: AxisDirection.down,
                color: color1,
                child: GridView.builder(
                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  itemCount: plans!.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 165,
                      crossAxisCount: 2,
                      mainAxisSpacing: 0,
                      crossAxisSpacing: 5),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return PlanItem(item: plans![index]);
                  },
                ),
              ),
            ),
          );
  }
}
