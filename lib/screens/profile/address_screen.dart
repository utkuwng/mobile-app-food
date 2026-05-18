import 'package:flutter/material.dart';
import 'add_address_screen.dart';
import 'edit_address_screen.dart';


const primaryColor = Color.fromRGBO(255, 82, 131, 1);



class AddressItem {
  final String id;
  String title;
  String detailAddress;
  String contactName;
  String contactPhone;
  bool isDefault;
  String? note;


  AddressItem({
    required this.id,
    required this.title,
    required this.detailAddress,
    required this.contactName,
    required this.contactPhone,
    this.isDefault = false,
    this.note,
  });


  AddressItem copyWith({
    String? title,
    String? detailAddress,
    String? contactName,
    String? contactPhone,
    bool? isDefault,
    String? note,
  }) {
    return AddressItem(
      id: id,
      title: title ?? this.title,
      detailAddress: detailAddress ?? this.detailAddress,
      contactName: contactName ?? this.contactName,
      contactPhone: contactPhone ?? this.contactPhone,
      isDefault: isDefault ?? this.isDefault,
      note: note ?? this.note,
    );
  }
}

List<AddressItem> globalAddressList = [
  AddressItem(id: '1', title: "Nhà", detailAddress: "11/2A, Bình Thạnh, TP.HCM", contactName: "Le Anh Vy", contactPhone: "090xxxx1234", isDefault: true),
  AddressItem(id: '2', title: "Công ty", detailAddress: "Tòa nhà Bitexco, P.Bến Nghé, Q.1, TP.HCM", contactName: "Nguyen Song Nhi", contactPhone: "091xxxx5678"),
  AddressItem(id: '3', title: "Nhà Bố Mẹ", detailAddress: "456 Lê Văn Sỹ, P.14, Q.3, TP.HCM", contactName: "Le Huynh Nhu", contactPhone: "070xxxx1847"),
];



class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});


  @override
  State<AddressScreen> createState() => _AddressScreenState();
}


class _AddressScreenState extends State<AddressScreen> {

  int _selectedIndex = 0;


  @override
  void initState() {
    super.initState();
    _selectedIndex = globalAddressList.indexWhere((addr) => addr.isDefault);
    if (_selectedIndex == -1 && globalAddressList.isNotEmpty) {
      globalAddressList[0].isDefault = true;
      _selectedIndex = 0;
    } else if (globalAddressList.isEmpty) {
      _selectedIndex = -1;
    }
  }


  void _navigateToAddAddress() async {
    final newAddress = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddAddressScreen()),
    );


    if (newAddress != null && newAddress is AddressItem) {
      setState(() {
        for (var addr in globalAddressList) {
          addr.isDefault = false;
        }
        newAddress.isDefault = true;
        globalAddressList.add(newAddress);
        _selectedIndex = globalAddressList.length - 1;
      });
    }
  }


  void _navigateToEditAddress(AddressItem addressToEdit, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditAddressScreen(address: addressToEdit)),
    );


    if (result is AddressItem) {
      setState(() {

        globalAddressList[index] = result;

        if (result.isDefault) {
          for (int i = 0; i < globalAddressList.length; i++) {
            if (i != index) globalAddressList[i].isDefault = false;
          }
        }
        _selectedIndex = globalAddressList.indexWhere((addr) => addr.isDefault);
      });
    } else if (result == "DELETE") {
      setState(() {
        final wasDefault = globalAddressList[index].isDefault;
        globalAddressList.removeAt(index);


        if (wasDefault && globalAddressList.isNotEmpty) {
          globalAddressList[0].isDefault = true;
          _selectedIndex = 0;
        } else if (_selectedIndex > index) {
          _selectedIndex--;
        }
        else if (_selectedIndex == index && globalAddressList.isNotEmpty) {
          _selectedIndex = 0;
          globalAddressList[0].isDefault = true;
        } else if (globalAddressList.isEmpty) {
          _selectedIndex = -1;
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
        title: const Text("Địa chỉ giao hàng", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildAddCompanyAddress(),
                const SizedBox(height: 10),


                ...globalAddressList.asMap().entries.map((entry) {
                  int index = entry.key;
                  AddressItem address = entry.value;
                  return _buildAddressOption(
                    index: index,
                    address: address,
                    onEdit: () => _navigateToEditAddress(address, index),
                  );
                }).toList(),


                const SizedBox(height: 20),
              ],
            ),
          ),


          _buildBottomButton(
            label: "Thêm địa chỉ mới",
            backgroundColor: const Color(0xFFFFF0F5),
            foregroundColor: primaryColor,
            onPressed: _navigateToAddAddress,
          ),


          _buildBottomButton(
            label: "Áp dụng",
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            onPressed: () {
              if (_selectedIndex != -1) {
                // Trả về địa chỉ đã chọn từ globalAddressList
                Navigator.pop(context, globalAddressList[_selectedIndex]);
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }


  Widget _buildAddCompanyAddress() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.work_outline, color: primaryColor, size: 24),
              SizedBox(width: 16),
              Text("Thêm địa chỉ Công ty", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black54),
        ],
      ),
    );
  }


  Widget _buildAddressOption({required int index, required AddressItem address, required VoidCallback onEdit}) {

    final isSelected = address.isDefault;


    void handleTap() {
      setState(() {

        for (var addr in globalAddressList) {
          addr.isDefault = false;
        }
        globalAddressList[index].isDefault = true;
        _selectedIndex = index;
      });
    }


    return GestureDetector(
      onTap: handleTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? Border.all(color: primaryColor, width: 1.5) : null,
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_box_outlined : Icons.check_box_outline_blank,
              color: isSelected ? primaryColor : Colors.grey,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(address.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      if (address.isDefault) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text("Mặc định", style: TextStyle(fontSize: 10, color: primaryColor, fontWeight: FontWeight.bold)),
                        )
                      ]
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${address.contactName} | ${address.contactPhone}',
                    style: TextStyle(color: Colors.grey[800], fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(address.detailAddress, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
            InkWell(
              onTap: onEdit,
              child: const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text("Sửa", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }


  Widget _buildBottomButton({required String label, required Color backgroundColor, required Color foregroundColor, required VoidCallback onPressed}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: 2,
          ),
          onPressed: onPressed,
          child: Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}