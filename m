Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38D512EA855
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 11:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbhAEKNS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 05:13:18 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:46782 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728446AbhAEKNR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 05:13:17 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 6DEB31C0B78; Tue,  5 Jan 2021 11:12:34 +0100 (CET)
Date:   Tue, 5 Jan 2021 11:12:33 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/29] 4.19.165-rc2 review
Message-ID: <20210105101233.GA28479@amd>
References: <20210105090818.518271884@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
In-Reply-To: <20210105090818.518271884@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.165 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 07 Jan 2021 09:08:03 +0000.
> Anything received after that time might be too late.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.19.y

We did not find any problems with -rc1, so I guess we don't test
exotic-enough configs...

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl/0O5EACgkQMOfwapXb+vLWgwCghcbbcW/8GIr5xDg6dr8odP+9
pacAn1osc2y4jMd7oUD70+fZlzHd3cJX
=z/ZN
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
