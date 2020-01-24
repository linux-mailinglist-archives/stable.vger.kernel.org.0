Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8AF1491B8
	for <lists+stable@lfdr.de>; Sat, 25 Jan 2020 00:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729163AbgAXXS3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 18:18:29 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:55972 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729147AbgAXXS3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jan 2020 18:18:29 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 726031C2649; Sat, 25 Jan 2020 00:18:27 +0100 (CET)
Date:   Sat, 25 Jan 2020 00:18:26 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jean-Jacques Hiblot <jjhiblot@ti.com>
Subject: Re: [PATCH 4.19 014/639] leds: tlc591xx: update the maximum
 brightness
Message-ID: <20200124231826.GA14064@duo.ucw.cz>
References: <20200124093047.008739095@linuxfoundation.org>
 <20200124093048.912391801@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
In-Reply-To: <20200124093048.912391801@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2020-01-24 10:23:04, Greg Kroah-Hartman wrote:
> From: Jean-Jacques Hiblot <jjhiblot@ti.com>
>=20
> commit a2cafdfd8cf5ad8adda6c0ce44a59f46431edf02 upstream.
>=20
> The TLC chips actually offer 257 levels:
> - 0: led OFF
> - 1-255: Led dimmed is using a PWM. The duty cycle range from 0.4% to 99.=
6%
> - 256: led fully ON
>=20
> Fixes: e370d010a5fe ("leds: tlc591xx: Driver for the TI 8/16 Channel i2c =
LED driver")
> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@ti.com>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Its a new feature, really and quite unusual one: 257 brightness levels
is not usual. It is theoretically safe, but...

Lets not do that for -stable.

(I'm a LED maintainer).

Best regards,
								Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXit7QgAKCRAw5/Bqldv6
8ki/AKCJG1IveuDvrfFS2CnZKCLi5ofS/QCfTHm9MDcAhsLv72qfMzpQMxgsEG8=
=iayr
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
