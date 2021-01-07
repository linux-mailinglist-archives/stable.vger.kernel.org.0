Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28AB02ED461
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 17:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbhAGQbj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 11:31:39 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:57888 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbhAGQbj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 11:31:39 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id D85BA1C0B81; Thu,  7 Jan 2021 17:30:39 +0100 (CET)
Date:   Thu, 7 Jan 2021 17:30:39 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/20] 4.4.250-rc2 review
Message-ID: <20210107163039.GB9524@duo.ucw.cz>
References: <20210107143049.179580814@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="yEPQxsgoJgBvi8ip"
Content-Disposition: inline
In-Reply-To: <20210107143049.179580814@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--yEPQxsgoJgBvi8ip
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.4.250 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sat, 09 Jan 2021 14:30:35 +0000.
> Anything received after that time might be too late.

This and 4.19.166-rc1 was tested by CIP project, and we did not find
anything wrong.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.4.y    =20
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.19.y

(I'm sending one email instead of two to keep the traffic down. If you
prefer separate emails, let me know.)

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
								Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--yEPQxsgoJgBvi8ip
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX/c3LwAKCRAw5/Bqldv6
8gdRAJ47sirSsLmeAzKukzCvwICyFB98AQCeLacEdLwLxMn7QdQCsaKxkDjWc8o=
=en6g
-----END PGP SIGNATURE-----

--yEPQxsgoJgBvi8ip--
