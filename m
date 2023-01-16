Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE4466D0F5
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 22:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbjAPVam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 16:30:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234626AbjAPVaX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 16:30:23 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 117FF2B63B;
        Mon, 16 Jan 2023 13:30:19 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 0ECD51C09F4; Mon, 16 Jan 2023 22:30:17 +0100 (CET)
Date:   Mon, 16 Jan 2023 22:30:16 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/64] 5.10.164-rc1 review
Message-ID: <Y8XB6E5t/qcKnQb7@duo.ucw.cz>
References: <20230116154743.577276578@linuxfoundation.org>
 <CAEUSe786JgSDJOtCU_tB81ddYxJk_sSfgzM33r7iFccsU7O5QA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="H5Vb37xdFkf30kEd"
Content-Disposition: inline
In-Reply-To: <CAEUSe786JgSDJOtCU_tB81ddYxJk_sSfgzM33r7iFccsU7O5QA@mail.gmail.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--H5Vb37xdFkf30kEd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> On Mon, 16 Jan 2023 at 10:06, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.164 release.
> > There are 64 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patc=
h-5.10.164-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>=20
> Preliminarily,
>=20
> | /builds/linux/drivers/gpu/drm/msm/dp/dp_aux.c: In function 'dp_aux_isr':
> | /builds/linux/drivers/gpu/drm/msm/dp/dp_aux.c:427:14: error: 'isr'
> undeclared (first use in this function); did you mean 'idr'?
> |   427 |         if (!isr)
> |       |              ^~~
> |       |              idr
>=20
> It's currently failing for arm, arm64, (not i386) and x86, with GCC 8,
> 10, 11, 12; Clang 15 and nightly. We'll test the extended set of
> architectures and update momentarily.

CIP testing sees the same build problem:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/7=
48630506

  CC [M]  drivers/gpu/drm/msm/dp/dp_display.o
6758drivers/gpu/drm/msm/dp/dp_aux.c: In function 'dp_aux_isr':
6759drivers/gpu/drm/msm/dp/dp_aux.c:427:7: error: 'isr' undeclared (first u=
se in this function); did you mean 'idr'?
6760  427 |  if (!isr)
6761      |       ^~~
6762      |       idr
6763drivers/gpu/drm/msm/dp/dp_aux.c:427:7: note: each undeclared identifier=
 is reported only once for each function it appears in
6764make[4]: *** [scripts/Makefile.build:286: drivers/gpu/drm/msm/dp/dp_aux=
=2Eo] Error 1
6765make[4]: *** Waiting for unfinished jobs....
6766


Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--H5Vb37xdFkf30kEd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY8XB6AAKCRAw5/Bqldv6
8iloAJ9LoMMCTNXlZWHlhrtunrUHp/OADwCeMzhdXd643Eo2lnCkeaQK/W0yfyQ=
=NKME
-----END PGP SIGNATURE-----

--H5Vb37xdFkf30kEd--
