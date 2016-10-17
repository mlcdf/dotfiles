.PHONY: all install bootstrap

all:
	install bootstrap

install:
	./install.sh

bootstrap:
	./bootstrap.sh

backup:
	mkdir -p ~/migration/home
	cp ~/.z ~/migration/home

	cp -R ~/.ssh ~/migration/home
	cp -R ~/.gnupg ~/migration/home

	cp -R ~/Documents ~/migration
	cp -R ~/Pictures ~/migration
