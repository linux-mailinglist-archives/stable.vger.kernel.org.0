Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D412F1ADE
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 17:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731405AbhAKQZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 11:25:14 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:38364 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728506AbhAKQZO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 11:25:14 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 6C68F1C0B77; Mon, 11 Jan 2021 17:24:16 +0100 (CET)
Date:   Mon, 11 Jan 2021 17:24:15 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/77] 4.19.167-rc1 review
Message-ID: <20210111162415.GB6322@duo.ucw.cz>
References: <20210111130036.414620026@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bCsyhTFzCvuiizWE"
Content-Disposition: inline
In-Reply-To: <20210111130036.414620026@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bCsyhTFzCvuiizWE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.167 release.
> There are 77 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/2=
39960426

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--bCsyhTFzCvuiizWE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX/x7rwAKCRAw5/Bqldv6
8pm5AJ9/wBBl0BRoD0bBQoHs1GA1ZsqmbwCgmIca+kiopQ4GO/y16serOhUEbas=
=kCy9
-----END PGP SIGNATURE-----

--bCsyhTFzCvuiizWE--
