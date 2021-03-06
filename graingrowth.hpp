// graingrowth.cpp
// Anisotropic sparse phase field (sparsePF) grain growth example code
// Questions/comments to gruberja@gmail.com (Jason Gruber)

std::string PROGRAM = "graingrowth";
std::string MESSAGE = "Sparse phase field (sparsePF) grain growth code with vertex drag";

typedef MMSP::grid<1,MMSP::sparse<float> > GRID1D;
typedef MMSP::grid<2,MMSP::sparse<float> > GRID2D;
typedef MMSP::grid<3,MMSP::sparse<float> > GRID3D;

