// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';

import '../../resources/service_constants.dart';
import '/utils/utils.dart';
import '/widgets/custom_button.dart';
import '/widgets/custom_textformfield.dart';

class ProfileDetailsView extends StatefulWidget {
  final Map<String, dynamic> userData;
  const ProfileDetailsView({super.key, required this.userData});

  @override
  State<ProfileDetailsView> createState() => _ProfileDetailsViewState();
}

class _ProfileDetailsViewState extends State<ProfileDetailsView> {
  final formKey = GlobalKey<FormState>();
  File? image;
  final picker = ImagePicker();

  bool btnLoading = false;

  Future getImageGalley() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 60);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        debugPrint("No image picked");
      }
    });
  }

  late TextEditingController emailC;
  late TextEditingController nameC;
  late TextEditingController sscPercent;
  late TextEditingController cgpa;
  late TextEditingController hscPercent;
  late TextEditingController interestsC;
  late TextEditingController aLevel;
  late TextEditingController oLevel;
  late TextEditingController matric;
  late TextEditingController inter;

  @override
  void initState() {
    super.initState();
    emailC = TextEditingController(text: widget.userData['email']);
    nameC = TextEditingController(text: widget.userData['name']);
    sscPercent =
        TextEditingController(text: widget.userData['sscPercent'].toString());
    hscPercent =
        TextEditingController(text: widget.userData['hscPercent'].toString());
    cgpa =
        TextEditingController(text: widget.userData['cgpa'].toString());
    interestsC = TextEditingController(
        text:
            (widget.userData['interests'] as List<dynamic>?)?.join(', ') ?? '');

    aLevel = TextEditingController();
    oLevel = TextEditingController();
    matric = TextEditingController();
    inter = TextEditingController();
  }

  @override
  void dispose() {
    emailC.dispose();
    nameC.dispose();
    cgpa.dispose();
    sscPercent.dispose();
    hscPercent.dispose();
    interestsC.dispose();
    aLevel.dispose();
    inter.dispose();
    oLevel.dispose();
    matric.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Personal information"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(height: 15),
              CupertinoButton(
                padding: const EdgeInsets.all(0),
                onPressed: getImageGalley,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade200,
                  child: ClipOval(
                    child: image != null
                        ? Image.file(
                            image!.absolute,
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                          )
                        : const Icon(
                            IconlyBold.image,
                            size: 50,
                            color: Colors.black,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Name"),
                    const SizedBox(height: 5),
                    CustomTextFormField(
                      hintText: "Name",
                      controller: nameC,
                    ),
                    const SizedBox(height: 15),
                    const Text("Email"),
                    const SizedBox(height: 5),
                    CustomTextFormField(
                      hintText: "Email",
                      controller: emailC,
                      enabled: false,
                    ),
                    const SizedBox(height: 15),
                    widget.userData['class'] == "A Level" ||
                            widget.userData['class'] == "O Level"
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("A Level"),
                              const SizedBox(height: 5),
                              CustomTextFormField(
                                hintText: "A Level",
                                controller: aLevel,
                                enabled: false,
                              ),
                              const Text("O Level"),
                              const SizedBox(height: 5),
                              CustomTextFormField(
                                hintText: "O Level",
                                controller: oLevel,
                                enabled: false,
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 15),
                              const Text("SSC Percentage"),
                              const SizedBox(height: 5),
                              CustomTextFormField(
                                hintText: "SSC Percentage",
                                controller: sscPercent,
                              ),
                              const SizedBox(height: 15),
                              const Text("HSC Percentage"),
                              const SizedBox(height: 5),
                              CustomTextFormField(
                                hintText: "HSC Percentage",
                                controller: hscPercent,
                              ),
                            ],
                          ),
                    const Text("CGPA"),
                    const SizedBox(height: 5),
                    CustomTextFormField(
                      hintText: "CGPA",
                      controller: cgpa,
                    ),
                    const SizedBox(height: 15),
                    const Text("Interests (comma-separated)"),
                    const SizedBox(height: 5),
                    CustomTextFormField(
                      hintText: "E.g., Computer Science, Data Analysis, AI",
                      controller: interestsC,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              CustomButton(
                text: "Update Profile",
                isLoading: btnLoading,
                onPressed: () async {
                  try {
                    setState(() {
                      btnLoading = true;
                    });

                    final updatedData = {
                      'username': nameC.text.toString(),
                      'sscPercent': sscPercent.text.toString(),
                      'hscPercent': hscPercent.text.toString(),
                      'aLevelPercent': aLevel.text.toString(),
                      'oLevelPercent': oLevel.text.toString(),
                      'cgpa': cgpa.text.toString(),
                      'interests': interestsC.text
                          .split(',')
                          .map((e) => e.trim())
                          .toList(),
                    };

                    if (image != null) {
                      final newId = DateTime.now().millisecondsSinceEpoch;
                      firebase_storage.Reference ref = firebase_storage
                          .FirebaseStorage.instance
                          .ref("/users/$newId");
                      firebase_storage.UploadTask uploadTask =
                          ref.putFile(image!.absolute);

                      await uploadTask;
                      final newUrl = await ref.getDownloadURL();
                      updatedData['imageUrl'] = newUrl;
                    }

                    await userCollection
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .update(updatedData);

                    Utils.flushBarErrorMessage('Changes Saved', context);
                  } catch (e) {
                    Utils.flushBarErrorMessage(
                        'Error updating profile: $e', context);
                  } finally {
                    setState(() {
                      btnLoading = false;
                    });
                  }
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
