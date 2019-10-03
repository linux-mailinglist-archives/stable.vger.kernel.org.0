Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BED2CB1E6
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 00:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730798AbfJCWZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 18:25:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46986 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728288AbfJCWZj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 18:25:39 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iG9XV-0006Ib-1F; Thu, 03 Oct 2019 23:25:37 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iG9XU-0006w0-I1; Thu, 03 Oct 2019 23:25:36 +0100
Message-ID: <0845242abbad163ce18709f3aa24153afa429b30.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 00/87] 3.16.75-rc1 review
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Denis Kirjanov <kda@linux-powerpc.org>
Date:   Thu, 03 Oct 2019 23:25:30 +0100
In-Reply-To: <1a374d67-9908-6c7d-c428-219ee6d79ee4@roeck-us.net>
References: <lsq.1570043210.379046399@decadent.org.uk>
         <1a374d67-9908-6c7d-c428-219ee6d79ee4@roeck-us.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-75TA8VT7BoMBAJdWkljp"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-75TA8VT7BoMBAJdWkljp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2019-10-03 at 05:54 -0700, Guenter Roeck wrote:
[...]
> The error is:
>=20
> drivers/staging/iio/cdc/ad7150.c:9:10: fatal error: linux/bitfield.h: No =
such file or directory
>=20
> which indeed does not exist in v3.16.y. Culprit is commit 6117323f0fbfb
> ("staging:iio:ad7150: fix threshold mode config bit".

Thanks for checking.  I'll drop the two patches for this driver.

Ben.

-=20
Ben Hutchings
Unix is many things to many people,
but it's never been everything to anybody.



--=-75TA8VT7BoMBAJdWkljp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl2WdVsACgkQ57/I7JWG
EQlVjw/+NhsqbT9hQNsRPwbFFOY8eaUYImkSYqWySY3TrTv7GRznbVgzNZtdKLaK
PKGer3d0rkuFd4xdLIHg764QbKOoj1YWwY1VdTeGn0pWi0M8v3CVi6RzJRJWVwHi
gAYPd5sfvcEMi/sJXKzvqs5gh35gL6PhZEXePfekhv01aMuJnmIENPP2NFTpFd6m
rWz6geXlJV3+R5suGxKsWn0uhhPUKWY2iRTzKq8lHBflECQZ8PClX2vs7kUWNTVK
wMigBHW3hsI+M6/WablYkdJt0RNF6m068aoQoCnPXgXa0c69Y0YgIqlpt/7sFy0c
GeTepub7kWcmVhhFvebUE2s/bdFSLlt9ELxsQY26nOyHgzDB8J6BdHtgoWX+GNaA
gafdio987QrOV0/hWtby+qpY2UYQ0PkvtRq/CfTrewQkMIJ/0uGaZRGn4Fuz09Ku
aBepkhoc3Fgq2JJEloWzDv11YIos6gH8/Vo+lhY/HNbwDfo853fckUhZTjiUW59m
7I5D4+bC0fepm7CtMcXDdkPY/IzPe/+rivBCF0XrMgRMHx47+iDUpFrxmbZoRO9J
vh4+skqvBb7binYGHXf2EY5MSYDwO+HK05MUFYy1qXrovfzpfJ6YodxLlIJ2OceK
w6yGf5VcEMDSRCVA3En4rQhWGx4+nUt23BQL/vhtQzs7UZqi4Z8=
=bB9f
-----END PGP SIGNATURE-----

--=-75TA8VT7BoMBAJdWkljp--
