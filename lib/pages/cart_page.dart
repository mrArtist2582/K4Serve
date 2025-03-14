// ignore_for_file: duplicate_import, unused_import

import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/my_button.dart';
import 'package:food_delivery_app/components/my_cart_tile.dart';
import 'package:food_delivery_app/components/my_receipt_page.dart';
import 'package:food_delivery_app/models/restauarant.dart';
import 'package:food_delivery_app/pages/delivery_progress_page.dart';
import 'package:food_delivery_app/pages/payment_page.dart';
import 'package:food_delivery_app/pages/home_page.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Restauarant>(builder: (context, restauarant, child) {
      // cart
      final userCart = restauarant.cart;

      // scaffold UI
      return Scaffold(
        appBar: AppBar(
          title: const Text("Cart"),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            // clear all cart button
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title:
                        const Text("Are you sure You want to clear the Cart?"),
                    actions: [
                      // cancel button
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      // yes button
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          restauarant.clearCart();
                        },
                        child: const Text("Yes"),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.delete),
            ),
          ],

            leading : IconButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
        }, icon: Icon(Icons.arrow_back_ios,color: Theme.of(context).colorScheme.inversePrimary,)),
        ),
        body: Column(
          children: [
            // list of cart
            Expanded(
              child: Column(
                children: [
                  userCart.isEmpty
                      ? const Expanded(
                          child: Center(
                            child: Text("Cart is empty..",
                            style: TextStyle(
                              color: Colors.grey
                            ),),
                          ),
                        )
                      : Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: ListView.builder(
                                itemCount: userCart.length,
                                itemBuilder: (context, index) {
                                  // get individual cart item
                                  final cartItem = userCart[index];
                                  // return cart title UI
                            
                                 
                                  return MyCartTile(cartItem: cartItem);
                                }),
                          ),
                        ),
                ],
              ),
            ),
            // button to pay
            MyButton(
              onTap: () {
                if (userCart.isEmpty) {
                  // Show popup (AlertDialog)
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Notice"),
                        content: const Text("First order something."),
                        actions: [],
                      );
                    },
                  );

                  // Close the dialog after 2 seconds and go to Home Page
                  Future.delayed(const Duration(seconds: 2), () {
                    Navigator.pop(context); // Close AlertDialog
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                      (route) => false, // Remove all previous routes
                    );
                  });
                } else {
                  // Show payment mode selection
                  _showPaymentDialog(context);
                }
              },
              text: "Go to checkout",
            ),
            const SizedBox(height: 25),
          ],
        ),
      );
    });
  }

void _showPaymentDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => Theme(
      data: Theme.of(context).copyWith(
        dialogTheme: const DialogTheme(
          backgroundColor: Color.fromARGB(255, 233, 174, 91),
        ),
      ),
      child: AlertDialog(
        title: const Text(
          "Select Payment Method",
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text(
                "Cash on Delivery",
                style: TextStyle(color: Colors.white),
              ),
              leading: const Icon(Icons.money, color: Colors.black),
              onTap: () {
                Navigator.pop(context); // Close dialog
                showLottieAnimation(context, "Cash on Delivery");
              },
            ),
            ListTile(
              title: const Text(
                "Credit/Debit Card",
                style: TextStyle(color: Colors.white),
              ),
              leading: const Icon(Icons.credit_card, color: Colors.black),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PaymentPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}
void showLottieAnimation(BuildContext context, String paymentMethod) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            'assets/deli.json',
            width: 400,
            height: 400,
            repeat: false,
            animate: true,
            onLoaded: (composition) {
             
              Future.delayed(composition.duration, () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DeliveryProgressPage(paymentMethod: paymentMethod),
                  ),
                );
              });
            },
          ),
          const SizedBox(height: 10),
          const Text(
            "Processing your payment...",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ],
      ),
    ),
  );
}

}