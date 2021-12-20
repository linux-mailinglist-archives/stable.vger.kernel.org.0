Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9567847B42D
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 21:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233604AbhLTUFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 15:05:05 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:42556 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234154AbhLTUEv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 15:04:51 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id DD8351C0B96; Mon, 20 Dec 2021 21:04:49 +0100 (CET)
Date:   Mon, 20 Dec 2021 21:04:49 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/56] 4.19.222-rc1 review
Message-ID: <20211220200449.GB29901@duo.ucw.cz>
References: <20211220143023.451982183@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bCsyhTFzCvuiizWE"
Content-Disposition: inline
In-Reply-To: <20211220143023.451982183@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bCsyhTFzCvuiizWE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.222 release.
> There are 56 patches in this series, all will be posted as a response
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

--bCsyhTFzCvuiizWE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYcDh4QAKCRAw5/Bqldv6
8sf0AKCruddcQG14Ynhn/FrFSiSYaKOPoQCcCXmg0l0YB5scLxaDSSPlvzGis0g=
=KXwN
-----END PGP SIGNATURE-----

--bCsyhTFzCvuiizWE--
