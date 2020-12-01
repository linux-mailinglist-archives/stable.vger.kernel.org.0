Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2372CA77F
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 16:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391965AbgLAPxW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 10:53:22 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:58862 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391955AbgLAPxW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 10:53:22 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 579731C0B87; Tue,  1 Dec 2020 16:52:40 +0100 (CET)
Date:   Tue, 1 Dec 2020 16:52:39 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 27/57] xtensa: uaccess: Add missing __user to
 strncpy_from_user() prototype
Message-ID: <20201201155239.GC23661@amd>
References: <20201201084647.751612010@linuxfoundation.org>
 <20201201084650.498869030@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="oTHb8nViIGeoXxdp"
Content-Disposition: inline
In-Reply-To: <20201201084650.498869030@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--oTHb8nViIGeoXxdp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>=20
> [ Upstream commit dc293f2106903ab9c24e9cea18c276e32c394c33 ]
>=20
> When adding __user annotations in commit 2adf5352a34a, the
> strncpy_from_user() function declaration for the
> CONFIG_GENERIC_STRNCPY_FROM_USER case was missed. Fix it.

We don't have 2adf5352a34a in v4.19, so rest of the functions are not
annotated, and we should not need this one, either.

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--oTHb8nViIGeoXxdp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl/GZscACgkQMOfwapXb+vIRPACghdaYx6s1n2K0m9P4q5EpEDnd
1IcAn0n+A+vVfZGycpdCAB9bI/HTWGnv
=wHBZ
-----END PGP SIGNATURE-----

--oTHb8nViIGeoXxdp--
