import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String profileImageUrl = ''; // URL gambar profil dari database
  String realName = 'SEBASTIAN WIJAYANTO';
  String username = 'sebastian';
  String mobileNumber = '62 *** 6367';
  String email = 'a **** @gmail.com';

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        profileImageUrl = image.path; // Atur ulang URL gambar setelah unggah
      });

      // TODO: Implementasikan logika penyimpanan ke database atau server
    }
  }

  void _editProfileField(
      String title, String initialValue, Function(String) onSave) {
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
                onSave(controller.text);
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
                'Account Type',
                'T-CASH Premium',
                showArrow: false,
                isBlue: true,
              ),
              _buildSettingItem(
                'Profile Picture',
                '',
                showArrow: true,
                leading: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.grey,
                  backgroundImage: profileImageUrl.isNotEmpty
                      ? FileImage(File(profileImageUrl))
                      : null,
                  child: profileImageUrl.isEmpty
                      ? const Icon(Icons.person, size: 20, color: Colors.white)
                      : null,
                ),
                onTap: _pickImage,
              ),
              _buildSettingItem(
                'Realname',
                realName,
                showArrow: true,
                isBlue: true,
                onTap: () =>
                    _editProfileField('Realname', realName, (newValue) {
                  setState(() {
                    realName = newValue;
                  });
                  // TODO: Save username to database
                }),
              ),
              _buildSettingItem(
                'Username',
                username,
                showArrow: true,
                isBlue: true,
                onTap: () =>
                    _editProfileField('Username', username, (newValue) {
                  setState(() {
                    username = newValue;
                  });
                  // TODO: Save username to database
                }),
              ),
              _buildSettingItem(
                'Mobile Number',
                mobileNumber,
                showArrow: true,
                onTap: () => _editProfileField('Mobile Number', mobileNumber,
                    (newValue) {
                  setState(() {
                    mobileNumber = newValue;
                  });
                  // TODO: Save mobile number to database
                }),
              ),
              _buildSettingItem(
                'Email Address',
                email,
                showArrow: true,
                onTap: () =>
                    _editProfileField('Email Address', email, (newValue) {
                  setState(() {
                    email = newValue;
                  });
                  // TODO: Save email address to database
                }),
              ),
            ]),
          ],
        ),
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
