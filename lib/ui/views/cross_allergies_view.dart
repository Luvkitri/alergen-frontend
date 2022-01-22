import 'package:flutter/material.dart';
import 'package:frontend/models/allergy_model.dart';
import 'package:frontend/ui/shared/shared_styles.dart';
import 'package:frontend/viewmodels/cross_allergies_view_model.dart';
import 'package:stacked/stacked.dart';

class CrossAllergiesView extends StatelessWidget {
  final List<int> selectedAllergies;
  const CrossAllergiesView({
    required this.selectedAllergies,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CrossAllergiesViewModel>.reactive(
      onModelReady: (model) {
        model.getCrossAllergiesList(selectedAllergies);
      },
      viewModelBuilder: () => CrossAllergiesViewModel(),
      builder: (context, model, child) => WillPopScope(
        onWillPop: model.onWillPop,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Cross-Allergies"),
            actions: [
              IconButton(
                onPressed: model.save,
                icon: const Icon(Icons.done),
              ),
              IconButton(
                onPressed: model.showHelp,
                icon: const Icon(Icons.help),
              )
            ],
          ),
          body: model.busy
              ? const CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    // separatorBuilder: (ctx, index) {
                    //   return spacedDivider;
                    // },
                    itemCount: model.crossAllergies.length,
                    itemBuilder: (ctx, index) =>
                        _crossAllergyBatchBuilder(index, model),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _crossAllergyBatchBuilder(int index, CrossAllergiesViewModel model) {
    List<Allergy> x = model.crossAllergies.values.toList()[index];
    Allergy root = model.getAllergyFromId(
      model.crossAllergies.keys.toList()[index],
    );
    List<Widget> rows = [];
    for (Allergy a in x) {
      rows.add(
        _crossAllergyItemBuilder(model, a),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpansionTile(
          children: rows,
          title: Text(
            root.name,
            style: titleStyleMedium,
          ),
        ),
      ],
    );
  }

  Widget _crossAllergyItemBuilder(
      CrossAllergiesViewModel model, Allergy allergy) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 38.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              allergy.name,
            ),
          ),
          Checkbox(
            value: model.selectedCheckbox[allergy.id],
            onChanged: (value) {
              model.selectCrossAllergy(value, allergy.id);
            },
          )
        ],
      ),
    );
  }
}
