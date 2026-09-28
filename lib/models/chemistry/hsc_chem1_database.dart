import '../formula.dart';

class HscChem1Database {
  static final List<Formula> hscChem1Formulas = [
    // ========== CHAPTER 1: LAB SAFETY & BASIC CONCEPTS ==========
    Formula(
      id: 'chem1_rider_constant',
      name: 'Rider Constant (RC = 2m/N)',
      variables: ['RC', 'm_rider', 'N'],
      equations: {
        'RC': '2*m_rider/N',
        'm_rider': 'RC*N/2',
        'N': '2*m_rider/RC',
      },
    ),
    Formula(
      id: 'chem1_total_mass',
      name: 'Total Mass (Paul-Bunge Balance)',
      variables: ['M', 'M_gram', 'M_mg', 'd', 'RC'],
      equations: {
        'M': 'M_gram+M_mg+(d*RC)',
        'd': '(M-M_gram-M_mg)/RC',
        'RC': '(M-M_gram-M_mg)/d',
      },
    ),
    Formula(
      id: 'chem1_molarity',
      name: 'Molarity (S = w/(M*V))',
      variables: ['S', 'w', 'M', 'V_L'],
      equations: {
        'S': 'w/(M*V_L)',
        'w': 'S*M*V_L',
        'M': 'w/(S*V_L)',
        'V_L': 'w/(S*M)',
      },
    ),
    Formula(
      id: 'chem1_mass_solute',
      name: 'Mass of Solute Required',
      variables: ['w', 'S', 'M', 'V_mL'],
      equations: {
        'w': 'S*M*V_mL/1000',
        'S': '1000*w/(M*V_mL)',
        'M': '1000*w/(S*V_mL)',
        'V_mL': '1000*w/(S*M)',
      },
    ),
    Formula(
      id: 'chem1_dilution_law',
      name: 'Dilution Law (V1S1 = V2S2)',
      variables: ['V1', 'S1', 'V2', 'S2'],
      equations: {
        'V1': 'V2*S2/S1',
        'S1': 'V2*S2/V1',
        'V2': 'V1*S1/S2',
        'S2': 'V1*S1/V2',
      },
    ),
    Formula(
      id: 'chem1_moles',
      name: 'Number of Moles (n = w/M)',
      variables: ['n', 'w', 'M'],
      equations: {'n': 'w/M', 'w': 'n*M', 'M': 'w/n'},
    ),
    Formula(
      id: 'chem1_ph_basic',
      name: 'pH of Basic Solution (pH = 14 + log[OH])',
      variables: ['pH', 'OH'],
      equations: {'pH': '14+log(OH)', 'OH': '10^(pH-14)'},
    ),

    // ========== CHAPTER 2: QUALITATIVE CHEMISTRY ==========
    Formula(
      id: 'chem1_bohr_radius',
      name: 'Bohr Radius (rn = 0.529n²/Z)',
      variables: ['rn', 'n', 'Z'],
      equations: {
        'rn': '0.529e-10*n^2/Z',
        'n': 'sqrt(rn*Z/0.529e-10)',
        'Z': '0.529e-10*n^2/rn',
      },
    ),
    Formula(
      id: 'chem1_bohr_velocity',
      name: 'Bohr Velocity (vn = 2.18e6 Z/n)',
      variables: ['vn', 'Z', 'n'],
      equations: {'vn': '2.18e6*Z/n', 'Z': 'vn*n/2.18e6', 'n': '2.18e6*Z/vn'},
    ),
    Formula(
      id: 'chem1_angular_momentum',
      name: 'Angular Momentum (L = nh/2π)',
      variables: ['L', 'n'],
      equations: {'L': 'n*6.626e-34/(2*3.14159)', 'n': 'L*2*3.14159/6.626e-34'},
    ),
    Formula(
      id: 'chem1_bohr_energy',
      name: 'Bohr Energy (En = -13.6Z²/n² eV)',
      variables: ['En', 'Z', 'n'],
      equations: {
        'En': '-13.6*Z^2/(n^2)',
        'Z': 'sqrt(-En*n^2/13.6)',
        'n': 'sqrt(-13.6*Z^2/En)',
      },
    ),
    Formula(
      id: 'chem1_bohr_energy_molar',
      name: 'Bohr Molar Energy (kJ/mol)',
      variables: ['En', 'Z', 'n'],
      equations: {
        'En': '-1312*Z^2/(n^2)',
        'Z': 'sqrt(-En*n^2/1312)',
        'n': 'sqrt(-1312*Z^2/En)',
      },
    ),
    Formula(
      id: 'chem1_planck_energy',
      name: 'Planck-Einstein (ΔE = hν)',
      variables: ['dE', 'nu', 'lambda'],
      equations: {
        'dE': '6.626e-34*nu',
        'nu': 'dE/6.626e-34',
        'lambda': '6.626e-34*3e8/dE',
      },
    ),
    Formula(
      id: 'chem1_de_broglie',
      name: 'de Broglie (λ = h/mv)',
      variables: ['lambda', 'm', 'v'],
      equations: {
        'lambda': '6.626e-34/(m*v)',
        'm': '6.626e-34/(lambda*v)',
        'v': '6.626e-34/(lambda*m)',
      },
    ),
    Formula(
      id: 'chem1_orbitals_subshell',
      name: 'Orbitals per Subshell (N = 2l+1)',
      variables: ['N', 'l'],
      equations: {'N': '2*l+1', 'l': '(N-1)/2'},
    ),
    Formula(
      id: 'chem1_max_electrons_subshell',
      name: 'Max Electrons Subshell (N = 2(2l+1))',
      variables: ['N', 'l'],
      equations: {'N': '2*(2*l+1)', 'l': '(N/2-1)/2'},
    ),
    Formula(
      id: 'chem1_orbitals_shell',
      name: 'Orbitals per Shell (N = n²)',
      variables: ['N', 'n'],
      equations: {'N': 'n^2', 'n': 'sqrt(N)'},
    ),
    Formula(
      id: 'chem1_max_electrons_shell',
      name: 'Max Electrons Shell (N = 2n²)',
      variables: ['N', 'n'],
      equations: {'N': '2*n^2', 'n': 'sqrt(N/2)'},
    ),
    Formula(
      id: 'chem1_mass_number',
      name: 'Mass Number (A = Z + n)',
      variables: ['A', 'Z', 'n'],
      equations: {'A': 'Z+n', 'Z': 'A-n', 'n': 'A-Z'},
    ),
    Formula(
      id: 'chem1_charge_to_mass',
      name: 'Mass from e/(e/m)',
      variables: ['m', 'e', 'em_ratio'],
      equations: {'m': 'e/em_ratio', 'e': 'm*em_ratio', 'em_ratio': 'e/m'},
    ),
    Formula(
      id: 'chem1_faraday_charge',
      name: 'Charge of 1 mole e⁻ (Q = NA·e)',
      variables: ['Q'],
      equations: {'Q': '6.022e23*1.602e-19'},
    ),

    // ========== CHAPTER 3: PERIODIC PROPERTIES ==========
    Formula(
      id: 'chem1_group_p_block',
      name: 'p-block Group Number (10 + s + p)',
      variables: ['G', 's', 'p'],
      equations: {'G': '10+s+p', 's': 'G-10-p', 'p': 'G-10-s'},
    ),
    Formula(
      id: 'chem1_group_d_block',
      name: 'd-block Group Number (d + s)',
      variables: ['G', 'd', 's'],
      equations: {'G': 'd+s', 'd': 'G-s', 's': 'G-d'},
    ),
    Formula(
      id: 'chem1_charge_density',
      name: 'Charge Density (Z/r)',
      variables: ['CD', 'Z', 'r'],
      equations: {'CD': 'Z/r', 'Z': 'CD*r', 'r': 'Z/CD'},
    ),
    Formula(
      id: 'chem1_magnetic_moment',
      name: 'Spin-only Magnetic Moment',
      variables: ['mu_s', 'n'],
      equations: {'mu_s': 'sqrt(n*(n+2))', 'n': 'sqrt(1+mu_s^2)-1'},
    ),
    Formula(
      id: 'chem1_crystal_field',
      name: 'Crystal Field Splitting Energy',
      variables: ['dE', 'lambda'],
      equations: {'dE': '6.626e-34*3e8/lambda', 'lambda': '6.626e-34*3e8/dE'},
    ),

    // ========== CHAPTER 4: CHEMICAL CHANGE ==========
    Formula(
      id: 'chem1_atom_economy',
      name: 'Percentage Atom Economy',
      variables: ['AE', 'M_prod', 'M_react'],
      equations: {
        'AE': '(M_prod/M_react)*100',
        'M_prod': 'AE*M_react/100',
        'M_react': 'M_prod*100/AE',
      },
    ),
    Formula(
      id: 'chem1_rate_reaction',
      name: 'Rate of Reaction',
      variables: ['rate', 'dx', 'dt'],
      equations: {'rate': 'dx/dt', 'dx': 'rate*dt', 'dt': 'dx/rate'},
    ),
    Formula(
      id: 'chem1_rate_law',
      name: 'Rate Law (r = k[A]^m[B]^n)',
      variables: ['r', 'k', 'A', 'B', 'm', 'n'],
      equations: {
        'r': 'k*(A^m)*(B^n)',
        'k': 'r/((A^m)*(B^n))',
        'A': '(r/(k*(B^n)))^(1/m)',
        'B': '(r/(k*(A^m)))^(1/n)',
      },
    ),
    Formula(
      id: 'chem1_first_order',
      name: 'First-Order Kinetics (k = (1/t)ln(a/(a-x)))',
      variables: ['k', 't', 'a', 'x'],
      equations: {
        'k': '(1/t)*ln(a/(a-x))',
        't': '(1/k)*ln(a/(a-x))',
        'a': 'x/(1-2.71828^(-k*t))',
        'x': 'a*(1-2.71828^(-k*t))',
      },
    ),
    Formula(
      id: 'chem1_first_half_life',
      name: 'First-Order Half-Life (t½ = 0.693/k)',
      variables: ['t_half', 'k'],
      equations: {'t_half': '0.693/k', 'k': '0.693/t_half'},
    ),
    Formula(
      id: 'chem1_second_order',
      name: 'Second-Order Kinetics',
      variables: ['k', 't', 'a', 'x'],
      equations: {
        'k': '(1/t)*(x/(a*(a-x)))',
        't': '(1/k)*(x/(a*(a-x)))',
        'a': 'x/(1-1/(1+k*t*x))',
        'x': 'a*(1-1/(1+k*t*a))',
      },
    ),
    Formula(
      id: 'chem1_second_half_life',
      name: 'Second-Order Half-Life (t½ = 1/ka)',
      variables: ['t_half', 'k', 'a'],
      equations: {
        't_half': '1/(k*a)',
        'k': '1/(t_half*a)',
        'a': '1/(k*t_half)',
      },
    ),
    Formula(
      id: 'chem1_arrhenius',
      name: 'Arrhenius Equation (k = A·e^(-Ea/RT))',
      variables: ['k', 'A', 'Ea', 'T'],
      equations: {
        'k': 'A*2.71828^(-Ea/(8.314*T))',
        'A': 'k/2.71828^(-Ea/(8.314*T))',
        'Ea': '-8.314*T*ln(k/A)',
        'T': '-Ea/(8.314*ln(k/A))',
      },
    ),
    Formula(
      id: 'chem1_arrhenius_2temp',
      name: 'Arrhenius 2-Temperature Form',
      variables: ['k1', 'k2', 'T1', 'T2', 'Ea'],
      equations: {
        'k2': 'k1*2.71828^((Ea/8.314)*(1/T1-1/T2))',
        'k1': 'k2/2.71828^((Ea/8.314)*(1/T1-1/T2))',
        'Ea': '8.314*ln(k2/k1)/(1/T1-1/T2)',
        'T1': '1/(1/T2-Ea/(8.314*ln(k2/k1)))',
        'T2': '1/(1/T1+Ea/(8.314*ln(k2/k1)))',
      },
    ),
    Formula(
      id: 'chem1_kc',
      name: 'Equilibrium Constant Kc',
      variables: ['Kc', 'C', 'D', 'A', 'B', 'c', 'd', 'a', 'b'],
      equations: {
        'Kc': '(C^c*D^d)/(A^a*B^b)',
        'C': '((Kc*(A^a)*(B^b))/(D^d))^(1/c)',
      },
    ),
    Formula(
      id: 'chem1_kp',
      name: 'Equilibrium Constant Kp',
      variables: ['Kp', 'pC', 'pD', 'pA', 'pB', 'c', 'd', 'a', 'b'],
      equations: {
        'Kp': '(pC^c*pD^d)/(pA^a*pB^b)',
        'pC': '((Kp*(pA^a)*(pB^b))/(pD^d))^(1/c)',
      },
    ),
    Formula(
      id: 'chem1_kp_kc',
      name: 'Kp and Kc Relation (Kp = Kc(RT)^Δn)',
      variables: ['Kp', 'Kc', 'T', 'dn'],
      equations: {
        'Kp': 'Kc*(0.0821*T)^dn',
        'Kc': 'Kp/((0.0821*T)^dn)',
        'T': '((Kp/Kc)^(1/dn))/0.0821',
        'dn': 'ln(Kp/Kc)/ln(0.0821*T)',
      },
    ),
    Formula(
      id: 'chem1_pcl5_kc',
      name: 'PCl5 Dissociation Kc',
      variables: ['Kc', 'alpha', 'V'],
      equations: {
        'Kc': 'alpha^2/((1-alpha)*V)',
        'alpha': '(-Kc*V+sqrt(Kc^2*V^2+4*Kc*V))/2',
      },
    ),
    Formula(
      id: 'chem1_pcl5_kp',
      name: 'PCl5 Dissociation Kp',
      variables: ['Kp', 'alpha', 'P'],
      equations: {'Kp': 'alpha^2*P/(1-alpha^2)', 'alpha': 'sqrt(Kp/(P+Kp))'},
    ),
    Formula(
      id: 'chem1_n2o4_kp',
      name: 'N2O4 Dissociation Kp',
      variables: ['Kp', 'alpha', 'P'],
      equations: {
        'Kp': '4*alpha^2*P/(1-alpha^2)',
        'alpha': 'sqrt(Kp/(4*P+Kp))',
      },
    ),
    Formula(
      id: 'chem1_kw',
      name: 'Ionic Product of Water (Kw = [H][OH])',
      variables: ['Kw', 'H', 'OH'],
      equations: {'Kw': 'H*OH', 'H': 'Kw/OH', 'OH': 'Kw/H'},
    ),
    Formula(
      id: 'chem1_ostwald_acid',
      name: "Ostwald Dilution Law (Acid)",
      variables: ['Ka', 'alpha', 'C'],
      equations: {
        'Ka': 'alpha^2*C/(1-alpha)',
        'alpha': '(-Ka+sqrt(Ka^2+4*Ka*C))/(2*C)',
        'C': 'Ka*(1-alpha)/(alpha^2)',
      },
    ),
    Formula(
      id: 'chem1_ostwald_acid_approx',
      name: "Ostwald Dilution Law (Acid, α << 1)",
      variables: ['Ka', 'alpha', 'C'],
      equations: {
        'Ka': 'alpha^2*C',
        'alpha': 'sqrt(Ka/C)',
        'C': 'Ka/(alpha^2)',
      },
    ),
    Formula(
      id: 'chem1_ostwald_base',
      name: "Ostwald Dilution Law (Base)",
      variables: ['Kb', 'alpha', 'C'],
      equations: {
        'Kb': 'alpha^2*C/(1-alpha)',
        'alpha': '(-Kb+sqrt(Kb^2+4*Kb*C))/(2*C)',
        'C': 'Kb*(1-alpha)/(alpha^2)',
      },
    ),
    Formula(
      id: 'chem1_ph',
      name: 'pH Definition (pH = -log[H])',
      variables: ['pH', 'H'],
      equations: {'pH': '-log(H)', 'H': '10^(-pH)'},
    ),
    Formula(
      id: 'chem1_poh',
      name: 'pOH Definition (pOH = -log[OH])',
      variables: ['pOH', 'OH'],
      equations: {'pOH': '-log(OH)', 'OH': '10^(-pOH)'},
    ),
    Formula(
      id: 'chem1_ph_poh',
      name: 'pH + pOH = 14',
      variables: ['pH', 'pOH'],
      equations: {'pH': '14-pOH', 'pOH': '14-pH'},
    ),
    Formula(
      id: 'chem1_henderson_acid',
      name: 'Henderson-Hasselbalch (Acid Buffer)',
      variables: ['pH', 'pKa', 'Salt', 'Acid'],
      equations: {
        'pH': 'pKa+log(Salt/Acid)',
        'pKa': 'pH-log(Salt/Acid)',
        'Salt': 'Acid*10^(pH-pKa)',
        'Acid': 'Salt/10^(pH-pKa)',
      },
    ),
    Formula(
      id: 'chem1_henderson_base',
      name: 'Henderson-Hasselbalch (Base Buffer)',
      variables: ['pOH', 'pKb', 'Salt', 'Base'],
      equations: {
        'pOH': 'pKb+log(Salt/Base)',
        'pKb': 'pOH-log(Salt/Base)',
        'Salt': 'Base*10^(pOH-pKb)',
        'Base': 'Salt/10^(pOH-pKb)',
      },
    ),
    Formula(
      id: 'chem1_heat_capacity',
      name: 'Heat Capacity (q = m·s·ΔT)',
      variables: ['q', 'm', 's', 'dT'],
      equations: {
        'q': 'm*s*dT',
        'm': 'q/(s*dT)',
        's': 'q/(m*dT)',
        'dT': 'q/(m*s)',
      },
    ),
    Formula(
      id: 'chem1_bond_enthalpy',
      name: 'Enthalpy from Bond Energies',
      variables: ['dH', 'sum_broken', 'sum_formed'],
      equations: {
        'dH': 'sum_broken-sum_formed',
        'sum_broken': 'dH+sum_formed',
        'sum_formed': 'sum_broken-dH',
      },
    ),
    Formula(
      id: 'chem1_hess_law',
      name: "Hess's Law (ΔH = ΔH1 + ΔH2)",
      variables: ['dH', 'dH1', 'dH2'],
      equations: {'dH': 'dH1+dH2', 'dH1': 'dH-dH2', 'dH2': 'dH-dH1'},
    ),

    // ========== CHAPTER 5: VOCATIONAL CHEMISTRY ==========
    Formula(
      id: 'chem1_water_activity',
      name: 'Water Activity (aw = p/p0)',
      variables: ['aw', 'p', 'p0'],
      equations: {'aw': 'p/p0', 'p': 'aw*p0', 'p0': 'p/aw'},
    ),
  ];
}
