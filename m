Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCD7C10279C
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 16:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbfKSPFT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 10:05:19 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46176 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727066AbfKSPFS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 10:05:18 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iX548-0006Z9-Eq; Tue, 19 Nov 2019 15:05:16 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iX548-0002N9-2O; Tue, 19 Nov 2019 15:05:16 +0000
Message-ID: <46dc1928560995ad297c47de39c067b66f0babc4.camel@decadent.org.uk>
Subject: Re: Fix bad backport to stable v3.16+
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Song Liu <songliubraving@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Nigel Croxon <ncroxon@redhat.com>,
        "linux@thorsten-knabe.de" <linux@thorsten-knabe.de>
Date:   Tue, 19 Nov 2019 15:05:10 +0000
In-Reply-To: <5F8253BF-1167-4A48-A3AC-E0728E1EE6CB@fb.com>
References: <5F8253BF-1167-4A48-A3AC-E0728E1EE6CB@fb.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-HOTLde77X4/KNkvQnvHn"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-HOTLde77X4/KNkvQnvHn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-05-22 at 16:30 +0000, Song Liu wrote:
> Hi,=20
>=20
> As reported by Thorsten Knabe <linux@thorsten-knabe.de>.=20
>=20
> commit 4f4fd7c5798b ("Don't jump to compute_result state from check_resul=
t state") =20
> was back ported to v3.16+. However, this fix was wrong. =20

I never backported it to 3.16=E2=80=A6

> Please back port the following two commits to fix this issue.=20
>=20
> commit a25d8c327bb4 ("Revert "Don't jump to compute_result state from che=
ck_result state"")

=E2=80=A6so I didn't need this=E2=80=A6

> commit b2176a1dfb51 ("md/raid: raid5 preserve the writeback action after =
the parity check")

=E2=80=A6but I have queued this up, thanks.

Ben.

--=20
Ben Hutchings
Theory and practice are closer in theory than in practice - John Levine



--=-HOTLde77X4/KNkvQnvHn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl3UBKYACgkQ57/I7JWG
EQm+XRAAjuq7lPYfpLakVu9CkQzfx2ts5oLLvYalovtkpktY5i/sFChs+Y+K5J2N
gpcRCz+sF2nvp8fMEC7jisO3Gt3KYKAAtsjWgbMY8w0KL8QC8CgPGxW7Bwil4VNh
/I/A6Khncldln5N1xa9CqN3ix37aUGe+j1BQARgsAd47K9OmMmd4FOMZOpqj3u5Z
pih2aJuNxsWP9ncwNFHg5K0ehQQ5pxo15N1Ov2fLsLbx1JHT2ZkhrwWaEgERHfZA
r8edwi82bXRhEcFSLjbl/Z4Qk1ZtRfXtO3EklSMC61jelABFRyPZTIqIp42zCbOJ
XNHPTqOnIdqUeJA8c8mq7b1CN9Y+pvQ7QVlcrmUNk146KYvDMXBWuIzbY6BnK4qU
qKT8NJiuCbc1L1F4NUOhq+tL6rhjH6j0Haedfy2Obyt7HGvgNYpqnCrXRWx2qTUn
LUwb+pqB62VbLvw6bwj+xznsMamv5pTIhsk29RykopfhoLG76nKR9ZRW4j2yi/9g
L94Ot9hhxfDf62afzDvV6hjy946tbXcQqx+sNZnm0JzVW3vsxdcsUE35iaUjE7zU
Y4Bapxg2QuNxilhDQ86E5hnJBTCigjv0sIEgbzvQTO4Mr6p5lTKoQb5AQ7zAVSlx
e8fc3KHS6k2wiJ47i5UNRLfUYZMzfHgan9MVPAGD1LTYrdqhNm4=
=ioIL
-----END PGP SIGNATURE-----

--=-HOTLde77X4/KNkvQnvHn--
