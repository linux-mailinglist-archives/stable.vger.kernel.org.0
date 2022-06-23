Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7105580ED
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233380AbiFWQy2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233381AbiFWQuv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:50:51 -0400
Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [95.217.213.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 370964F1F2
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 09:48:46 -0700 (PDT)
Received: from 168.7-181-91.adsl-dyn.isp.belgacom.be ([91.181.7.168] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1o4Q0Z-0000TX-In; Thu, 23 Jun 2022 18:48:43 +0200
Received: from ben by deadeye with local (Exim 4.95)
        (envelope-from <ben@decadent.org.uk>)
        id 1o4Q0Y-001xvp-UF;
        Thu, 23 Jun 2022 18:48:42 +0200
Message-ID: <a460d418d905a3fa2a92095def3cae029ec42289.camel@decadent.org.uk>
Subject: Re: [stable] Improved TCP source port randomisation
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable <stable@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>, Eric Dumazet <edumazet@google.com>,
        Amit Klein <aksecurity@gmail.com>
Date:   Thu, 23 Jun 2022 18:48:42 +0200
In-Reply-To: <YrSO4AO8usZQda1z@kroah.com>
References: <c07281c6d7faa8042cff0a3da7a273eb617cfa13.camel@decadent.org.uk>
         <YrSNqZazgv05N07+@kroah.com> <YrSO4AO8usZQda1z@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-zlrMeSxdm+YJdtGFgwY8"
User-Agent: Evolution 3.44.1-2 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 91.181.7.168
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-zlrMeSxdm+YJdtGFgwY8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2022-06-23 at 18:03 +0200, Greg Kroah-Hartman wrote:
> On Thu, Jun 23, 2022 at 05:58:33PM +0200, Greg Kroah-Hartman wrote:
> > On Wed, Jun 22, 2022 at 12:24:19AM +0200, Ben Hutchings wrote:
> > > Please pick the following commits for 5.4 and 5.10 stable branches:
> > >=20
> > > 90564f36f1c3071d1e0c617cde342f9706e250be tcp: add some entropy in __i=
net_hash_connect()
> > > 506884b616e95714af173c47b89e7d1f5157c190 tcp: use different parts of =
the port_offset for index and offset
> > > dabeb1baad260b2308477991f3006f4a1ac80d6d tcp: add small random increm=
ents to the source port
> > > 735ad25586cd381a3fdc8283e2d1cd4d65f0e9e7 tcp: dynamically allocate th=
e perturb table used by source ports
> > > ada9e93075c7d54a7fd28bae5429ed30ddd89bfa tcp: increase source port pe=
rturb table to 2^16
> > > 82f233b30b728249d1c374b77d722b2e4f55a631 tcp: drop the hash_32() part=
 from the index calculation
> >=20
> > All of these commit ids are not in Linus's tree, are you sure you got
> > them correct?
>=20
> Ah, I can pick them from the mboxes you sent me in the other email...

Oops, sorry about that.

Ben.

--=20
Ben Hutchings
It's easier to fight for one's principles than to live up to them.

--=-zlrMeSxdm+YJdtGFgwY8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmK0mWoACgkQ57/I7JWG
EQlZkxAAgE+0/wNJ/QoslHbPNXPmJ9k74WiTxRMT9S+JZ/AuZ4QRlI7ERS1bJ+so
jeNiKCyV6FBNcjx1pQPlCr/haax5BxqNPG4ptDvLaXonn61vg3RVOLu+GiEfOkLh
l/USCzMS4ZVHeFu4LUkxBGcQSUhn18zsa7t00AlPhKYztUyPgfts8PxHJwceoQfO
Oz3urdXbxMDfMJkxCCZw1r/VIA/PC/Y0Otey6D465e7rUXY9N3pStNJHLgXPl0AR
Fj8P2Sr3/9wf1dyoNktOt+bmZmMCKXY68//DfDYrPim/7rT6Z2A0VACRgpV7TwE4
mpA3AOi89MB1e9IUuNw+/fvuPuMMkoUpC4+rduPpAW1jDWubose4ds/iT8L7y/bW
EzdMJwwPRy2bPAHfqg09SmzrRJxtj7hjSv/prbCuOklfWUqICvTFyur5LCSEHFsB
9JJmJ6phxXZOggJXw+idYoB6pwk6zQQn27SHL0zhOx6h6wrIE9iCMXZVZmd5+9PA
buuU0hp1CsuftOrLM92k6vp86QLonedum/XCa3KYE9Fp/2gHexgDhr+2toDbqx6p
jdh7m4faZGqgnEp690Y2QQIgOYMhb5aWEw7z5mhUbZbNdkFogO0KMyqhVVAwkxfg
MQot08HWqdu1dM1gva33uHCEvY0rEWBcEwlMWieDKA84+m34x7E=
=23p+
-----END PGP SIGNATURE-----

--=-zlrMeSxdm+YJdtGFgwY8--
