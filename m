Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 384EA14956B
	for <lists+stable@lfdr.de>; Sat, 25 Jan 2020 13:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbgAYMFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jan 2020 07:05:02 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:40738 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726351AbgAYMFB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jan 2020 07:05:01 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id CAEC71C213B; Sat, 25 Jan 2020 13:04:59 +0100 (CET)
Date:   Sat, 25 Jan 2020 13:04:59 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Sylvain Chouleur <sylvain.chouleur@intel.com>,
        Patrick McDermott <patrick.mcdermott@libiquity.com>,
        linux-rtc@vger.kernel.org, Eric Wong <e@80x24.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 143/639] rtc: cmos: ignore bogus century byte
Message-ID: <20200125120458.GB14064@duo.ucw.cz>
References: <20200124093047.008739095@linuxfoundation.org>
 <20200124093105.163756275@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="U+BazGySraz5kW0T"
Content-Disposition: inline
In-Reply-To: <20200124093105.163756275@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--U+BazGySraz5kW0T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Eric Wong <e@80x24.org>
>=20
> [ Upstream commit 2a4daadd4d3e507138f8937926e6a4df49c6bfdc ]
>=20
> Older versions of Libreboot and Coreboot had an invalid value
> (`3' in my case) in the century byte affecting the GM45 in
> the Thinkpad X200.  Not everybody's updated their firmwares,
> and Linux <=3D 4.2 was able to read the RTC without problems,
> so workaround this by ignoring invalid values.

Should it print a warning so that wrong BIOSes are eventually fixed?

Best regards,
								Pavel
							=09
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--U+BazGySraz5kW0T
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXiwu6gAKCRAw5/Bqldv6
8vSgAJ9YPtVVd5IY2zMyS/nfUt8bXj+zTgCgnfvu6U09I6yYGvPYpek6u+0ZgPE=
=uWtY
-----END PGP SIGNATURE-----

--U+BazGySraz5kW0T--
