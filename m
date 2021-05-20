Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3CA038B881
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 22:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235107AbhETUht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 16:37:49 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:45354 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234997AbhETUht (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 16:37:49 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 623731C0B7F; Thu, 20 May 2021 22:36:26 +0200 (CEST)
Date:   Thu, 20 May 2021 22:36:26 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: [PATCH 4.19 425/425] scripts: switch explicitly to Python 3
Message-ID: <20210520203625.GA6187@amd>
References: <20210520092131.308959589@linuxfoundation.org>
 <20210520092145.369052506@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <20210520092145.369052506@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>=20
> commit 51839e29cb5954470ea4db7236ef8c3d77a6e0bb upstream.
>=20
> Some distributions are about to switch to Python 3 support only.
> This means that /usr/bin/python, which is Python 2, is not available
> anymore. Hence, switch scripts to use Python 3 explicitly.

I'd say this is unsuitable for -stable.

Old distributions may not have python3 installed, and we should not
change this dependency in the middle of the series.

Python is not listed in Documentation/Changes . Perhaps it should be?

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmCmyEkACgkQMOfwapXb+vIpgwCdEzjC0OM6U4yQCIvh4ZMELiJP
fyYAmwbyq8rD88DMHDKV4nH/3cSV3GNh
=jN8a
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
