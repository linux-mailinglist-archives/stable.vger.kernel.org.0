Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39DFD325726
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 20:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233365AbhBYT4o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 14:56:44 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:55186 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234383AbhBYTyu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 14:54:50 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id C0F0F1C0B87; Thu, 25 Feb 2021 20:54:06 +0100 (CET)
Date:   Thu, 25 Feb 2021 20:54:05 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/23] 5.10.19-rc1 review
Message-ID: <20210225195405.GA8175@amd>
References: <20210225092516.531932232@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <20210225092516.531932232@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.19 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here: (2 failures are due to
targets not available; not a kernel problem)

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.19.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmA4AFwACgkQMOfwapXb+vK9bwCdHn/iGfjsL8oZMm3AS0uAjmDq
w6YAnj5q/lNOseUL47bRZlOp8QG8IvhR
=mXqj
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
