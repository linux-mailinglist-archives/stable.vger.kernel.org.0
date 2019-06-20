Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF8F4CB0B
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 11:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbfFTJhU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 05:37:20 -0400
Received: from mx2.mailbox.org ([80.241.60.215]:47000 "EHLO mx2.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbfFTJhU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 05:37:20 -0400
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mx2.mailbox.org (Postfix) with ESMTPS id 69B92A1054;
        Thu, 20 Jun 2019 11:37:17 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter05.heinlein-hosting.de (spamfilter05.heinlein-hosting.de [80.241.56.123]) (amavisd-new, port 10030)
        with ESMTP id RdIcxNXkrWHC; Thu, 20 Jun 2019 11:37:15 +0200 (CEST)
To:     Christian Lamparter <chunkeey@gmail.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        gregkh@linuxfoundation.org, stable <stable@vger.kernel.org>
Cc:     linux-crypto@vger.kernel.org, Amit Pundir <amit.pundir@linaro.org>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Subject: crypto: crypto4xx - properly set IV after de- and encrypt breaks
 kernel 4.4
Openpgp: preference=signencrypt
Autocrypt: addr=hauke@hauke-m.de; keydata=
 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
Message-ID: <9d744c3b-d4ff-b84b-527b-fc050794499b@hauke-m.de>
Date:   Thu, 20 Jun 2019 11:36:50 +0200
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="z0q5bkh5y9sTYoTPWaX7hKBt0IhfQh0F9"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--z0q5bkh5y9sTYoTPWaX7hKBt0IhfQh0F9
Content-Type: multipart/mixed; boundary="dcbmbTo5yoWtlNANL1Mlfn8qDKhayOhhA";
 protected-headers="v1"
From: Hauke Mehrtens <hauke@hauke-m.de>
To: Christian Lamparter <chunkeey@gmail.com>, herbert@gondor.apana.org.au,
 davem@davemloft.net, gregkh@linuxfoundation.org,
 stable <stable@vger.kernel.org>
Cc: linux-crypto@vger.kernel.org, Amit Pundir <amit.pundir@linaro.org>
Message-ID: <9d744c3b-d4ff-b84b-527b-fc050794499b@hauke-m.de>
Subject: crypto: crypto4xx - properly set IV after de- and encrypt breaks
 kernel 4.4

--dcbmbTo5yoWtlNANL1Mlfn8qDKhayOhhA
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi,

The patch "crypto: crypto4xx - properly set IV after de- and encrypt"
causes a compile error on kernel 4.4.

When I revert this commit it compiles for me again:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?=
id=3De9a60ab1609a7d975922adad1bf9c46ac6954584

I do not have hardware to test if it is really working.

Hauke

drivers/crypto/amcc/crypto4xx_core.c: In function
'crypto4xx_ablkcipher_done':
drivers/crypto/amcc/crypto4xx_core.c:649:21: warning: dereferencing
'void *' pointer
  if (pd_uinfo->sa_va->sa_command_0.bf.save_iv =3D=3D SA_SAVE_IV) {
                     ^
drivers/crypto/amcc/crypto4xx_core.c:649:21: error: request for member
'sa_command_0' in something not a structure or union
drivers/crypto/amcc/crypto4xx_core.c:650:38: error: implicit declaration
of function 'crypto_skcipher_reqtfm' [-Werror=3Dimplicit-function-declara=
tion]
   struct crypto_skcipher *skcipher =3D crypto_skcipher_reqtfm(req);
                                      ^
drivers/crypto/amcc/crypto4xx_core.c:650:61: error: 'req' undeclared
(first use in this function)
   struct crypto_skcipher *skcipher =3D crypto_skcipher_reqtfm(req);
                                                             ^
drivers/crypto/amcc/crypto4xx_core.c:650:61: note: each undeclared
identifier is reported only once for each function it appears in
drivers/crypto/amcc/crypto4xx_core.c:652:3: error: implicit declaration
of function 'crypto4xx_memcpy_from_le32'
[-Werror=3Dimplicit-function-declaration]
   crypto4xx_memcpy_from_le32((u32 *)req->iv,
   ^
drivers/crypto/amcc/crypto4xx_core.c:653:19: warning: dereferencing
'void *' pointer
    pd_uinfo->sr_va->save_iv,
                   ^
drivers/crypto/amcc/crypto4xx_core.c:653:19: error: request for member
'save_iv' in something not a structure or union
drivers/crypto/amcc/crypto4xx_core.c:654:4: error: implicit declaration
of function 'crypto_skcipher_ivsize' [-Werror=3Dimplicit-function-declara=
tion]
    crypto_skcipher_ivsize(skcipher));
    ^




--dcbmbTo5yoWtlNANL1Mlfn8qDKhayOhhA--

--z0q5bkh5y9sTYoTPWaX7hKBt0IhfQh0F9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEyz0/uAcd+JwXmwtD8bdnhZyy68cFAl0LU8QACgkQ8bdnhZyy
68cWcwgAp/JiEa90ou8RcIkBKlLQE+doRmvWJSONfC49erPGocv69zRoDhMB+6Fq
9YZWz1bwlRErBcJP3nNW9rNkK2bC6XfMtrV5HHLCSvd7tIYFpHiixN0UHn/1u6oo
NTd7OGD8mLT5Mg6Wv1oxqb22ljG7zsvAknjX/wk3be90lMgOPZ/TCynBucFg0zpr
YFX/eqnwVH3+BDKdylzzJlBBZtAPVb3l6EUa2BCkCkdKmfYDajRIkW5wAJ1dtWe6
QQnU5e8YsEwitfe+6PWcJzYb3tbh84550zE+rqJ6UEIvqq4RzbdhZ6aY+ybo1wmp
m7jcwjQB6qRAd0cx57UIinoQTcbpRA==
=KyjT
-----END PGP SIGNATURE-----

--z0q5bkh5y9sTYoTPWaX7hKBt0IhfQh0F9--
