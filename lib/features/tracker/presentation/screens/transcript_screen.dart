import 'package:earnings_tracker/features/tracker/presentation/bloc/earnings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TranscriptScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Earnings Transcript')),
      body: BlocBuilder<EarningsBloc, EarningsState>(
        builder: (context, state) {
          if (state is TranscriptLoaded) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Text(state.transcript.transcript),
            );
          } else if (state is TranscriptLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TranscriptError) {
            return Center(child: Text(state.error));
          }
          return Center(child: Text('No transcript available'));
        },
      ),
    );
  }
}
