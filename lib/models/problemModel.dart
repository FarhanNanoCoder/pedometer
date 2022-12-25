import 'package:cloud_firestore/cloud_firestore.dart';

class ProblemModel {
  String? id, problem, created_at, created_by;
  int application_code;
  ProblemModel({
    this.id,
    this.problem,
    this.created_at,
    this.created_by,
    this.application_code = 0,
  });
  factory ProblemModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    dynamic map = doc.data();
    return ProblemModel(
      id: map['id'] ?? "",
      created_at: map['created_at'] ?? "",
      created_by: map['created_by'] ?? "",
      problem: map['problem'] ?? "",
      application_code: map['application_code'] ?? 0,
    );
  }

  Map<String,dynamic> toMap(){
    var map = <String,dynamic>{};
    map['id']=id;
    map['created_at'] = DateTime.now().toString();
    map['created_by'] =  created_by;
    map['problem'] = problem;
    map['application_code'] = application_code;
    return map;
  }
}
