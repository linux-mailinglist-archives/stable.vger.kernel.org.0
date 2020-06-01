Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB431EB10A
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 23:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728450AbgFAVjK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 17:39:10 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:32938 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728182AbgFAVjJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 17:39:09 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 00E061C0BD2; Mon,  1 Jun 2020 23:39:07 +0200 (CEST)
Date:   Mon, 1 Jun 2020 23:38:52 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kevin Locke <kevin@kevinlocke.name>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 38/95] Input: i8042 - add ThinkPad S230u to i8042
 nomux list
Message-ID: <20200601213852.GD17898@amd>
References: <20200601174020.759151073@linuxfoundation.org>
 <20200601174026.880387783@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="d9ADC0YsG2v16Js0"
Content-Disposition: inline
In-Reply-To: <20200601174026.880387783@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--d9ADC0YsG2v16Js0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Odds of a BIOS fix appear to be low: 1.57 was released over 6 years ago
> and although the [BIOS changelog] notes "Fixed an issue of UEFI
> touchpad/trackpoint/keyboard/touchscreen" in 1.58, it appears to be
> insufficient.
>=20
> Adding 33474HU to the nomux list avoids the issue on my system.

This patch is known bad, and is reverted as a step 93/ in this
series. I believe it would be better to remove this and the revert
before -stable kernel is released.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--d9ADC0YsG2v16Js0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl7VdWwACgkQMOfwapXb+vKQNwCbBvIjqjRKChD3/z62TTpRafQd
LdoAoKyMlNLZpRnsu2sOkfNgBIM6d7Pl
=w0I+
-----END PGP SIGNATURE-----

--d9ADC0YsG2v16Js0--
