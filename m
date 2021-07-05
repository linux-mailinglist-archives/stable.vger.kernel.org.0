Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF523BC25A
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 19:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbhGERqO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 13:46:14 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:46538 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbhGERqN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 13:46:13 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 58F091C0B76; Mon,  5 Jul 2021 19:43:35 +0200 (CEST)
Date:   Mon, 5 Jul 2021 19:43:34 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de
Subject: Re: [PATCH 5.10 0/7] 5.10.48-rc1 review
Message-ID: <20210705174333.GA7032@amd>
References: <20210705105957.1513284-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
In-Reply-To: <20210705105957.1513284-1-sashal@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.48 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmDjRMUACgkQMOfwapXb+vI0eACdEpElprecsfwSuh7Xq16sMG/i
TkYAn3kfKG9iqOIBE7m7M920HqOQ6CMH
=5MC8
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
