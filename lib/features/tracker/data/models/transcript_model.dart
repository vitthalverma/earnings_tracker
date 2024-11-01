import 'package:earnings_tracker/features/tracker/domain/entities/transcript_entity.dart';

class TranscriptModel extends TranscriptEntity {
  const TranscriptModel({
    required super.transcript,
  });

  factory TranscriptModel.fromJson(Map<String, dynamic> json) {
    return TranscriptModel(
      transcript: json['transcript'],
    );
  }
}
