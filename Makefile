# $NetBSD: Makefile,v 1.49 2025/05/22 04:51:28 schmonz Exp $

DISTNAME=		ucspi-tcp-0.88
PKGREVISION=		6
CATEGORIES=		net sysutils
MASTER_SITES=		http://cr.yp.to/ucspi-tcp/ ftp://cr.yp.to/ucspi-tcp/
DISTFILES=		${DISTNAME}.tar.gz ${MANPAGES}

MAINTAINER=		schmonz@NetBSD.org
HOMEPAGE=		https://cr.yp.to/ucspi-tcp.html
COMMENT=		Command-line tools for building TCP client-server applications
LICENSE=		public-domain

DESTDIR_PATCH=		ucspi-tcp-0.88-destdir-20180725.patch
PATCHFILES+=		${DESTDIR_PATCH}
SITES.${DESTDIR_PATCH}=	https://schmonz.com/qmail/ucspitcpdestdir/

MANPAGES=		${DISTNAME}-man-20020317.tar.gz
SITES.${MANPAGES}=	http://smarden.org/pape/djb/manpages/

CONFLICTS+=		ucspi-tcp6-[0-9]*

FORCE_C_STD=		c89

DJB_ERRNO_FIXUP=	error.h

SUBST_CLASSES+=		etc
SUBST_STAGE.etc=	do-configure
SUBST_FILES.etc=	dns_rcrw.c
SUBST_SED.etc=		-e 's|/etc/dnsrewrite|${PKG_SYSCONFBASE}/dnsrewrite|g'
SUBST_MESSAGE.etc=	Fixing prefix.

BUILD_DEFS+=		PKG_SYSCONFBASE

INSTALLATION_DIRS=	bin ${PKGMANDIR}/man1

.include "options.mk"

post-install:
	cd ${WRKDIR}/${PKGNAME_NOREV}-man; for i in 1; do	 	\
		for j in *.$$i; do ${INSTALL_MAN} $$j			\
			${DESTDIR}${PREFIX}/${PKGMANDIR}/man$$i; done	\
	done

.include "../../mk/djbware.mk"
.include "../../mk/bsd.pkg.mk"
