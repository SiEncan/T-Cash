import 'package:fintar/screen/auth/enter_curr_passcode.dart';
import 'package:fintar/screen/auth/passcode_create.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String userId = '';
  String profileImageUrl = '';
  String username = '';
  String mobileNumber = '';
  String email = '';
  bool passcodeExists = false;

  bool isLoading = true;
  bool isPicking = false;
  bool isUploading = false;

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
      _fetchUserProfile();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchUserProfile() async {
    if (userId.isEmpty) {
      return;
    }

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;

        setState(() {
          profileImageUrl = data?['profileImageUrl'] ?? '';
          username = data?['fullName'] ?? '';
          mobileNumber = data?['phone'] ?? '';
          email = data?['email'];
          passcodeExists = data?['passcode'] != null;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateUserProfile(String field, String value) async {
    if (userId.isEmpty) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({field: value});
    } catch (e) {
      debugPrint('$e');
    }
  }

  Future<String?> _uploadImageToCloudinary(File image) async {
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
      return null;
    }
  }

  Future _pickImage() async {
    if (isPicking) return;
    setState(() {
      isPicking = true;
    });

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          isUploading = true;
        });

        String? imageUrl = await _uploadImageToCloudinary(File(image.path));

        if (imageUrl != null) {
          if (mounted) {
            setState(() {
              profileImageUrl = imageUrl;
            });
          }
          _updateUserProfile('profileImageUrl', imageUrl);
        }
      }
    } catch (e) {
      debugPrint('Error picking or uploading image: $e');
    } finally {
      if (mounted) {
        setState(() {
          isPicking = false;
          isUploading = false;
        });
      }
    }
  }

  void _editProfileField(String title, String initialValue, String field) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController controller =
            TextEditingController(text: initialValue);
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter new $title'),
            maxLength: field == 'phone'
                ? 13
                : field == 'email'
                    ? 50
                    : 30,
            inputFormatters: field == 'phone'
                ? [FilteringTextInputFormatter.digitsOnly]
                : [],
            buildCounter: (_,
                {required currentLength, maxLength, required isFocused}) {
              return null; // Hide character counter
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  switch (field) {
                    case 'fullName':
                      username = controller.text;
                      break;
                    case 'phone':
                      mobileNumber = controller.text;
                      break;
                    case 'email':
                      email = controller.text;
                      break;
                  }
                });
                _updateUserProfile(field, controller.text);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
            child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        )),
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
            if (!passcodeExists) _buildSetupPasscodeItem(),
            const SizedBox(
              height: 20,
            ),
            _buildSection([
              _buildSettingItem(
                'Account Type',
                'T-CASH Premium',
                showArrow: false,
                isBlue: true,
              ),
              _buildSettingItem(
                'Profile Picture',
                '',
                showArrow: true,
                leading: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey,
                      backgroundImage: profileImageUrl.isNotEmpty
                          ? NetworkImage(profileImageUrl)
                          : null,
                      child: profileImageUrl.isEmpty
                          ? const Icon(Icons.person,
                              size: 40, color: Colors.white)
                          : null,
                    ),
                    if (isUploading)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.5),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                onTap: isPicking || isUploading ? null : _pickImage,
              ),
              _buildSettingItem(
                'Username',
                username,
                showArrow: true,
                isBlue: true,
                onTap: () =>
                    _editProfileField('Username', username, 'fullName'),
              ),
              _buildSettingItem(
                'Mobile Number',
                mobileNumber,
                showArrow: true,
                onTap: () =>
                    _editProfileField('Mobile Number', mobileNumber, 'phone'),
              ),
              _buildSettingItem(
                'Email Address',
                email,
                showArrow: true,
                onTap: () => _editProfileField('Email Address', email, 'email'),
              ),
              if (passcodeExists) _buildPasscodeSection()
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildPasscodeSection() {
    return
        // Change passcode option
        Container(
      margin: const EdgeInsets.only(left: 12, right: 12, bottom: 10, top: 10),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: const Icon(
          Icons.lock,
          color: Colors.white,
          size: 28,
        ),
        title: const Text(
          'Change Passcode',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.white,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EnterCurrentPasscode(userId: userId)),
          );
        },
      ),
    );
  }

  Widget _buildSetupPasscodeItem() {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 12, right: 12),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: const Icon(
          Icons.warning,
          color: Colors.white,
          size: 28,
        ),
        title: const Text(
          'Set up your passcode',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.white,
        ),
        onTap: () {
          // Navigate to the CreatePasscode screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreatePasscode()),
          );
        },
      ),
    );
  }

  Widget _buildSection(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingItem(String title, String value,
      {bool showArrow = true,
      Widget? leading,
      bool isBlue = false,
      VoidCallback? onTap}) {
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
                color: isBlue ? Colors.blue : Colors.grey[600],
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
