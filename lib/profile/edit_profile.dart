import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_profile.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class UpdateProfilePage extends StatefulWidget {
  final String userId;
  final String userTipe;

  UpdateProfilePage({required this.userId, required this.userTipe});

  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  late Map<String, dynamic> _userdata = {};
  final _formKey = GlobalKey<FormState>();
  File? _image;

  // Controller untuk input field
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _provinceController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _districtController = TextEditingController();
  TextEditingController _villageController = TextEditingController();
  TextEditingController _postalCodeController = TextEditingController();

  String? _selectedProvince;
  String? imagePath;

  final List<String> _provinces = [
    'Aceh',
    'Sumatera Utara',
    'Sumatera Barat',
    'Riau',
    'Kepulauan Riau',
    'Jambi',
    'Sumatera Selatan',
    'Bangka Belitung',
    'Bengkulu',
    'Lampung',
    'DKI Jakarta',
    'Jawa Barat',
    'Banten',
    'Jawa Tengah',
    'DI Yogyakarta',
    'Jawa Timur',
    'Bali',
    'Nusa Tenggara Barat',
    'Nusa Tenggara Timur',
    'Kalimantan Barat',
    'Kalimantan Tengah',
    'Kalimantan Selatan',
    'Kalimantan Timur',
    'Kalimantan Utara',
    'Sulawesi Utara',
    'Gorontalo',
    'Sulawesi Tengah',
    'Sulawesi Barat',
    'Sulawesi Selatan',
    'Sulawesi Tenggara',
    'Maluku',
    'Maluku Utara',
    'Papua',
    'Papua Barat',
  ];

  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Image picker error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('warga')
          .doc(widget.userId)
          .get();

      if (snapshot.exists) {
        setState(() {
          _userdata = snapshot.data() as Map<String, dynamic>;
          print(_userdata);
          _nameController.text = _userdata['name'] ?? '';
          _addressController.text = _userdata['address'] ?? '';
          _phoneController.text = _userdata['telnumber'] ?? '';
          _provinceController.text = _userdata['province'] ?? '';
          _cityController.text = _userdata['city'] ?? '';
          _districtController.text = _userdata['district'] ?? '';
          _villageController.text = _userdata['village'] ?? '';
          _postalCodeController.text = _userdata['postal_code'] ?? '';
        });
      } else {
        print('Document does not exist on the database');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  // Function to upload image to Firebase Storage
  Future<String?> uploadImageToFirebase(File image, String userEmail) async {
    try {
      String fileName = path.basename(image.path);
      Reference storageReference =
          FirebaseStorage.instance.ref().child('uploads/$userEmail/$fileName');

      // Uploading the file
      UploadTask uploadTask = storageReference.putFile(image);
      await uploadTask.whenComplete(() => null);

      // Getting the download URL of the uploaded file
      String downloadURL = await storageReference.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _updateProfile(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        String? downloadURL;
        if (_image != null) {
          downloadURL =
              await uploadImageToFirebase(_image!, _userdata['email']);
        }

        await FirebaseFirestore.instance
            .collection('warga')
            .doc(widget.userId)
            .update({
          'name': _nameController.text,
          'address': _addressController.text,
          'telnumber': _phoneController.text,
          'province': _selectedProvince,
          'city': _cityController.text,
          'district': _districtController.text,
          'village': _villageController.text,
          'postal_code': _postalCodeController.text,
          'photo_profile': downloadURL ?? "",
        });

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')));

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ProfilPage(
                    userid: widget.userId, usertipe: widget.userTipe)));
      } catch (e) {
        print('Error updating profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update profile')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50.0,
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : const AssetImage('assets/img/username.jpg')
                              as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: _pickImage,
                      ),
                    ),
                  ],
                ),
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your name' : null,
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your address' : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your phone number' : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedProvince,
                decoration: const InputDecoration(labelText: 'Province'),
                items: _provinces.map((String province) {
                  return DropdownMenuItem<String>(
                    value: province,
                    child: Text(province),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedProvince = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a province' : null,
              ),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'City'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your city' : null,
              ),
              TextFormField(
                controller: _districtController,
                decoration: const InputDecoration(labelText: 'District'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your district' : null,
              ),
              TextFormField(
                controller: _villageController,
                decoration: const InputDecoration(labelText: 'Village'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your village' : null,
              ),
              TextFormField(
                controller: _postalCodeController,
                decoration: const InputDecoration(labelText: 'Postal Code'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your postal code' : null,
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1D7948),
                ),
                onPressed: () => _updateProfile(context),
                child: const Text(
                  'Update Profile',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
