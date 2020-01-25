SHELL=/bin/bash

ALL: build run logf

build:
	docker build . -t test-checkmk
.PHONY: build

run: delete
	docker run -dp 8888:5000 --name cmk8888 test-checkmk
.PHONY: run

stop:
	docker kill cmk8888 || true
.PHONY: stop

delete: stop
	docker rm cmk8888 || true
.PHONY: delete

start:
	docker start cmk8888
.PHONY: start
	
clean: stop delete
	docker rmi test-checkmk || true
	rm -f inspect-*.txt
.PHONY: clean

inspect:
	docker inspect test-checkmk | jq -MS > inspect-mine.txt
	docker inspect checkmk/check-mk-raw:1.6.0p8 | jq -MS > inspect-orig.txt 
.PHONY: inspect

debug: delete
	echo -e "\n\nGO HERE: /opt/omd/sites/cmk/etc/apache\n\n"
	docker run -ti --entrypoint /bin/bash --name debug-checkmk test-checkmk || true
	docker rm debug-checkmk
.PHONY: debug

exec:
	echo -e "\n\nGO HERE: /opt/omd/sites/cmk/etc/apache\n\n"
	docker exec -ti cmk8888 /bin/bash || true
.PHONY: exec

test:
	curl -sv localhost:8888 -H "Host: localhost"         2>&1 | grep -E '(Host|Location):' | grep -v Connected
	curl -sv localhost:8888 -H "Host: check.mk.com"      2>&1 | grep -E '(Host|Location):' | grep -v Connected
	curl -sv localhost:8888 -H "Host: check-me.com:1234" 2>&1 | grep -E '(Host|Location):' | grep -v Connected
.PHONY: test

log:
	docker logs cmk8888
.PHONY: log

logf:
	docker logs -f cmk8888
.PHONY: logf
