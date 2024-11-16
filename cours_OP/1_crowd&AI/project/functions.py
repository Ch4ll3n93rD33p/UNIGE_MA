import json
import plotly.express as px
import plotly.graph_objects as go
import numpy as np
import random
import sklearn.cluster as cluster
import sklearn.neighbors as neighbors
from typing import Optional, NoReturn

def load_data(filename : str) -> dict :
	''' function that load data from the json file of epicollect5 '''

	with open(filename, 'r') as json_file :

		json_load : dict = json.load(json_file)

		data_set : dict = {'latitude' : [], 'longitude' : [], 'density' : []}
		for i in range(len(json_load["data"])) :

			data_set['latitude'].append(json_load["data"][i]['1_O_tesvous_']['latitude'])
			data_set['longitude'].append(json_load["data"][i]['1_O_tesvous_']['longitude'])
			data_set['density'].append(json_load["data"][i]['2_Environ_combien_de'])

	return data_set

def random_data(lat_max : float, lat_min : float, long_max : float, long_min : float, n : int) -> dict :
	''' function that creates n random data located in a certain zone '''

	data_set : dict = {'latitude' : [], 'longitude' : [], 'density' : []}
	for i in range(n) :

		data_set['latitude'].append(random.uniform(lat_min, lat_max))
		data_set['longitude'].append(random.uniform(long_min, long_max))
		data_set['density'].append(random.randint(1, 5))

	return data_set

def prep_data(data_set : dict) -> np.ndarray :
	''' function that transform the data in a np.array '''

	X : list = []
	for i in range(len(data_set['latitude'])) :
		for j in range(data_set['density'][i]) :

			X.append([data_set['latitude'][i], data_set['longitude'][i]])

	return np.array(X)

def display_on_map(data_set : dict, res : Optional[dict] = None ) -> NoReturn :
	''' function that displays locations on a map '''

	# colors based on density
	colo : list = []
	c : list = ['rgb(97, 163, 255)', 'rgb(2, 122, 255)', 'rgb(0, 84, 175)', 'rgb(2, 58, 121)', 'rgb(2, 33, 72)']
	for i in data_set['density'] :

		colo.append(c[i-1])

	mapbox_access_token : str = open(".mapbox_token").read()

	# display poop locations
	fig : go._figure.Figure = go.Figure(go.Scattermapbox(
        lat = data_set['latitude'],
        lon = data_set['longitude'],
        mode = 'markers',
        marker = go.scattermapbox.Marker(
            size = 9,
			color = colo
        ),
        text = data_set['density'],
		name = 'dog faeces '
    ))

    # if there is one we display the result set
	if res != None :

		fig.add_trace(go.Scattermapbox(
        	lat = res['latitude'],
        	lon = res['longitude'],
        	mode = 'markers',
        	marker = go.scattermapbox.Marker(
            	size = 6,
            	color = 'rgb(255, 0, 0)'
        	),
			name = 'dispensers'
    	))

    # plot the map
	fig.update_layout(
    	hovermode = 'closest',
    	mapbox = dict(
        	accesstoken = mapbox_access_token,
        	bearing = 0,
        	center = go.layout.mapbox.Center(
            	lat = 46.204733695135175,
            	lon = 6.139826523753949
        	),
        	pitch = 0,
        	zoom = 5
    	)
	)

	fig.show()

def affinity_propagation(X : np.ndarray) -> np.ndarray :
	''' functions that implements AP and returns centroids of the clusters '''

	model : cluster._affinity_propagation.AffinityPropagation = cluster.AffinityPropagation(damping = 0.5, random_state = 0)
	model.fit(X)
	Y : np.ndarray = model.labels_

	nc : neighbors._nearest_centroid.NearestCentroid = neighbors.NearestCentroid()
	centroids : np.ndarray = nc.fit(X, Y).centroids_

	return centroids

def mini_batch_Kmeans(X : np.ndarray) -> np.ndarray :
	''' functions that implements MBK and returns centroids of the clusters '''

	model : cluster._kmeans.MiniBatchKMeans = cluster.MiniBatchKMeans(init = "k-means++")
	model.fit(X)
	Y : np.ndarray = model.labels_

	nc : neighbors._nearest_centroid.NearestCentroid = neighbors.NearestCentroid()
	centroids : np.ndarray = nc.fit(X, Y).centroids_

	return centroids

def agglomerative_clustering(X : np.ndarray, n_cluster : Optional[int] = 8, distance_threshold : Optional[float] = None) -> np.ndarray :
	''' functions that implements AC and returns centroids of the clusters '''

	model : cluster._agglomerative.AgglomerativeClustering = cluster.AgglomerativeClustering(n_clusters = n_cluster, distance_threshold = distance_threshold)
	model.fit(X)
	Y : np.ndarray = model.labels_

	nc : neighbors._nearest_centroid.NearestCentroid = neighbors.NearestCentroid()
	centroids : np.ndarray = nc.fit(X, Y).centroids_

	return centroids

def format_res(Y : np.ndarray) -> dict :
	''' function that transforms the results in a dict '''

	res : dict = {'latitude' : [], 'longitude' : []}
	for i in Y :

		res['latitude'].append(i[0])
		res['longitude'].append(i[1])

	return res
