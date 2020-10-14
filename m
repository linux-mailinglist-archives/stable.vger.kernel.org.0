Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0847B28DECA
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 12:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728737AbgJNKSj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 06:18:39 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:45266 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727197AbgJNKSj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Oct 2020 06:18:39 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id C8E801C0B8B; Wed, 14 Oct 2020 12:18:37 +0200 (CEST)
Date:   Wed, 14 Oct 2020 12:18:36 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/39] 4.4.239-rc1 review
Message-ID: <20201014101835.GA1999@amd>
References: <20201012132628.130632267@linuxfoundation.org>
 <20201013181155.GB23594@amd>
 <20201014074704.GA3002862@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <20201014074704.GA3002862@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2020-10-14 09:47:04, Greg Kroah-Hartman wrote:
> On Tue, Oct 13, 2020 at 08:11:55PM +0200, Pavel Machek wrote:
> > On Mon 2020-10-12 15:26:30, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 4.4.239 release.
> > > There are 39 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >=20
> > > Responses should be made by Wed, 14 Oct 2020 13:26:14 +0000.
> > > Anything received after that time might be too late.
> >=20
> > Tested-by: Pavel Machek  (CIP) <pavel@denx.de>
>=20
> Why the '  '?

Typo, sorry. (Plus i wonder if there's better way to credit CIP
project than this? Keeping From: and Signed-off-by: consistent is not
something I always get right.)

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl+G0HsACgkQMOfwapXb+vKBnQCghuyl/qwckKKPPJnCLBeAwfrg
ew8Anjh4FE7pmqvxQmeUK4qlaXAXKJYI
=6oZi
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
