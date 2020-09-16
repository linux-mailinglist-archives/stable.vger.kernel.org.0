Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C10CC26BE06
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 09:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgIPHbG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 03:31:06 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:33316 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbgIPHbF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Sep 2020 03:31:05 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id A0A851C0B76; Wed, 16 Sep 2020 09:31:00 +0200 (CEST)
Date:   Wed, 16 Sep 2020 09:31:00 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Angelo Compagnucci <angelo.compagnucci@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 09/78] iio: adc: mcp3422: fix locking on error path
Message-ID: <20200916073100.GA32537@duo.ucw.cz>
References: <20200915140633.552502750@linuxfoundation.org>
 <20200915140634.010489871@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
In-Reply-To: <20200915140634.010489871@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit a139ffa40f0c24b753838b8ef3dcf6ad10eb7854 ]
>=20
> Reading from the chip should be unlocked on error path else the lock
> could never being released.
>=20
> Fixes: 07914c84ba30 ("iio: adc: Add driver for Microchip MCP3422/3/4 high=
 resolution ADC")
> Fixes: 3f1093d83d71 ("iio: adc: mcp3422: fix locking scope")

Well, 3f1093d83d71 is only applied later in the stable series, so this
introduces spurious unlock.

Ideally this should go just after 3f1093d83d71 ("iio: adc: mcp3422:
fix locking scope").

Best regards,
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX2G/NAAKCRAw5/Bqldv6
8ojkAJ0YrKaZTyrNMwgKA4OWczZiLBQAyACgh4hmA2LsPIoggr+YrlpdlKzXMdk=
=77CW
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
