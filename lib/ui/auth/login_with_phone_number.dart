

import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/ui/posts/post_screen.dart';
import 'package:untitled1/widgets/round_button.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({Key? key}) : super(key: key);

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {

  final _auth = FirebaseAuth.instance ;

  final phoneNumberController = TextEditingController();
  String phoneCode = '+92';
  String error = '';
  bool loading = false ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(

            children: [
              SizedBox(height: 80,),
              Row(
                children: [
                  TextButton(

                      onPressed: (){
                    showCountryPicker(
                      context: context,
                      //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
                      favorite: <String>['PK'],
                      //Optional. Shows phone code before the country name.
                      showPhoneCode: true,
                      onSelect: (Country country) {
                        setState(() {
                          phoneCode = "+"+country.phoneCode.toString();
                        });
                        print('Select country: ${country.displayName}');
                      },
                      // Optional. Sets the theme for the country list picker.
                      countryListTheme: CountryListThemeData(
                        // Optional. Sets the border radius for the bottomsheet.
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          topRight: Radius.circular(40.0),
                        ),
                        // Optional. Styles the search field.
                        inputDecoration: InputDecoration(
                          labelText: 'Search',
                          hintText: 'Start typing to search',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: const Color(0xFF8C98A8).withOpacity(0.2),
                            ),
                          ),
                        ),
                      ),
                    );
                  }, child: Text(phoneCode.toString())),
                  SizedBox(height: 10,),
                  Expanded(
                    child: TextFormField(
                      controller: phoneNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: 'Phone number'
                      ),
                    ),
                  ),

                ],
              ),
              SizedBox(height: 80,),

              RoundButton(
                title: 'Login',
                loading: loading,
                onTap: ()async{
                  setState(() {
                    loading = true ;
                  });
                  await _auth.verifyPhoneNumber(
                    phoneNumber: phoneCode+phoneNumberController.text,
                    verificationCompleted: (_) {
                      setState(() {
                        loading = false ;
                      });
                    },
                    verificationFailed: (e) {
                      setState(() {
                        error = '${e.message}';
                        loading = false ;
                      });
                    },
                    codeSent: (String verificationId, int? resendToken) async {
                      final smsCode = await getSmsCodeFromUser(context);

                      if (smsCode != null) {
                        // Create a PhoneAuthCredential with the code
                        final credential = PhoneAuthProvider.credential(
                          verificationId: verificationId,
                          smsCode: smsCode,
                        );

                        try {
                          // Sign the user in (or link) with the credential
                          await _auth.signInWithCredential(credential);
                          print('sucesss');
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreen()));
                          setState(() {
                            loading = false ;
                          });
                        } on FirebaseAuthException catch (e) {
                          setState(() {
                            error = e.message ?? '';
                          });
                          setState(() {
                            loading = false ;
                          });
                        }
                      }
                    },
                    codeAutoRetrievalTimeout: (e) {
                      setState(() {
                        error = e;
                      });
                    },
                  );
                },
              )

            ],
          ),
        ),
      ),
    );
  }

  Future<String?> getSmsCodeFromUser(BuildContext context) async {
    String? smsCode;

    // Update the UI - wait for the user to enter the SMS code
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('SMS code:'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Sign in'),
            ),
            OutlinedButton(
              onPressed: () {
                smsCode = null;
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
          content: Container(
            padding: const EdgeInsets.all(20),
            child: TextField(
              onChanged: (value) {
                smsCode = value;
              },
              textAlign: TextAlign.center,
              autofocus: true,
            ),
          ),
        );
      },
    );

    return smsCode;
  }

}

