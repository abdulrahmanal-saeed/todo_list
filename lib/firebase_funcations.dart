import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_list/models/task_model.dart';
import 'package:todo_list/models/user_model.dart';

class FirebaseFuncations {
  static CollectionReference<TaskModel> getTasksCollection(String userId) =>
      getUserCollection()
          .doc(userId)
          .collection('tasks')
          .withConverter<TaskModel>(
            fromFirestore: (docSnapshot, _) =>
                TaskModel.fromJson(docSnapshot.data()!),
            toFirestore: (taskModel, _) => taskModel.toJson(),
          );
  static CollectionReference<UserModel> getUserCollection() =>
      FirebaseFirestore.instance.collection('users').withConverter<UserModel>(
            fromFirestore: (docSnapshot, _) =>
                UserModel.fromJson(docSnapshot.data()!),
            toFirestore: (userModel, _) => userModel.toJosn(),
          );

  static Future<void> addTaskFirestore(TaskModel task, String userId) async {
    CollectionReference<TaskModel> tasksCollection = getTasksCollection(userId);
    DocumentReference<TaskModel> docRef = tasksCollection.doc();
    task.id = docRef.id;
    return docRef.set(task);
  }

  static Future<List<TaskModel>> getAllTasksFromFirestore(String userId) async {
    CollectionReference<TaskModel> tasksCollection = getTasksCollection(userId);
    QuerySnapshot<TaskModel> querySnapshot = await tasksCollection.get();
    return querySnapshot.docs.map((docSnapshot) => docSnapshot.data()).toList();
  }

  static Future<void> deleteTaskFirestore(String taskId, String userId) async {
    CollectionReference<TaskModel> tasksCollection = getTasksCollection(userId);
    return tasksCollection.doc(taskId).delete();
  }

  static Future<void> updateTaskFirestore(TaskModel task, String userId) async {
    CollectionReference<TaskModel> tasksCollection = getTasksCollection(userId);
    return tasksCollection.doc(task.id).set(task);
  }

  static Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final credentials = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    final user = UserModel(id: credentials.user!.uid, email: email, name: name);
    final userCollection = getUserCollection();
    await userCollection.doc(user.id).set(user);
    return user;
  }

  static Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final credentials = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    final userCollection = getUserCollection();
    final docSnapshot = await userCollection.doc(credentials.user!.uid).get();
    return docSnapshot.data()!;
  }

  static Future<void> logout() => FirebaseAuth.instance.signOut();

  static Future<void> updateTaskStatus(
      String taskId, String userId, bool isDone) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(taskId)
        .update({'isDone': isDone});
  }
}
