Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00FAC151AB4
	for <lists+stable@lfdr.de>; Tue,  4 Feb 2020 13:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbgBDMrY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Feb 2020 07:47:24 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:50844 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727126AbgBDMrY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Feb 2020 07:47:24 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id E74F31C0141; Tue,  4 Feb 2020 13:47:21 +0100 (CET)
Date:   Tue, 4 Feb 2020 13:47:21 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Chris Paterson <Chris.Paterson2@renesas.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "ben.hutchings@codethink.co.uk" <ben.hutchings@codethink.co.uk>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "cip-dev@lists.cip-project.org" <cip-dev@lists.cip-project.org>
Subject: Re: [PATCH 4.4 00/53] 4.4.213-stable review
Message-ID: <20200204124721.GB6903@duo.ucw.cz>
References: <20200203161902.714326084@linuxfoundation.org>
 <TYAPR01MB2285D96DC944217E7A22F8C6B7030@TYAPR01MB2285.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="i0/AhcQY5QxfSsSZ"
Content-Disposition: inline
In-Reply-To: <TYAPR01MB2285D96DC944217E7A22F8C6B7030@TYAPR01MB2285.jpnprd01.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--i0/AhcQY5QxfSsSZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> > Behalf Of Greg Kroah-Hartman
> > Sent: 03 February 2020 16:19
> >=20
> > This is the start of the stable review cycle for the 4.4.213 release.
> > There are 53 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Wed, 05 Feb 2020 16:17:59 +0000.
> > Anything received after that time might be too late.
>=20
> We're seeing an issue with 4.4.213-rc1 (36670370c48b) and 4.4.213-rc2 (75=
8a39807529) with our 4 am335x configurations [0]:
>=20
>    AS      arch/arm/kernel/hyp-stub.o
>  arch/arm/kernel/hyp-stub.S:   CC      arch/arm/mach-omap2/sram.o
>  Assembler messages:
>    AS      arch/arm/kernel/smccc-call.o
>  arch/arm/kernel/hyp-stub.S:147: Error: selected processor does not suppo=
rt `ubfx r7,r7,#16,#4' in ARM mode
>  scripts/Makefile.build:375: recipe for target 'arch/arm/kernel/hyp-stub.=
o' failed
>  make[1]: *** [arch/arm/kernel/hyp-stub.o] Error 1
>=20
> The culprit seems to be: 15163bcee7b5 ("ARM: 8955/1: virt: Relax arch tim=
er version check during early boot")
> Reverting the same resolves the build issue.
>=20
> Latest pipeline: https://gitlab.com/cip-project/cip-testing/linux-stable-=
rc-ci/pipelines/114683657
>=20
> [0] https://gitlab.com/cip-project/cip-kernel/cip-kernel-config/-/blob/ma=
ster/4.4.y-cip/arm/
> siemens_am335x-axm2_defconfig, siemens_am335x-draco_defconfig, siemens_am=
335x-dxr2_defconfig, siemens_am335x-etamin_defconfig
>=20

For the record, build results are here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/pipelines/114=
683657

4.19.102 builds okay:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/pipelines/114=
683672

but that's probably because siemens_am335x* configurations are not
tested in 4.19.X case.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--i0/AhcQY5QxfSsSZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXjln2QAKCRAw5/Bqldv6
8sIgAKCyj4zI/uOT7gLAynk1FPJR4qIjfQCeMFByf8ArntJ0TdW9b+2Yosh+sEc=
=7XhL
-----END PGP SIGNATURE-----

--i0/AhcQY5QxfSsSZ--
