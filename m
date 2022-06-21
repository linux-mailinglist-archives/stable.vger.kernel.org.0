Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00572553EC1
	for <lists+stable@lfdr.de>; Wed, 22 Jun 2022 00:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbiFUWzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 18:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbiFUWzQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 18:55:16 -0400
Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [95.217.213.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D1182E6BD
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 15:55:15 -0700 (PDT)
Received: from 168.7-181-91.adsl-dyn.isp.belgacom.be ([91.181.7.168] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1o3mIL-0003w7-BZ; Wed, 22 Jun 2022 00:24:25 +0200
Received: from ben by deadeye with local (Exim 4.95)
        (envelope-from <ben@decadent.org.uk>)
        id 1o3mIK-001pZy-Q9;
        Wed, 22 Jun 2022 00:24:24 +0200
Message-ID: <c07281c6d7faa8042cff0a3da7a273eb617cfa13.camel@decadent.org.uk>
Subject: [stable] Improved TCP source port randomisation
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable <stable@vger.kernel.org>, Willy Tarreau <w@1wt.eu>,
        Eric Dumazet <edumazet@google.com>,
        Amit Klein <aksecurity@gmail.com>
Date:   Wed, 22 Jun 2022 00:24:19 +0200
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-dTlylauhtNLFnkPNeWRY"
User-Agent: Evolution 3.44.1-2 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 91.181.7.168
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,HEXHASH_WORD,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-dTlylauhtNLFnkPNeWRY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please pick the following commits for 5.4 and 5.10 stable branches:

90564f36f1c3071d1e0c617cde342f9706e250be tcp: add some entropy in __inet_ha=
sh_connect()
506884b616e95714af173c47b89e7d1f5157c190 tcp: use different parts of the po=
rt_offset for index and offset
dabeb1baad260b2308477991f3006f4a1ac80d6d tcp: add small random increments t=
o the source port
735ad25586cd381a3fdc8283e2d1cd4d65f0e9e7 tcp: dynamically allocate the pert=
urb table used by source ports
ada9e93075c7d54a7fd28bae5429ed30ddd89bfa tcp: increase source port perturb =
table to 2^16
82f233b30b728249d1c374b77d722b2e4f55a631 tcp: drop the hash_32() part from =
the index calculation

I will send backports for older branches after this.

(All stable branches have the other 2 commits from this series; I'm not
sure why the whole series wasn't applied.)

Ben.

--=20
Ben Hutchings
Man invented language to satisfy his deep need to complain.
                                                          - Lily Tomlin

--=-dTlylauhtNLFnkPNeWRY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmKyRRQACgkQ57/I7JWG
EQn00RAAsnfcom/hYHUQ9WTLv7L548HL2iCG7p9hxlwU91/3BJ9xCW2ylZsO6tYI
i1RWCQNm0c6mBNGMFyP/SNR7DpKsEbcJkeX7B2gLlxVKRCSL1Ash4NiPWoQeF5IK
fsabmobJfqfhnadimypQ3EjVpGRyyGr3ocH3p6v2iUntjBKaPKB/E+oGLfKwrzjw
dpSWcLWm77N7dBxWSiKzRFCdQz+Ihbg2+4c6pmY2adIpfCpugyG7sgdRcp5BnpSy
I7X+tV87pBl3VxDxFBXbkFVej9Tk8DmUREgEvG7nQIvWUiIEJInEfs4LzRnvGzjV
L1UBqECnH4b4jqiHp3qMBjwaiaqtzNe4IvqTyImYOYE9rjstErqNvODKMI4AlM5F
zwrqjb4ym+TKp6JtK4mm9L50GBjIINpWtWI7zJYPZNX5Qdw7Vz0aDZVmSWYJvRN2
MQfyB0vP3oQwC3kRgsY7rS1YLftTYIKLrZF8IIJXOGl5DIMwtFJElTnj9dQZdTOq
qd3P0DMIN8eil9NIJ31oVggh/to9H6ICjZ3T469YYWE0aKqmi8fcbvH2PAh7faGp
bnJ7wQn6tpMX+rvONJyrAFYxJGNXZefgX4PUqjiTDurEsT+TyUToaltyUHAW6u7t
fVASH1ruOPol3ECj5ViBLnukvq9dF64/51kholmRKizZnfuicD4=
=Abkl
-----END PGP SIGNATURE-----

--=-dTlylauhtNLFnkPNeWRY--
