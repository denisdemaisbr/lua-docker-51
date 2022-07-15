TAG=mylua
PWD=(shell pwd)... /lua51


all:
	mkdir -p app
	mkdir -p out
	cp -f hello.lua app
	docker build -t $(TAG) .
	docker run --rm                                                    --name my $(TAG) lua -v
	docker run --rm                                                    --name my $(TAG) luac -v
	docker run --rm -w /app -v $(PWD)/app:/app                         --name my $(TAG) lua hello.lua
	docker run --rm -w /app -v $(PWD)/app:/app -v $(PWD)/out:/out --rm --name my mylua luac -s -o /out/hello.32 /app/hello.lua
	ls -1 $(PWD)/out
	ls -1 $(PWD)/app


# lua ubuntu/host (64-bit)
lua: deps
	sudo apt-get install libreadline-gplv2-dev
	sudo apt-get install libncurses5-dev libncursesw5-dev
	wget -O lua-5.1.5.tar.gz https://www.lua.org/ftp/lua-5.1.5.tar.gz
	rm -fr lua-5.1.5
	tar zxf lua-5.1.5.tar.gz
	$(MAKE) -C lua-5.1.5 clean
	$(MAKE) -C lua-5.1.5 linux
	cp -f lua-5.1.5/src/lua .
	cp -f lua-5.1.5/src/luac .
	rm -fr lua-5.1.5
	rm -f lua-5.1.5.tar.gz


# compare
cmp:
	./luac -o out/hello.64 app/hello.lua
	xxd out/hello.64
	xxd out/hello.32

