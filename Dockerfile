FROM checkmk/check-mk-raw:1.6.0p8

COPY new-entrypoint.sh fix-docker.sh /
ENTRYPOINT ["/new-entrypoint.sh"]

