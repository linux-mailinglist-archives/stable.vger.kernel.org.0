Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6712330C77A
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 18:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236230AbhBBRWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 12:22:47 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:55646 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237210AbhBBRUX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Feb 2021 12:20:23 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id E41851C0B7A; Tue,  2 Feb 2021 18:19:26 +0100 (CET)
Date:   Tue, 2 Feb 2021 18:19:26 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/28] 4.4.255-rc1 review
Message-ID: <20210202171926.GB7807@amd>
References: <20210202132941.180062901@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="WhfpMioaduB5tiZL"
Content-Disposition: inline
In-Reply-To: <20210202132941.180062901@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--WhfpMioaduB5tiZL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.4.255 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.4.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--WhfpMioaduB5tiZL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmAZiZ4ACgkQMOfwapXb+vIIJwCdHwWl/uRSWp1h0aX+fHXZ2oyw
j+cAnia5sGAGkpsf642pIYkVChK7W22d
=RzpY
-----END PGP SIGNATURE-----

--WhfpMioaduB5tiZL--
