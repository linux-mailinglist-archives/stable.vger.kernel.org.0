Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDE2917E1
	for <lists+stable@lfdr.de>; Sun, 18 Aug 2019 18:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfHRQlp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Aug 2019 12:41:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32932 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726097AbfHRQlp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Aug 2019 12:41:45 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hzOFR-0000CQ-Ro; Sun, 18 Aug 2019 17:41:41 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1hzOFR-0002kI-Lm; Sun, 18 Aug 2019 17:41:41 +0100
Message-ID: <a1775491e3dffb60afce950a28807f4049e3bf1c.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 0/4] 3.16.73-rc1 review
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Denis Kirjanov <kda@linux-powerpc.org>
Date:   Sun, 18 Aug 2019 17:41:36 +0100
In-Reply-To: <9bfbe161-70c5-d969-98e9-b94c911f09f6@roeck-us.net>
References: <lsq.1566038111.397675943@decadent.org.uk>
         <9bfbe161-70c5-d969-98e9-b94c911f09f6@roeck-us.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-Pe+nzvh1XPbDO30MCAPv"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-Pe+nzvh1XPbDO30MCAPv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2019-08-17 at 04:19 -0700, Guenter Roeck wrote:
> On 8/17/19 3:35 AM, Ben Hutchings wrote:
> > This is the start of the stable review cycle for the 3.16.73 release.
> > There are 4 patches in this series, which will be posted as responses
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Mon Aug 19 20:00:00 UTC 2019.
> > Anything received after that time might be too late.
> >=20
> Build results:
> 	total: 136 pass: 136 fail: 0
> Qemu test results:
> 	total: 229 pass: 229 fail: 0

Thanks for testing,

Ben.

--=20
Ben Hutchings
Larkinson's Law: All laws are basically false.



--=-Pe+nzvh1XPbDO30MCAPv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl1Zf8AACgkQ57/I7JWG
EQk7oQ/8Cw6dS3M1/L+js5wdoVaeHlQBzji3Xoo2RiorjXrIGvJRCeEEDvFyB5VU
di6F8uxbUPmXRPl4y9yFKi+Es/lcc+k8kHnkNtDpOcqn9s4hlCi3PLxjnz1TrrSK
VfPZMRxpGEB2dT3psBqQuZOMypMu4UNDWeP5SwUpRWT/ZRL1X5HEdUnC192ZBNPA
V/8OwXwtmwZ346jWKziONBOVCywJu5VvlHNX4E0pWDynz0r3R2Om5s+F/HhdkjHz
Ne5SsAMPEx+QlUKX5A8zVOcin1IiHdFmvFHCr17vrj5yAYgOyzeZ5M4cw/nBykZ8
RSE0PNPKTmcUszu7gD6SnPzFS8behcAMtBJXIwvLDh0pb8yNeNMBIsWXxuTobsHH
6mGEDluSIK8y8lD+OaQBO9AzRlY79NENZh5n9Q6+dBBp62tMcxY4zp8zNFeLSfJz
mAayVNMENaLrjxEdkB8IpbmBFUSaONlu/THVelHD3cd+CLYJGbQBlW1aQ/BFOc0J
XmCSoxc8qVw6TI9R+Z8oQ62pzwTdWMBZNERjIYc2lR8humH/xdCR/pWbfpLhS0wU
9XAyhDwsKbwL88ZPKoeGVt5UH3TJh/YI+P7EcwpKf72eUUbSzpWuQXim0icgHwgW
PK5jP1jKu4SUvx0KcCuXYSvn0WZ4fsJyIDDA4dCBDjBCjMRzcuQ=
=QPGF
-----END PGP SIGNATURE-----

--=-Pe+nzvh1XPbDO30MCAPv--
