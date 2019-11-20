Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0519E103FFE
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 16:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730559AbfKTPu6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 10:50:58 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53704 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729591AbfKTPu6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 10:50:58 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXSFs-0005UP-T3; Wed, 20 Nov 2019 15:50:56 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXSFs-0004kA-DB; Wed, 20 Nov 2019 15:50:56 +0000
Message-ID: <ab0f14d71b946fec022f366620f2ceec7100dad4.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 00/83] 3.16.78-rc1 review
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Denis Kirjanov <kda@linux-powerpc.org>
Date:   Wed, 20 Nov 2019 15:50:47 +0000
In-Reply-To: <7f0b50eb-8d42-bbcc-6291-0297f168ff55@roeck-us.net>
References: <lsq.1574264230.280218497@decadent.org.uk>
         <7f0b50eb-8d42-bbcc-6291-0297f168ff55@roeck-us.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-hXdM2tnwGXY4z7rpv/Fx"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-hXdM2tnwGXY4z7rpv/Fx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-11-20 at 07:46 -0800, Guenter Roeck wrote:
> On 11/20/19 7:37 AM, Ben Hutchings wrote:
> > This is the start of the stable review cycle for the 3.16.78 release.
> > There are 83 patches in this series, which will be posted as responses
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Fri Nov 22 15:37:10 UTC 2019.
> > Anything received after that time might be too late.
> >=20
>=20
> Build results:
> 	total: 136 pass: 136 fail: 0
> Qemu test results:
> 	total: 229 pass: 229 fail: 0

Great, thanks for testing,

Ben.

--=20
Ben Hutchings
Theory and practice are closer in theory than in practice - John Levine



--=-hXdM2tnwGXY4z7rpv/Fx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl3VYNcACgkQ57/I7JWG
EQmSgg/+Nmne7Y2xyeOm0oy2SPumAE9MQ7zjC0lWyrDmIhRLjo3WHMzfqpjfnPOW
8z5bAz0zt82rp/TpQK4n4X5tzZqAnN0WtE1vIbRZVg7vnuYjSVGVN36gV0+3G5jx
UHiMEaapRB043Dsp3TAc87kV24jVejbPw+J3I1rQL6caQ+q3R/s7uSKwp4ADfaMW
HWXte9e/Fmz8HBAx7alCymx9Yotpd2Rkvhj7kuC/Dyt5ok3m3a7qfyuWKdgIgGkB
KFW+m469yCltFgZG4rcei/Pumha6Oy0mOqu4wRLd8KblhMoSyVAWSMjrJSqKKeaV
kMEaTLwobhCI8GN+I4qkL/eg0wQ4FYdhTEfbvR2BEs9JRXG9yMc0ijEAxG0XsPey
jxUPzdmCSnp4k+jMuCRW1R1jh9ePEitqeZsNnpTLLBap1XKza3AS2rzXoOWO1SQg
AetSu2CTlRWl2w780P1g22Ik21u5V+XfHaiXUEnG/TGb5+pABzx+02l2MMqtMxHk
oRNGB9yEWp46akUX4zWLooEJiACOLma5p/EAb0YwTs7+3viOeo99dNuMQLSml/0Q
depdcfRKB89D68Y5k5ZLUZYHx9xRMZn+e/T6w0fu3Kw9t29zKa2vjtVN0sSP6VKt
6sHM8ocfXm0pbqrm/jls+HDmldgRHBQVf4vq1npL59uobB9laAM=
=hxQG
-----END PGP SIGNATURE-----

--=-hXdM2tnwGXY4z7rpv/Fx--
