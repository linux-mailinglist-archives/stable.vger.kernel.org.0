Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A896711C025
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 23:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbfLKWvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 17:51:35 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58440 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726345AbfLKWvf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 17:51:35 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ifApR-00013j-Lz; Wed, 11 Dec 2019 22:51:33 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ifApR-0000iN-30; Wed, 11 Dec 2019 22:51:33 +0000
Message-ID: <f2a2e4711db1903b927c9477cfb7703ca566317c.camel@decadent.org.uk>
Subject: [stable] net: qrtr: fix memort leak in qrtr_tun_write_iter
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable <stable@vger.kernel.org>,
        Navid Emamdoost <navid.emamdoost@gmail.com>
Date:   Wed, 11 Dec 2019 22:51:32 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-Tnk8cHMhy6I7Mn9EqK03"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-Tnk8cHMhy6I7Mn9EqK03
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please pick this commit for 4.19 only (newer branches already have it;
older branches don't include this protocol):

commit a21b7f0cff1906a93a0130b74713b15a0b36481d
Author: Navid Emamdoost <navid.emamdoost@gmail.com>
Date:   Wed Sep 11 10:09:02 2019 -0500

    net: qrtr: fix memort leak in qrtr_tun_write_iter

Ben.

--=20
Ben Hutchings
The generation of random numbers is too important to be left to chance.
                                                       - Robert Coveyou



--=-Tnk8cHMhy6I7Mn9EqK03
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl3xcvQACgkQ57/I7JWG
EQlJ9xAAoLZ26QWA/curYphKuOn9a3iw5uTJ4hnNrZKFDhVDee62TKipw3J/Nv9P
3bZecldm0T4BtbeMsm9AMhAeG3nyNV6cvC0C6u/hJKTh9ia5tVaTT4h6jbeyYlbt
hmzYMZPL+Z5hRPJpijif6RZ2AAhphvMGObYzOyDMRqGnr7qyqdfiNfQp2kDRYrEs
xVONsMPeoblhMnzfPOxUriNPt1B2TMqfTqOOEGaDUNaj6cSF27EVdqgjtv/yr0fp
IG12DPvqBWrzmt5jaPywmJDearB9sTtDEyqjJqhnAFvB2DmBwC1jEs9nvMzBrIO1
6wiGDJTOZe+Mr9S7zuyfGuh4aOAA2FO3wt27h1LIUiXvbMTCWo5QiC6Ew+d4x9IN
KNyUSjmHWxLcLEn5i2jiviOFD9rZGicuVnJ6Jq4swx0gb23df4NKvcwYC+gYGt7f
qcjRz1s2/yUf6aeB+5hQ6oVDmZAYliKT0QMXsMrEhDVWdeml2lCtZg95t68JzpDP
Ogpte44ocAKddSmnA159+Ftzo97Fb6AGPZtGwRKtCVmCJq+x8RJcDF3N4Z16qdjP
I1JVjc/3o9kDCLz+pCMsYdJoXeHXCeg+k++TOyPbKu8ltovqpN6Rekl2SNHwMWlu
DxaQBGYCfpC4grqC9WFozV2lZwl0SA5gXodPGW6dbdJUqXrkAoU=
=4DYP
-----END PGP SIGNATURE-----

--=-Tnk8cHMhy6I7Mn9EqK03--
