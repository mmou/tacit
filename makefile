all:
	coffee -c assets/js/*.coffee
	coffee -c assets/js/*/*.coffee
	coffee -c assets/js/*/*/*.coffee
