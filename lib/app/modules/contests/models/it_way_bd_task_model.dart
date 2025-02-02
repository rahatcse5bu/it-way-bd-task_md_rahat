import 'dart:developer';

class ITWayBDTask {
  final String id;
  final String? title;
  final String? description;
  final String? status;
  final DateTime? dueDate;
 

  ITWayBDTask({
    required this.id,
    this.title,
    this.description,
    this.status,
    this.dueDate,
   
  });

  factory ITWayBDTask.fromJson(Map<String, dynamic> json) {
    return ITWayBDTask(
      id: json['_id'] ?? '',
      title: json['title'],
      description: json['description'],
      status: json['status'],
      // dueDate: json['dueDate'],
            dueDate: json['dueDate'] != null ? parseDate(json['dueDate']) : null, // ✅ Convert String to DateTime

    
    );
  }

 /// **Convert Model to JSON (`toJson`)**
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "title": title,
      "description": description,
      "status": status,
      "dueDate": dueDate?.toIso8601String(), // ✅ Convert DateTime to String before sending API request
    };
  }

  /// **Safe Date Parsing from String to `DateTime?`**
  static DateTime? parseDate(dynamic dateStr) {
    if (dateStr == null || dateStr == "") return null; // ✅ Handle null or empty dates safely
    try {
      return DateTime.parse(dateStr); // ✅ Convert ISO 8601 String to DateTime
    } catch (e) {
      log('Invalid date format: $dateStr');
      return null; // ✅ Return null instead of crashing
    }
  }
}
