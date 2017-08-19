VER=$(shell grep Version control | cut -c 10-)
DIST_NAME=ezdk-1.8.0_131-8.21.0.57-eval-linux_aarch32sf
TGZ_NAME=${DIST_NAME}.tar.gz
IPK_NAME=zulu-jre_${VER}_cortexa9-vfpv3.ipk
FETCH_SITE=http://cdn.azul.com/zulu-embedded/bin

.PHONY: all clean fetch ipk

ipk: ${IPK_NAME}

all:
	$(MAKE) clean
	$(MAKE) ipk

clean:
	rm -f control.tar.gz
	rm -f data.tar.gz
	rm -f debian-binary
	rm -f ${IPK_NAME}
	rm -rf data

fetch: ${TGZ_NAME}

${TGZ_NAME}:
	wget ${FETCH_SITE}/${TGZ_NAME}

${IPK_NAME}: ${TGZ_NAME}
	tar xzf ${TGZ_NAME}
	tar czf data.tar.gz \
	    --transform "s,^${DIST_NAME}/jre,usr/local/frc/JRE," \
	    --exclude=\*.diz \
	    --exclude=\*.gif \
	    --owner=root \
	    --group=root \
	    ${DIST_NAME}/jre
	tar czf control.tar.gz control
	echo 2.0 > debian-binary
	ar r ${IPK_NAME} control.tar.gz data.tar.gz debian-binary
