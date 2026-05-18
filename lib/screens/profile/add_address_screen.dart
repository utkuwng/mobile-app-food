import 'package:flutter/material.dart';
import 'address_screen.dart';


const primaryColor = Color.fromRGBO(255, 82, 131, 1);



Widget buildHeaderInput(TextEditingController controller, String label) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600]),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        suffixIcon: const Padding(padding: EdgeInsets.only(right: 15), child: Icon(Icons.person_pin_circle_outlined, color: primaryColor)),
      ),
    ),
  );
}

Widget buildAddressInputField(TextEditingController controller, String hint) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextField(
      controller: controller,
      maxLines: 2,
      decoration: InputDecoration(
        hintText: hint,
        labelText: "Địa chỉ chi tiết",
        labelStyle: TextStyle(color: Colors.grey[600]),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        suffixIcon: const Padding(padding: EdgeInsets.only(right: 15), child: Icon(Icons.location_on, color: primaryColor)),
      ),
    ),
  );
}


Widget buildTextField(String hint, {TextEditingController? controller}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[500]),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    ),
  );
}


Widget buildNoteField(String hint, {TextEditingController? controller}) {
  return TextField(
    controller: controller,
    maxLines: 5,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[500]),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
    ),
  );
}


Widget buildSaveButton({required VoidCallback onPressed, required String label}) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))],
    ),
    child: SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 2,
        ),
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    ),
  );
}





class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});


  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}


class _AddAddressScreenState extends State<AddAddressScreen> {
  final TextEditingController _nameController = TextEditingController(text: "Binh An");
  final TextEditingController _phoneController = TextEditingController(text: "0898467354");
  final TextEditingController _addressDetailController = TextEditingController(text: "Nguyễn Đình Chiểu, Đa Kao, Quận 1, Hồ Chí Minh, Việt Nam");
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _aliasController = TextEditingController();


  String _selectedType = 'Other';


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
    final newId = DateTime.now().millisecondsSinceEpoch.toString();


    final newAddress = AddressItem(
      id: newId,
      title: _selectedType == 'Other' && _aliasController.text.isNotEmpty ? _aliasController.text : _selectedType,
      detailAddress: _addressDetailController.text,
      contactName: _nameController.text,
      contactPhone: _phoneController.text,
      note: _noteController.text.isEmpty ? null : _noteController.text,
    );
    Navigator.pop(context, newAddress);
  }


  Widget _buildTypeButton(String title) {
    bool isSelected = _selectedType == title;
    return Expanded(
      child: Padding(
        padding: title == 'Home' ? const EdgeInsets.only(right: 8.0) : title == 'Work' ? const EdgeInsets.symmetric(horizontal: 4.0) : const EdgeInsets.only(left: 8.0),
        child: OutlinedButton(
          onPressed: () => setState(() => _selectedType = title),
          style: OutlinedButton.styleFrom(
            foregroundColor: isSelected ? Colors.white : Colors.grey[600],
            backgroundColor: isSelected ? primaryColor : Colors.white,
            side: BorderSide(color: isSelected ? primaryColor : Colors.grey[300]!, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
        title: const Text("Thêm địa chỉ mới", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), centerTitle: true,
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

                  buildAddressInputField(_addressDetailController, "Nhập số nhà, tên đường, phường/xã"),


                  buildTextField("Tòa nhà, Số tầng (Không bắt buộc)"),
                  buildTextField("Cổng (Không bắt buộc)"),
                  const SizedBox(height: 16),


                  Row(children: [_buildTypeButton('Home'), _buildTypeButton('Work'), _buildTypeButton('Other')]),


                  if (_selectedType == 'Other')
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: buildTextField("Tên địa chỉ (VD: Trường học, Gym)", controller: _aliasController),
                    ),


                  const SizedBox(height: 20),
                  buildNoteField("Ghi chú cho Tài xế (Không bắt buộc)", controller: _noteController),
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
