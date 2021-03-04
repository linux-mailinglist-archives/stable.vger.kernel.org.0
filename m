Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7D6432CD96
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 08:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbhCDH23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 02:28:29 -0500
Received: from mx1.emlix.com ([136.243.223.33]:49472 "EHLO mx1.emlix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229737AbhCDH2H (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 02:28:07 -0500
Received: from mailer.emlix.com (unknown [81.20.119.6])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.emlix.com (Postfix) with ESMTPS id 8D3985FB76
        for <stable@vger.kernel.org>; Thu,  4 Mar 2021 08:26:39 +0100 (CET)
From:   Rolf Eike Beer <eb@emlix.com>
To:     stable@vger.kernel.org
Subject: [4.14 / 4.9 / 4.4] backport of 2cea4a7a1885bd0c765089afc14f7ff0eb77864e and fe968c41ac4f4ec9ffe3c4cf16b72285f5e9674f
Date:   Thu, 04 Mar 2021 08:23:34 +0100
Message-ID: <4669336.5LvBrcZMKH@devpool47>
Organization: emlix GmbH
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3386889.FFP1lQom1u"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--nextPart3386889.FFP1lQom1u
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"; protected-headers="v1"
From: Rolf Eike Beer <eb@emlix.com>
To: stable@vger.kernel.org
Subject: [4.14 / 4.9 / 4.4] backport of 2cea4a7a1885bd0c765089afc14f7ff0eb77864e and fe968c41ac4f4ec9ffe3c4cf16b72285f5e9674f
Date: Thu, 04 Mar 2021 08:23:34 +0100
Message-ID: <4669336.5LvBrcZMKH@devpool47>
Organization: emlix GmbH

Hi,

the attached patches are the backport of these 2 patches for tools/Makefile=
=20
that allows building when OpenSSL is not at the default location. They appl=
y=20
cleanly to both to 4.4, 4.9, and 4.14. Backports to 4.19 and 5.4 were alrea=
dy=20
sent and are already queued up.

Greetings,

Eike
=2D-=20
Rolf Eike Beer, emlix GmbH, http://www.emlix.com
=46on +49 551 30664-0, Fax +49 551 30664-11
Gothaer Platz 3, 37083 G=C3=B6ttingen, Germany
Sitz der Gesellschaft: G=C3=B6ttingen, Amtsgericht G=C3=B6ttingen HR B 3160
Gesch=C3=A4ftsf=C3=BChrung: Heike Jordan, Dr. Uwe Kracke =E2=80=93 Ust-IdNr=
=2E: DE 205 198 055

emlix - smart embedded open source

--nextPart3386889.FFP1lQom1u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iLMEAAEIAB0WIQQ/Uctzh31xzAxFCLur5FH7Xu2t/AUCYECK9gAKCRCr5FH7Xu2t
/NAlA/9DfxcZKr+mUZkN8lYGDT8nOlJtksoM4AqaBmfbypa9NQlmcHrObCXPTBku
ciCoPyGredxSa0f1NpNPeJHKPzuyRtXZ7L9vZFg8YGB8lKnnvK8HzpGeIPRK65du
hplusTf2K1TXGaItlZ5uO/jxDC9TRNJmjmEsfTCLnda0vkdJkQ==
=WpFG
-----END PGP SIGNATURE-----

--nextPart3386889.FFP1lQom1u--



