Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1851145EAE6
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 10:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376607AbhKZKDC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 05:03:02 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:42220 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376608AbhKZKBC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 05:01:02 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id BC3491C0BAC; Fri, 26 Nov 2021 10:57:48 +0100 (CET)
Date:   Fri, 26 Nov 2021 10:57:46 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/320] 4.19.218-rc3 review
Message-ID: <20211126095746.GB2396@duo.ucw.cz>
References: <20211125160544.661624121@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="mxv5cy4qt+RJ9ypb"
Content-Disposition: inline
In-Reply-To: <20211125160544.661624121@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--mxv5cy4qt+RJ9ypb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.218 release.
> There are 320 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.19.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--mxv5cy4qt+RJ9ypb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYaCvmgAKCRAw5/Bqldv6
8oXtAJ4r6+IeL4+SZ/+XG58JnBoRpKrFuQCfT7MYOCqM4SSCFA1RuuX/Ibhw43Y=
=uuuW
-----END PGP SIGNATURE-----

--mxv5cy4qt+RJ9ypb--
