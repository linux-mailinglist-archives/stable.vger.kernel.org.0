Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6140F314AB7
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 09:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbhBIIsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 03:48:07 -0500
Received: from mx1.emlix.com ([136.243.223.33]:57596 "EHLO mx1.emlix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230076AbhBIIpm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Feb 2021 03:45:42 -0500
Received: from mailer.emlix.com (unknown [81.20.119.6])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.emlix.com (Postfix) with ESMTPS id B08565FAF2;
        Tue,  9 Feb 2021 09:44:41 +0100 (CET)
From:   Rolf Eike Beer <eb@emlix.com>
To:     Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kbuild@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Daniel =?ISO-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     Daniel =?ISO-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>,
        stable@vger.kernel.org, Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: Re: [PATCH] scripts: Fix linking extract-cert against libcrypto
Date:   Tue, 09 Feb 2021 09:44:33 +0100
Message-ID: <6065587.C4oOSP4HzL@mobilepool36.emlix.com>
In-Reply-To: <20210209050047.1958473-1-daniel.diaz@linaro.org>
References: <20210209050047.1958473-1-daniel.diaz@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2242286.IDMuxJGT9b"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--nextPart2242286.IDMuxJGT9b
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"; protected-headers="v1"
From: Rolf Eike Beer <eb@emlix.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Michal Marek <michal.lkml@markovi.net>, linux-kbuild@vger.kernel.org, open list <linux-kernel@vger.kernel.org>, Daniel =?ISO-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc: Daniel =?ISO-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>, stable@vger.kernel.org, Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: Re: [PATCH] scripts: Fix linking extract-cert against libcrypto
Date: Tue, 09 Feb 2021 09:44:33 +0100
Message-ID: <6065587.C4oOSP4HzL@mobilepool36.emlix.com>
In-Reply-To: <20210209050047.1958473-1-daniel.diaz@linaro.org>
References: <20210209050047.1958473-1-daniel.diaz@linaro.org>

Am Dienstag, 9. Februar 2021, 05:59:56 CET schrieb Daniel D=C3=ADaz:
> When compiling under OpenEmbedded, the following error is seen
> as of recently:
>=20
>   /srv/oe/build/tmp/hosttools/ld: cannot find /lib/libc.so.6 inside /
>   /srv/oe/build/tmp/hosttools/ld: cannot find /usr/lib/libc_nonshared.a
> inside / /srv/oe/build/tmp/hosttools/ld: cannot find
> /lib/ld-linux-x86-64.so.2 inside / collect2: error: ld returned 1 exit
> status
>   make[2]: *** [scripts/Makefile.host:95: scripts/extract-cert] Error 1

[...]
> As per `make`'s documentation:
>=20
>   LDFLAGS
>     Extra flags to give to compilers when they are supposed to
>     invoke the linker, =E2=80=98ld=E2=80=99, such as -L. Libraries (-lfoo)
>     should be added to the LDLIBS variable instead.
>=20
>   LDLIBS
>     Library flags or names given to compilers when they are
>     supposed to invoke the linker, =E2=80=98ld=E2=80=99. LOADLIBES is a
>     deprecated (but still supported) alternative to LDLIBS.
>     Non-library linker flags, such as -L, should go in the
>     LDFLAGS variable.

Correct. And the patch I use for my local 4.19 build actually uses LDLIBS, =
so=20
it must have gone wrong in some rebase for one of the intermediate versions.

Acked-by: Rolf Eike Beer <eb@emlix.com>
=2D-=20
Rolf Eike Beer, emlix GmbH, http://www.emlix.com
=46on +49 551 30664-0, Fax +49 551 30664-11
Gothaer Platz 3, 37083 G=C3=B6ttingen, Germany
Sitz der Gesellschaft: G=C3=B6ttingen, Amtsgericht G=C3=B6ttingen HR B 3160
Gesch=C3=A4ftsf=C3=BChrung: Heike Jordan, Dr. Uwe Kracke =E2=80=93 Ust-IdNr=
=2E: DE 205 198 055

emlix - smart embedded open source
--nextPart2242286.IDMuxJGT9b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iLMEAAEIAB0WIQQ/Uctzh31xzAxFCLur5FH7Xu2t/AUCYCJLcQAKCRCr5FH7Xu2t
/HgNBAC/L0SeWjHivmkwlNtBK3WRW1GT/A1YwTPF+ZRV4xJk9UlHW4hLLmqJZdeH
agVHegp4Ffm5X7YgjQeAHf799IrVyfDcA/Z4e4gmd8pXdqUzkjdUXTpfFO7EFnrV
zCvyvqVVmqq9/QUrv0KApvn/pspEr6WYulLbp74dRMY/UU3u0Q==
=bLUv
-----END PGP SIGNATURE-----

--nextPart2242286.IDMuxJGT9b--



