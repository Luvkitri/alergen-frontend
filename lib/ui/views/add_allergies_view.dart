import 'package:flutter/material.dart';
import 'package:frontend/models/allergy_model.dart';
import 'package:frontend/ui/shared/ui_helpers.dart';
import 'package:frontend/ui/widgets/input_field.dart';
import 'package:frontend/viewmodels/add_allergies_view_model.dart';
import 'package:stacked/stacked.dart';

class AddAllergiesView extends StatelessWidget {
  const AddAllergiesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddAllergiesViewModel>.reactive(
      onModelReady: (model) {
        model.getAllergiesList();
      },
      viewModelBuilder: () => AddAllergiesViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text("Add Your Allergies"),
          actions: [
            IconButton(
              onPressed: model.saveUsersAllergies,
              icon: const Icon(Icons.done),
            ),
          ],
        ),
        body: Column(
                children: [
                  verticalSpaceSmall,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: InputField(
                            controller: model.filterController,
                            placeholder: 'Search',
                            onChanged: model.filterAllergies,
                          ),
                        ),
                        IconButton(
                          onPressed: model.clearSearch,
                          icon: const Icon(Icons.clear),
                        )
                      ],
                    ),
                  ),
                  smallSpacedDivider,
                  Expanded(
                    child: model.allergies.isEmpty ? const Text('No allergies were found') : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.separated(
                        separatorBuilder: (ctx, index) {
                          return smallSpacedDivider;
                        },
                        itemCount: model.allergies.length,
                        itemBuilder: (ctx, index) =>
                            _allergyItemBuilder(index, model),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _allergyItemBuilder(int index, AddAllergiesViewModel model) {
    Allergy a = model.allergies[index];
    return ExpansionTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(a.name),
          Checkbox(
            value: model.allergiesSelected[a.id],
            onChanged: (i) => model.addAllergyToList(a.id, i),
          ),
        ],
      ),
      subtitle: Text(a.type),
      children: [
        Text(a.description),
      ],
    );
  }
}
