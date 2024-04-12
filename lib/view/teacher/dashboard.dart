import 'package:flutter/material.dart';
import 'package:mobile/controller/classroomController.dart';
import 'package:mobile/model/classroomModel.dart';
import 'package:mobile/view/student/joinClass.dart';
import 'package:mobile/view/teacher/classes/create.dart';
import 'package:mobile/view/teacher/classes/update.dart';
import 'package:mobile/view/widgets/header.dart';
import 'package:mobile/view/widgets/navigationTop.dart';
import 'package:get/get.dart';
import 'package:mobile/view/widgets/floatingButtonBottom.dart';
import 'package:mobile/view/widgets/showBottom.dart';

class DashboardTeacher extends StatefulWidget {
  const DashboardTeacher({super.key});

  @override
  State<DashboardTeacher> createState() => _DashboardTeacherState();
}

class _DashboardTeacherState extends State<DashboardTeacher> {
  final classRoom = Get.put(ClassroomController());

  @override
  void initState() {
    classRoom.showClass();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Header(title: 'Teacher'),
        ),
        drawer: NavigationWidget(),
        floatingActionButton: FloatingButtonWidget(
          onPress: () {
            ShowBottom().showModalBottom(context, title: 'Create class',
                onTap: () {
              Navigator.of(context).pop();
              Get.to(() => CreateClassPage());
            });
          },
        ),
        body: Obx(() {
          return classRoom.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: Container(
                      child: ListView.builder(
                    itemCount: classRoom.dataList.value[0].classes.length,
                    itemBuilder: ((context, index) {
                      Classroom UserClass = classRoom.dataList.value[0];
                      return Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10.0),
                        padding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors
                                .primaries[index % Colors.primaries.length]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          textBaseline: TextBaseline.alphabetic,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  UserClass.classes[index].name,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 21.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  UserClass.classes[index].section,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                  ),
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
                                Text(
                                  UserClass.username,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            IconButton(
                                padding: EdgeInsets.all(0.0),
                                onPressed: () {
                                  ShowBottom().showModalBottom(context,
                                      title: 'Edit', onTap: () {
                                    Navigator.of(context).pop();
                                    Get.to(() => UpdatedClassPage());
                                  });
                                },
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Colors.white,
                                  size: 25.0,
                                )),
                          ],
                        ),
                      );
                    }),
                  )));
        }));
  }
}
