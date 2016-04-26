brng_type = VSL_BRNG_MT19937
println("Testing Uniform with $brng_type...")
brng = BasicRandomNumberGenerator(brng_type, 200701281)

t_uniform = Uniform(brng, VSL_RNG_METHOD_STD, 1.0, 5.0)
Test.@test_approx_eq rand(t_uniform) 2.322448899038136
Test.@test_approx_eq rand(t_uniform, 2, 3) [2.095937419682741 1.384681923314929 3.5385020431131124;
    2.722409107722342 3.2286222940310836 3.492045565508306]

t_uniform_s = Uniform(brng, VSL_RNG_METHOD_STD, 1.0f0, 5.0f0)
Test.@test_approx_eq rand(t_uniform_s) 1.9687817
Test.@test_approx_eq rand(t_uniform_s, 2, 3) Float32[3.6907854 4.696991 1.0887742; 2.5996513 3.0419362 1.6825311]

t_gaussian = Gaussian(brng, VSL_RNG_METHOD_BOXMULLER, 0.0, 2.0)
Test.@test_approx_eq rand(t_gaussian) -0.9735644733742295
Test.@test_approx_eq rand(t_gaussian, 2, 3) [1.6633829486206413 -2.6133352810372648 -0.970663366604635;
    -2.6558179968512556 0.15735047751114864 -0.17643768212765662]

t_gaussianmv = GaussianMV(brng, VSL_RNG_METHOD_BOXMULLER, 3, VSL.VSL_MATRIX_STORAGE_FULL,
                          Float64[1,2,3], Float64[1 2 3; 1 2 3; 1 2 3])
Test.@test_approx_eq rand(t_gaussianmv) [0.3082184760114798,6.300872957078845,7.334694164857175]
Test.@test_approx_eq rand(t_gaussianmv, 2, 2) [[1.923149938750187 -0.3162011679114993;
    2.9480075862554833 1.5239876962852263;
    5.275672885706222 0.45149386428434646] [0.3242650723722491 2.0260891238576626;
    6.385317296018982 5.496315313212104;
    9.489218714523638 6.179406031523525]]
