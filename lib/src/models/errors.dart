class EAsError extends Error {
  final int code;
  final String developerMessage;
  final String? userMessage;

  EAsError(this.code, this.developerMessage, [this.userMessage]);

  EAsError.fromJson(Map<String, dynamic> json)
      : code = json['code'],
        developerMessage = json['developer_message'],
        userMessage = json['user_message'];

  @override
  String toString() => 'EAsError("$developerMessage")';
}
