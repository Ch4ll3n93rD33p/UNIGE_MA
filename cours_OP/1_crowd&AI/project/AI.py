import functions as func
from randomData import random_data_set, clusters_data_set


''' ------------------------------- Our data set ------------------------------- '''

data_set : dict = func.load_data('form-1__a.json')
func.display_on_map(data_set)

X : func.np.ndarray = func.prep_data(data_set)

# AP
centroids_ap : func.np.ndarray = func.affinity_propagation(X)
res_ap : dict = func.format_res(centroids_ap)
func.display_on_map(data_set, res_ap)

# MBK
centroids_mbk : func.np.ndarray = func.mini_batch_Kmeans(X)
res_mbk : dict = func.format_res(centroids_mbk)
func.display_on_map(data_set, res_mbk)

# AC
centroids_ac : func.np.ndarray = func.agglomerative_clustering(X)
res_ac : dict = func.format_res(centroids_ac)
func.display_on_map(data_set, res_ac)

# AC with distance constraint
centroids_ac_dist : func.np.ndarray = func.agglomerative_clustering(X, n_cluster = None, distance_threshold = 0.0075) # env 500m distance
res_ac_dist : dict = func.format_res(centroids_ac_dist)
func.display_on_map(data_set, res_ac_dist)

''' ----------------------------- Random data set ----------------------------- '''

func.display_on_map(random_data_set)

X_rand : func.np.ndarray = func.prep_data(random_data_set)

# AP -> doesn't converge
#centroids_ap : func.np.ndarray = func.affinity_propagation(X_rand)
#res_ap : dict = func.format_res(centroids_ap)
#func.display_on_map(random_data_set, res_ap)

# MBK
centroids_mbk : func.np.ndarray = func.mini_batch_Kmeans(X_rand)
res_mbk : dict = func.format_res(centroids_mbk)
func.display_on_map(random_data_set, res_mbk)

# AC
centroids_ac : func.np.ndarray = func.agglomerative_clustering(X_rand)
res_ac : dict = func.format_res(centroids_ac)
func.display_on_map(random_data_set, res_ac)

# AC with distance constraint
centroids_ac_dist : func.np.ndarray = func.agglomerative_clustering(X_rand, n_cluster = None, distance_threshold = 0.0075) # env 500m distance
res_ac_dist : dict = func.format_res(centroids_ac_dist)
func.display_on_map(random_data_set, res_ac_dist)



''' ---------------------------- Clustered data set ---------------------------- '''

func.display_on_map(clusters_data_set)

X_clust : func.np.ndarray = func.prep_data(clusters_data_set)

#AP -> doesn't converge
#centroids_ap : func.np.ndarray = func.affinity_propagation(X_clust)
#res_ap : dict = func.format_res(centroids_ap)
#func.display_on_map(clusters_data_set, res_ap)

# MBK
centroids_mbk : func.np.ndarray = func.mini_batch_Kmeans(X_clust)
res_mbk : dict = func.format_res(centroids_mbk)
func.display_on_map(clusters_data_set, res_mbk)

# AC
centroids_ac : func.np.ndarray = func.agglomerative_clustering(X_clust)
res_ac : dict = func.format_res(centroids_ac)
func.display_on_map(clusters_data_set, res_ac)

# AC with distance constraint
centroids_ac_dist : func.np.ndarray = func.agglomerative_clustering(X_clust, n_cluster = None, distance_threshold = 0.0075) # env 500m distance
res_ac_dist : dict = func.format_res(centroids_ac_dist)
func.display_on_map(clusters_data_set, res_ac_dist)

print('OK')
