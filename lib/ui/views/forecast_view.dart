import 'package:flutter/material.dart';
import 'package:frontend/models/forecast_model.dart';
import 'package:frontend/ui/shared/ui_helpers.dart';
import 'package:frontend/ui/views/cross_allergies_view.dart';
import 'package:frontend/ui/widgets/busy_indicator.dart';
import 'package:frontend/viewmodels/forecast_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';

class ForecastView extends StatelessWidget {
  const ForecastView({Key? key}) : super(key: key);

  List<Widget> getAllergenChipList(ForecastItem fi, {bool compact = false}) {
    VisualDensity density = compact
        ? const VisualDensity(
            horizontal: VisualDensity.minimumDensity,
            vertical: VisualDensity.minimumDensity)
        : VisualDensity.standard;

    return fi.allergenTypeStrength.entries
        .where((element) => element.value > 0)
        .map((e) => Chip(
              backgroundColor: getAllergenChipColor(e.value),
              label: Text(e.key),
              // padding: EdgeInsets.all(padding),
              visualDensity: density,
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
      return Icon(
        Icons.check,
        size: size,
        color: Colors.green,
      );
    } else if (strength <= 10) {
      return Icon(
        Icons.warning,
        size: size,
        color: Colors.orange,
      );
    } else {
      return Icon(
        Icons.error,
        size: size,
        color: Colors.red,
      );
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
          return buildMap(context);
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
      onModelReady: (viewmodel) => {
        viewmodel.getForecast(),
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(title: const Text("Forecast View"), actions: [
          IconButton(
            onPressed: () => {model.setForecastDateOffset(0).getForecast()},
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () => {model.setForecastDateOffset(180).getForecast()},
            icon: const Icon(Icons.update),
          ),
        ]),
        body: model.busy
            ? const BusyIndicator()
            : _getWidget(model.getIndex(), context),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_today),
              label: 'Today',
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.view_week),
              label: 'Week',
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_view_month),
              label: 'Month',
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.map),
              label: 'Map',
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          ],
          currentIndex: model.getIndex(),
          selectedItemColor: Theme.of(context).colorScheme.onPrimary,
          onTap: (i) => {
            model.setIndex(i),
          },
        ),
      ),
    );
  }

  Widget buildMap(BuildContext context) {
    return ViewModelBuilder<ForecastViewModel>.reactive(
      viewModelBuilder: () => ForecastViewModel(),
      onModelReady: (model) =>
          {if (model.todaysForecast == null) model.getForecast()},
      builder: (context, model, child) => Scaffold(
        body: model.busy
            ? const BusyIndicator()
            : Padding(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Stack(
                        children: [
                          Image.asset('assets/images/polskaAlergia0.png'),
                          model.getRegionImage(),
                        ],
                      ),
                      //DropdownMenuItem(child: child)
                      DropdownButton(
                        items: model.getMapRegionItems(),
                        onChanged: (String? val) => model.setMapRegion(val),
                        value: model.selectedRegion,
                      ),
                      Wrap(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            getAllergenChipList(model.todaysForecast!).map(
                          (e) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: e,
                            );
                          },
                        ).toList(),
                      )
                      // ListView.builder(
                      //   itemBuilder: (ctx, index) {
                      //     return Text('asdasd $index');
                      //   },
                      //   itemCount: 20,
                      //   shrinkWrap: true,
                      //   physics: const NeverScrollableScrollPhysics(),
                      // )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget buildMonth(BuildContext context) {
    return ViewModelBuilder<ForecastViewModel>.reactive(
      viewModelBuilder: () => ForecastViewModel(),
      onModelReady: (viewmodel) => {
        viewmodel.getForecast(),
      },
      builder: (context, model, child) => Scaffold(
        body: model.busy
            ? const BusyIndicator()
            : Padding(
                padding: const EdgeInsets.all(5),
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
                  ],
                ),
              ),
      ),
    );
  }

  Widget buildWeek(BuildContext context) {
    return ViewModelBuilder<ForecastViewModel>.reactive(
      viewModelBuilder: () => ForecastViewModel(),
      onModelReady: (viewmodel) => {
        viewmodel.getForecast(),
      },
      builder: (context, model, child) => Scaffold(
        body: model.busy
            ? const BusyIndicator()
            : Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) =>
                            _buildWeekForecastList(context, index, model),
                        itemCount: model.weekForecast?.length,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget buildToday(BuildContext context) {
    return ViewModelBuilder<ForecastViewModel>.reactive(
      viewModelBuilder: () => ForecastViewModel(),
      onModelReady: (viewmodel) => {
        viewmodel.getForecast(),
      },
      builder: (context, model, child) => Scaffold(
        body: model.busy
            ? const BusyIndicator()
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('EEEE').format(ForecastViewModel.today),
                            style: const TextStyle(fontSize: 32.0),
                          ),
                          Text(
                            DateFormat('yyyy MMM dd')
                                .format(ForecastViewModel.today),
                            style: const TextStyle(fontSize: 26.0),
                          ),
                          Text(
                            " ${model.todaysForecast!.allergenTypeStrength.entries.where((element) => element.value > 0).length} allergen/s today:",
                            style: const TextStyle(fontSize: 18.0),
                          ),
                          Wrap(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children:
                                getAllergenChipList(model.todaysForecast!).map(
                              (e) {
                                return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: e);
                              },
                            ).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildMonthForecastList(
      BuildContext context, int index, ForecastViewModel model) {
    int dangerThatDay = model.monthForecast![index].allergenTypeStrength.values
        .toList()
        .reduce((a, b) => a + b);

    // List<String> allergensStrong = model
    //     .monthForecast![index].allergenTypeStrength.entries
    //     .where((e) => e.value == 2)
    //     .map((e) => e.key)
    //     .toList();
    // List<String> allergensMedium = model
    //     .monthForecast![index].allergenTypeStrength.entries
    //     .where((e) => e.value == 1)
    //     .map((e) => e.key)
    //     .toList();

    List<String> allergensAll = model
        .monthForecast![index].allergenTypeStrength.entries
        .map((e) => e.key)
        .toList();

    return Card(
      child: ListTile(
        leading: getAllergenIcon(dangerThatDay, 56.0),
        title:
            Text(DateFormat('MMM dd').format(model.monthForecast![index].date)),
        subtitle: Wrap(
          children:
              getAllergenChipList(model.monthForecast![index], compact: true),
        ),
      ),
    );
  }

  Widget _buildWeekForecastList(
      BuildContext context, int i, ForecastViewModel model) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 20, 5, 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DateFormat('EEEE').format(model.weekForecast![i].date),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(
              DateFormat('yyyy MMM dd').format(model.weekForecast![i].date),
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
            Text(
                " ${model.weekForecast![i].allergenTypeStrength.entries.where((element) => element.value > 0).length} allergen/s that day:",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
            ...getAllergenChipList(
              model.weekForecast![i],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildWeekForecastAllergenList(
      BuildContext context, int index, ForecastItem? f) {
    String? key = f?.allergenTypeStrength.keys.toList()[index];
    if (f!.allergenTypeStrength[key]! == 0) {
      return Container();
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("$key: ${f.allergenTypeStrength[key]}"),
        ],
      );
    }
  }
}
