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
    ScientificConstant(name: 'Neutron Mass', symbol: 'mₙ', value: 1.67492749804e-27, unit: 'kg'),
    ScientificConstant(name: 'Gas Constant', symbol: 'R', value: 8.314462618, unit: 'J/mol·K'),
    ScientificConstant(name: 'Standard Gravity', symbol: 'g', value: 9.80665, unit: 'm/s²'),
    ScientificConstant(name: 'Atomic Mass Unit', symbol: 'u', value: 1.66053906660e-27, unit: 'kg'),
    ScientificConstant(name: 'Faraday Constant', symbol: 'F', value: 96485.33212, unit: 'C/mol'),
    ScientificConstant(name: 'Rydberg Constant', symbol: 'R∞', value: 10973731.568160, unit: 'm⁻¹'),
    ScientificConstant(name: 'Bohr Radius', symbol: 'a₀', value: 5.29177210903e-11, unit: 'm'),
    ScientificConstant(name: 'Bohr Magneton', symbol: 'μB', value: 9.2740100783e-24, unit: 'J/T'),
    ScientificConstant(name: 'Stefan-Boltzmann Constant', symbol: 'σ', value: 5.670374419e-8, unit: 'W/m²·K⁴'),
    ScientificConstant(name: 'Wien Displacement Constant', symbol: 'b', value: 2.897771955e-3, unit: 'm·K'),
    ScientificConstant(name: 'Fine Structure Constant', symbol: 'α', value: 7.2973525693e-3, unit: 'dimensionless'),
    ScientificConstant(name: 'Vacuum Permeability', symbol: 'μ₀', value: 1.25663706212e-6, unit: 'N/A²'),
    ScientificConstant(name: 'Vacuum Permittivity', symbol: 'ε₀', value: 8.8541878128e-12, unit: 'F/m'),
    ScientificConstant(name: 'Molar Volume of Gas', symbol: 'Vm', value: 22.41396954, unit: 'L/mol'),
  ];
}