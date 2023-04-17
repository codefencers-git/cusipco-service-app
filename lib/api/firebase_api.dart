import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cusipco_doctor_app/models/chat_user.dart';

class FirebaseApi {
  static Stream<List<Users>> getUsers() => FirebaseFirestore.instance
      .collection('12312312')
      // .orderBy(TodoField.createdTime, descending: true)
      .snapshots()
      .transform(transformer(Users.fromJson));
}

StreamTransformer<QuerySnapshot<Map<String, dynamic>>, List<T>> transformer<T>(
        T Function(Map<String, dynamic> json) fromJson) =>
    StreamTransformer<QuerySnapshot<Map<String, dynamic>>,
        List<T>>.fromHandlers(
      handleData:
          (QuerySnapshot<Map<String, dynamic>> data, EventSink<List<T>> sink) {
        final snaps = data.docs.map((doc) => doc.data()).toList();
        final users = snaps.map((json) => fromJson(json)).toList();

        sink.add(users);
      },
    );
