Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6D6302CE9
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 21:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731960AbhAYUsg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 15:48:36 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:47104 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732189AbhAYUsS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 15:48:18 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 61AB41C0B81; Mon, 25 Jan 2021 21:47:34 +0100 (CET)
Date:   Mon, 25 Jan 2021 21:47:33 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/58] 4.19.171-rc1 review
Message-ID: <20210125204733.GA5220@duo.ucw.cz>
References: <20210125183156.702907356@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
In-Reply-To: <20210125183156.702907356@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.171 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:=20

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.19.y=20

Tested-by: Pavel Machek (CIP) <pavel@denx.de>
=20
Best regards,
								Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYA8uZQAKCRAw5/Bqldv6
8uw/AKDCn9C+38lK/9cDw0DGsuyMTRH6iACeNLcW5VJV1ITPxlr+yy/MXpufi5M=
=nNNo
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
