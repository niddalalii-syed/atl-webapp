// ignore_for_file: deprecated_member_use

import 'package:atl_webview/views/delete_user/delete_user_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

class DeleteUserView extends StatelessWidget {
  const DeleteUserView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 1280;
    final isTablet = MediaQuery.of(context).size.width >= 600 &&
        MediaQuery.of(context).size.width < 1280;

    return ViewModelBuilder.reactive(
      viewModelBuilder: () => DeleteUserVM(),
      onViewModelReady: (model) => model.init(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 58, 57, 57),
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Delete Account',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: isTablet
                    ? 12.sp
                    : isDesktop
                        ? 4.sp
                        : 15.sp, //
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: Center(
            child: Container(
              constraints: BoxConstraints(
                  maxWidth: 600.w), // Limit max width on web/desktop
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    // Background Image
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.1,
                        child: Image.asset(
                          'assets/AKL-BALL.png',
                          fit: BoxFit.contain,
                          // color: Colors.black.withOpacity(0.5),
                          // colorBlendMode: BlendMode.darken,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Fill out the details below to delete your account.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: isDesktop ? 5.sp : 16.sp,
                            color: Colors.white,
                          ),
                        ),
                        20.verticalSpace,
                        // Name TextField
                        TextField(
                          controller: model.nameController,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: isTablet
                                ? 10.sp
                                : isDesktop
                                    ? 4.sp
                                    : 12.sp,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Name',
                            labelStyle: GoogleFonts.poppins(
                              color: Colors.orange,
                              fontSize: isTablet
                                  ? 12.sp
                                  : isDesktop
                                      ? 5.sp
                                      : 13.sp,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r)),
                          ),
                        ),
                        15.verticalSpace,
                        // Email TextField
                        TextField(
                          controller: model.emailController,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: isTablet
                                ? 10.sp
                                : isDesktop
                                    ? 4.sp
                                    : 12.sp,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: GoogleFonts.poppins(
                              color: Colors.orange,
                              fontSize: isTablet
                                  ? 12.sp
                                  : isDesktop
                                      ? 5.sp
                                      : 13.sp,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        15.verticalSpace,
                        // UID (Read-only)
                        TextField(
                          controller: model.uidController,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: isTablet
                                ? 10.sp
                                : isDesktop
                                    ? 4.sp
                                    : 12.sp,
                          ),
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'UID',
                            labelStyle: GoogleFonts.poppins(
                              color: Colors.orange,
                              fontSize: isTablet
                                  ? 12.sp
                                  : isDesktop
                                      ? 5.sp
                                      : 13.sp,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ),
                        ),
                        15.verticalSpace,
                        // Reason to Delete (Multi-line)
                        TextField(
                          controller: model.reasonController,
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: isTablet
                                ? 10.sp
                                : isDesktop
                                    ? 4.sp
                                    : 12.sp,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Reason for Deletion',
                            labelStyle: GoogleFonts.poppins(
                              color: Colors.orange,
                              fontSize: isTablet
                                  ? 12.sp
                                  : isDesktop
                                      ? 5.sp
                                      : 13.sp,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                        ),
                        25.verticalSpace,
                        // Delete Button
                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width:
                                50.w + (isDesktop ? 0 : 100), // dynamic width
                            height: 70.h, // fixed height for button
                            // fixed width for button
                            child: ElevatedButton(
                              onPressed: model.isBusy
                                  ? null
                                  : () => model.deleteAccount(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              child: Text(
                                model.isBusy ? 'Deleting...' : 'Delete Account',
                                style: GoogleFonts.poppins(
                                    fontSize: isTablet
                                        ? 10.sp
                                        : isDesktop
                                            ? 4.sp
                                            : 10.sp,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
