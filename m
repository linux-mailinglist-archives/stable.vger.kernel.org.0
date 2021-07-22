Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEC7B3D2FC3
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 00:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbhGVVh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 17:37:56 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:41176 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbhGVVhz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Jul 2021 17:37:55 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 20CD71C0B96; Fri, 23 Jul 2021 00:18:29 +0200 (CEST)
Date:   Fri, 23 Jul 2021 00:18:28 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/123] 5.10.53-rc2 review
Message-ID: <20210722221828.GA4284@duo.ucw.cz>
References: <20210722184939.163840701@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline
In-Reply-To: <20210722184939.163840701@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.53 release.
> There are 123 patches in this series, all will be posted as a response
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

--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYPnutAAKCRAw5/Bqldv6
8rICAJ9dKTHUapI7Fo5DTrr+lyVxF3SDlQCfXoHEXGNhDMcK7wu3czSXT8xKH/4=
=v9A1
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
