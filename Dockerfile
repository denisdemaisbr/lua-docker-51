# https://github.com/MilesChou/docker-lua

# 64-bit
FROM alpine:3.12

# 32-bit
#FROM i386/alpine:3.14
RUN echo "x86" > /etc/apk/arch

# Set environment
ENV LUA_VERSION=5.1.5 \
LUAROCKS_VERSION=3.4.0

# Install dependency packages
RUN set -xe && \
	apk add --no-cache --virtual .build-deps \
		curl \
		gcc \
		g++ \
		libc-dev \
		make \
		readline-dev \
	&& \
	apk add --no-cache \
		readline \
	&& \
	# Install Lua
	wget http://www.lua.org/ftp/lua-${LUA_VERSION}.tar.gz && \
	tar zxf lua-${LUA_VERSION}.tar.gz && rm -f lua-${LUA_VERSION}.tar.gz && \
	cd lua-${LUA_VERSION} && \
	make -j $(getconf _NPROCESSORS_ONLN) linux && make install && \
	cd / && rm -rf lua-${LUA_VERSION} && \
	# Install LuaRocks
	wget https://luarocks.org/releases/luarocks-${LUAROCKS_VERSION}.tar.gz && \
	tar zxf luarocks-${LUAROCKS_VERSION}.tar.gz && rm -f luarocks-${LUAROCKS_VERSION}.tar.gz && \
	cd luarocks-${LUAROCKS_VERSION} && \
	./configure && \
	make -j $(getconf _NPROCESSORS_ONLN) build && make install && \
	cd / && rm -rf luarocks-${LUAROCKS_VERSION} && \
	# Remove all build deps
	apk del .build-deps && \
	# Test
	lua -v


