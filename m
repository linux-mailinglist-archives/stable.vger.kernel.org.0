Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71511102E3C
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 22:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbfKSVbn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 16:31:43 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47972 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726874AbfKSVbn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 16:31:43 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXB65-0003lK-Oz; Tue, 19 Nov 2019 21:31:41 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXB65-00053v-C0; Tue, 19 Nov 2019 21:31:41 +0000
Date:   Tue, 19 Nov 2019 21:31:41 +0000
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Subject: [PATCH website] releases: Extend 3.16 EOL to match Debian 8
Message-ID: <20191119213141.GA19244@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm maintaining 3.16 primarily for Debian 8.  I originally expected
that to have an EOL of April 2020 but it's actually June.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 content/releases.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/content/releases.rst b/content/releases.rst
index dbbe0d69db9d..0908fd090cdc 100644
--- a/content/releases.rst
+++ b/content/releases.rst
@@ -45,7 +45,7 @@ Longterm
     4.14     Greg Kroah-Hartman & Sasha Levin 2017-11-12   Jan, 2024
     4.9      Greg Kroah-Hartman & Sasha Levin 2016-12-11   Jan, 2023
     4.4      Greg Kroah-Hartman & Sasha Levin 2016-01-10   Feb, 2022
-    3.16     Ben Hutchings                    2014-08-03   Apr, 2020
+    3.16     Ben Hutchings                    2014-08-03   Jun, 2020
     =3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
 Distribution kernels

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl3UXzgACgkQ57/I7JWG
EQk+tw/+OOFHZ73t48BRbhufzQRpHIENPtHcOyCzpOpEAalQX6cFAO4N47xWhrdF
EFHT7sK5Q/4PRuA+fzksuBPonXBLlDo3VPtB8hb9ILp+9pjyPoLp4+gMDsw4E5dH
2/PP2hDAUQ6ircxZEj2UFjd1FKTQs8bIZwo/nagnldCLl4UWnodtj8k8o10ezbmb
5Tk912RIpPKUMjpYYRkEkhgtkslvCeWHh2OA/CEFDicZ3WcDtBvWXyPVSzYCmyHE
7fGNGo2rbhd+O256RJFi5D56hCKgDF10mgDIoAhmVzh99IIMVwznnse98huYxkta
MSBDL+GK+FflueV3pbyC4TdvvcAtg+D1uSQ7b+n2AXH73gLEfAtIQh+9HrLP2Gnk
yDUy3DlO9eefM5AKe5TRnUDikPmTSLqCjV9GT3weW5MTJ7uhAi/6GbFmyN8Flz00
xCDFBg4kTh/zCVKv2X01pu172tyUjKWBB6oCPWd+HJCmoAeh9pL/kuTrZDCCwRTX
l10Rl9C3i9tkiXSuGwfNGRRixxUJczH/sKTkGRA5UFw4xrDkxJh9wKHinbjlqaJ7
nduMBarzEzyYeEDFtno4u/bTdqjJHGMRKoJznKMTd0tnf4QfkjmlPvydvHn83+8/
go1/in2NLj7cO+hQ02q5RXDjJrtxqYs2wded0IEagAVJdJcZ+ew=
=6FzO
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
