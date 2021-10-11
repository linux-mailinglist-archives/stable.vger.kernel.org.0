Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3417B4294CF
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 18:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbhJKQx5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 12:53:57 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:35132 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbhJKQx4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 12:53:56 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 4AC881C0B82; Mon, 11 Oct 2021 18:51:55 +0200 (CEST)
Date:   Mon, 11 Oct 2021 18:51:54 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/28] 4.19.211-rc1 review
Message-ID: <20211011165154.GA4773@duo.ucw.cz>
References: <20211011134640.711218469@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
In-Reply-To: <20211011134640.711218469@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.211 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:                                =
           =20
                                                                           =
           =20
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.19.y     =20
                                                                           =
           =20
Tested-by: Pavel Machek (CIP) <pavel@denx.de>                              =
           =20
                                                                           =
           =20
Best regards,                                                              =
           =20
                                                                Pavel      =
           =20

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYWRrqgAKCRAw5/Bqldv6
8kDWAJ9b9pH3QLOPLzXtP33jRgvI6g4e2wCgn7kX65EiVCU0qlx3C0yF51lYfNg=
=kTtj
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
