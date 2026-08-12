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

	// C Language linkage : No name mangling

	extern "C" {


	// vec3 addition
	void vec3_add(awsm::vec3* dest, awsm::vec3* v, awsm::vec3* u) noexcept;

	// vec3 cross product
	void cross_product(awsm::vec3* dest, awsm::vec3* v, awsm::vec3* u) noexcept;

	// vec3 dot product
	[[nodiscard]] float vec3_dot(awsm::vec3* v, awsm::vec3* u) noexcept;

	// vec3 subtraction
	void vec3_sub(awsm::vec3* dest, awsm::vec3* v, awsm::vec3* u) noexcept;

	void vec3_scale(awsm::vec3* dest, float s, awsm::vec3* v) noexcept;
	}


}


#endif
