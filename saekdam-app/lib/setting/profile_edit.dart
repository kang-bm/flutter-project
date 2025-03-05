import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fly_ai_1/constant/color.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEditScreen extends StatefulWidget {
  final String initialName;
  final File? initialProfileImage;

  ProfileEditScreen({required this.initialName, this.initialProfileImage});

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  File? _profileImage;
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialName;
    _profileImage = widget.initialProfileImage;
  }

  /// 🔹 갤러리에서 이미지 선택
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  /// 🔹 변경된 정보 저장
  void _saveProfile() {
    Navigator.pop(context, {
      "name": _nameController.text,
      "profileImage": _profileImage,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("프로필 수정", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        actions: [
          TextButton(onPressed: _saveProfile, child: Text("완료", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: pinkmain))),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: _profileImage != null ? FileImage(_profileImage!) : AssetImage('asset/img/색담이_rm.png') as ImageProvider,
                ),
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(radius: 18, backgroundColor: Colors.white, child: Icon(Icons.camera_alt, size: 18, color: Colors.grey)),
                ),
              ],
            ),
            SizedBox(height: 30),
            Align(alignment: Alignment.centerLeft, child: Text("닉네임", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            SizedBox(height: 10),
            TextFormField(controller: _nameController, decoration: InputDecoration(border: OutlineInputBorder())),
          ],
        ),
      ),
    );
  }
}
