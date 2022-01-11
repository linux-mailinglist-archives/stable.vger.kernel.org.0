Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84A8E48AC91
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 12:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238839AbiAKLfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 06:35:48 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:46024 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238542AbiAKLfr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 06:35:47 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 8EE791C0B81; Tue, 11 Jan 2022 12:35:46 +0100 (CET)
Date:   Tue, 11 Jan 2022 12:35:46 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/21] 4.19.225-rc1 review
Message-ID: <20220111113546.GB11620@duo.ucw.cz>
References: <20220110071813.967414697@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="oLBj+sq0vYjzfsbl"
Content-Disposition: inline
In-Reply-To: <20220110071813.967414697@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--oLBj+sq0vYjzfsbl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.225 release.
> There are 21 patches in this series, all will be posted as a response
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

--oLBj+sq0vYjzfsbl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYd1rkgAKCRAw5/Bqldv6
8oLVAJ9ZcbTPILyRt6w93lm50KeDYGShUwCgvmoveTdcLqZsTG5tcuZ3WIMluZI=
=FkUY
-----END PGP SIGNATURE-----

--oLBj+sq0vYjzfsbl--
