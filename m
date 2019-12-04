Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E784112C2C
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 14:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbfLDNAJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 08:00:09 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:56672 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727445AbfLDNAJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Dec 2019 08:00:09 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 8E02E1C246E; Wed,  4 Dec 2019 14:00:07 +0100 (CET)
Date:   Wed, 4 Dec 2019 14:00:07 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 073/321] bus: ti-sysc: Check for no-reset and
 no-idle flags at the child level
Message-ID: <20191204130007.GB25176@duo.ucw.cz>
References: <20191203223427.103571230@linuxfoundation.org>
 <20191203223430.961774111@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="St7VIuEGZ6dlpu13"
Content-Disposition: inline
In-Reply-To: <20191203223430.961774111@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--St7VIuEGZ6dlpu13
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2019-12-03 23:32:19, Greg Kroah-Hartman wrote:
> From: Tony Lindgren <tony@atomide.com>
>=20
> [ Upstream commit 4014c08ba39476a18af546186da625a6833a1529 ]
>=20
> With ti-sysc, we need to now have the device tree properties for
> ti,no-reset-on-init and ti,no-idle-on-init at the module level instead
> of the child device level.
>=20
> Let's check for these properties at the child device level to enable
> quirks, and warn about moving the properties to the module level.
>=20
> Otherwise am335x-evm based boards tagging gpio1 with ti,no-reset-on-init
> will have their DDR power disabled if wired up in such a tricky way.
>=20
> Note that this should not be an issue for earlier kernels as we don't
> rely on this until the dts files have been updated to probe with ti-sysc
> interconnect target driver.

This is queued for 4.19-stable, but the comment seems to say it is not
needed in the older kernels.

Tony, do we want this in 4.19?

Best regards,
							Pavel
						=09
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--St7VIuEGZ6dlpu13
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXeet1wAKCRAw5/Bqldv6
8ukEAKCxbTfOmsBX9h7gTCQD+NhQM6N2SwCePPnbgcNyJZVhJvwwHX7aARNci/w=
=VUBL
-----END PGP SIGNATURE-----

--St7VIuEGZ6dlpu13--
