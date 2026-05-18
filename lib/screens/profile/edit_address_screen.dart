import 'package:flutter/material.dart';
import 'address_screen.dart';
import 'add_address_screen.dart';

const primaryColor = Color.fromRGBO(255, 82, 131, 1);


class EditAddressScreen extends StatefulWidget {
  final AddressItem address;


  const EditAddressScreen({super.key, required this.address});


  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}


class _EditAddressScreenState extends State<EditAddressScreen> {
  late AddressItem _currentAddress;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressDetailController;
  late TextEditingController _noteController;
  late String _selectedType;
  late TextEditingController _aliasController;


  @override
  void initState() {
    super.initState();
    _currentAddress = widget.address;
    _nameController = TextEditingController(text: _currentAddress.contactName);
    _phoneController =
        TextEditingController(text: _currentAddress.contactPhone);
    _addressDetailController = TextEditingController(
        text: _currentAddress.detailAddress); // Khởi tạo với giá trị hiện tại
    _noteController = TextEditingController(text: _currentAddress.note ?? '');


    final title = _currentAddress.title;
    if (title == 'Home' || title == 'Work') {
      _selectedType = title;
      _aliasController = TextEditingController();
    } else {
      _selectedType = 'Other';
      _aliasController = TextEditingController(text: title);
    }
  }


  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressDetailController.dispose();
    _noteController.dispose();
    _aliasController.dispose();
    super.dispose();
  }


  void _saveAddress() {
    final updatedAddress = _currentAddress.copyWith(
      title: _selectedType == 'Other' && _aliasController.text.isNotEmpty
          ? _aliasController.text
          : _selectedType,
      detailAddress: _addressDetailController.text,

      contactName: _nameController.text,
      contactPhone: _phoneController.text,
      note: _noteController.text.isEmpty ? null : _noteController.text,
    );
    Navigator.pop(context, updatedAddress);
  }


  Widget _buildTypeButton(String title) {
    bool isSelected = _selectedType == title;
    return Expanded(
      child: Padding(
        padding: title == 'Home' ? const EdgeInsets.only(right: 8.0) : title ==
            'Work'
            ? const EdgeInsets.symmetric(horizontal: 4.0)
            : const EdgeInsets.only(left: 8.0),
        child: OutlinedButton(
          onPressed: () => setState(() => _selectedType = title),
          style: OutlinedButton.styleFrom(
            foregroundColor: isSelected ? Colors.white : Colors.grey[600],
            backgroundColor: isSelected ? primaryColor : Colors.white,
            side: BorderSide(
                color: isSelected ? primaryColor : Colors.grey[300]!,
                width: 1.5),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }


  void _deleteAddress() {
    Navigator.pop(context, "DELETE");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context)),
        title: const Text("Sửa địa chỉ",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildHeaderInput(_nameController, "Tên người nhận"),
                  buildHeaderInput(_phoneController, "Số điện thoại"),

                  buildAddressInputField(_addressDetailController,
                      "Nhập số nhà, tên đường, phường/xã"),


                  buildTextField("Tòa nhà, Số tầng (Không bắt buộc)"),
                  buildTextField("Cổng (Không bắt buộc)"),
                  const SizedBox(height: 16),


                  Row(children: [
                    _buildTypeButton('Home'),
                    _buildTypeButton('Work'),
                    _buildTypeButton('Other')
                  ]),


                  if (_selectedType == 'Other')
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: buildTextField("Tên địa chỉ (VD: Trường học, Gym)",
                          controller: _aliasController),
                    ),


                  const SizedBox(height: 20),
                  buildNoteField("Ghi chú cho Tài xế (Không bắt buộc)",
                      controller: _noteController),
                  const SizedBox(height: 30),


                  TextButton(
                    onPressed: _deleteAddress,
                    child: const Text("Xóa địa chỉ", style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),


          buildSaveButton(onPressed: _saveAddress, label: "Lưu"),
        ],
      ),
    );
  }
}
