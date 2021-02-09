Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D15D314938
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 08:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbhBIHDP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 02:03:15 -0500
Received: from mx1.emlix.com ([136.243.223.33]:57306 "EHLO mx1.emlix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229639AbhBIHDP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Feb 2021 02:03:15 -0500
X-Greylist: delayed 614 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Feb 2021 02:03:15 EST
Received: from mailer.emlix.com (unknown [81.20.119.6])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.emlix.com (Postfix) with ESMTPS id 055845FAF2;
        Tue,  9 Feb 2021 07:52:18 +0100 (CET)
From:   Rolf Eike Beer <eb@emlix.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Daniel =?ISO-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Subject: Re: [PATCH 5.10 000/120] 5.10.15-rc1 review
Date:   Tue, 09 Feb 2021 07:52:08 +0100
Message-ID: <4373079.srkzGm6n8t@mobilepool36.emlix.com>
In-Reply-To: <CA+G9fYsjJ+K7w-PQ4gp=L3QO_VSaUMr6syvAS77--aFbfZVK-g@mail.gmail.com>
References: <20210208145818.395353822@linuxfoundation.org> <CA+G9fYsjJ+K7w-PQ4gp=L3QO_VSaUMr6syvAS77--aFbfZVK-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2038634.dKlP8bNpfP"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--nextPart2038634.dKlP8bNpfP
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"; protected-headers="v1"
From: Rolf Eike Beer <eb@emlix.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: open list <linux-kernel@vger.kernel.org>, Shuah Khan <shuah@kernel.org>, patches@kernelci.org, lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>, linux-stable <stable@vger.kernel.org>, pavel@denx.de, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Guenter Roeck <linux@roeck-us.net>, Masahiro Yamada <masahiroy@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Daniel =?ISO-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Subject: Re: [PATCH 5.10 000/120] 5.10.15-rc1 review
Date: Tue, 09 Feb 2021 07:52:08 +0100
Message-ID: <4373079.srkzGm6n8t@mobilepool36.emlix.com>
In-Reply-To: <CA+G9fYsjJ+K7w-PQ4gp=L3QO_VSaUMr6syvAS77--aFbfZVK-g@mail.gmail.com>
References: <20210208145818.395353822@linuxfoundation.org> <CA+G9fYsjJ+K7w-PQ4gp=L3QO_VSaUMr6syvAS77--aFbfZVK-g@mail.gmail.com>

Am Dienstag, 9. Februar 2021, 03:31:44 CET schrieb Naresh Kamboju:
> On Mon, 8 Feb 2021 at 20:44, Greg Kroah-Hartman
>=20
> <gregkh@linuxfoundation.org> wrote:
> > This is the start of the stable review cycle for the 5.10.15 release.
> > There are 120 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Wed, 10 Feb 2021 14:57:55 +0000.
> > Anything received after that time might be too late.
> >=20
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patc=
h-5
> >         .10.15-rc1.gz>=20
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-
> >         rc.git linux-5.10.y>=20
> > and the diffstat can be found below.
> >=20
> > thanks,
> >=20
> > greg k-h
>=20
> Due to the patch below, the x86_64 build breaks with gcc 7.3.x
> This issue is specific to openembedded kernel builder.
>=20
> We have also noticed on mainline, Linux next and now on stable-rc 5.10.
>=20
> collect2: error: ld returned 1 exit status
> make[2]: *** [scripts/Makefile.host:95: scripts/extract-cert] Error 1
>=20
> ref:
> Build failure link,
> https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5.1=
0/D
> ISTRO=3Dlkft,MACHINE=3Dintel-corei7-64,label=3Ddocker-buster-lkft/64/cons=
oleText

Is this part relevant or does that always happen with your builder.

| /srv/oe/build/tmp-lkft-glibc/hosttools/ld: cannot find /lib/libc.so.6 ins=
ide=20
/
| /srv/oe/build/tmp-lkft-glibc/hosttools/ld: cannot find /usr/lib/
libc_nonshared.a inside /
| /srv/oe/build/tmp-lkft-glibc/hosttools/ld: cannot find /lib/ld-linux-
x86-64.so.2 inside /

Can you provide a log with V=3D1 where we can see what actually is going on?

Eike
=2D-=20
Rolf Eike Beer, emlix GmbH, http://www.emlix.com
=46on +49 551 30664-0, Fax +49 551 30664-11
Gothaer Platz 3, 37083 G=C3=B6ttingen, Germany
Sitz der Gesellschaft: G=C3=B6ttingen, Amtsgericht G=C3=B6ttingen HR B 3160
Gesch=C3=A4ftsf=C3=BChrung: Heike Jordan, Dr. Uwe Kracke =E2=80=93 Ust-IdNr=
=2E: DE 205 198 055

emlix - smart embedded open source
--nextPart2038634.dKlP8bNpfP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iLMEAAEIAB0WIQQ/Uctzh31xzAxFCLur5FH7Xu2t/AUCYCIxGAAKCRCr5FH7Xu2t
/BozA/9jxUSptQ41grYGtw56IDWP+xsbVzutcYnimryDz4LXg40vhbe1imTtlFO+
Nh6qqx85eAmlDB/TZba+Ny+P3/FKQZB0kEyvQdjO5w6RgJ00aTOENOWks9gi9+9s
uIFfTNuGXm5tcYIf7F9cOVE/E/YVM9umL0oK9xN7t/rrDCTBSQ==
=7FWF
-----END PGP SIGNATURE-----

--nextPart2038634.dKlP8bNpfP--



