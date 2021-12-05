import 'package:flutter/material.dart';
import 'package:frontend/ui/shared/ui_helpers.dart';
import 'package:frontend/ui/widgets/busy_indicator.dart';
import 'package:frontend/viewmodels/forecast_view_model.dart';
import 'package:stacked/stacked.dart';

class ForecastView extends StatelessWidget {
  const ForecastView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForecastViewModel>.reactive(
      viewModelBuilder: () => ForecastViewModel(),
      onModelReady: (viewmodel) => {viewmodel.getForecast()},
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text("Forecast View"),
        ),
        body: model.busy
            ? const BusyIndicator()
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                        "location: (${model.position?.latitude} ${model.position?.longitude})"),
                    Text(
                        "in what region are you: ${model.todaysForecast?.region}"),
                    Text("today is: ${model.todaysForecast?.date}"),
                    Text(
                        "allergens in air today: ${model.todaysForecast?.allergenTypeStrength}"),
                    const Text("next 7 days - row ..."),
                    const Text("next month - list ..."),
                    smallSpacedDivider,
                    TextButton(
                        onPressed: () => {model.getForecast()},
                        child: const Text(
                            "refresh forecast for current location")),
                    TextButton(
                        onPressed: () => {model.getLocation()},
                        child: const Text("refresh current location")),
                    TextButton(
                        onPressed: () => {},
                        child: const Text("change location (not ready)"))
                  ],
                )),
      ),
    );
  }
}
