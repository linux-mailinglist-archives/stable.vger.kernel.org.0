Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCB6F11E304
	for <lists+stable@lfdr.de>; Fri, 13 Dec 2019 12:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbfLMLum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Dec 2019 06:50:42 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:42526 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726717AbfLMLum (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Dec 2019 06:50:42 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 1579D1C25B1; Fri, 13 Dec 2019 12:50:40 +0100 (CET)
Date:   Fri, 13 Dec 2019 12:50:39 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 185/243] ARM: dts: sun8i: a23/a33: Fix up RTC device
 node
Message-ID: <20191213115039.GB31336@duo.ucw.cz>
References: <20191211150339.185439726@linuxfoundation.org>
 <20191211150351.658072828@linuxfoundation.org>
 <20191212133132.GA13171@amd>
 <20191212140241.GA1595136@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="uQr8t48UFsdbeI+V"
Content-Disposition: inline
In-Reply-To: <20191212140241.GA1595136@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--uQr8t48UFsdbeI+V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2019-12-12 15:02:41, Greg Kroah-Hartman wrote:
> On Thu, Dec 12, 2019 at 02:31:32PM +0100, Pavel Machek wrote:
> > Hi!
> >=20
> > > The RTC module on the A23 was claimed to be the same as on the A31, w=
hen
> > > in fact it is not. The A31 does not have an RTC external clock output,
> > > and its internal RC oscillator's average clock rate is not in the same
> > > range. The A33's RTC is the same as the A23.
> > >=20
> > > This patch fixes the compatible string and clock properties to conform
> > > to the updated bindings. The register range is also fixed.
> >=20
> > No, this is not okay for v4.19. New compatible is not in
> > ./drivers/rtc/rtc-sun6i.c, so this will completely break rtc support.
>=20
> Good catch, I would have thought both of those would happen at the same
> time.

That's not normally how it works for dts changes. Drivers and dts very
often have different maintainers, so there is preference for them to
go in separately.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--uQr8t48UFsdbeI+V
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXfN7DwAKCRAw5/Bqldv6
8ibFAJ4pxy30IvcxHFjCBJCU15Pdj8quWwCfeIuo5fW4RKucTDuAB+Q4aUsc+wk=
=msQO
-----END PGP SIGNATURE-----

--uQr8t48UFsdbeI+V--
