import 'package:flutter/material.dart';
import 'package:frontend/viewmodels/example_view_model.dart';
import 'package:stacked/stacked.dart';

class ExampleView extends StatelessWidget {
  const ExampleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ExampleViewModel>.reactive(
      viewModelBuilder: () => ExampleViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text("Example View"),
        ),
      body: Container(),
      ),
    );
  }
}
