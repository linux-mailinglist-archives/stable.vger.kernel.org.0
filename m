Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23C4D7CBA9
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 20:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbfGaSOs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 14:14:48 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46161 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727167AbfGaSOs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 14:14:48 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id EEAD2802F0; Wed, 31 Jul 2019 20:14:33 +0200 (CEST)
Date:   Wed, 31 Jul 2019 20:14:45 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vishal Verma <vishal.l.verma@intel.com>,
        Jane Chu <jane.chu@oracle.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 4.19 112/113] libnvdimm/bus: Stop holding
 nvdimm_bus_list_mutex over __nd_ioctl()
Message-ID: <20190731181444.GA821@amd>
References: <20190729190655.455345569@linuxfoundation.org>
 <20190729190721.610390670@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <20190729190721.610390670@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2019-07-29 21:23:19, Greg Kroah-Hartman wrote:
> From: Dan Williams <dan.j.williams@intel.com>
>=20
> commit b70d31d054ee3a6fc1034b9d7fc0ae1e481aa018 upstream.
>=20
> In preparation for fixing a deadlock between wait_for_bus_probe_idle()
> and the nvdimm_bus_list_mutex arrange for __nd_ioctl() without
> nvdimm_bus_list_mutex held. This also unifies the 'dimm' and 'bus' level
> ioctls into a common nd_ioctl() preamble implementation.

Ok, so this is a preparation patch, not a fix...

> Marked for -stable as it is a pre-requisite for a follow-on fix.

=2E..but follow-on fixes are going to be applied for 5.2 but not
4.19. So perhaps this one should not be in 4.19, either?

Best regards,
								Pavel

(Plus its quite complex).
>  drivers/nvdimm/bus.c     |   94 ++++++++++++++++++++++++++++------------=
-------
>  drivers/nvdimm/nd-core.h |    3 +

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl1B2pQACgkQMOfwapXb+vJpdgCbBAV9m0328rZBqRMvo6K0u83S
HvkAni7cGN1XvGoPutUfrRqfcb/9Z14u
=BEUc
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
