Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E85DC3E2A93
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 14:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243624AbhHFMb7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 08:31:59 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:36978 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242089AbhHFMb7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Aug 2021 08:31:59 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 2245D1C0B7A; Fri,  6 Aug 2021 14:31:42 +0200 (CEST)
Date:   Fri, 6 Aug 2021 14:31:41 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/16] 4.19.202-rc1 review
Message-ID: <20210806123141.GB11939@duo.ucw.cz>
References: <20210806081111.144943357@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="uZ3hkaAS1mZxFaxD"
Content-Disposition: inline
In-Reply-To: <20210806081111.144943357@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--uZ3hkaAS1mZxFaxD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.202 release.
> There are 16 patches in this series, all will be posted as a response
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

--uZ3hkaAS1mZxFaxD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYQ0rrQAKCRAw5/Bqldv6
8mHYAKCTJs3X2oqKIDwFYxuAujyIqO+k6wCffz+DvEnBJaKH35SlT2wb7BF6lGs=
=1fiP
-----END PGP SIGNATURE-----

--uZ3hkaAS1mZxFaxD--
