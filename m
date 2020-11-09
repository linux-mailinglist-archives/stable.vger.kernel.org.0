Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9271C2AC4E6
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 20:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730092AbgKITWr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 14:22:47 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:35192 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729038AbgKITWq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 14:22:46 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 1DB591C0B88; Mon,  9 Nov 2020 20:22:45 +0100 (CET)
Date:   Mon, 9 Nov 2020 20:22:43 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/71] 4.19.156-rc1 review
Message-ID: <20201109192243.GA23987@amd>
References: <20201109125019.906191744@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
In-Reply-To: <20201109125019.906191744@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.156 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 11 Nov 2020 12:50:04 +0000.
> Anything received after that time might be too late.

> Chris Wilson <chris@chris-wilson.co.uk>
>     drm/i915: Break up error capture compression loops with
>     cond_resched()

This one is wrong, as explained in email.

But the series still passes CIP testing:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/2=
13663202

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
                                                                Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl+plwMACgkQMOfwapXb+vK5HwCgo6AgT0rcAP0dYY7SOxZYvK6b
FS4AmwYBWgitQxDaLLKjyaFxL8vKJbvL
=lcY6
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--
