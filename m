Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 025C27EF25
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 10:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404114AbfHBIZG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 04:25:06 -0400
Received: from mx1.emlix.com ([188.40.240.192]:35922 "EHLO mx1.emlix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404103AbfHBIZG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 04:25:06 -0400
Received: from mailer.emlix.com (unknown [81.20.119.6])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.emlix.com (Postfix) with ESMTPS id 0C61F60946;
        Fri,  2 Aug 2019 10:17:05 +0200 (CEST)
From:   Rolf Eike Beer <eb@emlix.com>
To:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc:     Greg KH <greg@kroah.com>, stable@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 4.9.180 build fails with gcc 9 and 'cleanup_module' specifies less restrictive attribute than its target =?UTF-8?B?4oCm?=
Date:   Fri, 02 Aug 2019 10:17:04 +0200
Message-ID: <4007272.nJfEYfeqza@devpool35>
Organization: emlix GmbH
In-Reply-To: <CANiq72n2E4Ue0MU5mWitSbsscizPQKML0QQx_DBwJVni+eWMHQ@mail.gmail.com>
References: <259986242.BvXPX32bHu@devpool35> <20190606185900.GA19937@kroah.com> <CANiq72n2E4Ue0MU5mWitSbsscizPQKML0QQx_DBwJVni+eWMHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2919239.1tgsZgVOpZ"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--nextPart2919239.1tgsZgVOpZ
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

Am Samstag, 8. Juni 2019, 14:00:34 CEST schrieb Miguel Ojeda:
> On Thu, Jun 6, 2019 at 8:59 PM Greg KH <greg@kroah.com> wrote:
> > "manually fixing it up" means "hacked it to pieces" to me, I have no
> > idea what the end result really was :)
> >=20
> > If someone wants to send me some patches I can actually apply, that
> > would be best...
>=20
> I will give it a go whenever I get some free time :)

I fear this has never happened, did it?

Eike
=2D-=20
Rolf Eike Beer, emlix GmbH, http://www.emlix.com
=46on +49 551 30664-0, Fax +49 551 30664-11
Gothaer Platz 3, 37083 G=C3=B6ttingen, Germany
Sitz der Gesellschaft: G=C3=B6ttingen, Amtsgericht G=C3=B6ttingen HR B 3160
Gesch=C3=A4ftsf=C3=BChrung: Heike Jordan, Dr. Uwe Kracke =E2=80=93 Ust-IdNr=
=2E: DE 205 198 055

emlix - smart embedded open source
--nextPart2919239.1tgsZgVOpZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iLMEAAEIAB0WIQQ/Uctzh31xzAxFCLur5FH7Xu2t/AUCXUPxgAAKCRCr5FH7Xu2t
/MnXA/wIyiTuEKU/RL+E+Mp4M3W4PnHlYfRL9rmX1ZvudWZvt7nykx3c3RcrDb4X
2e3V8u4FxoqqFab9TnaR6Aio1tDcQ9lufrNzVKoa2VpfW/Yb5IBckJxUbrp65p88
kJwjl7rPZ2oPF80iuHhOs7jpy1YvM9tv0ca8MRUXnQR5a4DZgw==
=T7ca
-----END PGP SIGNATURE-----

--nextPart2919239.1tgsZgVOpZ--



