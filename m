Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C704C4983B9
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 16:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbiAXPnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 10:43:21 -0500
Received: from maynard.decadent.org.uk ([95.217.213.242]:42210 "EHLO
        maynard.decadent.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240632AbiAXPnV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 10:43:21 -0500
Received: from 168.7-181-91.adsl-dyn.isp.belgacom.be ([91.181.7.168] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1nC1V1-0006td-JA; Mon, 24 Jan 2022 16:43:19 +0100
Received: from ben by deadeye with local (Exim 4.95)
        (envelope-from <ben@decadent.org.uk>)
        id 1nC1V1-009yzt-1j;
        Mon, 24 Jan 2022 16:43:19 +0100
Date:   Mon, 24 Jan 2022 16:43:19 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable@vger.kernel.org
Cc:     Andy Spencer <aspencer@spacex.com>,
        Michael Braun <michael-dev@fami-braun.de>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [stable 4.9,4.14] gianfar rx fixes
Message-ID: <Ye7JF4yOYE3y8QEJ@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="EOAzPLx7kVjRivnB"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 91.181.7.168
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--EOAzPLx7kVjRivnB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Please pick the following commits for 4.9 and 4.14.  They should apply
cleanly.

commit d903ec77118c09f93a610b384d83a6df33a64fe6
Author: Andy Spencer <aspencer@spacex.com>
Date:   Thu Feb 22 11:05:33 2018 -0800

    gianfar: simplify FCS handling and fix memory leak

commit d8861bab48b6c1fc3cdbcab8ff9d1eaea43afe7f
Author: Michael Braun <michael-dev@fami-braun.de>
Date:   Thu Mar 4 20:52:52 2021 +0100

    gianfar: fix jumbo packets+napi+rx overrun crash

Ben.

--=20
Ben Hutchings
Teamwork is essential - it allows you to blame someone else.

--EOAzPLx7kVjRivnB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmHuyQ4ACgkQ57/I7JWG
EQn2vw/8CWrnRlvB5ecDBZKOWPw2eALbfK5E7Ng5qZYSCh0PX8j2RQzSVU8d7io9
TbbbJEYC3R4zbpOjZOhMejPvgKvrR4B7YcdBO2nxeiSWtQaBp6Kq53bftNK07DP5
G2npCqyRHFKLOf0n8/Vtyg/dotNY8cZKfuz0xl+dnFbBAD7218rFKZPBFCWyYGEf
tO7ldWqPtCnALqOCv2RybNC0EYhLKOtvyPNMchVnVEPmHN5GgV4Xf9ShEmSubMAx
vbj+2ByVSmtqxVzlkuaUFR/dHwsGTrrsDUdBsFNEodrtcmjBtDU+wcTciEzd7PQE
KOQ1TBGGcyjb/5w1kNbyIRTuhS5I9UJZTTox/DUDpryqqv+ETzBexm5knqukSERM
OwsBYwas/hA+dpqUdVF5pVpUtYWJkQCzsf5jjJDGlgNXkDzJclFzcq5sdvlr246P
Jy1HI5Vme8g+5V17cBvXZ3QJWIDDxRcQ+ZD+b71MfCXoFAagPifNW72Objlv9cBW
212ZpwJhBGn6qc1rnWZRQB4UmxNmdlahM6PV+KlUuFNontqFLHQ7DiaP0D9h6Lsk
FYjsP0sBL/kz0p0yYtmXI3/I6GP8yGGNdMuUuCTruGQCVeWw+uhxnDKBxOLrkHeN
G+VE2bPKi2H5qwBeZKANdMtg1W31LWxVnTNg7QKGPs7ImoWRYMk=
=PXdd
-----END PGP SIGNATURE-----

--EOAzPLx7kVjRivnB--
