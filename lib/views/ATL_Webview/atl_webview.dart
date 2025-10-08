import 'package:atl_webview/views/ATL_Webview/atl_webview_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

class AtlWebview extends StatelessWidget {
  const AtlWebview({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure ScreenUtil is initialized for your app, typically in main.dart
    ScreenUtil.init(context);

    final isDesktop = MediaQuery.of(context).size.width >= 1280;
    // Adjust breakpoint as needed

    final isTablet = MediaQuery.of(context).size.width >= 600 &&
        MediaQuery.of(context).size.width < 1280;

    return ViewModelBuilder.reactive(
      viewModelBuilder: () => ATLWebViewVM(),
      onViewModelReady: (viewModel) => viewModel.init(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 58, 57, 57),
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: Colors.transparent,
            elevation: 0, // Remove shadow for cleaner look
            title: Text(
              "Standings",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: isTablet
                    ? 16.sp
                    : isDesktop
                        ? 4.sp
                        : 20.sp, // Adjusted font size
              ),
            ),
          ),
          body: model.isBusy
              ? const Center(
                  // Center the loading indicator
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : model.hasError
                  ? Center(
                      // Display error message prominently
                      child: Padding(
                        padding: EdgeInsets.all(20.w), // Use w for padding
                        child: Text(
                          model.errorMessage,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.redAccent,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            width: isTablet
                                ? 150.w
                                : isDesktop
                                    ? 200.w
                                    : 100.w, // Responsive width
                            height: isTablet
                                ? 150.w
                                : isDesktop
                                    ? 200.h
                                    : 100.h, // Responsive heights
                            child: Image.asset("assets/AKL-LOGO.png"),
                          ),
                          10.verticalSpace,
                          // Standings Table Section (Scrollable horizontally)
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 8.h),
                            child: Container(
                              constraints: BoxConstraints(
                                minWidth:
                                    MediaQuery.of(context).size.width - (32.w),
                              ),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 75, 75, 75),
                                borderRadius: BorderRadius.circular(12.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: DataTable(
                                columnSpacing: 15.w,
                                dataRowMinHeight: 40.h,
                                dataRowMaxHeight: 60.h,
                                headingRowColor: WidgetStateProperty.all<Color>(
                                    const Color.fromARGB(255, 90, 90, 90)),
                                headingRowHeight: 50.h,
                                border: TableBorder.all(
                                  color: Colors.white.withOpacity(0.1),
                                  width: 1.0,
                                ),
                                columns: [
                                  // 🏅 NEW: Rank column
                                  DataColumn(
                                    label: Text(
                                      'Rank',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: isTablet
                                            ? 12.sp
                                            : isDesktop
                                                ? 5.sp
                                                : 13.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Player',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: isTablet
                                            ? 12.sp
                                            : isDesktop
                                                ? 5.sp
                                                : 13.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'P',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: isTablet
                                            ? 12.sp
                                            : isDesktop
                                                ? 5.sp
                                                : 13.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'W',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: isTablet
                                            ? 12.sp
                                            : isDesktop
                                                ? 5.sp
                                                : 13.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'D',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: isTablet
                                            ? 12.sp
                                            : isDesktop
                                                ? 5.sp
                                                : 13.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'L',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: isTablet
                                            ? 12.sp
                                            : isDesktop
                                                ? 5.sp
                                                : 13.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'PF',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: isTablet
                                            ? 12.sp
                                            : isDesktop
                                                ? 5.sp
                                                : 13.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'PA',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: isTablet
                                            ? 12.sp
                                            : isDesktop
                                                ? 5.sp
                                                : 13.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Pts',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: isTablet
                                            ? 12.sp
                                            : isDesktop
                                                ? 5.sp
                                                : 13.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: List<DataRow>.generate(
                                  model.standings.length,
                                  (index) {
                                    final player = model.standings[index];
                                    final rank = index + 1; // 🏆 Dynamic Rank
                                    final isTop3 = rank <= 3;

                                    return DataRow(
                                      color: isTop3
                                          ? WidgetStateProperty.all<Color>(
                                              const Color(0xFFFFD700)
                                                  .withOpacity(
                                                      0.2)) // Gold tint
                                          : null,
                                      cells: [
                                        // 🏅 Rank Cell
                                        DataCell(
                                          Text(
                                            rank.toString(),
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              fontSize: isTablet
                                                  ? 12.sp
                                                  : isDesktop
                                                      ? 5.sp
                                                      : 13.sp,
                                              color: isTop3
                                                  ? Colors.amber
                                                  : Colors.white,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            player['name'],
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w400,
                                              fontSize: isTablet
                                                  ? 12.sp
                                                  : isDesktop
                                                      ? 5.sp
                                                      : 13.sp,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            player['played'].toString(),
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w400,
                                              fontSize: isTablet
                                                  ? 12.sp
                                                  : isDesktop
                                                      ? 5.sp
                                                      : 13.sp,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            player['win'].toString(),
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w400,
                                              fontSize: isTablet
                                                  ? 12.sp
                                                  : isDesktop
                                                      ? 5.sp
                                                      : 13.sp,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            player['draw'].toString(),
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w400,
                                              fontSize: isTablet
                                                  ? 12.sp
                                                  : isDesktop
                                                      ? 5.sp
                                                      : 13.sp,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            player['loss'].toString(),
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w400,
                                              fontSize: isTablet
                                                  ? 12.sp
                                                  : isDesktop
                                                      ? 5.sp
                                                      : 13.sp,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            player['pf'].toString(),
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w400,
                                              fontSize: isTablet
                                                  ? 12.sp
                                                  : isDesktop
                                                      ? 5.sp
                                                      : 13.sp,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            player['pa'].toString(),
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w400,
                                              fontSize: isTablet
                                                  ? 12.sp
                                                  : isDesktop
                                                      ? 5.sp
                                                      : 13.sp,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            player['points'].toString(),
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w400,
                                              fontSize: isTablet
                                                  ? 12.sp
                                                  : isDesktop
                                                      ? 5.sp
                                                      : 13.sp,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          20.verticalSpace,
                          // Matchday Section
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: model.matchdays.length,
                            itemBuilder: (context, index) {
                              final matchdayData = model.matchdays[index];
                              final matchdayNumber = matchdayData['matchday'];
                              final matches =
                                  matchdayData['matches'] as List<dynamic>;

                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.h, horizontal: 16.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Matchday $matchdayNumber',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: isTablet
                                            ? 18.sp
                                            : isDesktop
                                                ? 5.sp
                                                : 14.sp, // Adjusted font size
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    5.verticalSpace,
                                    // Display individual matches for this matchday
                                    Column(
                                      children: matches.map((match) {
                                        return Container(
                                          margin: EdgeInsets.symmetric(
                                            vertical: 4.h,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 4.h),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    // Using Expanded for player names
                                                    child: Text(
                                                      match['player1'],
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: Colors.white,
                                                        fontSize: isTablet
                                                            ? 16.sp
                                                            : isDesktop
                                                                ? 5.sp
                                                                : 14.sp, // Adjusted font size
                                                      ),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${match['score1']} - ${match['score2']}',
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontSize: isTablet
                                                          ? 12.sp
                                                          : isDesktop
                                                              ? 5.sp
                                                              : 14.sp, // Adjusted font size
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    // Using Expanded for player names
                                                    child: Text(
                                                      match['player2'],
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: Colors.white,
                                                        fontSize: isTablet
                                                            ? 16.sp
                                                            : isDesktop
                                                                ? 5.sp
                                                                : 14.sp, // Adjusted font size
                                                      ),
                                                      textAlign: TextAlign.end,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              5.verticalSpace,
                                              // Display date and time

                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Date:",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.deepOrange,
                                                      fontSize: isTablet
                                                          ? 10.sp
                                                          : isDesktop
                                                              ? 4.sp
                                                              : 12.sp, // Adjusted font size
                                                    ),
                                                  ),
                                                  5.horizontalSpace,
                                                  Text(
                                                    match['date'],
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontSize: isTablet
                                                          ? 10.sp
                                                          : isDesktop
                                                              ? 4.sp
                                                              : 12.sp, // Adjusted font size
                                                    ),
                                                  ),
                                                  10.horizontalSpace,
                                                  Text(
                                                    "Time:",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.deepOrange,
                                                      fontSize: isTablet
                                                          ? 10.sp
                                                          : isDesktop
                                                              ? 4.sp
                                                              : 12.sp, // Adjusted font size
                                                    ),
                                                  ),
                                                  5.horizontalSpace,
                                                  Text(
                                                    match['time'],
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontSize: isTablet
                                                          ? 10.sp
                                                          : isDesktop
                                                              ? 4.sp
                                                              : 12.sp, // Adjusted font size
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                    10.verticalSpace,
                                    const Divider(
                                      color: Colors.white54,
                                      height: 1,
                                    ),
                                    10.verticalSpace,
                                  ],
                                ),
                              );
                            },
                          ),
                          10.verticalSpace,
                        ],
                      ),
                    ),
        );
      },
    );
  }
}
