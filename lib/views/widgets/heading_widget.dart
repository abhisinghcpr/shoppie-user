import 'package:flutter/material.dart';


class HeadingWidget extends StatelessWidget {
  final String headingTitle;
  final String? headingSubTitle;
  final VoidCallback? onTap;

  const HeadingWidget({
    super.key,
    required this.headingTitle,
     this.headingSubTitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  headingTitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                // Text(
                //   headingSubTitle??'',
                //   style: TextStyle(
                //     fontWeight: FontWeight.w500,
                //     fontSize: 12.0,
                //     color: Colors.grey,
                //   ),
                // ),
              ],
            ),
            GestureDetector(
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                 padding: EdgeInsets.all(3.0), // Optional: Adjust padding as needed
                child: Icon(Icons.keyboard_arrow_right,color: Colors.white,),
              ),
            )

          ],
        ),
      ),
    );
  }
}
