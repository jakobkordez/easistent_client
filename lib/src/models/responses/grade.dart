enum GradeRank { average, good, poor }

enum GradeType { description, grade }

abstract class BaseGrade {
  final String gradeRank;
  final String gradeType;

  final int id;
  final bool isExcused;
  final String name;
  final String shortName;

  BaseGrade(
    this.gradeRank,
    this.gradeType,
    this.id,
    this.isExcused,
    this.name,
    this.shortName,
  );
}

class FinalGrade {
  final String value;

  FinalGrade(this.value);

  FinalGrade.fromJson(Map<String, dynamic> json) : value = json['value'];
}

class SemesterGrade {
  final String gradeRank;
  final int id;
  final List<int> overridesIds;
  final String typeName;
  final String value;

  SemesterGrade(
    this.gradeRank,
    this.id,
    this.overridesIds,
    this.typeName,
    this.value,
  );

  SemesterGrade.fromJson(Map<String, dynamic> json)
      : gradeRank = json['grade_rank'],
        id = json['id'],
        overridesIds = json['overrides_ids'],
        typeName = json['type_name'],
        value = json['value'];
}

abstract class BaseSemester {
  int id;
  FinalGrade get finalGrade;

  BaseSemester(this.id);
}

class Semester extends BaseSemester {
  @override
  final FinalGrade finalGrade;
  final List<SemesterGrade> grades;

  Semester(int id, this.finalGrade, this.grades) : super(id);

  Semester.fromJson(Map<String, dynamic> json)
      : finalGrade = FinalGrade.fromJson(json['final_grade']),
        grades = (json['grades'] as List)
            .map((e) => SemesterGrade.fromJson(e))
            .toList(),
        super(json['id']);
}

class Grade extends BaseGrade {
  final String averageGrade;
  final FinalGrade finalGrade;
  final List<Semester> semesters;

  Grade(
    String gradeRank,
    String gradeType,
    int id,
    bool isExcused,
    String name,
    String shortName,
    this.averageGrade,
    this.finalGrade,
    this.semesters,
  ) : super(gradeRank, gradeType, id, isExcused, name, shortName);

  Grade.fromJson(Map<String, dynamic> json)
      : averageGrade = json['average_grade'],
        finalGrade = FinalGrade.fromJson(json['final_grade']),
        semesters = (json['semesters'] as List)
            .map((e) => Semester.fromJson(e))
            .toList(),
        super(
          json['grade_rank'],
          json['grade_type'],
          json['id'],
          json['isExcused'],
          json['name'],
          json['short_name'],
        );
}

class Grades {
  final List<Grade> items;

  Grades(this.items);
}
