import 'package:flutter/material.dart';
import 'package:ueh_food_delivery/constants.dart';
import '../sign_in/sign_in_screen.dart';
import '../sign_up/sign_up_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [

          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.pinkAccent.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),

              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
                child: Image.asset(
                  "assets/images/welcome_bg.png",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ),


          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  const Spacer(),

                  const Text(
                    "BITOO FOOD",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: Colors.pinkAccent,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Thèm là có, đặt là giao.\nMón ngon ngay trước cửa nhà bạn.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const Spacer(),


                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                        shadowColor: Colors.pinkAccent.withOpacity(0.4),
                      ),
                      child: const Text(
                        "Đăng nhập",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),


                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.pinkAccent, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Tạo tài khoản",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.pinkAccent,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}