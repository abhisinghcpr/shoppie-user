import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shoppie/views/utils/app-constant.dart';
import 'package:shoppie/views/widgets/singup_widgits.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ContactUsPage extends StatefulWidget {
  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final String phoneNumber = '+918521616449';
  final String emailAddress = 'abhisingh852161@gmail.com';
  var name = TextEditingController();
  var email = TextEditingController();
  var feedback = TextEditingController();
  double rating = 0.0;

  @override
  Widget build(BuildContext context) {
    var viewuser = AddCustomer(context: context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          "Contact Us",
          style: TextStyle(color: AppConstant.appTextColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 150),
              child: const Text(
                'Contact us',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "  LETS ,CONNECT: WE ARE HERE TO HELP,AND WE"
                          "    LOVE TO HERE FROM YOU FROM YOU A QUESTION\n"
                          " COMMENT OR YOU CAN REACH YOU CAN REACH "
                          "  OUT TO US THROUGH THE CONNECT FROM ON THIS PAGE, OR BY PHONE EMAIL AND FEEDBACK ",
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.blueAccent),
                  ),
                  onPressed: () => _launchPhoneCall(),
                  child: Text(
                    'Call Us',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.blueAccent),
                  ),
                  onPressed: () => _launchEmail(),
                  child: Text(
                    'Email',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            viewuser.fieldView(
              icon: Icons.person,
              type: TextInputType.text,
              text: "Name",
              controller: name,
            ),
            viewuser.fieldView(
              icon: Icons.email,
              type: TextInputType.text,
              text: "Email",
              controller: email,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                maxLines: 3,
                controller: feedback,
                decoration: InputDecoration(
                  hintMaxLines: null,
                  hintText: "Enter Your feedback",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            RatingBar(
              initialRating: rating,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              ratingWidget: RatingWidget(
                full: Icon(Icons.star, color: Colors.amber),
                half: Icon(Icons.star_half, color: Colors.amber),
                empty: Icon(Icons.star_border, color: Colors.amber),
              ),
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              onRatingUpdate: (value) {
                setState(() {
                  rating = value;
                });
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all<Color>(Colors.blueAccent),
              ),
              onPressed: () => _saveFeedback(context),
              child: Text(
                "Save Feedback",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _launchPhoneCall() async {
    String url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchEmail() async {
    String url = 'mailto:$emailAddress';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _saveFeedback(BuildContext context) {
    if (name.text.isNotEmpty && email.text.isNotEmpty && feedback.text.isNotEmpty) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      FirebaseFirestore.instance.collection('userfeedback').add({
        'name': name.text,
        'email': email.text,
        'feedback': feedback.text,
        'rating': rating,
        'timestamp': FieldValue.serverTimestamp(),
      }).then((value) {
        print('Feedback saved successfully!');

        Fluttertoast.showToast(
          msg: 'Feedback saved successfully!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
        );

        name.clear();
        email.clear();
        feedback.clear();
        setState(() {
          rating = 0.0;
        });

        Navigator.of(context).pop();
      }).catchError((error) {
        // Handle errors here
        print('Failed to save feedback: $error');
        Fluttertoast.showToast(
          msg: 'Failed to save feedback: $error',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
        );
        Navigator.of(context).pop();
      });
    } else {
      Fluttertoast.showToast(
        msg: 'Please fill all fields!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
    }
  }
}
