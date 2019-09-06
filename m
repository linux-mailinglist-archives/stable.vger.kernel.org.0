Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3693AAB9EF
	for <lists+stable@lfdr.de>; Fri,  6 Sep 2019 15:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729908AbfIFNya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Sep 2019 09:54:30 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40156 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729217AbfIFNya (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Sep 2019 09:54:30 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id A559582094; Fri,  6 Sep 2019 15:54:14 +0200 (CEST)
Date:   Fri, 6 Sep 2019 15:54:28 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 10/93] soundwire: cadence_master: fix register
 definition for SLAVE_STATE
Message-ID: <20190906135428.GB28960@amd>
References: <20190904175302.845828956@linuxfoundation.org>
 <20190904175304.057403828@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="3uo+9/B/ebqu+fSQ"
Content-Disposition: inline
In-Reply-To: <20190904175304.057403828@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--3uo+9/B/ebqu+fSQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2019-09-04 19:53:12, Greg Kroah-Hartman wrote:
> [ Upstream commit b07dd9b400981f487940a4d84292d3a0e7cd9362 ]
>=20
> wrong prefix and wrong macro.

Both defines are unused in 4.19 stable... so this does not fix any
bug.

Best regards,
								Pavel

> Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> Link: https://lore.kernel.org/r/20190725234032.21152-14-pierre-louis.boss=
art@linux.intel.com
> Signed-off-by: Vinod Koul <vkoul@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

> =20
>  #define CDNS_MCP_INTSET				0x4C
> =20
> -#define CDNS_SDW_SLAVE_STAT			0x50
> -#define CDNS_MCP_SLAVE_STAT_MASK		BIT(1, 0)
> +#define CDNS_MCP_SLAVE_STAT			0x50
> +#define CDNS_MCP_SLAVE_STAT_MASK		GENMASK(1, 0)
> =20
>  #define CDNS_MCP_SLAVE_INTSTAT0			0x54
>  #define CDNS_MCP_SLAVE_INTSTAT1			0x58

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--3uo+9/B/ebqu+fSQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl1yZRQACgkQMOfwapXb+vLNgwCgq3Fs7PgEqpbmrR8KP0HC0Kns
yv0AoKIhUntTW5fAHi4hBDdVQViTzGEM
=Wr65
-----END PGP SIGNATURE-----

--3uo+9/B/ebqu+fSQ--
