brng_type = VSL_BRNG_MT19937
println("Testing Uniform with $brng_type...")
brng = BasicRandomNumberGenerator(brng_type, 200701281)
t_uniform = Uniform(brng, VSL_RNG_METHOD_STD, 1.0, 5.0)
Test.@test_approx_eq rand(t_uniform) 2.322448899038136
Test.@test_approx_eq rand(t_uniform, 10) [2.095937419682741, 2.722409107722342, 1.384681923314929, 3.2286222940310836,
    3.5385020431131124, 3.492045565508306, 1.9687817562371492, 3.690785413607955, 2.5996512761339545, 4.69699069019407]
Test.@test_approx_eq rand(t_uniform, 2, 3) [3.0419360622763634 1.6825310532003641 4.629723406396806;
    1.0887741530314088 3.7013560943305492 3.7430916549637914]
t_uniform_s = Uniform(brng, VSL_RNG_METHOD_STD, 1.0f0, 5.0f0)
Test.@test_approx_eq rand(t_uniform_s) 2.186183
Test.@test_approx_eq rand(t_uniform_s, 10) Float32[1.3960528, 3.4236805, 2.4837372, 4.2433987, 3.4296734, 2.9497883,
    1.877209, 4.8202567, 4.904007, 3.2621489]
Test.@test_approx_eq rand(t_uniform_s, 2, 3) Float32[3.242768 1.0435851 4.1186557; 4.5553055 1.7886127 4.0003376]
