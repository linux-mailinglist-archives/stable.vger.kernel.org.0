Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954E545EAE9
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 11:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237296AbhKZKDg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 05:03:36 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:42338 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376634AbhKZKBd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 05:01:33 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 68E4C1C0BAF; Fri, 26 Nov 2021 10:58:20 +0100 (CET)
Date:   Fri, 26 Nov 2021 10:58:18 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 000/159] 4.4.293-rc3 review
Message-ID: <20211126095818.GC2396@duo.ucw.cz>
References: <20211125160503.347646915@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="+xNpyl7Qekk2NvDX"
Content-Disposition: inline
In-Reply-To: <20211125160503.347646915@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--+xNpyl7Qekk2NvDX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.4.293 release.
> There are 159 patches in this series, all will be posted as a response
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

--+xNpyl7Qekk2NvDX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYaCvugAKCRAw5/Bqldv6
8nZJAJ4lCggiRtSDWE3VTBuQtKnsVnWXmACdEXUMi7mI8xoXoIMFPI/gdfKSZlU=
=BKI6
-----END PGP SIGNATURE-----

--+xNpyl7Qekk2NvDX--
