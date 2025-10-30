import 'package:flutter/material.dart';

class PaginationUtils {

  ScrollController scrollController = ScrollController();

  // PaginationUtils(scrollController) {
  //   this.scrollController = scrollController;
  // }

  // initScrolling(ScrollController scrollController1, BuildContext context, Function setState, int pageNumber,
  //     bool isPaginationLoading, Future<void> initCall) {
  //
  //   printData("PaginationUtils pageNumber ", pageNumber.toString());
  //   printData("PaginationUtils isPaginationLoading ", isPaginationLoading.toString());
  //
  //   scrollController1.addListener(() async {
  //     if (scrollController1.position.maxScrollExtent ==
  //         scrollController1.position.pixels) {
  //
  //       scrollController1.jumpTo(scrollController1.position.maxScrollExtent);
  //       isPaginationLoading = true;
  //
  //       setState();
  //       pageNumber = pageNumber + 1;
  //       await initCall;
  //       isPaginationLoading = true;
  //
  //       setState();
  //
  //       // setState();
  //       printData("PaginationUtils ", "If");
  //       return isPaginationLoading;
  //     }else{
  //       isPaginationLoading = true;
  //       printData("Common PaginationUtils ", "else");
  //     }
  //
  //   });
  // }

  // This is what you're looking for!
  void _scrollDown() {
    // scrollController.jumpTo(scrollController.position.maxScrollExtent);

    // controller.scrollController.animateTo(
    //   controller.scrollController.position.maxScrollExtent,
    //   duration: Duration(seconds: 2),
    //   curve: Curves.fastOutSlowIn,
    // );
  }

  Widget loader() {
    return Center(
        child: Container(
            padding: const EdgeInsets.all(10),
            height: 40,
            width: 40,
            color: Colors.transparent,
            child: const CircularProgressIndicator(
              strokeWidth: 2,
            )));
  }
}