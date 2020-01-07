Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6D2A133581
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 23:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727174AbgAGWJ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 17:09:58 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37484 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726142AbgAGWJ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jan 2020 17:09:58 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iox2t-0001Hd-VD; Tue, 07 Jan 2020 22:09:52 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1iox2t-007a24-Cw; Tue, 07 Jan 2020 22:09:51 +0000
Message-ID: <cfc2fd04db37009435bbf716f32c0a2ddbf4b5e6.camel@decadent.org.uk>
Subject: Re: [PATCH 4.4 0/2] Backport readdir sanity checking patches
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Siddharth Chandrasekaran <csiddharth@vmware.com>,
        torvalds@linux-foundation.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org, jannh@google.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        siddharth@embedjournal.com
Date:   Tue, 07 Jan 2020 22:09:46 +0000
In-Reply-To: <cover.1577129050.git.csiddharth@vmware.com>
References: <cover.1577128778.git.csiddharth@vmware.com>
         <cover.1577129050.git.csiddharth@vmware.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-53uJTOEUIz6tm6mxxnAt"
User-Agent: Evolution 3.34.1-2+b1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-53uJTOEUIz6tm6mxxnAt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-12-24 at 01:06 +0530, Siddharth Chandrasekaran wrote:
> Hello,
>=20
> This patchset is a backport of upstream commits that makes getdents() and
> getdents64() do sanity checking on the pathname that it gives to user
> space.

These seem to be needed for 3.16, as well, so I've added them to my
queue.

Ben.

> Sid
>=20
> Linus Torvalds (2):
>   Make filldir[64]() verify the directory entry filename is valid
>   filldir[64]: remove WARN_ON_ONCE() for bad directory entries
>=20
>  fs/readdir.c | 40 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
>=20
--=20
Ben Hutchings
Larkinson's Law: All laws are basically false.



--=-53uJTOEUIz6tm6mxxnAt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl4VAasACgkQ57/I7JWG
EQmQuhAApLAOPhkwu3c+KZvczKE5+1a4Y90gRMzVkbsa5+oW+GTLM1fWVC3H81Oj
f4zfTfhmR5QyVONI1ZSAMv6Lu7kP4r7J7xg2UXJd3l5Fdu22BjXxyDeN59q9CqLa
6XozWsvZ/2T9OOI28ejh7uNoc+v8Yj70cYBc1V6VpXXkvhNV4o02XsRZb2RRy85z
bX2d0A5UFOiruGjiOYHQshV3gq7PjzlaA3dQ/lXnP43nMbfv4MZKKgPsSGxi4VD/
SUPkjY4kOU1rgyF+vOFgN1ylPLE2yGxsj4W0mu6/okJFljt74wjA/k5x+zat1xSm
CoUYODFQtYicvGlEAaBVXk9l7YttmNHdKB5NFTytEq/+KRheoYA9HDWkAYcYa4QN
2rK+8/TMWsVhVEQArowpnBFqhR6QZbcep6SH4nJ2o5q+KZ5VjmK9K8rLhXCucI+d
eberXjai0Yaa2lJIIv0ekXosTKZR/35cw0xPpP8JS7N1ipZtcS1IuzJxWBM9ul/K
BRDkEy991P1RS8YI1kjKF6Wy4RLbnczvvOa3euyVt47oq0ezwun9tehmSoAST4c9
p+PL5NYDKR1JRsbJTT87Iva8FkSQnX4vpAvVO18lmZkwygpm1zCI/IkhQe7J7W5A
husApJz3eDzNWbqBGYPYS9DZSOKzqBZ7V4pIgh7bSmTvueFMbwk=
=6AHG
-----END PGP SIGNATURE-----

--=-53uJTOEUIz6tm6mxxnAt--
