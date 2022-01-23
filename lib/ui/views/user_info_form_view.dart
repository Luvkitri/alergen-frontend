import 'package:flutter/material.dart';
import 'package:frontend/ui/shared/ui_helpers.dart';
import 'package:frontend/ui/widgets/input_field.dart';
import 'package:frontend/viewmodels/user_info_form_view_model.dart';
import 'package:stacked/stacked.dart';

class UserInfoFormView extends StatelessWidget {
  const UserInfoFormView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserInfoFromViewModel>.reactive(
      viewModelBuilder: () => UserInfoFromViewModel(),
      onModelReady: (model) {
        model.init();
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text("User info"),
          actions: [
            IconButton(
              onPressed: model.save,
              icon: const Icon(Icons.done),
            ),
            IconButton(
              onPressed: model.deleteUser,
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              userInfoFormField('Name', model.nameController),
              smallSpacedDivider,
              userInfoFormField('Email', model.emailController),
              smallSpacedDivider,
              userInfoSexSelector(model),
              smallSpacedDivider,
              userBirthdayField(context, model),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton(
                    onPressed: model.save, child: const Text('Save')),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget userBirthdayField(BuildContext context, UserInfoFromViewModel model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text('Birthday', style: TextStyle(fontSize: 18)),
          verticalSpaceSmall,
          ElevatedButton(
              onPressed: () {
                model.showBirthdayPicker(context);
              },
              child: Text(model.selectedDate != null
                  ? model.selectedDate.toString().substring(0, 11)
                  : 'Click to pick'))
        ],
      ),
    );
  }

  Widget userInfoFormField(String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18)),
          verticalSpaceSmall,
          InputField(
            controller: controller,
            placeholder: title,
          )
        ],
      ),
    );
  }

  Widget userInfoSexSelector(UserInfoFromViewModel model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Sex', style: TextStyle(fontSize: 18)),
          ListTile(
            title: const Text("Men"),
            leading: Radio(
              value: 'M',
              groupValue: model.groupValue,
              onChanged: model.setUsersSex,
              //activeColor: Colors.green,
            ),
          ),
          ListTile(
            title: const Text("Female"),
            leading: Radio(
              value: 'F',
              groupValue: model.groupValue,
              onChanged: model.setUsersSex,
              //activeColor: Colors.green,
            ),
          ),
          ListTile(
            title: const Text("Other / Prefer not to say"),
            leading: Radio(
              value: 'X',
              groupValue: model.groupValue,
              onChanged: model.setUsersSex,
              //activeColor: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
