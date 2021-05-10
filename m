Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A52BC378F12
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 15:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241586AbhEJN14 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 09:27:56 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:56250 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242144AbhEJMTg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 08:19:36 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id F1C5D1C0B7C; Mon, 10 May 2021 14:18:18 +0200 (CEST)
Date:   Mon, 10 May 2021 14:18:18 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/299] 5.10.36-rc1 review
Message-ID: <20210510121818.GA8478@duo.ucw.cz>
References: <20210510102004.821838356@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.36 release.
> There are 299 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any kernel problems here: (Siemens board is
unavailable):
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYJkkigAKCRAw5/Bqldv6
8qEcAJ4yPt2qfNZzwG7nDztNMdGYWy0GpQCfQmMa3yoDofAq4fvGRy41PZj2vEY=
=Wdxb
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
