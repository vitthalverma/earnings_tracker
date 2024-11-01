import 'package:earnings_tracker/features/tracker/domain/entities/earning_data_entity.dart';
import 'package:earnings_tracker/features/tracker/presentation/bloc/earnings_bloc.dart';
import 'package:earnings_tracker/features/tracker/presentation/screens/transcript_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  final TextEditingController _tickerController = TextEditingController();

  int extractQuarter(DateTime pricedate) {
    return ((pricedate.month - 1) / 3).floor() + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Earnings Tracker')),
      body: Column(
        children: [
          SizedBox(height: 10.h),
          SizedBox(
            height: 60.h,
            child: BlocBuilder<EarningsBloc, EarningsState>(
              builder: (context, state) {
                if (state is EarningsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is EarningsLoaded) {
                  // return ListView.builder(
                  //   itemCount: state.earnings.length,
                  //   itemBuilder: (context, index) {
                  //     final earning = state.earnings[index];
                  //     return ListTile(
                  //       title: Text(earning.date),
                  //       subtitle: Text('Estimated EPS: ${earning.estimatedEPS}, Reported EPS: ${earning.actualEPS}'),
                  //     );
                  //   },
                  // );

                  return _buildEarningsGraph(context, state.earnings);
                } else if (state is EarningsError) {
                  return Center(child: Text(state.error));
                }
                return const Center(child: Text('Enter a company symbol'));
              },
            ),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _tickerController,
              decoration: const InputDecoration(
                labelText: 'Enter Company Symbol (e.g., MSFT)',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (symbol) {
                context.read<EarningsBloc>().add(GetEarningsDataEvent(_tickerController.text.trim().toUpperCase()));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsGraph(BuildContext context, List<EarningsDataEntity> earnings) {
    for (int i = 0; i < earnings.length; i++) {
      print('estimatedRevenue: ${earnings[i].estimatedRevenue}, actualRevenue: ${earnings[i].actualRevenue}');
      print('pricedate: ${earnings[i].pricedate}');
    }
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: LineChart(
        LineChartData(
          backgroundColor: Colors.grey.shade200,
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              spots: List.generate(
                earnings.length,
                (index) => FlSpot(
                  index.toDouble(),
                  earnings[index].actualRevenue / 1e9,
                ),
              ),
              color: Colors.blue,
              barWidth: 2,
            ),
            LineChartBarData(
              isCurved: true,
              spots: List.generate(
                earnings.length,
                (index) => FlSpot(
                  index.toDouble(),
                  earnings[index].estimatedRevenue / 1e9,
                ),
              ),
              color: Colors.red,
              barWidth: 2,
            ),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index >= 0 && index < earnings.length) {
                    final date = earnings[index].pricedate;
                    return Text(
                      '${date.month}-${date.year.toString().substring(2)}',
                      style: TextStyle(color: Colors.black, fontSize: 14.sp),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
            leftTitles: AxisTitles(
              axisNameSize: 20,
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  return Text('${value.toInt()}B', style: TextStyle(color: Colors.black, fontSize: 14.sp));
                },
              ),
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
              tooltipRoundedRadius: 8,
              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                return touchedBarSpots.map((barSpot) {
                  final index = barSpot.spotIndex;
                  final earning = earnings[index];
                  final isActual = barSpot.barIndex == 0;

                  return LineTooltipItem(
                    '${isActual ? "Actual" : "Estimated"}\n'
                    'Revenue: \$${(barSpot.y).toStringAsFixed(2)}B\n'
                    'Date: ${earning.pricedate.toString().substring(0, 10)}\n'
                    'Tap for transcript',
                    TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  );
                }).toList();
              },
            ),
            touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
              if (event is FlTapUpEvent && touchResponse?.lineBarSpots != null) {
                final spotIndex = touchResponse!.lineBarSpots!.first.spotIndex;
                final earning = earnings[spotIndex];

                context.read<EarningsBloc>().add(
                      GetTranscriptEvent(
                        _tickerController.text.trim().toUpperCase(),
                        earning.pricedate.year,
                        extractQuarter(earning.pricedate),
                      ),
                    );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TranscriptScreen(),
                  ),
                );
              }
            },
            getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
              return spotIndexes.map((spotIndex) {
                return TouchedSpotIndicatorData(
                  FlLine(
                    color: Colors.grey,
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  ),
                  FlDotData(
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 6, // Slightly larger for touched spot
                        color: barData.color ?? Colors.blue,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
