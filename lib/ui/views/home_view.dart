import 'package:flutter/material.dart';
import 'package:frontend/ui/shared/app_colors.dart';
import 'package:frontend/ui/shared/shared_styles.dart';
import 'package:frontend/ui/shared/ui_helpers.dart';
import 'package:frontend/ui/widgets/busy_indicator.dart';
import 'package:frontend/viewmodels/home_view_model.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (model) {
        model.fetchSomeList();
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text("HomeView"),
          actions: [
            IconButton(
              icon: const Icon(Icons.wb_sunny),
              onPressed: model.navigateToForecast,
            ),
            IconButton(
              icon: const Icon(Icons.account_box),
              onPressed: model.navigateToUserInfoForm,
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: model.fetchMoreSomeList,
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: model.navigateToScanner,
          child: const Icon(Icons.qr_code_scanner),
          backgroundColor: primaryColor,
        ),
        body: model.busy
            ? const BusyIndicator()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'HomeView',
                        style: titleStyleHugeB,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return buildList(context, index, model);
                          },
                          itemCount: model.someList.length,
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget buildList(BuildContext context, int index, HomeViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('Data: ${model.someList[index]}'),
        horizontalSpaceSmall,
        ElevatedButton(
          onPressed: model.navigateToExample,
          child: const Text('Navigate'),
        ),
      ],
    );
  }
}
