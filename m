Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58E3214C99D
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 12:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbgA2LbJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 06:31:09 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:39728 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbgA2LbJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jan 2020 06:31:09 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 70DA21C2607; Wed, 29 Jan 2020 12:31:07 +0100 (CET)
Date:   Wed, 29 Jan 2020 12:31:06 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/92] 4.19.100-stable review
Message-ID: <20200129113106.GA28178@duo.ucw.cz>
References: <20200128135809.344954797@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <20200128135809.344954797@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.100 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 30 Jan 2020 13:57:09 +0000.
> Anything received after that time might be too late.

It builds and basic tests work in our configurations.

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/pipelines/112=
957173

Best regards,
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXjFs+gAKCRAw5/Bqldv6
8g5oAJ0SUS7p1w/quPFGQ9A4jFluVxdgIwCgw5neYeW/cz8x9LWLws9qlDYKWg8=
=gRsD
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
