enum CurrentModuleType {
  quiz,
  exam,
  attendance,
}

class ModuleSelectionService {
  CurrentModuleType _selectedModule = CurrentModuleType.quiz;

  void setSelectedModule(CurrentModuleType module) {
    _selectedModule = module;
  }

  CurrentModuleType getSelectedModule() {
    return _selectedModule;
  }
}
