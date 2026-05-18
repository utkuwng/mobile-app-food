import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ueh_food_delivery/constants.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String _selectedGender = "Nam";
  String _selectedCountry = "Việt Nam";

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nicknameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dateController.dispose();
    super.dispose();
  }


  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {

      _nameController.text = prefs.getString(StorageKeys.name) ?? "Người dùng BITOO";
      _emailController.text = prefs.getString(StorageKeys.email) ?? "";
      _nicknameController.text = prefs.getString(StorageKeys.nickname) ?? "";
      _phoneController.text = prefs.getString(StorageKeys.phone) ?? "";
      _dateController.text = prefs.getString(StorageKeys.dob) ?? "27/12/1995";

      _selectedGender = prefs.getString(StorageKeys.gender) ?? "Nam";
      _selectedCountry = prefs.getString(StorageKeys.country) ?? "Việt Nam";
    });
    print("✅ Đã tải thông tin hồ sơ của người dùng.");
  }


  Future<void> _saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(StorageKeys.name, _nameController.text);
    await prefs.setString(StorageKeys.nickname, _nicknameController.text);
    await prefs.setString(StorageKeys.email, _emailController.text);
    await prefs.setString(StorageKeys.phone, _phoneController.text);
    await prefs.setString(StorageKeys.dob, _dateController.text);
    await prefs.setString(StorageKeys.gender, _selectedGender);
    await prefs.setString(StorageKeys.country, _selectedCountry);

    print("💾 Đã lưu thay đổi vào bộ nhớ cục bộ.");
  }



  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate;
    try {
      initialDate = DateFormat('dd/MM/yyyy').parse(_dateController.text);
    } catch (_) {
      initialDate = DateTime.now();
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                    primary: primaryColor,
                    onPrimary: Colors.white,
                    onSurface: Colors.black
                )
            ),
            child: child!
        );
      },
    );
    if (picked != null) {
      setState(() => _dateController.text = DateFormat('dd/MM/yyyy').format(picked));
    }
  }

  void _handleUpdate() async {
    await _saveProfileData();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text("Thông tin hồ sơ đã được cập nhật thành công!"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2)
      ),
    );

    Navigator.pop(context, true);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Chỉnh sửa hồ sơ",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [

                  Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage('https://i.pravatar.cc/150?img=12'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.edit, color: Colors.white, size: 16),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 30),


                  _buildTextField(controller: _nameController, hint: "Họ và tên"),
                  const SizedBox(height: 20),
                  _buildTextField(controller: _nicknameController, hint: "Biệt danh"),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _dateController,
                    hint: "Ngày sinh",
                    isReadOnly: true,
                    suffixIcon: Icons.calendar_today_outlined,
                    onTap: () => _selectDate(context),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _emailController,
                    hint: "Email",
                    suffixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),


                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: "Số điện thoại",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.flag, color: Colors.red, size: 20),
                              const SizedBox(width: 5),
                              const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey),
                              const SizedBox(width: 5),
                              const Text("+84", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                              const SizedBox(width: 10),
                              Container(height: 20, width: 1, color: Colors.grey.withOpacity(0.3))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),


                  _buildDropdownField(
                    value: _selectedGender,
                    items: const ["Nam", "Nữ", "Khác"],
                    onChanged: (val) => setState(() => _selectedGender = val!),
                    hint: "Giới tính",
                  ),
                  const SizedBox(height: 20),
                  _buildDropdownField(
                    value: _selectedCountry,
                    items: const ["Việt Nam", "Hoa Kỳ", "Anh", "Nhật Bản"],
                    onChanged: (val) => setState(() => _selectedCountry = val!),
                    hint: "Quốc gia",
                  ),
                ],
              ),
            ),
          ),


          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                )
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _handleUpdate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 0,
                ),
                child: const Text(
                  "Cập nhật",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool isReadOnly = false,
    IconData? suffixIcon,
    VoidCallback? onTap,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        readOnly: isReadOnly,
        onTap: onTap,
        keyboardType: keyboardType,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400]),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: Colors.grey[600], size: 22) : null,
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required String hint,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(Icons.arrow_drop_down_circle, color: Colors.grey, size: 22),
          isExpanded: true,
          style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600),
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
        ),
      ),
    );
  }
}