class Node(object):

	def __init__(self, number, name=""):

		self.number = number
		if name:
			self.name = name
		else:
			self.name = "node" + str(number)
		self.neighbours = dict()

	def __str__(self):
		return "Node " + str(self.number) + ": " + self.name

	def add_neighbour(self, node):
		self.neighbours[node.number] = node

	@property
	def get_neighbours(self):
		return self.nodes.values()

class NodeNet(object):

	def __init__(self):
		self.nodes = dict()

	def add_node(self, number, name):
		node = Node(number, name)
		self.nodes[number] = node
		return node

	def get_node(self, number):
		try:
			node = self.nodes[number]
			return node
		except:
			return None

	def get_nodes(self):
		return self.nodes.values()

