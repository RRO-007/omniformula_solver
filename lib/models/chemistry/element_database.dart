import 'element.dart';

class ElementDatabase {
  static final List<ChemicalElement> elements = [
    ChemicalElement(atomicNumber: 1, symbol: 'H', name: 'Hydrogen', atomicMass: 1.008, category: 'Nonmetal', electronConfiguration: '1s1', electronegativity: 2.20, state: 'Gas'),
    ChemicalElement(atomicNumber: 2, symbol: 'He', name: 'Helium', atomicMass: 4.0026, category: 'Noble Gas', electronConfiguration: '1s2', electronegativity: 0.0, state: 'Gas'),
    ChemicalElement(atomicNumber: 3, symbol: 'Li', name: 'Lithium', atomicMass: 6.94, category: 'Alkali Metal', electronConfiguration: '[He] 2s1', electronegativity: 0.98, state: 'Solid'),
    ChemicalElement(atomicNumber: 4, symbol: 'Be', name: 'Beryllium', atomicMass: 9.0122, category: 'Alkaline Earth', electronConfiguration: '[He] 2s2', electronegativity: 1.57, state: 'Solid'),
    ChemicalElement(atomicNumber: 5, symbol: 'B', name: 'Boron', atomicMass: 10.81, category: 'Metalloid', electronConfiguration: '[He] 2s2 2p1', electronegativity: 2.04, state: 'Solid'),
    ChemicalElement(atomicNumber: 6, symbol: 'C', name: 'Carbon', atomicMass: 12.011, category: 'Nonmetal', electronConfiguration: '[He] 2s2 2p2', electronegativity: 2.55, state: 'Solid'),
    ChemicalElement(atomicNumber: 7, symbol: 'N', name: 'Nitrogen', atomicMass: 14.007, category: 'Nonmetal', electronConfiguration: '[He] 2s2 2p3', electronegativity: 3.04, state: 'Gas'),
    ChemicalElement(atomicNumber: 8, symbol: 'O', name: 'Oxygen', atomicMass: 15.999, category: 'Nonmetal', electronConfiguration: '[He] 2s2 2p4', electronegativity: 3.44, state: 'Gas'),
    ChemicalElement(atomicNumber: 9, symbol: 'F', name: 'Fluorine', atomicMass: 18.998, category: 'Halogen', electronConfiguration: '[He] 2s2 2p5', electronegativity: 3.98, state: 'Gas'),
    ChemicalElement(atomicNumber: 10, symbol: 'Ne', name: 'Neon', atomicMass: 20.180, category: 'Noble Gas', electronConfiguration: '[He] 2s2 2p6', electronegativity: 0.0, state: 'Gas'),
    ChemicalElement(atomicNumber: 11, symbol: 'Na', name: 'Sodium', atomicMass: 22.990, category: 'Alkali Metal', electronConfiguration: '[Ne] 3s1', electronegativity: 0.93, state: 'Solid'),
    ChemicalElement(atomicNumber: 12, symbol: 'Mg', name: 'Magnesium', atomicMass: 24.305, category: 'Alkaline Earth', electronConfiguration: '[Ne] 3s2', electronegativity: 1.31, state: 'Solid'),
    ChemicalElement(atomicNumber: 13, symbol: 'Al', name: 'Aluminium', atomicMass: 26.982, category: 'Post-transition Metal', electronConfiguration: '[Ne] 3s2 3p1', electronegativity: 1.61, state: 'Solid'),
    ChemicalElement(atomicNumber: 14, symbol: 'Si', name: 'Silicon', atomicMass: 28.085, category: 'Metalloid', electronConfiguration: '[Ne] 3s2 3p2', electronegativity: 1.90, state: 'Solid'),
    ChemicalElement(atomicNumber: 15, symbol: 'P', name: 'Phosphorus', atomicMass: 30.974, category: 'Nonmetal', electronConfiguration: '[Ne] 3s2 3p3', electronegativity: 2.19, state: 'Solid'),
    ChemicalElement(atomicNumber: 16, symbol: 'S', name: 'Sulfur', atomicMass: 32.06, category: 'Nonmetal', electronConfiguration: '[Ne] 3s2 3p4', electronegativity: 2.58, state: 'Solid'),
    ChemicalElement(atomicNumber: 17, symbol: 'Cl', name: 'Chlorine', atomicMass: 35.45, category: 'Halogen', electronConfiguration: '[Ne] 3s2 3p5', electronegativity: 3.16, state: 'Gas'),
    ChemicalElement(atomicNumber: 18, symbol: 'Ar', name: 'Argon', atomicMass: 39.948, category: 'Noble Gas', electronConfiguration: '[Ne] 3s2 3p6', electronegativity: 0.0, state: 'Gas'),
    ChemicalElement(atomicNumber: 19, symbol: 'K', name: 'Potassium', atomicMass: 39.098, category: 'Alkali Metal', electronConfiguration: '[Ar] 4s1', electronegativity: 0.82, state: 'Solid'),
    ChemicalElement(atomicNumber: 20, symbol: 'Ca', name: 'Calcium', atomicMass: 40.078, category: 'Alkaline Earth', electronConfiguration: '[Ar] 4s2', electronegativity: 1.00, state: 'Solid'),
  ];
}