import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

void main() => runApp(MySample());

class MySample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MySampleState();
  }
}

class MySampleState extends State<MySample> {
  String cardNumber = '5172467783002001';
  String expiryDate = '20/25';
  String cardHolderName = 'Github';
  String cvvCode = '123';
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.7),
        width: 2.0,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Credit Card View Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          // decoration: BoxDecoration(
          //   image: !useBackgroundImage
          //       ? const DecorationImage(
          //           image: ExactAssetImage('assets/bg.png'),
          //           fit: BoxFit.fill,
          //         )
          //       : null,
          //   color: Colors.black,
          // ),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 30,
                ),
                CreditCardWidget(
                  glassmorphismConfig:
                      useGlassMorphism ? Glassmorphism.defaultConfig() : null,
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName,
                  cvvCode: cvvCode,
                  obscureCardNumber: true,
                  obscureCardCvv: true,
                  isHolderNameVisible: true,
                  backgroundImage:
                      useBackgroundImage ? 'assets/card_bg.png' : null,
                  onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
                  customCardTypeIcons: <CustomCardTypeIcon>[
                    CustomCardTypeIcon(
                      cardType: CardType.mastercard,
                      cardImage: Image.asset(
                        'assets/mastercard.png',
                        height: 48,
                        width: 48,
                      ),
                    ),
                  ],
                  showButtonCallback: () async {
                    await Future<void>.delayed(const Duration(seconds: 2),() {
                      print('2 detik telah berlalu');
                    },);
                  },
                ),
                // Expanded(
                //   child: SingleChildScrollView(
                //     child: Column(
                //       children: <Widget>[
                //         CreditCardForm(
                //           formKey: formKey,
                //           obscureCvv: true,
                //           obscureNumber: true,
                //           cardNumber: cardNumber,
                //           cvvCode: cvvCode,
                //           isHolderNameVisible: true,
                //           isCardNumberVisible: true,
                //           isExpiryDateVisible: true,
                //           cardHolderName: cardHolderName,
                //           expiryDate: expiryDate,
                //           themeColor: Colors.blue,
                //           textColor: Colors.white,
                //           cardNumberDecoration: InputDecoration(
                //             labelText: 'Number',
                //             hintText: 'XXXX XXXX XXXX XXXX',
                //             hintStyle: const TextStyle(color: Colors.white),
                //             labelStyle: const TextStyle(color: Colors.white),
                //             focusedBorder: border,
                //             enabledBorder: border,
                //           ),
                //           expiryDateDecoration: InputDecoration(
                //             hintStyle: const TextStyle(color: Colors.white),
                //             labelStyle: const TextStyle(color: Colors.white),
                //             focusedBorder: border,
                //             enabledBorder: border,
                //             labelText: 'Expired Date',
                //             hintText: 'XX/XX',
                //           ),
                //           cvvCodeDecoration: InputDecoration(
                //             hintStyle: const TextStyle(color: Colors.white),
                //             labelStyle: const TextStyle(color: Colors.white),
                //             focusedBorder: border,
                //             enabledBorder: border,
                //             labelText: 'CVV',
                //             hintText: 'XXX',
                //           ),
                //           cardHolderDecoration: InputDecoration(
                //             hintStyle: const TextStyle(color: Colors.white),
                //             labelStyle: const TextStyle(color: Colors.white),
                //             focusedBorder: border,
                //             enabledBorder: border,
                //             labelText: 'Card Holder',
                //           ),
                //           onCreditCardModelChange: onCreditCardModelChange,
                //         ),
                //         const SizedBox(
                //           height: 20,
                //         ),
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: <Widget>[
                //             const Text(
                //               'Glassmorphism',
                //               style: TextStyle(
                //                 color: Colors.white,
                //                 fontSize: 18,
                //               ),
                //             ),
                //             Switch(
                //               value: useGlassMorphism,
                //               inactiveTrackColor: Colors.grey,
                //               activeColor: Colors.white,
                //               activeTrackColor: Colors.green,
                //               onChanged: (bool value) => setState(() {
                //                 useGlassMorphism = value;
                //               }),
                //             ),
                //           ],
                //         ),
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: <Widget>[
                //             const Text(
                //               'Card Image',
                //               style: TextStyle(
                //                 color: Colors.white,
                //                 fontSize: 18,
                //               ),
                //             ),
                //             Switch(
                //               value: useBackgroundImage,
                //               inactiveTrackColor: Colors.grey,
                //               activeColor: Colors.white,
                //               activeTrackColor: Colors.green,
                //               onChanged: (bool value) => setState(() {
                //                 useBackgroundImage = value;
                //               }),
                //             ),
                //           ],
                //         ),
                //         const SizedBox(
                //           height: 20,
                //         ),
                //         ElevatedButton(
                //           style: ElevatedButton.styleFrom(
                //             shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(8.0),
                //             ),
                //             primary: const Color(0xff1b447b),
                //           ),
                //           child: Container(
                //             margin: const EdgeInsets.all(12),
                //             child: const Text(
                //               'Validate',
                //               style: TextStyle(
                //                 color: Colors.white,
                //                 fontFamily: 'halter',
                //                 fontSize: 14,
                //                 package: 'flutter_credit_card',
                //               ),
                //             ),
                //           ),
                //           onPressed: () {
                //             if (formKey.currentState!.validate()) {
                //               print('valid!');
                //             } else {
                //               print('invalid!');
                //             }
                //           },
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
    });
  }
}
