import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Constants/constants.dart';
import 'kText.dart';

class GraphTem extends StatefulWidget {
  const GraphTem({Key? key}) : super(key: key);

  @override
  State<GraphTem> createState() => _GraphTemState();
}
class _GraphTemState extends State<GraphTem> {
  List<Color> gradientColors = [
    Constants().primaryAppColor,
    Constants().primaryAppColor,
  ];
  List<Color> gradientColors2 = [
    Constants().primaryAppColor.withOpacity(0.25),
    Constants().primaryAppColor.withOpacity(0),

  ];
  bool showAvg = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:

      Container(
        width: 400,
        height: 200,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                right: 30,
                left: 12,
                top: 24,
                bottom: 12,
              ),
              child: LineChart(
                mainData(),

              ),
            ),

          ],
        ),
      ),
    );
  }



  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text =  KText(text:'2013', style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xff718EBF)
        ), );
        break;
    /* case 2:
        text =  KText(text:'2014', style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xff718EBF)
        ), );
        break;*/
      case 4:
        text =  KText(text:'2015', style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xff718EBF)
        ), );
        break;
    /*  case 6:
        text =  KText(text:'2016', style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xff718EBF)
        ), );
        break;*/
      case 8:
        text =  KText(text:'2017', style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xff718EBF)
        ), );
        break;
    /* case 10:
        text =  KText(text:'2018', style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xff718EBF)
        ), );
        break;*/
      case 12:
        text =  KText(text:'2019', style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xff718EBF)
        ), );
        break;
    /*  case 14:
        text =  KText(text:'2020', style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xff718EBF)
        ), );
        break;*/
      case 16:
        text =  KText(text:'2021', style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xff718EBF)
        ), );
        break;
    /* case 18:
        text =  KText(text:'2022', style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xff718EBF)
        ), );
        break;*/
      case 20:
        text =  KText(text:'2023', style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xff718EBF)
        ), );
        break;
    /*  case 22:
        text =  KText(text:'2024', style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xff718EBF)
        ), );
        break;*/
      default:
        text =  KText(text:'', style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xff718EBF)
        ), );
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {

    String text;
    switch (value.toInt()) {
      case 1:
        text = '0';
        break;
      case 3:
        text = '100';
        break;
      case 5:
        text = '200';
        break;
      case 7:
        text = '800';
      case 9:
        text = '1000';
        break;
      default:
        return Container();
    }

    return KText(text:text, style: GoogleFonts.inter(
        fontWeight: FontWeight.w400,
        fontSize: 12,
        color: Color(0xff718EBF)
    ), );
  }

  LineChartData mainData() {
    return LineChartData(

      gridData: FlGridData(
        show: true,


        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,

        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },

      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 22,
      minY: 0,
      maxY: 9,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
            FlSpot(14, 6),
            FlSpot(16, 3),
            FlSpot(18, 2),
            FlSpot(20, 5),
            FlSpot(22, 4.1),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 3,
          //isStrokeCapRound: true,


          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: gradientColors2,
            ),
          ),

        ),
      ],

    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 9,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
class AppColors {
  static const Color primary = contentColorCyan;
  static const Color menuBackground = Color(0xFF090912);
  static const Color itemsBackground = Color(0xFF1B2339);
  static const Color pageBackground = Color(0xFF282E45);
  static const Color mainTextColor1 = Colors.white;
  static const Color mainTextColor2 = Colors.white70;
  static const Color mainTextColor3 = Colors.white38;
  static const Color mainGridLineColor = Colors.white10;
  static const Color borderColor = Colors.white54;
  static const Color gridLinesColor = Color(0x11FFFFFF);

  static const Color contentColorBlack = Colors.black;
  static const Color contentColorWhite = Colors.white;
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorYellow = Color(0xFFFFC300);
  static const Color contentColorOrange = Color(0xFFFF683B);
  static const Color contentColorGreen = Color(0xFF3BFF49);
  static const Color contentColorPurple = Color(0xFF6E1BFF);
  static const Color contentColorPink = Color(0xFFFF3AF2);
  static const Color contentColorRed = Color(0xFFE80054);
  static const Color contentColorCyan = Color(0xFF50E4FF);
}