Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5182B12F5A4
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 09:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgACImr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 03:42:47 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:32916 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgACImr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 03:42:47 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 044671C25DE; Fri,  3 Jan 2020 09:42:45 +0100 (CET)
Date:   Fri, 3 Jan 2020 09:42:45 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Michael Hennerich <michael.hennerich@analog.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 029/114] clk: clk-gpio: propagate rate change to
 parent
Message-ID: <20200103084245.GA14328@amd>
References: <20200102220029.183913184@linuxfoundation.org>
 <20200102220032.059523763@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
In-Reply-To: <20200102220032.059523763@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

Changelog explains author is not sure if this will break existing
setups:

> This rate change wasn't propagated until now, and it's unclear about cases
> where this shouldn't be propagated. Thus, it's unclear whether this is
> fixing a bug, or extending the current driver behavior. Also, it's unsure
> about whether this may break any existing setups; in the case that it doe=
s,
> a device-tree property may be added to disable this flag.

I don't see explanation how this fixes any user bug, so this may not
be good patch for stable?

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl4O/oUACgkQMOfwapXb+vJj1wCfQq9g+XvIhKcC7shGk/uEtzjB
yxkAn2/ArQWUB1de+MytmyGgUAKoX+mn
=oAHi
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
