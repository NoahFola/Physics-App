import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:bloc/bloc.dart';
import '../bloc/module_bloc.dart';
import '../widgets/module_list_item.dart';

// Screen from Screenshot: ...164728.jpg
// Displays the list of "Physics Modules"

class ModulesScreen extends StatelessWidget {
  const ModulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Physics Modules'),
        centerTitle: false,
      ),
      body: BlocBuilder<ModuleBloc, ModuleState>(
        builder: (context, state) {
          if (state is ModuleLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ModuleError) {
            return Center(child: Text(state.message));
          }
          if (state is ModulesLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: state.modules.length,
              itemBuilder: (context, index) {
                final module = state.modules[index];
                return ModuleListItem(module: module);
              },
            );
          }
          // Initial or other states
          return const Center(child: Text('Please load modules.'));
        },
      ),
    );
  }
}
