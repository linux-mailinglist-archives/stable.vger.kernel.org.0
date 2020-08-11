Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E38A5241848
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 10:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbgHKIcM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 04:32:12 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:43422 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728253AbgHKIcM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 04:32:12 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 7FA6F1C0BDE; Tue, 11 Aug 2020 10:32:09 +0200 (CEST)
Date:   Tue, 11 Aug 2020 10:32:08 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/48] 4.19.139-rc1 review
Message-ID: <20200811083208.GA5900@amd>
References: <20200810151804.199494191@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
In-Reply-To: <20200810151804.199494191@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2020-08-10 17:21:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.139 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 12 Aug 2020 15:17:47 +0000.
> Anything received after that time might be too late.

No problems detected in -cip testing:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/1=
76251340

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl8yV4gACgkQMOfwapXb+vKaXQCgwcKPA9rfEwcrubQ0nxdTK9CD
SPkAoIbxRGgpdVNpLBl6/O0Z+jvC2dQ4
=Njkw
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
