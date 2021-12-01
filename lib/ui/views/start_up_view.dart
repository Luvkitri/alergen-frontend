import 'package:flutter/material.dart';
import 'package:frontend/ui/shared/ui_helpers.dart';
import 'package:frontend/ui/widgets/busy_indicator.dart';
import 'package:frontend/viewmodels/start_up_view_model.dart';
import 'package:stacked/stacked.dart';

class StartUpView extends StatelessWidget {
  const StartUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartUpViewModel>.reactive(
      viewModelBuilder: () => StartUpViewModel(),
      onModelReady: (model) {
        model.handleStartUpLogic();
      },
      builder: (context, model, child) => Scaffold(
        body: model.busy
            ? const BusyIndicator()
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    verticalSpaceSmall,
                    const Text('Allergen', style: TextStyle(fontSize: 50)),
                    ElevatedButton(
                      onPressed: model.newUser,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child:
                            Text("Let's go!", style: TextStyle(fontSize: 30)),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
