class Todo {
  int? id;
  String? subject_name;
  int? classes;
  int? reports;
  int? timelimit;

  Todo({
    this.id,
    this.subject_name,
    this.classes,
    this.reports,
    this.timelimit
  });


  // SQLiteから取得したデータをオブジェクトに変換
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      subject_name: map['name'],
      classes: map['total_classes'],
      reports: map['report_count'],
      timelimit: map['absent_limit']

    );
  }
}
