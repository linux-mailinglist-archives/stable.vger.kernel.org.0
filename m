Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05BF8321F52
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 19:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbhBVSoN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 13:44:13 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:42062 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbhBVSnG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 13:43:06 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id E4A601C0B76; Mon, 22 Feb 2021 19:42:23 +0100 (CET)
Date:   Mon, 22 Feb 2021 19:42:23 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/29] 5.10.18-rc1 review
Message-ID: <20210222184223.GB22197@duo.ucw.cz>
References: <20210222121019.444399883@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="i0/AhcQY5QxfSsSZ"
Content-Disposition: inline
In-Reply-To: <20210222121019.444399883@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--i0/AhcQY5QxfSsSZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.18 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Two runs are marked as failed, but details show "no available board",
so it is not a kernel problem.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
5.10.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel


--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--i0/AhcQY5QxfSsSZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYDP7DwAKCRAw5/Bqldv6
8hiNAJ9Fo4GP7pCUNSog/V97a/aurT9/9wCcCm4Dvod2NSmyxXVmcS6rJTAlv5E=
=UTqx
-----END PGP SIGNATURE-----

--i0/AhcQY5QxfSsSZ--
