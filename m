Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620AF25A912
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 12:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgIBKG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 06:06:26 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:45400 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgIBKGZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 06:06:25 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 5A51B1C0B7F; Wed,  2 Sep 2020 12:06:22 +0200 (CEST)
Date:   Wed, 2 Sep 2020 12:06:21 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/125] 4.19.143-rc1 review
Message-ID: <20200902100621.GA3765@duo.ucw.cz>
References: <20200901150934.576210879@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="fUYQa+Pmc3FrFX/N"
Content-Disposition: inline
In-Reply-To: <20200901150934.576210879@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.143 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 03 Sep 2020 15:09:01 +0000.
> Anything received after that time might be too late.

CIP testing did not find any problems (test:x86_siemens failure is
because those boards are offline).

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/1=
84417281

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--fUYQa+Pmc3FrFX/N
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX09unQAKCRAw5/Bqldv6
8uwDAJ94+FOoyrW/2r1HEeD/3MO6GLKSGgCfR69oxpgEIHb2nPL4gfsjwJvlFx8=
=fGY7
-----END PGP SIGNATURE-----

--fUYQa+Pmc3FrFX/N--
