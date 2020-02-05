Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7417153B09
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 23:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbgBEWhk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 17:37:40 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:35532 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727170AbgBEWhk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Feb 2020 17:37:40 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 1330E1C036E; Wed,  5 Feb 2020 23:37:39 +0100 (CET)
Date:   Wed, 5 Feb 2020 23:37:38 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Chris Paterson <Chris.Paterson2@renesas.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "cip-dev@lists.cip-project.org" <cip-dev@lists.cip-project.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>
Subject: Re: [cip-dev] [PATCH 4.4 00/53] 4.4.213-stable review
Message-ID: <20200205223738.GC1140@amd>
References: <20200203161902.714326084@linuxfoundation.org>
 <TYAPR01MB2285D96DC944217E7A22F8C6B7030@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20200205130207.GA1199959@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="hYooF8G/hrfVAmum"
Content-Disposition: inline
In-Reply-To: <20200205130207.GA1199959@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--hYooF8G/hrfVAmum
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2020-02-05 13:02:07, Greg Kroah-Hartman wrote:
> On Tue, Feb 04, 2020 at 09:50:56AM +0000, Chris Paterson wrote:
> > Hi Greg,
> >=20
> > > From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> > > Behalf Of Greg Kroah-Hartman
> > > Sent: 03 February 2020 16:19
> > >=20
> > > This is the start of the stable review cycle for the 4.4.213 release.
> > > There are 53 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >=20
> > > Responses should be made by Wed, 05 Feb 2020 16:17:59 +0000.
> > > Anything received after that time might be too late.
> >=20
> > We're seeing an issue with 4.4.213-rc1 (36670370c48b) and 4.4.213-rc2 (=
758a39807529) with our 4 am335x configurations [0]:
> >=20
> >    AS      arch/arm/kernel/hyp-stub.o
> >  arch/arm/kernel/hyp-stub.S:   CC      arch/arm/mach-omap2/sram.o
> >  Assembler messages:
> >    AS      arch/arm/kernel/smccc-call.o
> >  arch/arm/kernel/hyp-stub.S:147: Error: selected processor does not sup=
port `ubfx r7,r7,#16,#4' in ARM mode
> >  scripts/Makefile.build:375: recipe for target 'arch/arm/kernel/hyp-stu=
b.o' failed
> >  make[1]: *** [arch/arm/kernel/hyp-stub.o] Error 1
> >=20
> > The culprit seems to be: 15163bcee7b5 ("ARM: 8955/1: virt: Relax arch t=
imer version check during early boot")
> > Reverting the same resolves the build issue.
> >=20
> > Latest pipeline: https://gitlab.com/cip-project/cip-testing/linux-stabl=
e-rc-ci/pipelines/114683657
> >=20
> > [0] https://gitlab.com/cip-project/cip-kernel/cip-kernel-config/-/blob/=
master/4.4.y-cip/arm/
> > siemens_am335x-axm2_defconfig, siemens_am335x-draco_defconfig, siemens_=
am335x-dxr2_defconfig, siemens_am335x-etamin_defconfig
>=20
> Thanks, I'll go drop that patch from 4.4 and 4.9 trees.

I believe it is more likely than not to break 4.19 (and possibly
mainline), too, but I have not yet done required testing.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--hYooF8G/hrfVAmum
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl47Q7IACgkQMOfwapXb+vIb9wCggda45Gbi7vfZ9Rh2gBfoXKpH
0gUAoLsP4cEKshmiZdBQBpCgLvlCGSXr
=gdVu
-----END PGP SIGNATURE-----

--hYooF8G/hrfVAmum--
