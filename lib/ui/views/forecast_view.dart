import "dart:math";
import 'package:flutter/material.dart';
import 'package:frontend/models/forecast_model.dart';
import 'package:frontend/ui/shared/ui_helpers.dart';
import 'package:frontend/ui/widgets/busy_indicator.dart';
import 'package:frontend/viewmodels/forecast_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';

class ForecastView extends StatelessWidget {
  const ForecastView({Key? key}) : super(key: key);

  List<Widget> getAllergenChipList(ForecastItem fi) {
    return fi!.allergenTypeStrength.entries
        .where((element) => element.value > 0)
        .map((e) => Chip(
              backgroundColor: getAllergenChipColor(e.value),
              label: Text(e.key),
            ))
        .toList();
  }

  Color getAllergenChipColor(int strength) {
    switch (strength) {
      case 0:
        return Colors.yellow;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  Icon getAllergenIcon(int strength, double size) {
    if (strength <= 5) {
      return Icon(Icons.check, size: size, color: Colors.green);
    } else if (strength <= 10) {
      return Icon(Icons.warning, size: size, color: Colors.orange);
    } else {
      return Icon(Icons.error, size: size, color: Colors.red);
    }
  }

  Widget _getWidget(int index, BuildContext context) {
    switch (index) {
      case 0:
        {
          return buildToday(context);
        }
      case 1:
        {
          return buildWeek(context);
        }
      case 2:
        {
          return buildMonth(context);
        }
      case 3:
        {
          return const Text("Here will be map");
        }
      default:
        {
          return const Text("???");
        }
    }
  }

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
            : _getWidget(model.getIndex(), context),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_today),
              label: 'Today',
              backgroundColor: Colors.purple.shade700,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.view_week),
              label: 'Week',
              backgroundColor: Colors.purple.shade600,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_view_month),
              label: 'Month',
              backgroundColor: Colors.purple.shade500,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.map),
              label: 'Map',
              backgroundColor: Colors.purple.shade400,
            ),
          ],
          currentIndex: model.getIndex(),
          selectedItemColor: Colors.amberAccent.shade100,
          onTap: (i) => {model.setIndex(i)},
        ),
      ),
    );
  }

  Widget buildMonth(BuildContext context) {
    return ViewModelBuilder<ForecastViewModel>.reactive(
      viewModelBuilder: () => ForecastViewModel(),
      onModelReady: (viewmodel) => {viewmodel.getForecast()},
      builder: (context, model, child) => Scaffold(
        body: model.busy
            ? const BusyIndicator()
            : Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                        child: ListView.builder(
                      itemBuilder: (context, index) =>
                          _buildMonthForecastList(context, index, model),
                      itemCount: model.monthForecast?.length,
                      scrollDirection: Axis.vertical,
                    )),
                    smallSpacedDivider,
                    TextButton(
                        onPressed: () => {model.getForecast()},
                        child: const Text("refresh forecast")),
                    TextButton(
                        onPressed: () => {model.getForecast(add180days: true)},
                        child: const Text("refresh forecast (+180days)"))
                  ],
                )),
      ),
    );
  }

  Widget buildWeek(BuildContext context) {
    return ViewModelBuilder<ForecastViewModel>.reactive(
      viewModelBuilder: () => ForecastViewModel(),
      onModelReady: (viewmodel) => {viewmodel.getForecast()},
      builder: (context, model, child) => Scaffold(
        body: model.busy
            ? const BusyIndicator()
            : Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                        child: ListView.builder(
                      itemBuilder: (context, index) =>
                          _buildWeekForecastList(context, index, model),
                      itemCount: model.weekForecast?.length,
                      scrollDirection: Axis.horizontal,
                    )),
                    smallSpacedDivider,
                    TextButton(
                        onPressed: () => {model.getForecast()},
                        child: const Text("refresh forecast")),
                    TextButton(
                        onPressed: () => {model.getForecast(add180days: true)},
                        child: const Text("refresh forecast (+180days)"))
                  ],
                )),
      ),
    );
  }

  Widget buildToday(BuildContext context) {
    return ViewModelBuilder<ForecastViewModel>.reactive(
      viewModelBuilder: () => ForecastViewModel(),
      onModelReady: (viewmodel) => {viewmodel.getForecast()},
      builder: (context, model, child) => Scaffold(
        body: model.busy
            ? const BusyIndicator()
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                        "(location: (${model.position?.latitude} ${model.position?.longitude}), region: ${model.todaysForecast?.region})"),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(DateFormat('EEEE').format(model.today)),
                              Text(DateFormat('yyyy MMM dd')
                                  .format(model.today)),
                              Text(
                                  " ${model.todaysForecast!.allergenTypeStrength.entries.where((element) => element.value > 0).length} allergen/s today:"),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:
                                getAllergenChipList(model.todaysForecast!),
                          )
                        ],
                      ),
                    ),
                    smallSpacedDivider,
                    TextButton(
                        onPressed: () => {model.getForecast()},
                        child: const Text("refresh forecast")),
                    TextButton(
                        onPressed: () => {model.getForecast(add180days: true)},
                        child: const Text("refresh forecast (+180days)"))
                  ],
                )),
      ),
    );
  }

  Widget _buildMonthForecastList(
      BuildContext context, int index, ForecastViewModel model) {
    int dangerThatDay = model.monthForecast![index].allergenTypeStrength.values
        .toList()
        .reduce((a, b) => a + b);

    List<String> allergensStrong = model
        .monthForecast![index].allergenTypeStrength.entries
        .where((e) => e.value == 2)
        .map((e) => e.key)
        .toList();
    List<String> allergensMedium = model
        .monthForecast![index].allergenTypeStrength.entries
        .where((e) => e.value == 1)
        .map((e) => e.key)
        .toList();

    return Card(
      child: ListTile(
        leading: getAllergenIcon(dangerThatDay, 56.0),
        title: Text(
            "${DateFormat('MMM dd').format(model.monthForecast![index].date)}, ${allergensStrong}"),
        subtitle: Text("$allergensMedium"),
      ),
    );
  }

  Widget _buildWeekForecastList(
      BuildContext context, int i, ForecastViewModel model) {
    return Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(DateFormat('EEEE').format(model.weekForecast![i].date)),
            Text(DateFormat('yyyy MMM dd').format(model.weekForecast![i].date)),
            Text(
                " ${model.weekForecast![i].allergenTypeStrength.entries.where((element) => element.value > 0).length} allergen/s that day:"),
            ...getAllergenChipList(model.weekForecast![i])
          ],
        ));
  }

  Widget _buildWeekForecastAllergenList(
      BuildContext context, int index, ForecastItem? f) {
    String? key = f?.allergenTypeStrength.keys.toList()[index];
    if (f!.allergenTypeStrength[key]! == 0) {
      return Container();
    } else {
      return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("$key: ${f.allergenTypeStrength[key]}")]);
    }
  }
}
