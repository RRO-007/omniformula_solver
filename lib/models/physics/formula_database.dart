import '../formula.dart';

class FormulaDatabase {
  static final List<Formula> physicsFormulas = [
    // ============ KINEMATICS ============
    Formula(id: 'kin_1', name: 'Kinematics: v = u + at', variables: ['v', 'u', 'a', 't'],
      equations: {'v': 'u + a * t', 'u': 'v - a * t', 'a': '(v - u) / t', 't': '(v - u) / a'}),
    Formula(id: 'kin_2', name: 'Kinematics: v² = u² + 2as', variables: ['v', 'u', 'a', 's'],
      equations: {'v': 'sqrt(u^2 + 2*a*s)', 'u': 'sqrt(v^2 - 2*a*s)', 'a': '(v^2 - u^2)/(2*s)', 's': '(v^2 - u^2)/(2*a)'}),
    Formula(id: 'kin_3', name: 'Kinematics: s = ut + ½at²', variables: ['s', 'u', 'a', 't'],
      equations: {'s': 'u*t + 0.5*a*t^2', 'u': '(s - 0.5*a*t^2)/t', 'a': '(2*(s - u*t))/(t^2)'}),
    Formula(id: 'kin_4', name: 'Kinematics: s = ((u+v)/2)·t', variables: ['s', 'u', 'v', 't'],
      equations: {'s': '((u + v)/2)*t', 'u': '(2*s/t) - v', 'v': '(2*s/t) - u', 't': '(2*s)/(u + v)'}),

    // ============ DYNAMICS ============
    Formula(id: 'force', name: 'Force: F = ma', variables: ['F', 'm', 'a'],
      equations: {'F': 'm*a', 'm': 'F/a', 'a': 'F/m'}),
    Formula(id: 'momentum', name: 'Momentum: p = mv', variables: ['p', 'm', 'v'],
      equations: {'p': 'm*v', 'm': 'p/v', 'v': 'p/m'}),
    Formula(id: 'work', name: 'Work: W = Fd', variables: ['W', 'F', 'd'],
      equations: {'W': 'F*d', 'F': 'W/d', 'd': 'W/F'}),
    Formula(id: 'kinetic_energy', name: 'Kinetic Energy: KE = ½mv²', variables: ['KE', 'm', 'v'],
      equations: {'KE': '0.5*m*v^2', 'm': '(2*KE)/(v^2)', 'v': 'sqrt((2*KE)/m)'}),
    Formula(id: 'potential_energy', name: 'Potential Energy: PE = mgh', variables: ['PE', 'm', 'g', 'h'],
      equations: {'PE': 'm*g*h', 'm': 'PE/(g*h)', 'g': 'PE/(m*h)', 'h': 'PE/(m*g)'}),
    Formula(id: 'power', name: 'Power: P = W/t', variables: ['P', 'W', 't'],
      equations: {'P': 'W/t', 'W': 'P*t', 't': 'W/P'}),

    // ============ HSC: VECTORS & PROJECTILE ============
    Formula(id: 'vector_perp', name: 'Perpendicular Vectors: R = √(P² + Q²)', variables: ['R', 'P', 'Q'],
      equations: {'R': 'sqrt(P^2 + Q^2)', 'P': 'sqrt(R^2 - Q^2)', 'Q': 'sqrt(R^2 - P^2)'}),
    Formula(id: 'vector_max', name: 'Max Resultant (parallel): R = P + Q', variables: ['R', 'P', 'Q'],
      equations: {'R': 'P + Q', 'P': 'R - Q', 'Q': 'R - P'}),
    Formula(id: 'projectile_range', name: 'Projectile Range: R = u²sin(2θ)/g', variables: ['R', 'u', 'theta', 'g'],
      equations: {'R': '(u^2 * sin(2*theta))/g', 'u': 'sqrt((R*g)/sin(2*theta))'}),
    Formula(id: 'projectile_max_height', name: 'Projectile Max Height: H = u²sin²(θ)/2g', variables: ['H', 'u', 'theta', 'g'],
      equations: {'H': '(u^2 * sin(theta)^2)/(2*g)', 'u': 'sqrt((2*g*H)/(sin(theta)^2))'}),
    Formula(id: 'projectile_time', name: 'Projectile Time of Flight: T = 2u·sin(θ)/g', variables: ['T', 'u', 'theta', 'g'],
      equations: {'T': '(2*u*sin(theta))/g', 'u': '(T*g)/(2*sin(theta))'}),

    // ============ HSC: CIRCULAR MOTION ============
    Formula(id: 'circ_vel', name: 'Circular: v = 2πr/T', variables: ['v', 'r', 'T'],
      equations: {'v': '(2*3.14159*r)/T', 'r': '(v*T)/(2*3.14159)', 'T': '(2*3.14159*r)/v'}),
    Formula(id: 'centripetal_a', name: 'Centripetal Accel: a = v²/r', variables: ['a', 'v', 'r'],
      equations: {'a': '(v^2)/r', 'v': 'sqrt(a*r)', 'r': '(v^2)/a'}),
    Formula(id: 'banking', name: 'Banking Angle: tan(θ) = v²/(rg)', variables: ['theta', 'v', 'r', 'g'],
      equations: {'theta': 'atan((v^2)/(r*g))', 'v': 'sqrt(tan(theta)*r*g)', 'r': '(v^2)/(tan(theta)*g)'}),

    // ============ HSC: GRAVITATION ============
    Formula(id: 'gravity', name: 'Universal Gravitation: F = Gm₁m₂/r²', variables: ['F', 'm1', 'm2', 'r'],
      equations: {'F': '(6.674e-11*m1*m2)/(r^2)', 'r': 'sqrt((6.674e-11*m1*m2)/F)'}),
    Formula(id: 'gravity_altitude', name: 'Gravity at Altitude: g_h = g(1 - 2h/R)', variables: ['gh', 'g', 'h'],
      equations: {'gh': 'g*(1 - (2*h)/6371000)', 'h': '((1 - gh/g) * 6371000)/2'}),
    Formula(id: 'gravity_depth', name: 'Gravity at Depth: g_d = g(1 - d/R)', variables: ['gd', 'g', 'd'],
      equations: {'gd': 'g*(1 - d/6371000)', 'd': '(1 - gd/g) * 6371000'}),

    // ============ HSC: THERMODYNAMICS ============
    Formula(id: 'heat', name: 'Heat: Q = mcΔT', variables: ['Q', 'm', 'c', 'dT'],
      equations: {'Q': 'm*c*dT', 'm': 'Q/(c*dT)', 'c': 'Q/(m*dT)', 'dT': 'Q/(m*c)'}),
    Formula(id: 'ideal_gas', name: 'Ideal Gas: PV = nRT', variables: ['P', 'V', 'n', 'T'],
      equations: {'P': '(n*8.314*T)/V', 'V': '(n*8.314*T)/P', 'n': '(P*V)/(8.314*T)', 'T': '(P*V)/(n*8.314)'}),
    Formula(id: 'work_isothermal', name: 'Isothermal Work: W = nRT·ln(V₂/V₁)', variables: ['W', 'n', 'T', 'V1', 'V2'],
      equations: {'W': 'n*8.314*T*ln(V2/V1)', 'T': 'W/(n*8.314*ln(V2/V1))'}),
    Formula(id: 'efficiency', name: 'Carnot Efficiency: η = 1 - T_c/T_h', variables: ['eta', 'Tc', 'Th'],
      equations: {'eta': '1 - Tc/Th', 'Tc': 'Th*(1 - eta)', 'Th': 'Tc/(1 - eta)'}),

    // ============ WAVES & OPTICS ============
    Formula(id: 'wave', name: 'Wave: v = fλ', variables: ['v', 'f', 'lambda'],
      equations: {'v': 'f*lambda', 'f': 'v/lambda', 'lambda': 'v/f'}),
    Formula(id: 'period', name: 'Period: T = 1/f', variables: ['T', 'f'],
      equations: {'T': '1/f', 'f': '1/T'}),
    Formula(id: 'lens', name: 'Lens Formula: 1/f = 1/v + 1/u', variables: ['f', 'v', 'u'],
      equations: {'f': '1/((1/v) + (1/u))', 'v': '1/((1/f) - (1/u))', 'u': '1/((1/f) - (1/v))'}),

    // ============ ELECTRICITY ============
    Formula(id: 'ohms_law', name: "Ohm's Law: V = IR", variables: ['V', 'I', 'R'],
      equations: {'V': 'I*R', 'I': 'V/R', 'R': 'V/I'}),
    Formula(id: 'electric_power', name: 'Electric Power: P = VI', variables: ['P', 'V', 'I'],
      equations: {'P': 'V*I', 'V': 'P/I', 'I': 'P/V'}),
    Formula(id: 'charge', name: 'Charge: Q = It', variables: ['Q', 'I', 't'],
      equations: {'Q': 'I*t', 'I': 'Q/t', 't': 'Q/I'}),
    Formula(id: 'resistance_wire', name: 'Resistance: R = ρL/A', variables: ['R', 'rho', 'L', 'A'],
      equations: {'R': '(rho*L)/A', 'rho': '(R*A)/L', 'L': '(R*A)/rho', 'A': '(rho*L)/R'}),
    Formula(id: 'capacitor', name: 'Capacitor: C = Q/V', variables: ['C', 'Q', 'V'],
      equations: {'C': 'Q/V', 'Q': 'C*V', 'V': 'Q/C'}),

    // ============ QUANTUM ============
    Formula(id: 'photon_energy', name: 'Photon Energy: E = hf', variables: ['E', 'f'],
      equations: {'E': '6.626e-34*f', 'f': 'E/6.626e-34'}),
    Formula(id: 'mass_energy', name: 'Mass-Energy: E = mc²', variables: ['E', 'm'],
      equations: {'E': 'm*(3e8)^2', 'm': 'E/((3e8)^2)'}),
    Formula(id: 'de_broglie', name: 'De Broglie: λ = h/(mv)', variables: ['lambda', 'm', 'v'],
      equations: {'lambda': '(6.626e-34)/(m*v)', 'm': '(6.626e-34)/(lambda*v)', 'v': '(6.626e-34)/(lambda*m)'}),

        // ============ HSC: MORE THERMODYNAMICS ============
    Formula(id: 'work_adiabatic', name: 'Adiabatic Work: W = nR(T₁-T₂)/(γ-1)', variables: ['W', 'n', 'T1', 'T2', 'gamma'],
      equations: {'W': '(n*8.314*(T1-T2))/(gamma-1)', 'T1': '((W*(gamma-1))/(n*8.314)) + T2', 'T2': 'T1 - (W*(gamma-1))/(n*8.314)'}),
    Formula(id: 'carnot_cop', name: 'Carnot COP: COP = T_c/(T_h - T_c)', variables: ['COP', 'Tc', 'Th'],
      equations: {'COP': 'Tc/(Th - Tc)', 'Tc': '(COP*Th)/(1 + COP)', 'Th': '(Tc/COP) + Tc'}),

    // ============ HSC: CIRCUITS ============
    Formula(id: 'wheatstone', name: 'Wheatstone Bridge: P/Q = R/S', variables: ['P', 'Q', 'R', 'S'],
      equations: {'P': '(Q*R)/S', 'Q': '(P*S)/R', 'R': '(P*S)/Q', 'S': '(Q*R)/P'}),
    Formula(id: 'series_resistance', name: 'Series Resistance: R = R₁+R₂+R₃', variables: ['R', 'R1', 'R2', 'R3'],
      equations: {'R': 'R1 + R2 + R3', 'R1': 'R - R2 - R3'}),
    Formula(id: 'parallel_resistance', name: 'Parallel: 1/R = 1/R₁ + 1/R₂', variables: ['R', 'R1', 'R2'],
      equations: {'R': '1/((1/R1) + (1/R2))', 'R1': '1/((1/R) - (1/R2))', 'R2': '1/((1/R) - (1/R1))'}),
    Formula(id: 'kirchhoff_charge', name: 'Kirchhoff (Charge): ΣI_in = ΣI_out', variables: ['Iin', 'Iout'],
      equations: {'Iin': 'Iout', 'Iout': 'Iin'}),
    Formula(id: 'kirchhoff_energy', name: 'Kirchhoff (Energy): ΣV = 0 (loop)', variables: ['V1', 'V2', 'V3'],
      equations: {'V3': 'V1 + V2'}),

    // ============ HSC: MAGNETIC & EMI ============
    Formula(id: 'lorentz_force', name: 'Lorentz Force: F = qvB', variables: ['F', 'q', 'v', 'B'],
      equations: {'F': 'q*v*B', 'q': 'F/(v*B)', 'v': 'F/(q*B)', 'B': 'F/(q*v)'}),
    Formula(id: 'magnetic_flux', name: 'Magnetic Flux: Φ = BA', variables: ['Phi', 'B', 'A'],
      equations: {'Phi': 'B*A', 'B': 'Phi/A', 'A': 'Phi/B'}),
    Formula(id: 'emf_induced', name: 'Faraday EMF: ε = -N·ΔΦ/Δt', variables: ['emf', 'N', 'dPhi', 'dt'],
      equations: {'emf': '-N*(dPhi/dt)', 'N': '-emf*dt/dPhi', 'dPhi': '-emf*dt/N'}),

    // ============ HSC: SHM & WAVES ============
    Formula(id: 'shm_period', name: 'SHM Period: T = 2π√(m/k)', variables: ['T', 'm', 'k'],
      equations: {'T': '2*3.14159*sqrt(m/k)', 'm': 'k*(T/(2*3.14159))^2', 'k': 'm/((T/(2*3.14159))^2)'}),
    Formula(id: 'pendulum', name: 'Pendulum: T = 2π√(L/g)', variables: ['T', 'L', 'g'],
      equations: {'T': '2*3.14159*sqrt(L/g)', 'L': 'g*(T/(2*3.14159))^2', 'g': 'L/((T/(2*3.14159))^2)'}),
    Formula(id: 'doppler', name: 'Doppler: f\' = f(v±v_o)/(v∓v_s)', variables: ['f_prime', 'f', 'v', 'v_obs', 'v_src'],
      equations: {'f_prime': 'f*(v + v_obs)/(v - v_src)'}),  
  ];
}