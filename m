Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B86DD3ECABA
	for <lists+stable@lfdr.de>; Sun, 15 Aug 2021 21:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbhHOTvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Aug 2021 15:51:01 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:48544 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbhHOTvB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Aug 2021 15:51:01 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 1825A1C0B79; Sun, 15 Aug 2021 21:50:30 +0200 (CEST)
Date:   Sun, 15 Aug 2021 21:50:29 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/11] 4.19.204-rc1 review
Message-ID: <20210815195029.GB23194@duo.ucw.cz>
References: <20210813150520.072304554@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="uQr8t48UFsdbeI+V"
Content-Disposition: inline
In-Reply-To: <20210813150520.072304554@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--uQr8t48UFsdbeI+V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.204 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any kernel problems here: (but we have some
infrastructure problems)

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.19.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel


--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--uQr8t48UFsdbeI+V
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYRlwBQAKCRAw5/Bqldv6
8nAGAJ4kcyJ2Ox1Hv7j7IgkCUR5f1GJhLQCgh/KMp7N4oAkUBpTW9KoNgoWfJfw=
=skM0
-----END PGP SIGNATURE-----

--uQr8t48UFsdbeI+V--
