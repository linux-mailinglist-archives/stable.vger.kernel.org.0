Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAC133F706F
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 09:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238677AbhHYHe1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 03:34:27 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:48460 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238536AbhHYHe0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Aug 2021 03:34:26 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id F0B361C0B7A; Wed, 25 Aug 2021 09:33:38 +0200 (CEST)
Date:   Wed, 25 Aug 2021 09:33:38 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de
Subject: Re: [PATCH 4.4 00/31] 4.4.282-rc1 review
Message-ID: <20210825073338.GA4193@duo.ucw.cz>
References: <20210824170743.710957-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
In-Reply-To: <20210824170743.710957-1-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.4.282 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.4.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYSXyUgAKCRAw5/Bqldv6
8mBoAJ4tQdFy99Ly/aLtJzFW+o3yA/j4GwCgoQ30Mp+0ch7o9fr/lR97rjLf2eA=
=qrQb
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
