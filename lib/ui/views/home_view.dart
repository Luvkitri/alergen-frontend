import 'package:flutter/material.dart';
// import 'package:frontend/ui/shared/app_colors.dart';
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
              icon: const Icon(Icons.account_box),
              onPressed: model.navigateToUserInfoForm,
            ),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: model.navigateToScanner,
        //   child: const Icon(Icons.qr_code_scanner),
        //   backgroundColor: primaryColor,
        // ),
        body: model.busy
            ? const BusyIndicator()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    children: [
                      menuButton(model.navigateToAllergies, 'Allergies'),
                      verticalSpaceSmall,
                      menuButton(model.navigateToUserInfoForm, 'User info'),
                      verticalSpaceSmall,
                      menuButton(model.navigateToScanner, 'Bar code scanner'),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget menuButton(Function() onpressed, String title) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 100,
            child: ElevatedButton(
              onPressed: onpressed,
              child: Text(
                title,
                style: largeButtonTitleTextStyle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
