angular.module 'pacman.services', []
angular.module 'pacman.controllers', []
angular.module 'pacman.directives', []

app = angular.module 'ngPacman', [

	'pacman.services',
	'pacman.controllers',
	'pacman.directives'

]