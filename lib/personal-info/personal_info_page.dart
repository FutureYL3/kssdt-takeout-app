import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:takeout/dto/personal_info_dto.dart';
import 'package:takeout/personal-info/personal_info_apis.dart';

import '../welcome/welcome_page.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  String? imageUrl;
  String? idCardNumber;
  String? phone;
  final PersonalInfoApiService personalInfoApiService = PersonalInfoApiService();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  PersonalInfoDto dto = PersonalInfoDto();

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    final String? getPhone = await secureStorage.read(key: 'phone');
    if (getPhone == null) {
      // 如果没有存储手机号，即表示未登录，跳转到欢迎页面
      await Get.offAll(() => const WelcomePage());
      return;
    }
    // 请求成功，保存数据
    Map<String, dynamic> response = await personalInfoApiService.getPersonalInfo(getPhone, context);
    if (response['code'] == 1) {
      setState(() {
        idCardNumber  = response['data']['id_card_number'];
        imageUrl = response['data']['imageURL'];
        phone = getPhone;
      });
    }
  }

  void _pickAndUploadImage() async {
    // 选择图片并上传
    // personalInfoApiService.dio.options.headers['Content-Type'] = 'multipart/form-data';
    personalInfoApiService.uploadImage(dto, context);
    getData();
  }



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('头像：'),
              const SizedBox(width: 20),
              // Container(
              //   width: 100,
              //   height: 100,
              //   color: Colors.grey[300],
              // ),
              GestureDetector(
                onTap: _pickAndUploadImage,  // 点击头像选择图片并上传
                child: CircleAvatar(
                  radius: 50, // 头像的半径大小
                  backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
                      ? NetworkImage(imageUrl!) // 显示网络头像
                      : null, // 如果没有头像，显示默认图标
                  backgroundColor: Colors.grey[300], // 没有头像时的背景色
                  child: imageUrl == null || imageUrl!.isEmpty
                      ? const Icon(Icons.person, size: 50)  // 默认显示图标
                      : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text("实名验证：${idCardNumber ?? ''}"),
          const SizedBox(height: 10),
          Text("手机号：${phone ?? ''}"),
          const SizedBox(height: 20),
          // ElevatedButton(
          //   onPressed: () {
          //     // 修改资料按钮点击事件
          //   },
          //   child: const Text('修改资料'),
          // ),
        ],
      )
    );
  }
}