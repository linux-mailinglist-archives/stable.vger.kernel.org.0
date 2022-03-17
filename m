Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A43264DC316
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 10:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232142AbiCQJlP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 05:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbiCQJlI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 05:41:08 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2151918F225;
        Thu, 17 Mar 2022 02:39:39 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 631BD1C0B7F; Thu, 17 Mar 2022 10:39:37 +0100 (CET)
Date:   Thu, 17 Mar 2022 10:39:35 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        lkml <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        torvalds@linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/29] 4.19.235-rc2 review
Message-ID: <20220317093935.GA31609@amd>
References: <20220314145920.247358804@linuxfoundation.org>
 <CAG=yYwktdQ1Ep0r=VKitta=1gWrNN1Wi0Ft9t0+sXdy1bsX81Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <CAG=yYwktdQ1Ep0r=VKitta=1gWrNN1Wi0Ft9t0+sXdy1bsX81Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > This is the start of the stable review cycle for the 4.19.235 release.
> > There are 29 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
=2E..
> Compiled and  booted 4.19.235-rc2+ on ...
>=20
> Processor Information
>     Socket Designation: FM2
>     Type: Central Processor
>     Family: A-Series
>     Manufacturer: AuthenticAMD
>     ID: 31 0F 61 00 FF FB 8B 17
>     Signature: Family 21, Model 19, Stepping 1
>=20
>=20
> I think No major new  regression or regressions  from dmesg.
> Some error related stuff has happened.
> Please see the  attachment for build issues related.

Are the build issues new in 4.19.235?=20

> Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
> Reported-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

In that case you probably should not be giving Tested-by: tag, and we
probably should figure out which patch causes them...

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmIzAdcACgkQMOfwapXb+vImpgCfXNzQBm1LUIxNZKucl6h/bdqb
W9wAnj6Cn9mPM7MJc6RqZ8VIdr4VXGXh
=XXSt
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
