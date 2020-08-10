Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0A5240B44
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 18:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgHJQiz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 12:38:55 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:47544 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbgHJQiz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 12:38:55 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 6A29D1C0BD6; Mon, 10 Aug 2020 18:38:52 +0200 (CEST)
Date:   Mon, 10 Aug 2020 18:38:51 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        stable <stable@kernel.org>
Subject: Re: [PATCH 4.19 14/48] mtd: properly check all write ioctls for
 permissions
Message-ID: <20200810163851.GB24408@amd>
References: <20200810151804.199494191@linuxfoundation.org>
 <20200810151804.911709325@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="cmJC7u66zC7hs+87"
Content-Disposition: inline
In-Reply-To: <20200810151804.911709325@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--cmJC7u66zC7hs+87
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> commit f7e6b19bc76471ba03725fe58e0c218a3d6266c3 upstream.
>=20
> When doing a "write" ioctl call, properly check that we have permissions
> to do so before copying anything from userspace or anything else so we
> can "fail fast".  This includes also covering the MEMWRITE ioctl which
> previously missed checking for this.

> +	/* "safe" commands */
> +	case MEMGETREGIONCOUNT:

I wonder if MEMSETBADBLOCK, MEMLOCK/MEMUNLOCK, BLKPG, OTPLOCK and
MTDFILEMODE should be in the list of "safe" commands? Sounds like they
can do at least as much damage as average MEMWRITE...

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--cmJC7u66zC7hs+87
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl8xeBsACgkQMOfwapXb+vJbGACePOFn4WrVSn4NiT5nFyGDhvHL
SBsAoLYnI0NTUWIrbjb1V+LMMOLvPDJr
=asrN
-----END PGP SIGNATURE-----

--cmJC7u66zC7hs+87--
