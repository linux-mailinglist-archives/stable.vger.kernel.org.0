Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B63C821518
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 10:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbfEQIJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 04:09:18 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59531 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727624AbfEQIJS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 04:09:18 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id CDDC5803A1; Fri, 17 May 2019 10:09:06 +0200 (CEST)
Date:   Fri, 17 May 2019 10:09:16 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 012/113] acpi/nfit: Always dump _DSM output payload
Message-ID: <20190517080916.GB17012@amd>
References: <20190515090652.640988966@linuxfoundation.org>
 <20190515090654.483522396@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="DKU6Jbt7q3WqK7+M"
Content-Disposition: inline
In-Reply-To: <20190515090654.483522396@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--DKU6Jbt7q3WqK7+M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2019-05-15 12:55:03, Greg Kroah-Hartman wrote:
> [ Upstream commit 351f339faa308c1c1461314a18c832239a841ca0 ]
>=20
> The dynamic-debug statements for command payload output only get emitted
> when the command is not ND_CMD_CALL. Move the output payload dumping
> ahead of the early return path for ND_CMD_CALL.

I don't think this fixes problem serious enough for stable.

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--DKU6Jbt7q3WqK7+M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlzebCwACgkQMOfwapXb+vKetACdHYU6ygVeYJDuMH+PPbGmzFX2
pKEAniiPAPrIX1SRPXPDnXnCw8Q8i+SG
=DqD6
-----END PGP SIGNATURE-----

--DKU6Jbt7q3WqK7+M--
