ARG OMEROWEB_BASE_IMAGE=openmicroscopy/omero-web-standalone:5
FROM $OMEROWEB_BASE_IMAGE

USER root
RUN /opt/omero/web/venv3/bin/pip install parade-crossfilter
USER omero-web
RUN /opt/omero/web/venv3/bin/omero config append omero.web.apps '"parade_crossfilter"'
RUN /opt/omero/web/venv3/bin/omero config append omero.web.open_with '["Parade", "parade_crossfilter_index", {"supported_objects": ["project", "screen"]}]'