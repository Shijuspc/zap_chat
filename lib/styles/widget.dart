import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zap_chat/phone_auth.dart';
import 'animation.dart';
import 'styles.dart';

class ChatWidgets {
  static Widget card({title, time, subtitle, onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Card(
        elevation: 0,
        child: ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.only(left: 15, right: 15),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 2, color: Colors.blue.shade400),
            borderRadius: BorderRadius.circular(10),
          ),
          leading: const Padding(
            padding: EdgeInsets.all(0.0),
            child: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(
                  Icons.person,
                  size: 30,
                  color: Colors.white,
                )),
          ),
          title: Text(title),
          subtitle: subtitle != null ? Text(subtitle) : null,
          trailing: Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Text(time),
          ),
        ),
      ),
    );
  }

  static Widget messagesCard(bool check, message, time) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (check) const Spacer(),
          if (!check)
            const CircleAvatar(
              child: Icon(
                Icons.person,
                size: 13,
                color: Colors.white,
              ),
              backgroundColor: Colors.grey,
              radius: 10,
            ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 250),
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(10),
              child: Text(
                '$message\n\n$time',
                style: TextStyle(color: check ? Colors.white : Colors.black),
              ),
              decoration: Styles.messagesCardStyle(check),
            ),
          ),
          if (check)
            const CircleAvatar(
              child: Icon(
                Icons.person,
                size: 13,
                color: Colors.white,
              ),
              backgroundColor: Colors.grey,
              radius: 10,
            ),
          if (!check) const Spacer(),
        ],
      ),
    );
  }

  static messageField({required onSubmit}) {
    final con = TextEditingController();

    return Container(
      margin: const EdgeInsets.all(5),
      child: TextField(
        controller: con,
        decoration: Styles.messageTextFieldStyle(onSubmit: () {
          onSubmit(con);
        }),
      ),
      decoration: Styles.messageFieldCardStyle(),
    );
  }

  static drawer(context) {
    TextEditingController name = TextEditingController();
    TextEditingController email = TextEditingController();

    // Retrieve the current user
    final currentUser = FirebaseAuth.instance.currentUser;

    // Set initial values for name and email controllers
    name.text = currentUser?.displayName ?? '';
    email.text = currentUser?.email ?? '';
    void updateUserData(String name, String email) {
      // Retrieve the current user
      final currentUser = FirebaseAuth.instance.currentUser;

      // Update the display name and email
      currentUser?.updateDisplayName(name);
      currentUser?.updateEmail(email);
    }

    return Drawer(
      backgroundColor: Colors.blue.shade400,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 20),
          child: Theme(
            data: ThemeData.dark(),
            child: Column(
              children: [
                const CircleAvatar(
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.white,
                  ),
                  radius: 40,
                  backgroundColor: Colors.grey,
                ),
                const SizedBox(height: 10),
                const Divider(
                  color: Colors.white,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 20),
                      child: Text(
                        'Name',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 5, right: 5, top: 10),
                      child: TextFormField(
                        controller: name,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Color.fromRGBO(0, 112, 173, 1),
                              ),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 20),
                      child: Text(
                        'Email',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 5, right: 5, top: 10, bottom: 20),
                      child: TextFormField(
                        controller: email,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
                ListTile(
                  trailing: SizedBox(
                    width: 100,
                    height: 35,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          side: BorderSide(color: Colors.white, width: 2)),
                      child: Text(
                        'Save',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      onPressed: () {
                        updateUserData(name.text, email.text);
                        Navigator.pop(context);
                        var snackBar = SnackBar(content: Text('Saved'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 200),
                  child: SizedBox(
                    width: 200,
                    height: 50,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        side: BorderSide(color: Colors.white, width: 2),
                      ),
                      onPressed: () async {
                        await GoogleSignIn().signOut();
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Phone()),
                        );

                        var snackBar = SnackBar(content: Text('Logged Out'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      child: Text(
                        'Log Out',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static searchBar(
    bool open,
  ) {
    return AnimatedDialog(
      height: open ? 800 : 0,
      width: open ? 400 : 0,
    );
  }

  static searchField({Function(String)? onChange}) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: TextField(
        onChanged: onChange,
        decoration: Styles.searchTextFieldStyle(),
      ),
      decoration: Styles.messageFieldCardStyle(),
    );
  }
}
