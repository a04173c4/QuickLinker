import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:QuickLinker/features/models/profile.dart';
import 'package:QuickLinker/features/profile/services/profile_service.dart';
import 'package:QuickLinker/providers/user_provider.dart';
import 'package:QuickLinker/theme.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});
  static const String routeName = '/edit-profile';

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  File? selectedImage;
  ProfileService profileService = ProfileService();

  @override
  void initState() {
    super.initState();
  }

  void pickImages() async {
    final ImagePicker picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  final List<String> _categories = ['Male', 'Female'];

  String? _selectedCategory;
  bool isLoading = false;
  void updateProfile() {
    isLoading = true;
    setState(() {});

    profileService.updateProfile(
        name: nameController.text.isEmpty
            ? 'untouched name'
            : nameController.text,
        img: selectedImage,
        gender:
            _selectedCategory != null ? _selectedCategory! : 'untouched gender',
        street: streetController.text.isEmpty
            ? 'untouched street'
            : streetController.text,
        postalCode: postalCodeController.text.isEmpty
            ? 'untouched postalCode'
            : postalCodeController.text,
        city: cityController.text.isEmpty
            ? 'untouched city'
            : cityController.text,
        country: countryController.text.isEmpty
            ? 'untouched country'
            : countryController.text,
        context: context);
  }

  final nameController = TextEditingController();
  final streetController = TextEditingController();
  final postalCodeController = TextEditingController();
  final cityController = TextEditingController();
  final countryController = TextEditingController();
  final genderController = TextEditingController();

  String countryFlag = '';
  String countryCode = '';
  bool isSelected = true;
  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void selectCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      onSelect: (Country country) {
        setState(() {
          countryFlag = country.flagEmoji;
          countryCode = country.phoneCode;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Profile profile =
        Provider.of<UserProvider>(context, listen: false).user.profile;
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text('تعديل الملف الشخصي'),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          Stack(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 70,
                  child: selectedImage != null
                      ? ClipOval(
                          child: Image.file(
                            selectedImage!,
                            fit: BoxFit.cover,
                            width: 140,
                            height: 140,
                          ),
                        )
                      : ClipOval(
                          child: Image.network(
                            profile.img,
                            fit: BoxFit.cover,
                            width: 140,
                            height: 140,
                          ),
                        ),
                ),
              ),
              Positioned(
                bottom: 5,
                left: 254,
                child: GestureDetector(
                  onTap: pickImages,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.light
                          ? white
                          : teal,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit_outlined,
                      size: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Text(
              profile.name,
              style: const TextStyle(
                  fontSize: 24,
                  color: Color(0XFF5A5A5A),
                  fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: profile.name,
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding: const EdgeInsets.all(18),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: TextField(
              controller: postalCodeController,
              decoration: InputDecoration(
                hintText: profile.postalCode,
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding: const EdgeInsets.all(18),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: TextField(
              controller: cityController,
              decoration: InputDecoration(
                hintText: profile.city,
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding: const EdgeInsets.all(18),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: TextField(
              controller: streetController,
              decoration: InputDecoration(
                hintText: profile.street,
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding: const EdgeInsets.all(18),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: TextField(
              controller: countryController,
              decoration: InputDecoration(
                hintText: profile.country,
                hintStyle: const TextStyle(color: Colors.grey),
                contentPadding: const EdgeInsets.all(18),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
            ),
          ),
          profile.gender == 'Male' || profile.gender == 'Female'
              ? const SizedBox.shrink()
              : DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Select a Category',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
          Container(
            padding: const EdgeInsets.all(18.0),
            child: TextButton(
                onPressed: () {
                  updateProfile();
                },
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : const Text(
                        'تحديث',
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'OdinRounded',
                        ),
                      )),
          )
        ],
      ),
    );
  }
}
