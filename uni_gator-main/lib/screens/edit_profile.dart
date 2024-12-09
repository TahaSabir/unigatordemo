import 'package:flutter/material.dart';

import '/model/users_model.dart';

class EditProfilePage extends StatefulWidget {
  final Users user;
  final Function(Users) onUserUpdated;

  const EditProfilePage(
      {super.key, required this.user, required this.onUserUpdated});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _sscPercentController;
  late TextEditingController _hscPercentController;
  late TextEditingController _cgpaController;
  late TextEditingController _interestsController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _sscPercentController =
        TextEditingController(text: widget.user.sscPercent.toString());
    _hscPercentController =
        TextEditingController(text: widget.user.hscPercent.toString());
    _cgpaController = TextEditingController(text: widget.user.cgpa.toString());
    _interestsController =
        TextEditingController(text: widget.user.interests.join(', '));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _sscPercentController.dispose();
    _hscPercentController.dispose();
    _cgpaController.dispose();
    _interestsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/FAST.jpeg'),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon:
                              const Icon(Icons.camera_alt, color: Colors.white),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _sscPercentController,
                decoration: const InputDecoration(labelText: 'SSC Percent'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your SSC percent';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _hscPercentController,
                decoration: const InputDecoration(labelText: 'HSC Percent'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your HSC percent';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cgpaController,
                decoration:
                    const InputDecoration(labelText: 'Bachelor\'s CGPA'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your CGPA';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _interestsController,
                decoration: const InputDecoration(
                  labelText: 'Interests',
                  hintText: 'Separate interests with commas',
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      double? sscPercent = double.tryParse(_sscPercentController.text);
      double? hscPercent = double.tryParse(_hscPercentController.text);
      double? cgpa = double.tryParse(_cgpaController.text);

      if (sscPercent == null || hscPercent == null || cgpa == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Please enter valid numeric values for percentages and CGPA')),
        );
        return;
      }

      final updatedUser = Users(
        name: _nameController.text,
        email: _emailController.text,
        sscPercent: sscPercent,
        hscPercent: hscPercent,
        cgpa: cgpa,
        interests:
            _interestsController.text.split(',').map((e) => e.trim()).toList(),
      );

      widget.onUserUpdated(updatedUser);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
      Navigator.pop(context);
    }
  }
}
