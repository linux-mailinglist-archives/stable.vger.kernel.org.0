Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E235B33C890
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 22:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbhCOVjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 17:39:13 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:34580 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232636AbhCOVim (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 17:38:42 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 0D5371C0B80; Mon, 15 Mar 2021 22:38:40 +0100 (CET)
Date:   Mon, 15 Mar 2021 22:38:39 +0100
From:   Pavel Machek <pavel@denx.de>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/120] 4.19.181-rc1 review
Message-ID: <20210315213839.GA4269@amd>
References: <20210315135720.002213995@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
In-Reply-To: <20210315135720.002213995@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.181 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any kernel problems here: (Renesas boards
are still unavailable)

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.4.y
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.19.y
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
							=09

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmBP098ACgkQMOfwapXb+vJrzACeOwr8ZzVDv/Gh5QiEkHDkgDTz
U84AoI+JU0c1Nk8UJgX/husP2vkW18+G
=NYrL
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
