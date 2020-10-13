Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B50728D376
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 20:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgJMSLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Oct 2020 14:11:39 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:52258 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726829AbgJMSLj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Oct 2020 14:11:39 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 472A71C0B77; Tue, 13 Oct 2020 20:11:36 +0200 (CEST)
Date:   Tue, 13 Oct 2020 20:11:35 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/49] 4.19.151-rc1 review
Message-ID: <20201013181135.GA23594@amd>
References: <20201012132629.469542486@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
In-Reply-To: <20201012132629.469542486@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.151 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 14 Oct 2020 13:26:14 +0000.
> Anything received after that time might be too late.

Tested-by: Pavel Machek (CIP) <pavel@denx.de>

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl+F7dcACgkQMOfwapXb+vK89QCghU9wtzI3Ly86vUAgLd7ycSvD
UuUAoL25SI5gazHn9h8dAREFz2m3jDSj
=Jo88
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
