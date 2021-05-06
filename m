Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27FBC37512A
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 10:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233930AbhEFI61 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 04:58:27 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:34172 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233765AbhEFI61 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 May 2021 04:58:27 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 802891C0B77; Thu,  6 May 2021 10:57:27 +0200 (CEST)
Date:   Thu, 6 May 2021 10:57:26 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/29] 5.10.35-rc1 review
Message-ID: <20210506085726.GA32271@duo.ucw.cz>
References: <20210505112326.195493232@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <20210505112326.195493232@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.35 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Fri, 07 May 2021 11:23:16 +0000.
> Anything received after that time might be too late.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

ChangeLogs are now in new format; I believe that's a bad idea as I
indicated in reply to one of the patches.

Best regards,
                                                                Pavel


--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYJOvdgAKCRAw5/Bqldv6
8m0gAKCl8xhCNwy8BN62tDZ4pP3zqO3aEwCfUGi9ZE30PIpKkw7mjbNkVif4oqI=
=nRyg
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
