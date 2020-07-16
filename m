Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F86221D8E
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 09:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbgGPHpS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jul 2020 03:45:18 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:33632 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbgGPHpR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jul 2020 03:45:17 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 1FE551C0BDA; Thu, 16 Jul 2020 09:45:15 +0200 (CEST)
Date:   Thu, 16 Jul 2020 09:45:14 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/58] 4.19.133-rc1 review
Message-ID: <20200716074514.GA26482@amd>
References: <20200714184056.149119318@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
In-Reply-To: <20200714184056.149119318@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.133 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 16 Jul 2020 18:40:38 +0000.
> Anything received after that time might be too late.

No problems detected by CIP test farm:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/1=
66553779

And no problems on 4.4 detected, either: Linux 4.4.231-rc1 (270512166a37)

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/1=
66553747

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl8QBYoACgkQMOfwapXb+vKM0ACgkfZq0QvY0ZNGPMHADqkPf6fJ
O48Ani9e8MrOR3F04jgyXbtfBTYwVLe9
=Qmv9
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
