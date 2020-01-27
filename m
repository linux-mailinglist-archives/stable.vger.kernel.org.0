Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE30114A409
	for <lists+stable@lfdr.de>; Mon, 27 Jan 2020 13:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729633AbgA0Mk6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jan 2020 07:40:58 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:46050 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729224AbgA0Mk6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jan 2020 07:40:58 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 4E0CD1C2103; Mon, 27 Jan 2020 13:40:56 +0100 (CET)
Date:   Mon, 27 Jan 2020 13:40:55 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Jean-Jacques Hiblot <jjhiblot@ti.com>
Subject: Re: [PATCH 4.19 014/639] leds: tlc591xx: update the maximum
 brightness
Message-ID: <20200127124055.GB19331@duo.ucw.cz>
References: <20200124093047.008739095@linuxfoundation.org>
 <20200124093048.912391801@linuxfoundation.org>
 <20200124231826.GA14064@duo.ucw.cz>
 <20200126091811.GB3549630@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="JP+T4n/bALQSJXh8"
Content-Disposition: inline
In-Reply-To: <20200126091811.GB3549630@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--JP+T4n/bALQSJXh8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun 2020-01-26 10:18:11, Greg Kroah-Hartman wrote:
> On Sat, Jan 25, 2020 at 12:18:26AM +0100, Pavel Machek wrote:
> > On Fri 2020-01-24 10:23:04, Greg Kroah-Hartman wrote:
> > > From: Jean-Jacques Hiblot <jjhiblot@ti.com>
> > >=20
> > > commit a2cafdfd8cf5ad8adda6c0ce44a59f46431edf02 upstream.
> > >=20
> > > The TLC chips actually offer 257 levels:
> > > - 0: led OFF
> > > - 1-255: Led dimmed is using a PWM. The duty cycle range from 0.4% to=
 99.6%
> > > - 256: led fully ON
> > >=20
> > > Fixes: e370d010a5fe ("leds: tlc591xx: Driver for the TI 8/16 Channel =
i2c LED driver")
> > > Signed-off-by: Jean-Jacques Hiblot <jjhiblot@ti.com>
> > > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >=20
> > Its a new feature, really and quite unusual one: 257 brightness levels
> > is not usual. It is theoretically safe, but...
> >=20
> > Lets not do that for -stable.
> >=20
> > (I'm a LED maintainer).
>=20
> Ok, now dropped from 4.19 and older, thanks!

Thank you!
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--JP+T4n/bALQSJXh8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXi7aVwAKCRAw5/Bqldv6
8j3pAJ0c74aqK13yKKggOVAyqLznpDndcgCfbtNIhlXPG/VROv14gsCmxO4Qzlk=
=6LdR
-----END PGP SIGNATURE-----

--JP+T4n/bALQSJXh8--
