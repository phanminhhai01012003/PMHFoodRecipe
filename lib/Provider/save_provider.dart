import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class SaveProvider extends ChangeNotifier{
  List<String> _saveList = [];
  List<String> get saveProducts => _saveList;
  SaveProvider(){
    loadSaves();
  }
  void toggleSave(DocumentSnapshot data) async{
    String foodID = data.id;
    if (_saveList.contains(foodID)){
      _saveList.remove(foodID);
      await _removeSave(foodID);
    }else{
      _saveList.add(foodID);
      await _addSave(foodID);
    }
    notifyListeners();
  }
  bool isExist(DocumentSnapshot data){
    return _saveList.contains(data.id);
  }
  Future<void> _addSave(String id) async{
    try{
      await FirebaseFirestore.instance.collection("saved").doc(id).set({
        "id": FirebaseAuth.instance.currentUser!.uid,
        "isSaved": true
      });
    }catch(e){
      Fluttertoast.showToast(
        msg: "Có lỗi xảy ra: ${e.toString()}",
        backgroundColor: Colors.red.shade500,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
        fontSize: 14,
      );
    }
  }
  Future<void> _removeSave(String id) async{
    try{
      await FirebaseFirestore.instance.collection("saved").doc(id).delete();
    }catch(e){
      Fluttertoast.showToast(
        msg: "Có lỗi xảy ra: ${e.toString()}",
        backgroundColor: Colors.red.shade500,
        textColor: Colors.white,
        fontSize: 14,
        toastLength: Toast.LENGTH_LONG
      );
    }
  }
  Future<void> loadSaves() async{
    try{
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("saved")
          .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      _saveList = snapshot.docs.map((doc) => doc.id).toList();
    }catch(e){
      Fluttertoast.showToast(
        msg: "Có lỗi xảy ra: ${e.toString()}",
        backgroundColor: Colors.red.shade500,
        textColor: Colors.white,
        fontSize: 14,
        toastLength: Toast.LENGTH_LONG
      );
    }
    notifyListeners();
  }
  static SaveProvider of(BuildContext context, {bool listen = true}){
    return Provider.of<SaveProvider>(context, listen: listen);
  }
}