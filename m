Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95F7D6087C
	for <lists+stable@lfdr.de>; Fri,  5 Jul 2019 16:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbfGEOzH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jul 2019 10:55:07 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40668 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725813AbfGEOzH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jul 2019 10:55:07 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hjPc7-0008KK-7y; Fri, 05 Jul 2019 15:55:03 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hjPc6-0007ht-Pm; Fri, 05 Jul 2019 15:55:02 +0100
Message-ID: <7b5ed02b408123b4faf1d25cca141c147431cfc5.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 08/10] tcp: tcp_fragment() should apply sane memory
 limits
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jonathan Looney <jtl@netflix.com>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Tyler Hicks <tyhicks@canonical.com>,
        Neal Cardwell <ncardwell@google.com>,
        Bruce Curtis <brucec@netflix.com>
Date:   Fri, 05 Jul 2019 15:54:57 +0100
In-Reply-To: <37926faa-0f7f-621c-8ee6-ba46d34c8cfc@gmail.com>
References: <lsq.1560868082.489417250@decadent.org.uk>
         <37926faa-0f7f-621c-8ee6-ba46d34c8cfc@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-knK/NfaM1EwGjQg9NetO"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-knK/NfaM1EwGjQg9NetO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2019-07-01 at 19:51 -0700, Florian Fainelli wrote:
> Hi Ben,
>=20
> On 6/18/2019 7:28 AM, Ben Hutchings wrote:
> > 3.16.69-rc1 review patch.  If anyone has any objections, please let me =
know.
> >=20
> > ------------------
> >=20
> > From: Eric Dumazet <edumazet@google.com>
> >=20
> > commit f070ef2ac66716357066b683fb0baf55f8191a2e upstream.
[...]
> Don't we also need this patch to be backported:
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?=
id=3Db6653b3629e5b88202be3c9abc44713973f5c4b4

I've queued that up for the next 3.16 update, thanks.

Ben.

--=20
Ben Hutchings
Quantity is no substitute for quality, but it's the only one we've got.



--=-knK/NfaM1EwGjQg9NetO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl0fZMEACgkQ57/I7JWG
EQlcvxAAza50SJJcvSL4WeB8ppVmSav9xe/XkpDyFyvrC+WpurjvMB0y5kKLFWF6
JKfS3M8nK1PX+5oWnBaSVHg1serv+Z/AXtCBprPjyyd2wG90ikR4h3EjeCyHKnuQ
8lw1f4PUypMHUq1WJDIt8i62pcU6nSwelUPGZbSLcNQpbRJNjSkstb0Lw7lv0xPB
OUlWvkUPiIgbJDqTeP6LoiLY0UKbHdMbzlGx/yrOO9NythJ5s+G58pe5I4URULq7
D6aIqA0jFkwgJV0/TAUG6dnJwkzrVfxmEh4ZwJ+ngP3/sCLUredWPW5qFMJX5Qr3
UsmdrHvtHlpsJoGjHz0CyFdEPJu66f3Zl8JwAWbRzUbf1yjK6lUbjQpRU29E7EXj
a24zURk9L6TjKx56rdVgGsEKTmSmTgo2XEPCVO1kWu427Wpf/RX1RxoQICndO+Ba
GCXTv1YqJxct2ft5Wz9QCydJhpVu+GRh44hQRmk2FAXHfutnJt5DS8bGtr4HQqxD
Uv+JaYkNS+GWVubm2p75Qk7AS97tQ4Rka3TTa8xeuqI48PpibvtOUABLKDiiD8kQ
xWHD1YZcEU+J19iRlRevy4LPo0gA1HTImnPTCwNsuDa37D8Fgs4t4/F/eCBNXg1C
wsq39rF+sbcx+g1xp9sZnfxTzjVG+RkKjinZJu/WssemRktxIsk=
=Ud+D
-----END PGP SIGNATURE-----

--=-knK/NfaM1EwGjQg9NetO--
