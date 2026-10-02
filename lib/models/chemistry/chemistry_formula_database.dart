import '../formula.dart';

class ChemistryFormulaDatabase {
  static final List<Formula> chemistryFormulas = [
    // --- BASIC ---
    Formula(
      id: 'molarity',
      name: 'Molarity: M = n/V',
      variables: ['M', 'n', 'V'],
      equations: {'M': 'n/V', 'n': 'M*V', 'V': 'n/M'},
    ),
    Formula(
      id: 'dilution',
      name: 'Dilution: M₁V₁ = M₂V₂',
      variables: ['M1', 'V1', 'M2', 'V2'],
      equations: {
        'M1': '(M2*V2)/V1',
        'V1': '(M2*V2)/M1',
        'M2': '(M1*V1)/V2',
        'V2': '(M1*V1)/M2',
      },
    ),
    Formula(
      id: 'ideal_gas_law',
      name: 'Ideal Gas: PV = nRT (R=0.0821)',
      variables: ['P', 'V', 'n', 'T'],
      equations: {
        'P': '(n*0.0821*T)/V',
        'V': '(n*0.0821*T)/P',
        'n': '(P*V)/(0.0821*T)',
        'T': '(P*V)/(n*0.0821)',
      },
    ),
    Formula(
      id: 'percent_yield',
      name: 'Percent Yield = (Actual/Theoretical)×100',
      variables: ['PY', 'Actual', 'Theoretical'],
      equations: {
        'PY': '(Actual/Theoretical)*100',
        'Actual': '(PY*Theoretical)/100',
        'Theoretical': '(Actual*100)/PY',
      },
    ),
    Formula(
      id: 'density',
      name: 'Density: d = m/V',
      variables: ['d', 'm', 'V'],
      equations: {'d': 'm/V', 'm': 'd*V', 'V': 'm/d'},
    ),
    Formula(
      id: 'moles',
      name: 'Moles: n = mass/molarMass',
      variables: ['n', 'mass', 'molarMass'],
      equations: {
        'n': 'mass/molarMass',
        'mass': 'n*molarMass',
        'molarMass': 'mass/n',
      },
    ),

    // --- ACID/BASE ---
    Formula(
      id: 'ph_calc',
      name: 'pH = -log₁₀[H⁺]',
      variables: ['pH', 'H'],
      equations: {'pH': '-log(H)', 'H': '10^(-pH)'},
    ),
    Formula(
      id: 'poh_calc',
      name: 'pOH = -log₁₀[OH⁻]',
      variables: ['pOH', 'OH'],
      equations: {'pOH': '-log(OH)', 'OH': '10^(-pOH)'},
    ),
    Formula(
      id: 'ph_poh',
      name: 'pH + pOH = 14',
      variables: ['pH', 'pOH'],
      equations: {'pH': '14 - pOH', 'pOH': '14 - pH'},
    ),
    Formula(
      id: 'pka_ka',
      name: 'pKa = -log₁₀(Ka)',
      variables: ['pKa', 'Ka'],
      equations: {'pKa': '-log(Ka)', 'Ka': '10^(-pKa)'},
    ),
    Formula(
      id: 'henderson',
      name: 'Henderson-Hasselbalch: pH = pKa + log([Salt]/[Acid])',
      variables: ['pH', 'pKa', 'Salt', 'Acid'],
      equations: {'pH': 'pKa + log(Salt/Acid)', 'pKa': 'pH - log(Salt/Acid)'},
    ),

    // --- EQUILIBRIUM ---
    Formula(
      id: 'kp_kc',
      name: 'Kp = Kc(RT)^Δn',
      variables: ['Kp', 'Kc', 'dN', 'T'],
      equations: {'Kp': 'Kc*(0.0821*T)^dN', 'Kc': 'Kp/((0.0821*T)^dN)'},
    ),
    Formula(
      id: 'equilibrium_q',
      name: 'Reaction Quotient Q = [Products]/[Reactants]',
      variables: ['Q', 'P', 'R'],
      equations: {'Q': 'P/R', 'P': 'Q*R', 'R': 'P/Q'},
    ),

    // --- ELECTROCHEMISTRY ---
    Formula(
      id: 'nernst',
      name: 'Nernst: E = E° - (0.0592/n)·log(Q)',
      variables: ['E', 'E0', 'n', 'Q'],
      equations: {'E': 'E0 - (0.0592/n)*log(Q)', 'E0': 'E + (0.0592/n)*log(Q)'},
    ),
    Formula(
      id: 'faraday_mass',
      name: 'Electrolysis: m = (M·I·t)/(n·F)',
      variables: ['m', 'M', 'I', 't', 'n'],
      equations: {
        'm': '(M*I*t)/(n*96485)',
        'I': '(m*n*96485)/(M*t)',
        't': '(m*n*96485)/(M*I)',
      },
    ),

    // --- HSC: ATOMIC STRUCTURE ---
    Formula(
      id: 'bohr_radius',
      name: 'Bohr Radius: rₙ = 0.529·(n²/Z) Å',
      variables: ['r', 'n', 'Z'],
      equations: {
        'r': '0.529*(n^2)/Z',
        'n': 'sqrt((r*Z)/0.529)',
        'Z': '0.529*(n^2)/r',
      },
    ),
    Formula(
      id: 'bohr_energy',
      name: 'Bohr Energy: Eₙ = -13.6·(Z²/n²) eV',
      variables: ['E', 'n', 'Z'],
      equations: {
        'E': '-13.6*(Z^2)/(n^2)',
        'n': 'sqrt((-13.6*Z^2)/E)',
        'Z': 'sqrt((E*n^2)/(-13.6))',
      },
    ),
    Formula(
      id: 'rydberg',
      name: 'Rydberg: 1/λ = R·Z²·(1/n₁² - 1/n₂²)',
      variables: ['lambda', 'Z', 'n1', 'n2'],
      equations: {'lambda': '1/(10973731*Z^2*((1/n1^2) - (1/n2^2)))'},
    ),
    Formula(
      id: 'photon_energy_chem',
      name: 'Photon Energy: E = hc/λ',
      variables: ['E', 'lambda'],
      equations: {'E': '(6.626e-34*3e8)/lambda', 'lambda': '(6.626e-34*3e8)/E'},
    ),

    // --- GAS LAWS ---
    Formula(
      id: 'boyles_law',
      name: "Boyle's Law: P₁V₁ = P₂V₂",
      variables: ['P1', 'V1', 'P2', 'V2'],
      equations: {
        'P1': '(P2*V2)/V1',
        'V1': '(P2*V2)/P1',
        'P2': '(P1*V1)/V2',
        'V2': '(P1*V1)/P2',
      },
    ),
    Formula(
      id: 'charles_law',
      name: "Charles's Law: V₁/T₁ = V₂/T₂",
      variables: ['V1', 'T1', 'V2', 'T2'],
      equations: {
        'V1': '(V2*T1)/T2',
        'T1': '(V1*T2)/V2',
        'V2': '(V1*T2)/T1',
        'T2': '(V2*T1)/V1',
      },
    ),
    Formula(
      id: 'combined_gas',
      name: 'Combined Gas: (P₁V₁)/T₁ = (P₂V₂)/T₂',
      variables: ['P1', 'V1', 'T1', 'P2', 'V2', 'T2'],
      equations: {'T2': '(P2*V2*T1)/(P1*V1)', 'P2': '(P1*V1*T2)/(T1*V2)'},
    ),
    // ============ HSC: ADVANCED EQUILIBRIUM ============
    Formula(
      id: 'kp_kc_alt',
      name: 'Kp from Kc (atm): Kp = Kc(RT)^Δn [R=0.0821]',
      variables: ['Kp', 'Kc', 'dN', 'T'],
      equations: {
        'Kp': 'Kc*(0.0821*T)^dN',
        'Kc': 'Kp/((0.0821*T)^dN)',
        'dN': 'log(Kp/Kc)/log(0.0821*T)',
      },
    ),
    Formula(
      id: 'buffer_ratio',
      name: 'Buffer Ratio: [Salt]/[Acid] = 10^(pH - pKa)',
      variables: ['ratio', 'pH', 'pKa'],
      equations: {
        'ratio': '10^(pH - pKa)',
        'pH': 'pKa + log(ratio)',
        'pKa': 'pH - log(ratio)',
      },
    ),

    // ============ HSC: ELECTROCHEMISTRY ============
    Formula(
      id: 'nernst_alt',
      name: 'Nernst (ln form): E = E° - (RT/nF)·ln(Q)',
      variables: ['E', 'E0', 'n', 'Q', 'T'],
      equations: {
        'E': 'E0 - ((8.314*T)/(n*96485))*ln(Q)',
        'E0': 'E + ((8.314*T)/(n*96485))*ln(Q)',
      },
    ),
    Formula(
      id: 'gibbs_emf',
      name: 'ΔG = -nFE°',
      variables: ['dG', 'n', 'E0'],
      equations: {
        'dG': '-n*96485*E0',
        'E0': '-dG/(n*96485)',
        'n': '-dG/(96485*E0)',
      },
    ),
    Formula(
      id: 'electrolysis_time',
      name: 'Electrolysis Time: t = (m·n·F)/(M·I)',
      variables: ['t', 'm', 'n', 'M', 'I'],
      equations: {
        't': '(m*n*96485)/(M*I)',
        'm': '(M*I*t)/(n*96485)',
        'I': '(m*n*96485)/(M*t)',
      },
    ),

    // ============ HSC: THERMOCHEMISTRY ============
    Formula(
      id: 'enthalpy',
      name: 'Enthalpy: ΔH = H_products - H_reactants',
      variables: ['dH', 'Hp', 'Hr'],
      equations: {'dH': 'Hp - Hr', 'Hp': 'dH + Hr', 'Hr': 'Hp - dH'},
    ),
    Formula(
      id: 'gibbs_temp',
      name: 'Gibbs Free Energy: ΔG = ΔH - TΔS',
      variables: ['dG', 'dH', 'T', 'dS'],
      equations: {
        'dG': 'dH - T*dS',
        'dH': 'dG + T*dS',
        'T': '(dH - dG)/dS',
        'dS': '(dH - dG)/T',
      },
    ),
    Formula(
      id: 'spontaneity_check',
      name: 'Spontaneity: ΔG < 0 → spontaneous',
      variables: ['dG', 'dH', 'T', 'dS'],
      equations: {'dG': 'dH - T*dS'},
    ),

    // ============ HSC: KINETICS ============
    Formula(
      id: 'rate_law',
      name: 'Rate = k[A]^m[B]^n (given k, orders)',
      variables: ['rate', 'k', 'A', 'B', 'm', 'n'],
      equations: {'rate': 'k*(A^m)*(B^n)'},
    ),
    Formula(
      id: 'half_life',
      name: 'Half-life (1st order): t½ = 0.693/k',
      variables: ['t_half', 'k'],
      equations: {'t_half': '0.693/k', 'k': '0.693/t_half'},
    ),
    Formula(
      id: 'arrhenius',
      name: 'Arrhenius: k = A·e^(-Ea/RT)',
      variables: ['k', 'A', 'Ea', 'T'],
      equations: {'k': 'A*exp(-Ea/(8.314*T))'},
    ),

    // ============ HSC: SOLUBILITY ============
    Formula(
      id: 'ksp',
      name: 'Ksp = [A⁺]^m[B⁻]^n (given concs)',
      variables: ['Ksp', 'A', 'B', 'm', 'n'],
      equations: {'Ksp': '(A^m)*(B^n)'},
    ),
  ];
}
