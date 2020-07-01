Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF2F2116A8
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 01:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgGAXbE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 19:31:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60252 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726586AbgGAXbE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jul 2020 19:31:04 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jqmBy-0003Zx-FR; Thu, 02 Jul 2020 00:31:02 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jqmBy-000J2y-1W; Thu, 02 Jul 2020 00:31:02 +0100
Message-ID: <1bf72bc1ace92609fec953daf17342e1d2d48394.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 00/10] Fix possible crash on L2CAP socket shutdown
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Denis Grigorev <d.grigorev@omprussia.ru>, stable@vger.kernel.org
Date:   Thu, 02 Jul 2020 00:31:01 +0100
In-Reply-To: <20200630153641.21004-1-d.grigorev@omprussia.ru>
References: <20200630153641.21004-1-d.grigorev@omprussia.ru>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-ZNGHyncelzkhXGWtGD33"
User-Agent: Evolution 3.36.3-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-ZNGHyncelzkhXGWtGD33
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2020-06-30 at 18:36 +0300, Denis Grigorev wrote:
> This series of commits fixes a problem with closing l2cap connection
> if socket has unACKed frames. Due an to an infinite loop in l2cap_wait_ac=
k
> the userspace process gets stuck in close() and then the kernel crashes
> with the following report:
>=20
> Call trace:
> [<ffffffc000ace0b4>] l2cap_do_send+0x2c/0xec
> [<ffffffc000acf5f8>] l2cap_send_sframe+0x178/0x260
> [<ffffffc000acf740>] l2cap_send_rr_or_rnr+0x60/0x84
> [<ffffffc000acf980>] l2cap_ack_timeout+0x60/0xac
> [<ffffffc0000b35b8>] process_one_work+0x140/0x384
> [<ffffffc0000b393c>] worker_thread+0x140/0x4e4
> [<ffffffc0000b8c48>] kthread+0xdc/0xf0
>=20
> All kernels below v4.3 are affected.
[...]

Thanks for your work, but I'm afraid the 3.16-stable branch is no
longer being maintained (as of today).

Ben.

--=20
Ben Hutchings
It is a miracle that curiosity survives formal education.
                                                      - Albert Einstein



--=-ZNGHyncelzkhXGWtGD33
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl79HLUACgkQ57/I7JWG
EQkeIxAAjT4iQmy5wRz8lhE9Vct8MFStnPgx5HqHOxkj9aV8mWb5HbOcLIUyOyoS
YQysMOESRKsaA1pRH8oFM6L58npJwWWrIGWTwu/boJJJEUKOF5wGFLq4cUPBZnJt
hLZ/T4Qa1XEZUg/vB8O/6bGOqqS8nJFRgKu4tf+x45bTJ6ZSmcNAhuuVepUwQo6l
jLGyiurQ6TMPXk7sXG6sB+RHYVEwJEiR220M7C0SOSyipjff7Iq+ykUfca2ViyxY
z1g4SmSYXak5qsN9h8p3ZeqTLoMqdA9C6iAawMIuzTKL4CcHdWknucyBlXEcX4lC
V+rPdKeIoP0ly422SEPt/Vc58G5m3Lx/pPXxLEBjAb0ZTzAkkbPfHMGZLjQ8vWb/
GUOtxz1VEXOUbs6J8YaUm27D9jaPWiIRk47u/MJ0IRi8qvJ5URlU4FaPpEOmtFF4
+XlL49w1ujZcYqDDb4He2mJ7ZWV35fWx11uNYgMDMSwBWcj2aAAMXAJ3QtXLtKfa
OXbIErMKo6RFmj0SCmYyYuK+WNEAt+GwCdtfIwnXwFckLyjeiMvUHp3EHVNpcgS2
UvKL61akgaa4vJNc5pjA9zxC6zucYqYPaJ/QrCSCXuWnJDYv8xOKSDIv3ID716ot
Cf453Sh47zti4rtTglShIpAYcdj4JE/JPlTPk6e4vWD8fTnX0XY=
=X/vu
-----END PGP SIGNATURE-----

--=-ZNGHyncelzkhXGWtGD33--
