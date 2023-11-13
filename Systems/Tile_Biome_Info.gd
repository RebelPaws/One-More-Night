extends MeshInstance3D

#This holds biome info which makes customizing each biome very easy and lightweight
#Especially once modding becomes a thing

@export_group("Spawnable Objects") ##This puts all decor objects into a group we can look out for
@export var decor : Array[PackedScene] ##The decor items that can spawn
@export var chance_of_decor : float ##The chance the biome has at spawning a decor item

