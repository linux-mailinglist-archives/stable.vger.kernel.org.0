Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B901831A545
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 20:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbhBLTWV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 14:22:21 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:42770 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232105AbhBLTWP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Feb 2021 14:22:15 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 0FAEE1C0B9E; Fri, 12 Feb 2021 20:21:16 +0100 (CET)
Date:   Fri, 12 Feb 2021 20:21:15 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/27] 4.19.176-rc2 review
Message-ID: <20210212192115.GA30277@amd>
References: <20210212074240.963766197@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <20210212074240.963766197@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.176 release.
> There are 27 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Our test infrastructure seems to have some problems, but we did not
detect any problems with actual kernel. (I'm attempting to re-run the
tests).

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.19.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmAm1SsACgkQMOfwapXb+vL8awCgog6Jf84TND4N+/c6Sr1EUz+s
uIAAnjHlzcV9XAxP3bxg/9n2NxNQeg5a
=LT6J
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
