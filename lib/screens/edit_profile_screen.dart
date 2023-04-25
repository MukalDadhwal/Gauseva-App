import 'package:flutter/material.dart';

class EditUserProfile extends StatefulWidget {
  const EditUserProfile({Key? key}) : super(key: key);

  @override
  State<EditUserProfile> createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(children: [
            Stack(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Icon(Icons.account_circle_outlined),
                    /*child: Image(image: AssetImage(*image url*))
                  is to be added here */
                  ),
                ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Color.fromARGB(255, 59, 177, 120)),
                      child: Icon(
                        Icons.camera_roll_outlined,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ))
              ],
            ),
            SizedBox(height: 50),
            Form(
                child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      label: Text("Full Name"),
                      prefixIcon: Icon(Icons.account_circle_outlined)),
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                      label: Text("Email Id"), prefixIcon: Icon(Icons.mail)),
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                      label: Text("Phone Number"),
                      prefixIcon: Icon(Icons.phone)),
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                      label: Text("Password"), prefixIcon: Icon(Icons.lock)),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 213, 205, 177),
                          side: BorderSide.none,
                          shape: StadiumBorder()),
                      child: Text("Edit Profile",
                          style: TextStyle(
                              color: Color.fromARGB(255, 59, 177, 120)))),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Color.fromARGB(255, 178, 38, 38).withOpacity(0.1),
                          elevation: 0,
                          foregroundColor: Color.fromARGB(255, 201, 44, 44),
                          shape: StadiumBorder(),
                          side: BorderSide.none),
                      child: Text("Delete"),
                    )
                  ],
                )
              ],
            ))
          ]),
        ),
      ),
    );
  }
}
