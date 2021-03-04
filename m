Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6095532CD95
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 08:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbhCDH1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 02:27:25 -0500
Received: from mx1.emlix.com ([136.243.223.33]:49470 "EHLO mx1.emlix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229737AbhCDH1V (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 02:27:21 -0500
Received: from mailer.emlix.com (unknown [81.20.119.6])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.emlix.com (Postfix) with ESMTPS id 8B6C35F780
        for <stable@vger.kernel.org>; Thu,  4 Mar 2021 08:26:39 +0100 (CET)
From:   Rolf Eike Beer <eb@emlix.com>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 / 4.9 / 4.4 2/2] scripts: set proper OpenSSL include dir also for  sign-file
Date:   Thu, 04 Mar 2021 08:26:28 +0100
Message-ID: <1859038.itBudK23F7@devpool47>
Organization: emlix GmbH
In-Reply-To: <4669336.5LvBrcZMKH@devpool47>
References: <4669336.5LvBrcZMKH@devpool47>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3317947.1oUap0M5Nd"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--nextPart3317947.1oUap0M5Nd
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"; protected-headers="v1"
From: Rolf Eike Beer <eb@emlix.com>
To: stable@vger.kernel.org
Subject: [PATCH 4.14 / 4.9 / 4.4 2/2] scripts: set proper OpenSSL include dir also for  sign-file
Date: Thu, 04 Mar 2021 08:26:28 +0100
Message-ID: <1859038.itBudK23F7@devpool47>
Organization: emlix GmbH
In-Reply-To: <4669336.5LvBrcZMKH@devpool47>
References: <4669336.5LvBrcZMKH@devpool47>

commit fe968c41ac4f4ec9ffe3c4cf16b72285f5e9674f upstream.

=46ixes: 2cea4a7a1885 ("scripts: use pkg-config to locate libcrypto")
Signed-off-by: Rolf Eike Beer <eb@emlix.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
=2D--
 scripts/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/Makefile b/scripts/Makefile
index 6a9f6db114b0..fb82adadb680 100644
=2D-- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -25,6 +25,7 @@ hostprogs-$(CONFIG_SYSTEM_EXTRA_CERTIFICATE) +=3D insert-=
sys-
cert
=20
 HOSTCFLAGS_sortextable.o =3D -I$(srctree)/tools/include
 HOSTCFLAGS_asn1_compiler.o =3D -I$(srctree)/include
+HOSTCFLAGS_sign-file.o =3D $(CRYPTO_CFLAGS)
 HOSTLOADLIBES_sign-file =3D $(CRYPTO_LIBS)
 HOSTCFLAGS_extract-cert.o =3D $(CRYPTO_CFLAGS)
 HOSTLOADLIBES_extract-cert =3D $(CRYPTO_LIBS)
=2D-=20
2.30.1

=2D-=20
Rolf Eike Beer, emlix GmbH, http://www.emlix.com
=46on +49 551 30664-0, Fax +49 551 30664-11
Gothaer Platz 3, 37083 G=C3=B6ttingen, Germany
Sitz der Gesellschaft: G=C3=B6ttingen, Amtsgericht G=C3=B6ttingen HR B 3160
Gesch=C3=A4ftsf=C3=BChrung: Heike Jordan, Dr. Uwe Kracke =E2=80=93 Ust-IdNr=
=2E: DE 205 198 055

emlix - smart embedded open source

--nextPart3317947.1oUap0M5Nd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iLMEAAEIAB0WIQQ/Uctzh31xzAxFCLur5FH7Xu2t/AUCYECLpAAKCRCr5FH7Xu2t
/NKvBADD0eg0utXw1qP+Tz4MVWLlsETUrYCWiXP8ehBOQnuYwrXcQ20QwyDrc4Ji
kkYWoLs8geqDxsuV7vwX6l0ZPWm/s/c+2EkGAvzFj8kRqzdgm7BaKK2d/7if+sIX
DwhfTXsxRoDS65+jvPW4ht1YTahc8HBVNBsEfVz4wvFhAS2WjQ==
=MiSn
-----END PGP SIGNATURE-----

--nextPart3317947.1oUap0M5Nd--



