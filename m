Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 574DF1D9899
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 15:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728997AbgESNxT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 09:53:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55466 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727086AbgESNxT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 09:53:19 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jb2gA-0000Ym-T6; Tue, 19 May 2020 14:53:10 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jb2gA-000uKi-GB; Tue, 19 May 2020 14:53:10 +0100
Message-ID: <0b158b60fe621552c327e9d822bc3245591a4bd6.camel@decadent.org.uk>
Subject: Backporting "padata: Remove broken queue flushing"
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, stable <stable@vger.kernel.org>
Date:   Tue, 19 May 2020 14:53:05 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-8aSYj/hllzzIHLdFqU8o"
User-Agent: Evolution 3.36.2-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-8aSYj/hllzzIHLdFqU8o
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I noticed that commit 07928d9bfc81 "padata: Remove broken queue
flushing" has been backported to most stable branches, but commit
6fc4dbcf0276 "padata: Replace delayed timer with immediate workqueue in
padata_reorder" has not.

Is this correct?  What prevents the parallel_data ref-count from
dropping to 0 while the timer is scheduled?

Ben.

--=20
Ben Hutchings
Larkinson's Law: All laws are basically false.


--=-8aSYj/hllzzIHLdFqU8o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl7D5MEACgkQ57/I7JWG
EQm9Bg//QAhe9WehPg50caN5e9YGyXbSJjYPJueqpnQhCSf0m6fXXcCJQyxBe9mY
4gONFO6eYPCRCZnrEpyq31ZjsQJap6h/u603Rb9F1Awus9ILHxL2L3gBktf4zEcS
1DtBUPWE75KXHIQxZC0c2APgO+ay3zQ7Qh3X0SJNB7ahELJ4PQX5AIFAxoHLQADq
Vatu+BFlmzSqbivrb1i92+d1Guhq+ELyX0ZgYjVJJkfb4tlPrsAaOS7JJFsCCqCh
8ZH9ailNkNLhTi9unMISOypGMdrHVdCf0BeXZTrirOwBtlBluEE19OS/djMgbwS3
Z0LXWh5HoWPSS6UuzpptycB3sW33xXjW+Xr30Ze1/SPb1ztOFUrWdLr1jbxawF4y
HuMfWcTYmnMu3DwvcMN3rqik7ghyUV+mWJtuJ9gwHKJ5KILIa116bpct+mqFP270
kqiFF0/FUlJezRD115ywzL+nwxoIpoOzXzWZpxG/7BTMD+559Lb8ad15RJZOX14Q
wJFiMfZRGXl0Bbwr9XtCOVHIhRlh3SjY0sHSRLfn1UPqBOlfOIHvF6dvenvyIbpZ
lkAqVB//CT3WqMWvm70EJC5vhbawl88r08hwFUUx2I647gm4lbQdWLqhU3mTWuS+
D4iWNS8KxGb4au8JiaBa939kpTbLrC7KLc3LDPSw16RLtcvJtL8=
=t2oh
-----END PGP SIGNATURE-----

--=-8aSYj/hllzzIHLdFqU8o--
