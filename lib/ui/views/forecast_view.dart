import 'package:flutter/material.dart';
import 'package:frontend/viewmodels/forecast_view_model.dart';
import 'package:stacked/stacked.dart';

class ForecastView extends StatelessWidget {
  const ForecastView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForecastViewModel>.reactive(
      viewModelBuilder: () => ForecastViewModel(),
      onModelReady: (viewmodel) => {viewmodel.getLocation()},
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text("Forecast View"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                    "(${model.position?.latitude} ${model.position?.longitude})"),
                Text("jaki region"),
                Text("poziom pylenia dzisiaj"),
                Text("next 7 dni - wiersz"),
                Text("next miesiac - lista"),
                TextButton(
                    onPressed: () => {model.getLocation()},
                    child: Text("get current location"))
              ],
            )),
      ),
    );
  }
}
