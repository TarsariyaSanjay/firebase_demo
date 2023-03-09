import 'package:firebase_demo/model/Databasemodel.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CollectionHelper{

  static CollectionHelper instance = CollectionHelper();
  CollectionReference data = FirebaseFirestore.instance.collection('data');
  // static data add in collection firebase // ====== Not Using Model Class


  // insertData() async {
  //   CollectionReference data = await FirebaseFirestore.instance.collection('data');
  //   return data.add(
  //       {
  //         'name' : 'Sahil',
  //         'age' : '20'
  //       }
  //   ).then((value) => print('User Added'))
  //       .catchError((error) => print("failed USer : $error"));
  // }


  // ============== using model class ==================

    dataInsert(UsersData users){

      return data.add(users.toMap())
          .then((value) => print("data Add"))
          .catchError((error) => print("error : ${error}"));
    }

  // ================= update

  dataUpdate(){
     return data
         .doc('Jxz3yp2yDvbXpgokqPiZ')
         .update(
          UsersData(name: 'akash', age: '25').toMap())
         .then((value) => print("data Update"))
         .catchError((error) => print("error : ${error}"));
  }

  dataDelete(){
    return data
        .doc('pq24SiO7Q6kd0Dw3SEZT')
        .delete()
        .then((value) => print("data Update"))
        .catchError((error) => print("error : ${error}"));
  }



}