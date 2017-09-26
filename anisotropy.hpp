
// anisotropy.hpp
// Anisotropic energy and mobility functions
// Questions/comments to gruberja@gmail.com (Jason Gruber)

#ifndef ANISOTROPY
#define ANISOTROPY
#include<iostream>
#include<cmath>

float energy(int i, int j)
{
	// trivial case: no boundary
	if (i==j) return 0.0;
	return 1.0;
}

double mobility(const double temp)
{
	// Return temperature-dependent mobility, based on Gangulee, J. Appl. Phys. 45 (1974) 3749-3756.
	// M = m0*exp(-Q/RT)
	// Y. Tan implemented this for Potts MC for T=[673,773]K, resulting in M = [0.233,6.11]x10^-14 m^4/J/sec
	// Original constants:
	//	m0 = 2.16e-4; // m^4/J/s
	//	Qm = 141.3; // kJ/mol
	//	kT = 8.314*temp; // J/mol
	double m0 = 2.16e8; // um^4/pJ/s (actually a function of T, but we're neglecting it)
	double A = 75.0; // scaling factor, converting real time to phase-field time
	//double Qm = 141300.0; // J/mol
	//double kT = 8.314*temp; // J/mol
	double QbyR = -16995.43; // K

	return m0*A*exp(QbyR/temp);
}

#endif
