Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2897B185FCD
	for <lists+stable@lfdr.de>; Sun, 15 Mar 2020 21:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729151AbgCOUg5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Mar 2020 16:36:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59142 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729122AbgCOUg5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Mar 2020 16:36:57 -0400
Received: from [2001:8b0:7bc4:6b97:e0:2819:e4a9:bc26] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jDa0F-00035j-Kr; Sun, 15 Mar 2020 20:36:55 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jDa0F-00CkkA-15; Sun, 15 Mar 2020 20:36:55 +0000
Message-ID: <8508c19359077ac33c9ef305c468a44c6ddff772.camel@decadent.org.uk>
Subject: Re: [PING] EFI/PTI fix not backported to 3.16.XX?
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Pavel Tatashin <pasha.tatashin@soleen.com>
Cc:     stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        Martin Galvan <omgalvan.86@gmail.com>
Date:   Sun, 15 Mar 2020 20:36:46 +0000
In-Reply-To: <CA+CK2bCEtgvkG7jd3rm2gipKE6KQ4dzfgFGERoib5W-=pchDWw@mail.gmail.com>
References: <CAN19L9Fi0h0wHOyY3zdAU4vX=J+T_3sVkL_wsq89W+RgF7gBxA@mail.gmail.com>
         <CA+CK2bCEtgvkG7jd3rm2gipKE6KQ4dzfgFGERoib5W-=pchDWw@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-St97vTNwbFyYAzfPGOmy"
User-Agent: Evolution 3.34.1-4 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2001:8b0:7bc4:6b97:e0:2819:e4a9:bc26
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-St97vTNwbFyYAzfPGOmy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2020-03-13 at 18:41 +0000, Pavel Tatashin wrote:
> Hi Ben,
>=20
> I have tested and it cherry-picks cleanly on 3.16. I do not see any
> issues with backporting it to 3.16. Do you want me to send a patch for
> review, or can you just cherry-pick 7ec5d87df34a to 3.16?

I've queued this up, thanks.

Ben.

> Thank you,
> Pasha
>=20
>=20
> On Fri, Mar 13, 2020 at 10:09 AM Martin Galvan <omgalvan.86@gmail.com> wr=
ote:
> > Hi all,
> >=20
> > I've been running some tests on Debian 8 (which uses a 3.16.XX
> > kernel), and saw that my system would occasionally reboot when
> > performing an EFI variables dump. I did some digging and saw that this
> > problem first appeared in 4.4.110 and was fixed by Pavel Tatashin in
> > commit 7ec5d87df34a. At the same time, 4.9.XX, 4.14.XX and mainline
> > have commit 67a9108ed431, which also solves the issue. However, the
> > 3.16 stable line doesn't seem to have either fix, and therefore the
> > crash is still there.
> >=20
> > I don't know whether any distros use 3.16 other than Debian, but it'd
> > still be good to have this fix backported as well.
>=20
>=20
--=20
Ben Hutchings
Humour is the best antidote to reality.



--=-St97vTNwbFyYAzfPGOmy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl5ukd8ACgkQ57/I7JWG
EQnExg/+MLjqT2iZn70JS5WvveAu0ZJl2tYqG0fxlkOUQR6bIPnvQUsKWG3o1WMI
my+sL5jQhUYlkPIjJ5Z9V2ySvcAXoEX43Cya36IWNrnocMvk0c+9xq4At+ICGO5W
FYr/cf7n+2cV3H9x1Keqtb2MsSbUQiRdFQogxuqF4zhVxpjmqxp452EamZNOD91G
iiGgsJZwBtMIyTxa9tdxT+Q3Ly06SsM/gWLjN+OF6TFCKbg9Yii/dnTZYvfQnfjx
SWe8VjqGfhnDuf64hFqoq1dj6KY+d1N4rl3We6JLEd4UgDrAyu2kMOjRuEg1AKbD
sfqh95yG162Q4nwkKbiKZ0puK9basBIOzeGEKoESCg65j2Mfk5puFetzdJikBxMy
AMhN3D3U/TLRCj+FHqrIjCIwFcpAzBLRPbp8j24K/1ZwRrdeejNSFvX6RXWoKiE4
QpD+y4reT0VLz18PNhFOYC4rTc8RLyNaQJCjONuK3E18/vbwVpnw9OUz9zl8NupQ
LoEGa3RGzSMAcwq5326XyUhcleccCsBybo1/RZ9WTkRqfcrvUKGVImOcZEZAqfT0
2/7/606yigzHJzEvzf26BdWy/XP0uaLNyumtzeekuRgtjwnwpOCz8fboGzlELvHb
8ibdfN5mp/99Z0FzM83HUB92LSFG+HtsVIM+OEt8CBFnBdV4GoE=
=shF0
-----END PGP SIGNATURE-----

--=-St97vTNwbFyYAzfPGOmy--
