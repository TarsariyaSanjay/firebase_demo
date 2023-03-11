import 'package:firebase_demo/model/Databasemodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper/collectionHelper.dart';
import '../utils/global.dart';

class EditPage extends StatefulWidget {
  const EditPage({Key? key}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {

  CollectionHelper dbhHelper = CollectionHelper.instance;

  @override
  Widget build(BuildContext context) {
    int index = ModalRoute.of(context)!.settings.arguments as int;
    name.text = data[index]['name'];
    age.text = data[index]['age'];
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Page"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            TextFormField(
              controller: name,
              validator: (val){
                if(val!.isEmpty){
                  return "Please Enter The Email";
                }
                return null;
              },
              decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      fontSize: 18
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)
                  ),
                  focusedBorder: OutlineInputBorder()
              ),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                fontSize: 20,
              ),
            ),

            SizedBox(height: 30,),

            // ====== pass =============

            TextFormField(
              controller: age,
              validator: (val){
                if(val!.isEmpty){
                  return "Please Enter The Password";
                }
                return null;
              },
              decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      fontSize: 18
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)
                  ),
                  focusedBorder: OutlineInputBorder()
              ),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                fontSize: 20,
              ),
            ),

            SizedBox(height: 70,),

            CupertinoButton(
              color: Colors.black,
              child: Text("Update Data",
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              onPressed: ()  => setState(() {
                var userData = UsersData(name: name.text, age: age.text);
                dbhHelper.dataUpdate(id: index,usersData: userData);
                Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
                //dbhHelper.insertData();
              }),
            ),
          ],
        ),
      ),
    );
  }
}
