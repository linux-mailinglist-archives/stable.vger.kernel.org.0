Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68C2514ED03
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 14:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbgAaNMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 08:12:25 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:49148 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728544AbgAaNMZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jan 2020 08:12:25 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 1FE091C228F; Fri, 31 Jan 2020 14:12:24 +0100 (CET)
Date:   Fri, 31 Jan 2020 14:12:23 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/55] 4.19.101-stable review
Message-ID: <20200131131223.GA13686@duo.ucw.cz>
References: <20200130183608.563083888@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <20200130183608.563083888@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.101 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sat, 01 Feb 2020 18:35:06 +0000.
> Anything received after that time might be too late.

No problems detected in CIP compile/boot tests:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/commit/bb5fd2=
ed7f74648a46141afdad5902a3a7cf2c00

4.4.213-rc1 also seems to compile ok:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/pipelines/113=
738982

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXjQntwAKCRAw5/Bqldv6
8oj8AJ0aROb2eBAPnbaqjRhPo5TLwB1QHACeLeldWtcCkvYDDHAE0w1XAhLdXiA=
=5mSe
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
