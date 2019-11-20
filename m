Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B50F10463F
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 23:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbfKTWCI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 17:02:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:58509 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725936AbfKTWCI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Nov 2019 17:02:08 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Nov 2019 14:02:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,223,1571727600"; 
   d="asc'?scan'208";a="218829808"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga002.jf.intel.com with ESMTP; 20 Nov 2019 14:02:07 -0800
Message-ID: <b9a58fb8446aa374170d386efff7fe7a16c5021e.camel@intel.com>
Subject: Re: [PATCH 4.19 065/422] ice: Fix and update driver version string
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Sasha Levin <sashal@kernel.org>
Date:   Wed, 20 Nov 2019 14:02:06 -0800
In-Reply-To: <20191120215905.GB23361@duo.ucw.cz>
References: <20191119051400.261610025@linuxfoundation.org>
         <20191119051403.893600135@linuxfoundation.org>
         <20191120215905.GB23361@duo.ucw.cz>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-MAM+CBUPqDuYkAcevsoM"
User-Agent: Evolution 3.34.1 (3.34.1-1.fc31) 
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-MAM+CBUPqDuYkAcevsoM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-11-20 at 22:59 +0100, Pavel Machek wrote:
> On Tue 2019-11-19 06:14:22, Greg Kroah-Hartman wrote:
> > From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
> >=20
> > [ Upstream commit 9ea47d81a7f17c6b77211ab75fbca2127719ad39 ]
> >=20
> > Remove the "ice" prefix for the driver version string and bump
> > version
> > to 0.7.1-k.
>=20
> This sounds like a bad idea. 0.7.1 in mainline contains patches that
> were not backported to stable, so marking this as 0.7.1 version is
> wrong.

I agree, backporting this change to stable should not happen.

NAK

> 							=09
> > +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> > @@ -7,7 +7,7 @@
> > =20
> >  #include "ice.h"
> > =20
> > -#define DRV_VERSION	"ice-0.7.0-k"
> > +#define DRV_VERSION	"0.7.1-k"
> >  #define DRV_SUMMARY	"Intel(R) Ethernet Connection E800
> > Series Linux Driver"
> >  const char ice_drv_ver[] =3D DRV_VERSION;
> >  static const char ice_driver_string[] =3D DRV_SUMMARY;
> > --=20
> > 2.20.1
> >=20
> >=20


--=-MAM+CBUPqDuYkAcevsoM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl3Vt94ACgkQ5W/vlVpL
7c7ZbA/6AmAtK8igN+6bVC7UvmhyyF5acGmZijZlheMoA2yZlIKg9jIOoCDCx5p2
btGc4mcmBvXTO5/5G4rKsowsNdolqxNr4M20Pjaj97RALsHmB1OL47ayJ8qQO1lf
mv93bSXFO76sXTiFb+GuqBkgsAD+jaFs1ToGvfVCJ0eo0i4jlKRp/9KtZB+nvDn9
ROu5TywUU9n9q+fMgxK+OqRyvH7rTfe1QOMYAkZZuVjZInkSh1eHk2Jz0soLYoyP
bvG9XLAAlZFbP5o0yMScuo2UOFvsnsJjzGwd3t3o6893xVFF10mRZj4AbYJha3t/
/9RUfMN/hNqenKYE/uA8LIWAdSvWQDK0JjEpiEO5ep+YfKjojY7zZ7CQwnFsKG6F
36Y7xrvZYrnUGSync7eRXy3rwUumrCeDofoUoq5pe4/GWjtlW0a7w09EDSvEvdWa
tiA95Kr8aqNsGpyzlo1KWep40WqkJWEZF57W5k5ucA9+F/yV8lalMQrd/yjcRB+F
k9gWArhYe7G9mMTY+aJtkw1vnAm5qlYYymyVWb13uTO92mG2CdeWUEKbFir0BM3v
V0PmRolx7inrbUHauGLrnuhOmMUq52HStOopyoYJBUWBKpgkPB/dj525hANWu+rJ
Set2ZyxtLuDeGkRdCoC6/gqUrTa9YrCZu752+GjCUlPsmLa0wDg=
=uDda
-----END PGP SIGNATURE-----

--=-MAM+CBUPqDuYkAcevsoM--

