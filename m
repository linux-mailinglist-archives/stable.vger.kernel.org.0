Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02BF52ED62D
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 18:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbhAGR6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 12:58:46 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:37514 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbhAGR6p (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 12:58:45 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id C1FD71C0B81; Thu,  7 Jan 2021 18:58:02 +0100 (CET)
Date:   Thu, 7 Jan 2021 18:58:01 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 0/8] 4.19.166-rc1 review
Message-ID: <20210107175801.GA3906@amd>
References: <20210107143047.586006010@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <20210107143047.586006010@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.166 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

This was tested by CIP project, and we did not find anything wrong.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.19.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl/3S6gACgkQMOfwapXb+vK2mACfTvbwuRU6myMEHl52RvSBUaON
f3AAnRYGX5R29CRVh1GfpDXvvakpEjIR
=bGr3
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
