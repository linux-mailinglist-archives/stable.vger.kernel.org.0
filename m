Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBC12712E7
	for <lists+stable@lfdr.de>; Sun, 20 Sep 2020 10:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgITIab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Sep 2020 04:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgITIab (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Sep 2020 04:30:31 -0400
X-Greylist: delayed 104 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 20 Sep 2020 01:30:30 PDT
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [IPv6:2a00:da80:fff0:2::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B9EC061755
        for <stable@vger.kernel.org>; Sun, 20 Sep 2020 01:30:30 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 7E5291C0B96; Sun, 20 Sep 2020 10:30:26 +0200 (CEST)
Date:   Sun, 20 Sep 2020 10:30:25 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     stable@vger.kernel.org, Greg KH <greg@kroah.com>,
        prabhakar.csengg@gmail.com, mchehab@kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH 4.19] media: da_vinci: fix code duplication due to missmerge
Message-ID: <20200920083025.GA991@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


I'm not sure what went wrong there, but same block of code is there,
twice. Probably some kind of mis-merge.

Fix it.

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>

--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1633,11 +1633,6 @@ static __init int vpif_probe(struct platform_device =
*pdev)
 		return -EINVAL;
 	}
=20
-	if (!pdev->dev.platform_data) {
-		dev_warn(&pdev->dev, "Missing platform data.  Giving up.\n");
-		return -EINVAL;
-	}
-
 	vpif_dev =3D &pdev->dev;
=20
 	err =3D initialize_vpif();

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl9nEyEACgkQMOfwapXb+vK76gCeOZFV7NV44O1PSwX3V1uJhaLK
e3YAnjaATsfy6Wd9PBdkKGSczN6DchHx
=XONN
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--
