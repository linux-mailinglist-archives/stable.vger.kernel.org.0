Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 826C0451781
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 23:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349105AbhKOWaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 17:30:01 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:59324 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352482AbhKOWUs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 17:20:48 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 812081C0B76; Mon, 15 Nov 2021 23:17:31 +0100 (CET)
Date:   Mon, 15 Nov 2021 23:17:30 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/575] 5.10.80-rc1 review
Message-ID: <20211115221730.GA22123@duo.ucw.cz>
References: <20211115165343.579890274@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.80 release.
> There are 575 patches in this series, all will be posted as a response
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

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYZLcegAKCRAw5/Bqldv6
8kZvAJ9j/yG9Mu4JVXlNN4O4r79pyT/Q3QCeKrMepS7Zw/9Zh3iwOKkpAzoRtNk=
=tljm
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
