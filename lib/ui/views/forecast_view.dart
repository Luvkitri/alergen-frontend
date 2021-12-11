import 'package:flutter/material.dart';
import 'package:frontend/models/forecast_model.dart';
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
                        "(location: (${model.position?.latitude} ${model.position?.longitude}))"),
                    Text("(region: ${model.todaysForecast?.region})"),
                    model.todaysForecast != null
                        ? Text(
                            "allergens today: ${model.todaysForecast?.allergenTypeStrength}")
                        : Text("..."),
                    model.weekForecast != null
                        ? Expanded(
                            child: ListView.builder(
                            itemExtent: 90.0,
                            itemBuilder: (context, index) =>
                                buildWeekForecastList(context, index, model),
                            itemCount: model.weekForecast?.length,
                            scrollDirection: Axis.horizontal,
                          ))
                        : Text("..."),
                    model.monthForecast != null
                        ? Expanded(
                            child: ListView.builder(
                            itemExtent: 70.0,
                            itemBuilder: (context, index) =>
                                buildMonthForecastList(context, index, model),
                            itemCount: model.monthForecast?.length,
                            scrollDirection: Axis.vertical,
                          ))
                        : Text("..."),
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

  Widget buildMonthForecastList(
      BuildContext context, int index, ForecastViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
            "${model.monthForecast?[index].date.day}-${model.monthForecast?[index].date.month}"),
        Expanded(
            child: ListView.builder(
          itemBuilder: (context, index) => buildMonthForecastAllergenList(
              context, index, model.monthForecast?[index]),
          itemCount: model.monthForecast?[index].allergenTypeStrength.length,
          scrollDirection: Axis.horizontal,
        )),
      ],
    );
  }

  Widget buildMonthForecastAllergenList(
      BuildContext context, int index, ForecastItem? f) {
    String? key = f?.allergenTypeStrength.keys.toList()[index];
    return Text("$key -> ${f?.allergenTypeStrength[key]}");
  }

  Widget buildWeekForecastList(
      BuildContext context, int index, ForecastViewModel model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
            "${model.weekForecast?[index].date.day}-${model.weekForecast?[index].date.month}"),
        Expanded(
            child: ListView.builder(
          itemBuilder: (context, index) => buildWeekForecastAllergenList(
              context, index, model.weekForecast?[index]),
          itemCount: model.weekForecast?[index].allergenTypeStrength.length,
        )),
      ],
    );
  }

  Widget buildWeekForecastAllergenList(
      BuildContext context, int index, ForecastItem? f) {
    String? key = f?.allergenTypeStrength.keys.toList()[index];
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text("$key - ${f?.allergenTypeStrength[key]}")]);
  }
}
