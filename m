Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7ED6608CB7
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 13:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiJVLeQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 07:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbiJVLdu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 07:33:50 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D5C4119BFD;
        Sat, 22 Oct 2022 04:15:28 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 3C7B11C09E5; Sat, 22 Oct 2022 13:15:27 +0200 (CEST)
Date:   Sat, 22 Oct 2022 13:15:26 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.19 000/717] 5.19.17-rc1 review
Message-ID: <20221022111526.GA20649@duo.ucw.cz>
References: <20221022072415.034382448@linuxfoundation.org>
 <Y1Ov3KuyKmb9Nizm@debian.me>
 <Y1PCyVHKEUst4mRL@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <Y1PCyVHKEUst4mRL@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > This is the start of the stable review cycle for the 5.19.17 release.
> > > There are 717 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >=20
> > > Note, this will be the LAST 5.19.y kernel to be released.  Please move
> > > to the 6.0.y kernel branch at this point in time, as after this is
> > > released, this branch will be end-of-life.
> > >=20
> >=20
> > Hi Greg, thanks for the patch series, which is out three days after
> > the -rc1 have been pused. As usual, the template message follows.
>=20
> What exactly do you mean by "3 days after"?
>=20
> Are you watching the linux-stable-rc branches?  Those are there only for
> CI systems and are not a "real" -rc release at all until we do this
> email announcement.
>=20
> The -rc1 release here does not look at all like what was in the
> linux-stable-rc branch 3 days ago if you look closely.  There are a lot
> fewer patches now than before, and other changes.
>=20
> So again, unless you are running a CI system, don't look at the
> linux-stable-rc branches.

What do you suggest for people trying to review -stable? Two days are
not enough to review 500 patches...

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--liOOAslEiF7prFVr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY1PQzgAKCRAw5/Bqldv6
8jnEAKCx+qTFehKfNmo/sitI6BnaKPxBTQCcCqJ51ctRksbo6UpODN6vvbdfJwk=
=5PP0
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
