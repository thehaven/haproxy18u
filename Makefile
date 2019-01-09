HOME=$(shell pwd)
VERSION=1.9.1
RELEASE=1

all: build

clean:
	rm -rf ./rpmbuild
	mkdir -p ./rpmbuild/SPECS/ ./rpmbuild/SOURCES/

install-prerequisites:
	sudo yum install -y rpmdevtools pcre-devel openssl-devel zlib-devel lua53u-devel systemd-devel
	sudo yum install -y gcc libtool patch patchutils redhat-rpm-config rpm-build systemtap

download-upstream:
	test -s $(PWD)/SOURCES/haproxy-$(VERSION).tar.gz || wget -O $(PWD)/SOURCES/haproxy-$(VERSION).tar.gz http://www.haproxy.org/download/1.9/src/haproxy-$(VERSION).tar.gz

build: clean install-prerequisites download-upstream
	mkdir -p ./SPECS/ ./SOURCES/
	cp -r ./SPECS/* ./rpmbuild/SPECS/ || true
	cp -r ./SOURCES/* ./rpmbuild/SOURCES/ || true
	rpmbuild -ba SPECS/haproxy19u.spec \
	--define "version ${VERSION}" \
	--define "release ${RELEASE}" \
	--define "_topdir %(pwd)/rpmbuild" \
	--define "_builddir %{_topdir}" \
	--define "_rpmdir %{_topdir}" \
	--define "_srcrpmdir %{_topdir}"
