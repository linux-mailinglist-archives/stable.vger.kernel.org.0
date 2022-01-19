Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3C1493B6A
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 14:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347038AbiASNtp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 08:49:45 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:37358 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235698AbiASNtp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 08:49:45 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id A0E6D1C0B9C; Wed, 19 Jan 2022 14:49:43 +0100 (CET)
Date:   Wed, 19 Jan 2022 14:49:43 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: 4.4 series end of line was Re: [PATCH 4.4 00/17] 4.4.297-rc1
 review
Message-ID: <20220119134943.GA1032@duo.ucw.cz>
References: <20211227151315.962187770@linuxfoundation.org>
 <20220119102858.GB4984@amd>
 <YefooANkr6eem49U@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <YefooANkr6eem49U@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > This is the start of the stable review cycle for the 4.4.297 release.
> > > There are 17 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> >=20
> > 4.4.X series is scheduled for EOL next month. Do you have any
> > estimates if it will be more like Feb 2 or Feb 27?
>=20
> I would bet on Feb 1 :)

Hmm. That does not leave us too much time.

FAQ states:

# Why are some longterm versions supported longer than others?  The
# "projected EOL" dates are not set in stone. Each new longterm kernel
# usually starts with only a 2-year projected EOL that can be extended
# further if there is enough interest from the industry at large to
# help support it for a longer period of time.

Is there anyone else interested in continued 4.4.X maintainence?

CIP project will need to maintain 4.4.X-cip and 4.4.X-cip-rt for some
more years. Do you think it would make sense to maintain 4.4.X-stable
as well? What would be requirements for doing so?

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYegW9wAKCRAw5/Bqldv6
8i7kAJ4ihbzh6IYNHqBBAq0eKdOiknic/QCeMN2gTepaNuGTiVNfhvT6Ipvt2iY=
=qkFY
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
