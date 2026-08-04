#ifdef AWSM_HPP
#define AWSM_HPP

namespace awsm {

struct alignas(16) Vec3 {
  float x{},y{},z{};
};

struct alignas(16) Vec4 {
  
  float x{},y{},z{},w{};
};
  
// 3x3 Matrix : Row-major
struct Max3x3 {
  
  Vec3 r[3]{};
};

struct Mat4x4 {
  
  Vec4 r[4]{};  
};

// TODO : Add function forward delclaration

}

#endif 
