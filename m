Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCCEF2AC426
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 19:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729302AbgKISvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 13:51:18 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:60300 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729292AbgKISvS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 13:51:18 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 4C92E1C0B8B; Mon,  9 Nov 2020 19:51:16 +0100 (CET)
Date:   Mon, 9 Nov 2020 19:51:15 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/86] 4.4.242-rc1 review
Message-ID: <20201109185115.GA22399@amd>
References: <20201109125020.852643676@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
In-Reply-To: <20201109125020.852643676@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.4.242 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No problems detected by CIP testing:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-=
4.4.y

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl+pj6MACgkQMOfwapXb+vI5uwCgqQswVWZH9qwyWF9vAu0mmEBw
IkwAnR8YGTBw/0BAPH1TLBum4Aoq39LS
=mhiw
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
