Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A422AD8A9
	for <lists+stable@lfdr.de>; Mon,  9 Sep 2019 14:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387544AbfIIMP6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 08:15:58 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43088 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387507AbfIIMP6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Sep 2019 08:15:58 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 5F27680ED4; Mon,  9 Sep 2019 14:15:42 +0200 (CEST)
Date:   Mon, 9 Sep 2019 14:15:55 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Fabian Henneke <fabian.henneke@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 19/57] Bluetooth: hidp: Let hidp_send_message return
 number of queued bytes
Message-ID: <20190909121555.GA18869@amd>
References: <20190908121125.608195329@linuxfoundation.org>
 <20190908121132.859238319@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
In-Reply-To: <20190908121132.859238319@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 48d9cc9d85dde37c87abb7ac9bbec6598ba44b56 ]
>=20
> Let hidp_send_message return the number of successfully queued bytes
> instead of an unconditional 0.
>=20
> With the return value fixed to 0, other drivers relying on hidp, such as
> hidraw, can not return meaningful values from their respective
> implementations of write(). In particular, with the current behavior, a
> hidraw device's write() will have different return values depending on
> whether the device is connected via USB or Bluetooth, which makes it
> harder to abstract away the transport layer.

So, does this change any actual behaviour?

Is it fixing a bug, or is it just preparation for a patch that is not
going to make it to stable?
							Pavel
						=09
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl12QnsACgkQMOfwapXb+vLK9wCgvDo1ioez+R+UTafjdDImN1aD
BY8An0DRaqyJuXu3ZUOP2wDZXs5UziSy
=Gkqy
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
