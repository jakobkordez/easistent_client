class SelectiveCourseResponse {
  final int id;
  final String name;
  final int weekHours;

  SelectiveCourseResponse.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        weekHours = json['week_hours'];
}

class SelectiveCoursesResponse {
  final bool electionEnabled;
  final String introAdditionalDescription;
  final String introDescription;
  final String introMessage;
  final List<SelectiveCourseResponse> items;

  SelectiveCoursesResponse.fromJson(Map<String, dynamic> json)
      : electionEnabled = json['election_enabled'],
        introAdditionalDescription = json['intro_additional_description'],
        introDescription = json['intro_description'],
        introMessage = json['intro_message'],
        items = (json['items'] as List)
            .map((e) => SelectiveCourseResponse.fromJson(e))
            .toList();
}
