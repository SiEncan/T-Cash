import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CobaProfile extends StatefulWidget {
  const CobaProfile({super.key});

  @override
  State<CobaProfile> createState() => _CobaProfileState();
}

class _CobaProfileState extends State<CobaProfile> {
  String userId = '';
  String profileImageUrl = '';
  String username = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeUserId();
  }

  Future<void> _initializeUserId() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        userId = currentUser.uid;
      });
      await _fetchUserProfile();
    } else {
      print('No user logged in!');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchUserProfile() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        setState(() {
          profileImageUrl = userDoc['profileImageUrl'] ?? '';
          username = userDoc['fullName'] ?? 'No Name';
          isLoading = false;
        });
      } else {
        print('User document does not exist!');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<String?> uploadImagetoCloudinary(File image) async {
    String cloudName = 'dm0brovfk';
    String apiKey = '996164835147661';
    String apiSecret = '6unpohh6GYqJYW027mDU2vgl03E';

    final url =
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
    String auth = base64Encode(utf8.encode('$apiKey:$apiSecret'));

    var request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Basic $auth'
      ..fields['upload_preset'] = 'lginmk6z'
      ..files.add(await http.MultipartFile.fromPath('file', image.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseData);
      return jsonResponse['secure_url'];
    } else {
      print('Failed to upload image: ${response.statusCode}');
      print(await response.stream.bytesToString());
      return null;
    }
  }

  Future<void> saveProfileInfoToFirestore(String imageUrl) async {
    if (userId.isNotEmpty) {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'profileImageUrl': imageUrl,
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String? imagePath = await uploadImagetoCloudinary(File(image.path));
      if (imagePath != null) {
        await saveProfileInfoToFirestore(imagePath);
        setState(() {
          profileImageUrl = imagePath;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Profile Settings',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSection([
              _buildSettingItem(
                'Profile Picture',
                '',
                showArrow: true,
                leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey,
                  backgroundImage: profileImageUrl.isNotEmpty
                      ? NetworkImage(profileImageUrl) as ImageProvider
                      : const AssetImage('img/T-Cash_Logo.png'),
                  child: profileImageUrl.isEmpty
                      ? const Icon(Icons.person, size: 40, color: Colors.white)
                      : null,
                ),
                onTap: _pickImage,
              ),
              _buildSettingItem(
                'Username',
                username,
                showArrow: false,
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingItem(String title, String value,
      {bool showArrow = true, Widget? leading, VoidCallback? onTap}) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: ListTile(
        leading: leading,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            if (showArrow)
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
