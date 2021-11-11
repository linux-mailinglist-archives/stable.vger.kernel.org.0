Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4F944DA9C
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 17:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234280AbhKKQpC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 11:45:02 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:42962 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234266AbhKKQpB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 11:45:01 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id C17DD1C0B87; Thu, 11 Nov 2021 17:42:11 +0100 (CET)
Date:   Thu, 11 Nov 2021 17:42:10 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/21] 5.10.79-rc1 review
Message-ID: <20211111164210.GC25784@duo.ucw.cz>
References: <20211110182002.964190708@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="vOmOzSkFvhd7u8Ms"
Content-Disposition: inline
In-Reply-To: <20211110182002.964190708@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--vOmOzSkFvhd7u8Ms
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.79 release.
> There are 21 patches in this series, all will be posted as a response
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

--vOmOzSkFvhd7u8Ms
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYY1H4gAKCRAw5/Bqldv6
8l1jAKCaRz4XvYNbLdQIxAKN+bGu2bsJbwCfRfphd1HUUrizh0THPmpPQFJ9sts=
=nMJe
-----END PGP SIGNATURE-----

--vOmOzSkFvhd7u8Ms--
