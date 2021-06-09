Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4243A1D83
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 21:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbhFITOx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 15:14:53 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:52046 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbhFITOw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Jun 2021 15:14:52 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 74B621C0B77; Wed,  9 Jun 2021 21:12:55 +0200 (CEST)
Date:   Wed, 9 Jun 2021 21:12:53 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/57] 4.19.194-rc2 review
Message-ID: <20210609191253.GA4927@amd>
References: <20210609062858.532803536@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <20210609062858.532803536@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.194 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Thanks, compile problems are gone, and this tests out okay.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmDBErUACgkQMOfwapXb+vIkgwCfZ8FTDlMRgtnLdg4ZdbA+2QvV
aycAoLvTpcsmY3yS0aS1U/4LjRtIx3vP
=8oYE
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
