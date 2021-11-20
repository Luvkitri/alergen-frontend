import 'package:flutter/material.dart';
import 'package:frontend/viewmodels/user_info_form_view_model.dart';
import 'package:stacked/stacked.dart';

class UserInfoFormView extends StatelessWidget {
  const UserInfoFormView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserInfoFromViewModel>.reactive(
      viewModelBuilder: () => UserInfoFromViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text("Dane użytkownika"),
          actions: [
            IconButton(onPressed: model.save, icon: const Icon(Icons.save))
          ],
        ),
        body: Container(),
      ),
    );
  }
}
