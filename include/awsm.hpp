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

	struct mat3 {
		vec3 r0, r1{}, r2{};
	};

	struct mat4 {
		vec4 r0{}, r1{}, r2{}, r3{};
	};

	// C Language linkage : No name mangling

	extern "C" {

	////////////////////////////////////////////////////////////////////////////////////////////////////
	//                         vec3 operations                                                        //
	///////////////////////////////////////////////////////////////////////////////////////////////////

	// vec3 addition
	void vec3_add(awsm::vec3& dest, awsm::vec3& v, awsm::vec3& u) noexcept;

	// vec3 cross product
	void cross_product(awsm::vec3& dest, awsm::vec3& v, awsm::vec3& u) noexcept;

	// vec3 dot product
	[[nodiscard]] float vec3_dot(awsm::vec3 v, awsm::vec3& u) noexcept;

	// vec3 normalize : ||dest||==1
	void vec3_normalize(awsm::vec3& dest, awsm::vec3& v) noexcept;

	// vec3 reflect
	void vec3_reflect(awsm::vec3& dest, awsm::vec3& incident, awsm::vec3& normal) noexcept;

	// vec3 refract : r
	void vec3_refract(awsm::vec3& dest, awsm::vec3& incident, awsm::vec3& normal, float eta) noexcept;

	// Rotate a vector clock-wise : Trait-Brian angles(radian) x,y,z
	void vec3_rotate(awsm::vec3& dest, awsm::vec3& v, awsm::vec3& angles) noexcept;

	// vec3 subtraction
	void vec3_sub(awsm::vec3& dest, awsm::vec3& v, awsm::vec3& u) noexcept;

	// vec3 scale : scale a vector by factor 's'
	void vec3_scale(awsm::vec3& dest, float s, awsm::vec3& v) noexcept;


	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	//                               vec4 operations                                                        //
	/////////////////////////////////////////////////////////////////////////////////////////////////////////

	// vec4 addition : dest = v + u;
	void vec4_add(awsm::vec4& dest, awsm::vec4& v, awsm::vec4& u) noexcept;

	// vec4 dot product
	[[nodiscard]] float vec4_dot(awsm::vec4 v, awsm::vec4& u) noexcept;

	// vec4 subtraction
	void vec4_sub(awsm::vec4& dest, awsm::vec4& v, awsm::vec4 u) noexcept;

	// vec4 scale : scale a vector by factor 's'
	void vec4_scale(awsm::vec4& dest, float s, awsm::vec4& v) noexcept;



	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	//                              mat3x3 operations                                                      //
	////////////////////////////////////////////////////////////////////////////////////////////////////////


	// Mat3x3 Addition : dest = m1 + m2;
	void mat3_add(awsm::mat3& dest, awsm::mat3& m1, awsm::mat3& m2) noexcept;

	// Matrix Multiplication : dest = m1 x traspose(m2)  -> One of those matrices must be transposed first
	void mat3_mul(awsm::mat3& dest, awsm::mat3& m1, awsm::mat3& m2) noexcept;

	// Mat3x3 multiplied by Vec3(Mat3x1)
	void mat3_mulv(awsm::vec3& dest, awsm::mat3& matrix, awsm::vec3& vec) noexcept;

	void mat3_scale(awsm::mat3& dest, float s, awsm::mat3& m) noexcept;

	// Mat3x3 Subtract : dest=m1-m2;
	void mat3_sub(awsm::mat3& dest, awsm::mat3& m1, awsm::mat3& m2) noexcept;



	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	//                              mat4x4 operations                                                      //
	////////////////////////////////////////////////////////////////////////////////////////////////////////

	// Mat4x4 Addition : dest = m1 + m2;
	void mat4_add(awsm::mat4& dest, awsm::mat4& m1, awsm::mat4& m2) noexcept;

	// Matrix Multiplication : dest = m1 x traspose(m2)  -> One of those matrices must be transposed first
	void mat4_mul(awsm::mat4& dest, awsm::mat3& m1, awsm::mat4& m2) noexcept;

	// Mat4x4 multiplied by Vec4(Mat4x1)
	void mat4_mulv(awsm::vec4& dest, awsm::mat4& matrix, awsm::vec4& vec) noexcept;

	// Scale a matrix by factor of 's'
	void mat4_scale(awsm::mat4& dest, float s, awsm::mat4& m) noexcept;

	// Mat4x4 Subtract : dest=m1-m2;
	void mat4_sub(awsm::mat4& dest, awsm::mat4& m1, awsm::mat4& m2) noexcept;
	}


}

// AUTHOR - ArcShahi

#endif
