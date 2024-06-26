import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/controller/studiesController.dart';
import 'package:mobile/view/admin/studies/create-studies.dart';
import 'package:mobile/view/admin/studies/update-studies.dart';
import 'package:mobile/view/assets/style.dart';
import 'package:mobile/view/widgets/floatingButtonBottom.dart';

class FetchStudiesPage extends StatefulWidget {
  const FetchStudiesPage({super.key});

  @override
  State<FetchStudiesPage> createState() => _FetchStudiesPageState();
}

class _FetchStudiesPageState extends State<FetchStudiesPage> {
  final studiesController = Get.put(StudiesController());

  @override
  void initState() {
    studiesController.fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Obx(() {
            return studiesController.loading.value
                ? Text(
                    'Loading...',
                    style: GoogleFonts.poppins(),
                  )
                : Text(
                    'Studies',
                    style: GoogleFonts.poppins(),
                  );
          }),
        ),
        body: Obx(() {
          return studiesController.loading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: studiesController.studies.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      child: ListTile(
                        leading: Text(
                          '${index + 1}',
                          style: GoogleFonts.poppins(fontSize: 12.0),
                        ),
                        title: Text(
                          studiesController.studies[index].name ?? '',
                          style: GoogleFonts.poppins(fontSize: 14.0),
                        ),
                        subtitle: Text(
                            studiesController.studies[index].id ?? '',
                            style: GoogleFonts.poppins(fontSize: 12.0)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.yellow.shade700,
                                ),
                                onPressed: () {
                                  studiesController.fetchById(
                                      studiesController.studies[index].id ??
                                          '');
                                  Get.to(() => const UpdateStudiesPage());
                                }),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: primaryColor,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      titleTextStyle: GoogleFonts.poppins(
                                          color: Colors.black),
                                      title: const Text(
                                        'Delete',
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 18.0),
                                      ),
                                      content: const Text(
                                        'Are you sure want to delete this record?',
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('No'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .labelLarge,
                                          ),
                                          child: const Text('Yes'),
                                          onPressed: () {
                                            studiesController.delete(
                                                studiesController
                                                    .studies[index].id
                                                    .toString());
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  });
        }),
        floatingActionButton: FloatingButtonWidget(
          backgroundColor: Colors.white,
          color: primaryColor,
          onPress: () => Get.to(() => const CreateStudiesPage()),
        ));
  }
}
