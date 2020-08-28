Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22DBC2554D2
	for <lists+stable@lfdr.de>; Fri, 28 Aug 2020 09:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgH1HHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Aug 2020 03:07:31 -0400
Received: from www.zeus03.de ([194.117.254.33]:56428 "EHLO mail.zeus03.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728155AbgH1HH2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Aug 2020 03:07:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=k1; bh=Az1Sk4hkwbQABBKARFwOvsdniom9
        41JaYW/JGUCYwxs=; b=mlsMiFL5Cc9N/xPC5xAFNmDg3WJp3Gd6GkqozaSv3Jmc
        jS1XuZ7g1Zpzgi0qtxXZ+cWUCnLphjKJ/xOi0vfI/MDOkMvyaFWVj3gHo8gh1Kay
        ut7MA0JcdoUsI56xkwXZqJI1KYBeSI2Jh8FcledpF7P3AQtzCqXJMOY41b/oXJo=
Received: (qmail 1185780 invoked from network); 28 Aug 2020 09:07:25 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 28 Aug 2020 09:07:25 +0200
X-UD-Smtp-Session: l3s3148p1@NcB8tOqtFI8gAwDPXwV9AGQXyOmO3Ynm
Date:   Fri, 28 Aug 2020 09:07:25 +0200
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     Eugeniu Rosca <erosca@de.adit-jv.com>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-i2c@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eugeniu Rosca <roscaeugeniu@gmail.com>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Andy Lowe <andy_lowe@mentor.com>
Subject: Re: [PATCH v2] i2c: i2c-rcar: Auto select RESET_CONTROLLER
Message-ID: <20200828070725.GD1343@ninjato>
References: <20200827092330.16435-1-erosca@de.adit-jv.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="q9KOos5vDmpwPx9o"
Content-Disposition: inline
In-Reply-To: <20200827092330.16435-1-erosca@de.adit-jv.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--q9KOos5vDmpwPx9o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 27, 2020 at 11:23:30AM +0200, Eugeniu Rosca wrote:
> From: Dirk Behme <dirk.behme@de.bosch.com>
>=20
> The i2c-rcar driver utilizes the Generic Reset Controller kernel
> feature, so select the RESET_CONTROLLER option when the I2C_RCAR
> option is selected.
>=20
> Fixes: 2b16fd63059ab9 ("i2c: rcar: handle RXDMA HW behaviour on Gen3")
> Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Dirk Behme <dirk.behme@de.bosch.com>
> Signed-off-by: Andy Lowe <andy_lowe@mentor.com>
> [erosca: Add "if ARCH_RCAR_GEN3" on Wolfram's request]
> Signed-off-by: Eugeniu Rosca <erosca@de.adit-jv.com>

Applied to for-next, thanks!


--q9KOos5vDmpwPx9o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl9IrSwACgkQFA3kzBSg
KbZXZg//VIRSaaFqXdc/btBi/FKFe3CQTJF5rr83q7zDXmNCPwmlW5W75nTtYpNa
bEMF+mKziIgs1yELPIzUoitOYPHPjtgGUiwsfjAQ6XotcRk6RWsDi2PRNAnYOVsA
tg+qNv96YZ++t+u7tVEtPVrbj5YwZaKz7W4EvVrPAaIxjF4xtvpXb9sHE9BVbwqC
u2kDFtywya+IHHgT5mP+uqRf73jSpZncuA1KhcTR3o1FFyMV1U9wO5WadJLzsbSy
bjDTrHNDpOBNchFb+0d7BPmHzu6CHq8twpQOqXEdazsqHVAplnElfj5/E0sP3BTy
DKV+KqNzvqOO5Z37Q/+xMx2XGHbd2jCio2jeYXDKQGhgf8zrB7eI30plB6n2F29r
+bK74WgakaT2BBhcLe74iZaxTqIhjTml1zLFVbxxXFm5/FnbXT6U1Ze5bTB05k1G
S6EUa6gaXqZOIwN0g0pSflBop/MWD30sNt4M2bDZN5RxjcWLEAE3KhuRDHQPONmC
kH0fYFbjSjb/U2EnYVrpH9viDl5Xo4EidyzMDZANAHg8u58yJme7Z6ycLscRuuuI
i/cNhDCRGeqzg1Kvg8qBIm6LfzB03yxa3jcYeiVElMriIjo7/xMxHCYEyA7gmNEH
vJYhuv5RXEI/BmZEYmQJIkRR+r+a8oLrxOaO6/dhBXn5EgW/bkU=
=Lp0u
-----END PGP SIGNATURE-----

--q9KOos5vDmpwPx9o--
