import 'dart:convert';
import 'dart:io';

import 'package:earnings_tracker/core/constants/api_constants.dart';
import 'package:earnings_tracker/core/constants/error/api_exception.dart';
import 'package:earnings_tracker/features/tracker/data/models/earning_data_model.dart';
import 'package:earnings_tracker/features/tracker/data/models/transcript_model.dart';
import 'package:http/http.dart' as http;

abstract interface class EarningDataSource {
  Future<List<EarningsDataModel>> getEarningsData({required String ticker});
  Future<TranscriptModel> getTranscript({required String ticker, required int year, required int quarter});
}

class EarningDataSourceImpl implements EarningDataSource {
  final http.Client client;

  EarningDataSourceImpl(this.client);
  @override
  Future<List<EarningsDataModel>> getEarningsData({required String ticker}) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/earningscalendar?ticker=$ticker'),
        headers: {'X-Api-Key': ApiConstants.apiKey},
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final earnings = jsonList.map((json) => EarningsDataModel.fromJson(json)).toList();
        return earnings;
      } else {
        throw ApiException(message: 'Failed to fetch earnings data');
      }
    } on HttpException catch (e) {
      throw ApiException(message: e.message);
    }
  }

  @override
  Future<TranscriptModel> getTranscript({required String ticker, required int year, required int quarter}) async {
    try {
      print('Requesting transcript with: ticker=$ticker, year=$year, quarter=$quarter');
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/earningstranscript?ticker=$ticker&year=$year&quarter=$quarter'),
        headers: {'X-Api-Key': ApiConstants.apiKey},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final transcript = TranscriptModel.fromJson(json);
        return transcript;
      } else {
        print(response.body);
        throw ApiException(message: 'Failed to fetch transcript');
      }
    } catch (e) {
      print(e.toString());
      throw ApiException(message: e.toString());
    }
  }
}
