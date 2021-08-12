Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD9E3EAAD5
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 21:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbhHLTWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 15:22:15 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:33802 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbhHLTWO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Aug 2021 15:22:14 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 57CA51C0B76; Thu, 12 Aug 2021 21:21:48 +0200 (CEST)
Date:   Thu, 12 Aug 2021 21:21:47 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/135] 5.10.58-rc1 review
Message-ID: <20210812192147.GB20325@duo.ucw.cz>
References: <20210810172955.660225700@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="U+BazGySraz5kW0T"
Content-Disposition: inline
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--U+BazGySraz5kW0T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.58 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any kernel problems here: (but we have some
problems with test infrastructure)

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--U+BazGySraz5kW0T
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYRV0ywAKCRAw5/Bqldv6
8k9dAJ4zqeZ9pO/QTzXiAMf3AvgVXTtAKQCfY5skmxLe7itGxstBMwEjUa6s2RM=
=PUJk
-----END PGP SIGNATURE-----

--U+BazGySraz5kW0T--
