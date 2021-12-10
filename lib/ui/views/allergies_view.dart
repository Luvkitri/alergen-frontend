import 'package:flutter/material.dart';
import 'package:frontend/models/allergy_model.dart';
import 'package:frontend/ui/shared/ui_helpers.dart';
import 'package:frontend/viewmodels/allergies_view_model.dart';
import 'package:stacked/stacked.dart';

class AllergiesView extends StatelessWidget {
  const AllergiesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AllergiesViewModel>.reactive(
      onModelReady: (model) {
        model.getAllergiesList();
      },
      viewModelBuilder: () => AllergiesViewModel(),
      builder: (context, model, child) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: model.navigateToAddAllergies,
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: const Text("Your Allergies"),
        ),
        body: model.allergies.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    'You dont have any allergies selected',
                    style: TextStyle(fontSize: 32),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : ListView.separated(
                separatorBuilder: (context, index) {
                  return smallSpacedDivider;
                },
                itemCount: model.allergies.length,
                itemBuilder: (ctx, index) => _allergyItemBuilder(index, model)),
      ),
    );
  }

  Widget _allergyItemBuilder(int index, AllergiesViewModel model) {
    Allergy a = model.allergies[index];
    return ExpansionTile(
      title: Text(a.name),
      subtitle: Text(a.type),
      children: [
        Text(a.description),
      ],
    );
  }
}
