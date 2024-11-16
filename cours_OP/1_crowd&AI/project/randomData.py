import functions as func

lat_max : float = 46.20314165553645
lat_min : float = 46.19590023622804
long_max : float = 6.151798416625887
long_min : float = 6.135160930398176
n : int = 500

random_data_set : dict = func.random_data( lat_max, lat_min, long_max, long_min, n)

ds1 : dict = func.random_data( lat_max, lat_min, long_max, long_min, 100)

#clust 1
# 46.199079799094946, 6.139581178874668
# 46.19812183482681, 6.141694759537313
ds2 : dict = func.random_data(
		46.199079799094946,
		46.19812183482681,
		6.141694759537313,
		6.139581178874668,
		150
)

#clust 2
# 46.202912187127644, 6.141605595495715
# 46.20140478256923, 6.138944847099512
ds3 : dict = func.random_data(
		46.202912187127644,
		46.20140478256923,
		6.141605595495715,
		6.138944847099512,
		100
)

# clust 3
# 46.198144436958174, 6.148069161317298
# 46.19741090264836, 6.147467025780619
ds4 : dict = func.random_data(
		46.198144436958174,
		46.19741090264836,
		6.148069161317298,
		6.147467025780619,
		50
)

clusters_data_set : dict = {
		'latitude' : ds1['latitude']+ds2['latitude']+ds3['latitude']+ds4['latitude'],
		'longitude' : ds1['longitude']+ds2['longitude']+ds3['longitude']+ds4['longitude'],
		'density' : ds1['density']+ds2['density']+ds3['density']+ds4['density']
}
