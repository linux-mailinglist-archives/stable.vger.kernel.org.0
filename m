Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5E7318648
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 09:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbhBKIY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 03:24:26 -0500
Received: from mx1.emlix.com ([136.243.223.33]:36656 "EHLO mx1.emlix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229636AbhBKIYZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 03:24:25 -0500
Received: from mailer.emlix.com (unknown [81.20.119.6])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.emlix.com (Postfix) with ESMTPS id 6772A5F9C9;
        Thu, 11 Feb 2021 09:23:28 +0100 (CET)
From:   Rolf Eike Beer <eb@emlix.com>
To:     Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kbuild@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Daniel =?ISO-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     stable@vger.kernel.org, Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: Re: [PATCH] scripts: Fix linking extract-cert against libcrypto
Date:   Thu, 11 Feb 2021 09:23:25 +0100
Message-ID: <1703981.WaQNzpUyZo@mobilepool36.emlix.com>
In-Reply-To: <6065587.C4oOSP4HzL@mobilepool36.emlix.com>
References: <20210209050047.1958473-1-daniel.diaz@linaro.org> <6065587.C4oOSP4HzL@mobilepool36.emlix.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3171492.fxiCIuZd90"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--nextPart3171492.fxiCIuZd90
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"; protected-headers="v1"
From: Rolf Eike Beer <eb@emlix.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Michal Marek <michal.lkml@markovi.net>, linux-kbuild@vger.kernel.org, open list <linux-kernel@vger.kernel.org>, Daniel =?ISO-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc: stable@vger.kernel.org, Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: Re: [PATCH] scripts: Fix linking extract-cert against libcrypto
Date: Thu, 11 Feb 2021 09:23:25 +0100
Message-ID: <1703981.WaQNzpUyZo@mobilepool36.emlix.com>
In-Reply-To: <6065587.C4oOSP4HzL@mobilepool36.emlix.com>
References: <20210209050047.1958473-1-daniel.diaz@linaro.org> <6065587.C4oOSP4HzL@mobilepool36.emlix.com>

Am Dienstag, 9. Februar 2021, 09:44:33 CET schrieb Rolf Eike Beer:
> Am Dienstag, 9. Februar 2021, 05:59:56 CET schrieb Daniel D=C3=ADaz:
> > When compiling under OpenEmbedded, the following error is seen
> >=20
> > as of recently:
> >   /srv/oe/build/tmp/hosttools/ld: cannot find /lib/libc.so.6 inside /
> >   /srv/oe/build/tmp/hosttools/ld: cannot find /usr/lib/libc_nonshared.a
> >=20
> > inside / /srv/oe/build/tmp/hosttools/ld: cannot find
> > /lib/ld-linux-x86-64.so.2 inside / collect2: error: ld returned 1 exit
> > status
> >=20
> >   make[2]: *** [scripts/Makefile.host:95: scripts/extract-cert] Error 1
>=20
> [...]
>=20
> > As per `make`'s documentation:
> >   LDFLAGS
> >  =20
> >     Extra flags to give to compilers when they are supposed to
> >     invoke the linker, =E2=80=98ld=E2=80=99, such as -L. Libraries (-lf=
oo)
> >     should be added to the LDLIBS variable instead.
> >  =20
> >   LDLIBS
> >  =20
> >     Library flags or names given to compilers when they are
> >     supposed to invoke the linker, =E2=80=98ld=E2=80=99. LOADLIBES is a
> >     deprecated (but still supported) alternative to LDLIBS.
> >     Non-library linker flags, such as -L, should go in the
> >     LDFLAGS variable.
>=20
> Correct. And the patch I use for my local 4.19 build actually uses LDLIBS,
> so it must have gone wrong in some rebase for one of the intermediate
> versions.
>=20
> Acked-by: Rolf Eike Beer <eb@emlix.com>

Oh, scrap that. I misread your patch. I was actually using LDLIBS exclusive=
ly,=20
no LDFLAGS at all.

I'll have to get my test setup ready for this, can take a moment.

Eike
=2D-=20
Rolf Eike Beer, emlix GmbH, http://www.emlix.com
=46on +49 551 30664-0, Fax +49 551 30664-11
Gothaer Platz 3, 37083 G=C3=B6ttingen, Germany
Sitz der Gesellschaft: G=C3=B6ttingen, Amtsgericht G=C3=B6ttingen HR B 3160
Gesch=C3=A4ftsf=C3=BChrung: Heike Jordan, Dr. Uwe Kracke =E2=80=93 Ust-IdNr=
=2E: DE 205 198 055

emlix - smart embedded open source
--nextPart3171492.fxiCIuZd90
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iLMEAAEIAB0WIQQ/Uctzh31xzAxFCLur5FH7Xu2t/AUCYCTpfQAKCRCr5FH7Xu2t
/GAlA/sGIXnM1yi4UcosLjEavPqHS79oPb3VT7h937qzOnb6HDawVB1i4NWfhnBQ
ie9XfCm4wQpDQa9FqYKN1GWBGS0kgmtn+m56XjSgYzAMfch9Uvsk0a/EWP2JqUzj
1tArm+5kywsa5mXHLf60QtNJim9HYfYEAsysnSMjcPViLAB3hg==
=+cDF
-----END PGP SIGNATURE-----

--nextPart3171492.fxiCIuZd90--



