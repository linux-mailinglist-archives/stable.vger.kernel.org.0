Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC2C3C8310
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 12:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbhGNKoN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 06:44:13 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:46964 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhGNKoN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Jul 2021 06:44:13 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 682961C0B7A; Wed, 14 Jul 2021 12:41:20 +0200 (CEST)
Date:   Wed, 14 Jul 2021 12:41:19 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Holger Kiehl <Holger.Kiehl@dwd.de>
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.13 000/800] 5.13.2-rc1 review
Message-ID: <20210714104119.GA30649@amd>
References: <20210712060912.995381202@linuxfoundation.org>
 <68b6051-09c-9dc8-4b52-c4e766fee5@praktifix.dwd.de>
 <YO56HTE3k95JLeje@kroah.com>
 <50fb4713-6b5d-b5e0-786a-6ece57896d2f@praktifix.dwd.de>
 <20653f1-deaa-6fac-1f8-19319e87623a@praktifix.dwd.de>
 <a59b73aa-24f6-7395-6b99-d6c62feb0fc4@kernel.org>
 <83b8a9a7-a29c-526-d36-78737cb9f56b@praktifix.dwd.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
In-Reply-To: <83b8a9a7-a29c-526-d36-78737cb9f56b@praktifix.dwd.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!
>=20
> > On 14. 07. 21, 10:15, Holger Kiehl wrote:
> > >> Yes, will try to do that. I think it will take some time ...
> > >>
> > > Hmm, I am doing something wrong?
> >=20
> > No, you are not: -rcs are not tagged.
> >=20
> > >     git clone
> > >     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git
> > >     linux-5.13.y
> > >     cd linux-5.13.y/
> > >     git tag|grep v5.13
> > >     v5.13
> > >     v5.13-rc1
> > >     v5.13-rc2
> > >     v5.13-rc3
> > >     v5.13-rc4
> > >     v5.13-rc5
> > >     v5.13-rc6
> > >     v5.13-rc7
> > >     v5.13.1
> > >=20
> > > There is no v5.13.2-rc1. It is my first time with 'git bisect'. Must =
be
> > > doing something wrong. How can I get the correct git kernel rc versio=
n?
> >=20
> > So just bisect v5.13.1..linux-5.13.y.
> >=20
> But what do I say for bad?
>=20
>    git bisect bad linux-5.13.y
>    error: Bad rev input: linux-5.13.y
>=20
> Just saying:
>=20
>    git bisect bad
>    git bisect good v5.13.1
>    Bisecting: a merge base must be tested
>    [62fb9874f5da54fdb243003b386128037319b219] Linux 5.13
>=20
> If I read this correctly it now set v5.13 as bad and v5.13.1 as good.
> How to set the correct bad?

You can use hashes instead of symbolic revisions, and that may be
easier. I suspect you want to say "git bisect bad
origin/linux-5.13.y". You can also just do git show and note the hash.

There's other option: git bisect can be quite confusing, but you are
searching for a bug in linear history, so you can just git log
--pretty=3Doneline into a file, then do the binary search
manually. Should be 10 steps or so...

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmDuv08ACgkQMOfwapXb+vKxFgCfV3aTQlvGcOYdpaqp/aN+S/5O
eHUAn2IsWIEEr11mU9rYm4E2WaTxsdM0
=hiMI
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
