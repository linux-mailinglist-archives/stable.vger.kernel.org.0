Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A91943A073E
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 00:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234092AbhFHWnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 18:43:52 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:56166 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhFHWnw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 18:43:52 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 4297F1C0B77; Wed,  9 Jun 2021 00:41:57 +0200 (CEST)
Date:   Wed, 9 Jun 2021 00:41:55 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marek Vasut <marex@denx.de>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Fabio Estevam <festevam@gmail.com>,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        Ludwig Zenz <lzenz@dh-electronics.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: Re: [PATCH 4.19 00/58] 4.19.194-rc1 review
Message-ID: <20210608224155.GA31308@amd>
References: <20210608175932.263480586@linuxfoundation.org>
 <CA+G9fYu3URCR6_ZL+KPYFEOVL4f=8TjjyFncmvoLuYrR_YR3=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
In-Reply-To: <CA+G9fYu3URCR6_ZL+KPYFEOVL4f=8TjjyFncmvoLuYrR_YR3=A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > This is the start of the stable review cycle for the 4.19.194 release.
> > There are 58 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
=2E..
> > Marek Vasut <marex@denx.de>
> >     ARM: dts: imx6q-dhcom: Add PU,VDD1P1,VDD2P5 regulators
>=20
> make --silent --keep-going --jobs=3D8
> O=3D/home/tuxbuild/.cache/tuxmake/builds/current ARCH=3Darm
> CROSS_COMPILE=3Darm-linux-gnueabihf- 'CC=3Dsccache
> arm-linux-gnueabihf-gcc' 'HOSTCC=3Dsccache gcc'
> Error: /builds/linux/arch/arm/boot/dts/imx6q-dhcom-som.dtsi:414.1-12
> Label or path reg_vdd1p1 not found
> Error: /builds/linux/arch/arm/boot/dts/imx6q-dhcom-som.dtsi:418.1-12
> Label or path reg_vdd2p5 not found
> FATAL ERROR: Syntax error parsing input tree
> make[2]: *** [scripts/Makefile.lib:294:
> arch/arm/boot/dts/imx6q-dhcom-pdk2.dtb] Error 1

For the record, we see same build error in our testing:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/132886=
9295

Best regards,
									Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmC/8jMACgkQMOfwapXb+vKX1gCfffpNSycUCSUhvbKVxTiIExRe
iUIAn1WS6Zp8ntIiNubnNjoRwzZesA37
=U0Me
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
