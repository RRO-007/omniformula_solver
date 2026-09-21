import 'constant.dart';

class ConstantDatabase {
  static final List<ScientificConstant> constants = [
    ScientificConstant(name: 'Speed of Light', symbol: 'c', value: 299792458.0, unit: 'm/s'),
    ScientificConstant(name: 'Gravitational Constant', symbol: 'G', value: 6.67430e-11, unit: 'm³/kg·s²'),
    ScientificConstant(name: 'Planck\'s Constant', symbol: 'h', value: 6.62607015e-34, unit: 'J·s'),
    ScientificConstant(name: 'Boltzmann Constant', symbol: 'k', value: 1.380649e-23, unit: 'J/K'),
    ScientificConstant(name: 'Avogadro\'s Number', symbol: 'Nₐ', value: 6.02214076e23, unit: 'mol⁻¹'),
    ScientificConstant(name: 'Elementary Charge', symbol: 'e', value: 1.602176634e-19, unit: 'C'),
    ScientificConstant(name: 'Electron Mass', symbol: 'mₑ', value: 9.1093837015e-31, unit: 'kg'),
    ScientificConstant(name: 'Proton Mass', symbol: 'mₚ', value: 1.67262192369e-27, unit: 'kg'),
    ScientificConstant(name: 'Gas Constant', symbol: 'R', value: 8.314462618, unit: 'J/mol·K'),
    ScientificConstant(name: 'Standard Gravity', symbol: 'g', value: 9.80665, unit: 'm/s²'),
  ];
}