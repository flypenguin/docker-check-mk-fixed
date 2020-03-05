FROM checkmk/check-mk-raw:1.6.0p9

COPY new-entrypoint.sh fix-docker.sh /
ENTRYPOINT ["/new-entrypoint.sh"]

