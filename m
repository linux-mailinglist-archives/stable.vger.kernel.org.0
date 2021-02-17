Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A475E31DFA2
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 20:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233033AbhBQT1z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 14:27:55 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:55008 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233463AbhBQT1t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Feb 2021 14:27:49 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 44F521C0B81; Wed, 17 Feb 2021 20:27:06 +0100 (CET)
Date:   Wed, 17 Feb 2021 20:27:05 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5.10 098/104] switchdev: mrp: Remove
 SWITCHDEV_ATTR_ID_MRP_PORT_STAT
Message-ID: <20210217192705.GA18394@amd>
References: <20210215152719.459796636@linuxfoundation.org>
 <20210215152722.633343806@linuxfoundation.org>
 <20210216213508.GA32671@amd>
 <20210216220804.iadtjpg7r3masi5m@soft-dev3.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <20210216220804.iadtjpg7r3masi5m@soft-dev3.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > From: Horatiu Vultur <horatiu.vultur@microchip.com>
> > >=20
> > > commit 059d2a1004981dce19f0127dabc1b4ec927d202a upstream.
> > >=20
> > > Now that MRP started to use also SWITCHDEV_ATTR_ID_PORT_STP_STATE to
> > > notify HW, then SWITCHDEV_ATTR_ID_MRP_PORT_STAT is not used anywhere
> > > else, therefore we can remove it.
> >=20
> > Are you sure this is suitable for 5.10 backport? Unlike mainline,
> > net/bridge use is not removed, so this will cause compile problem...?
> >=20
> > pavel@amd:~/cip/krc$ grep -ri SWITCHDEV_ATTR_ID_MRP_PORT_STATE .
> > ./include/net/switchdev.h:    SWITCHDEV_ATTR_ID_MRP_PORT_STATE,
> > ./net/bridge/br_mrp_switchdev.c:		.id =3D SWITCHDEV_ATTR_ID_MRP_PORT_ST=
ATE,
> > pavel@amd:~/cip/krc$ e ./net/bridge/br_mrp_switchdev.c
>=20
> The usage of SWITCHDEV_ATTR_ID_MRP_PORT_STATE in
> net/bridge/br_mrp_switchdev.c is removed in this patch:
> https://www.spinics.net/lists/stable/msg443626.html

You are right, sorry for the noise.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmAtbgkACgkQMOfwapXb+vK+zQCgt45v9ESc/QDcjWwIDphZgahI
0EMAoK5Z7SZaA3cwGUiv4TjsIqpdmntJ
=bgZO
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
