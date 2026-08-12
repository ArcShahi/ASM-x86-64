#ifndef AWSM_HPP
#define AWSM_HPP

// Sample header

namespace awsm {

	struct alignas(16) vec3 {
		float x{}, y{}, z{};
	};

	struct alignas(16) vec4 {
		float x{}, y{}, z{}, w{};
	};

	// 3x3 Matrix : Row-major
	struct max3x3 {
		vec3 r[3]{};
	};

	struct mat4x4 {
		vec4 r[4]{};
	};

	// Function declaration

	// vec3 addition
	extern "C" void vec3_add(awsm::vec3* dest, awsm::vec3* v, awsm::vec3* u);

	// vec3 dot product
	extern "C" float vec3_dot(awsm::vec3* v, awsm::vec3* u);
}


#endif
