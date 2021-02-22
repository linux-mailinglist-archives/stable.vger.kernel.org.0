Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834FA321988
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 14:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231638AbhBVN5S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 08:57:18 -0500
Received: from mx1.emlix.com ([136.243.223.33]:41600 "EHLO mx1.emlix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231860AbhBVN4c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 08:56:32 -0500
Received: from mailer.emlix.com (p5098be52.dip0.t-ipconnect.de [80.152.190.82])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.emlix.com (Postfix) with ESMTPS id CAB225FA09
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 14:54:46 +0100 (CET)
From:   Rolf Eike Beer <eb@emlix.com>
To:     stable@vger.kernel.org
Subject: [5.4 / 4.19] backport of 2cea4a7a1885bd0c765089afc14f7ff0eb77864e and fe968c41ac4f4ec9ffe3c4cf16b72285f5e9674f
Date:   Mon, 22 Feb 2021 14:51:36 +0100
Message-ID: <2934400.eNZDa4x5nO@devpool47>
Organization: emlix GmbH
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1835111.1NzRSpx9Dy"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--nextPart1835111.1NzRSpx9Dy
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"; protected-headers="v1"
From: Rolf Eike Beer <eb@emlix.com>
To: stable@vger.kernel.org
Subject: [5.4 / 4.19] backport of 2cea4a7a1885bd0c765089afc14f7ff0eb77864e and fe968c41ac4f4ec9ffe3c4cf16b72285f5e9674f
Date: Mon, 22 Feb 2021 14:51:36 +0100
Message-ID: <2934400.eNZDa4x5nO@devpool47>
Organization: emlix GmbH

Hi,

the attached patches are the backport of these 2 patches for tools/Makefile=
=20
that allows building when OpenSSL is not at the default location. They appl=
y=20
cleanly to both to 5.4.99 and 4.19.176. Backports for older stable kernels=
=20
will follow.

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

--nextPart1835111.1NzRSpx9Dy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iLMEAAEIAB0WIQQ/Uctzh31xzAxFCLur5FH7Xu2t/AUCYDO26AAKCRCr5FH7Xu2t
/F+bA/0aMjakPo8WNS9BWD9mjxmnoTT/zk6FQ5j14p80OhtsBgNAtnX3EY7KYyyx
WsMGIIMQOmaxLPEB4Gbyrxgy2djs5uw615TdtL1lsMkyO7OmKqkpM2jcNpCd0U8X
FG0tDdtH0J8nueqBGY2MX1rcApJmGFObTrSTA85WCoT4tpM8mg==
=QaQ1
-----END PGP SIGNATURE-----

--nextPart1835111.1NzRSpx9Dy--



