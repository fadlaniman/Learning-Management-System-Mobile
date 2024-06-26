import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/controller/attachmentController.dart';

import 'package:mobile/view/assets/style.dart';
import 'package:mobile/view/teacher/attachments/create-assignment.dart';
import 'package:mobile/view/teacher/attachments/create-material.dart';
import 'package:mobile/view/widgets/floatingButtonBottom.dart';
import 'package:mobile/view/widgets/showBottom.dart';

class ClassWorkPage extends StatefulWidget {
  const ClassWorkPage({super.key});

  @override
  State<ClassWorkPage> createState() => _ClassWorkPageState();
}

class _ClassWorkPageState extends State<ClassWorkPage> {
  final attachmentsController = Get.put(AttachmentsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 5.0,
          ),
          child: Obx(() {
            return attachmentsController.loading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: attachmentsController.attachments.length,
                    itemBuilder: ((context, index) {
                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                          margin: EdgeInsets.all(5.0),
                          padding: EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: Colors.grey.shade400)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                  leading: Container(
                                      padding: EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        color: attachmentsController
                                                    .attachments[index].type ==
                                                'assignment'
                                            ? primaryColor
                                            : Colors.yellow[800],
                                        shape: BoxShape.circle,
                                      ),
                                      child: attachmentsController
                                                  .attachments[index].type ==
                                              'assignment'
                                          ? Icon(
                                              Icons.assignment_outlined,
                                              color: Colors.white,
                                            )
                                          : Icon(
                                              Icons.book_outlined,
                                              color: Colors.white,
                                            )),
                                  title: Text(
                                    attachmentsController
                                            .attachments[index].title ??
                                        '',
                                    style: GoogleFonts.poppins(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  subtitle: Text(
                                      attachmentsController
                                              .attachments[index].description ??
                                          '',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13.0,
                                      ))),
                            ],
                          ),
                        ),
                      );
                    }));
          })),
      floatingActionButton: FloatingButtonWidget(
        color: Colors.white,
        backgroundColor: primaryColor,
        onPress: () {
          ShowBottom().showModalBottom(
              context,
              Wrap(
                children: [
                  ListTile(
                    title: Text(
                      'Create',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 20.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                  ListTile(
                    title: Text('Assignment'),
                    leading: Icon(Icons.assignment_outlined),
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.to(() => CreateAssignment());
                    },
                  ),
                  ListTile(
                    title: Text('Material'),
                    leading: Icon(Icons.class_outlined),
                    onTap: () {
                      Navigator.of(context).pop();
                      Get.to(() => CreateMaterial());
                    },
                  )
                ],
              ));
        },
      ),
    );
  }
}
