Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04B3211E0C5
	for <lists+stable@lfdr.de>; Fri, 13 Dec 2019 10:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfLMJai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Dec 2019 04:30:38 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:57308 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbfLMJai (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Dec 2019 04:30:38 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 7349A1C24A9; Fri, 13 Dec 2019 10:30:36 +0100 (CET)
Date:   Fri, 13 Dec 2019 10:30:35 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/243] 4.19.89-stable review
Message-ID: <20191213093035.GA27637@amd>
References: <20191211150339.185439726@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 4.19.89 release.
> There are 243 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Fri, 13 Dec 2019 14:56:06 +0000.
> Anything received after that time might be too late.

Is there something funny going on with the timing, again? I see that
4.19.89 is already out:

commit 312017a460d5ea31d646e7148e400e13db799ddc
Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Fri Dec 13 08:52:59 2019 +0100

    Linux 4.19.89

Best regards,
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl3zWjsACgkQMOfwapXb+vLxBwCcCV59FTq4D+TyeTCFcZoYPJL9
y98AoLl2tgyaM1dFmr5gWXczkM2IxCK1
=fwVY
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
