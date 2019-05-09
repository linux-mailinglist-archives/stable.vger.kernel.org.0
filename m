Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1555C191D0
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728328AbfEITAf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 15:00:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49042 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726996AbfEITAe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 15:00:34 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hOoHQ-0001b6-MT; Thu, 09 May 2019 20:00:32 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hOoHQ-0001rA-F2; Thu, 09 May 2019 20:00:32 +0100
Message-ID: <3ac380160a8531fcb5db85e5985dcac19cdd8150.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 00/10] 3.16.67-rc1 review
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Denis Kirjanov <kda@linux-powerpc.org>
Date:   Thu, 09 May 2019 20:00:26 +0100
In-Reply-To: <20190509173809.GA28365@roeck-us.net>
References: <lsq.1557410896.171359878@decadent.org.uk>
         <20190509173809.GA28365@roeck-us.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-D0ikVV8XcqjJkyFMem/j"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-D0ikVV8XcqjJkyFMem/j
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2019-05-09 at 10:38 -0700, Guenter Roeck wrote:
> On Thu, May 09, 2019 at 03:08:16PM +0100, Ben Hutchings wrote:
> > This is the start of the stable review cycle for the 3.16.67 release.
> > There are 10 patches in this series, which will be posted as responses
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Sat May 11 14:08:16 UTC 2019.
> > Anything received after that time might be too late.
> >=20
>=20
> Build results:
> 	total: 137 pass: 136 fail: 1
> Failed builds:=20
> 	i386:tools/perf=20
> Qemu test results:
> 	total: 226 pass: 226 fail: 0

Thanks for testing.

Ben.

--=20
Ben Hutchings
Any sufficiently advanced bug is indistinguishable from a feature.



--=-D0ikVV8XcqjJkyFMem/j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAlzUeMsACgkQ57/I7JWG
EQktMxAAtExddFOCnH8u+thgZQiE3IdloL5kzuWcAkRHGghxiDcT0CgXzcxDy+Ap
NqG1y2x9TlU6ZiBrFpjXhR3+c2otDYbECnxfWrvA+09t5Wejja24MlyD+GAALojq
HmsyIkHPWoNlHAnewDW28SUa423U8o/96/xhIh8a8Q+dRufD7iz+yOBCH1mw2hZA
uL2eRSht3RPx+xlw1YSmSipv/07ingx/YZcuHYNhHAW/FFaquzoy/u4P56K+oZ+n
Hk68nARwmSwarqHJYBw80ElOlF8r9UxxSnucXMHdgpVn1WNqOwL67czOWyfesrQi
gde5BSguJQf6l7COILEh/pcTyYKVL9xUHgn5edkbrafCOnV6A1dkK+JT3KYEXv0f
GDrwVDU8P3tfPlgT5t/WDWcoY7Wxcqrvk888CTxpMCVw9vjWyR5aSeYRm92dR5th
uMIQOH3l5u9aSXqqv3JIpHLOfhtoOWyNdzyJpLUhaZ4AioogNUjweeL5Zilr8qGn
VbXDMQamCGsciwBvHxq6UKXSf8s0Z2L0oHFDzHx/RAbjcXdCkS+kG6nVrHeCTlf9
epOsa40K+74iK4h4S+HyZKuNBnn4aQpnx1MLy5uLzcgFu1QEC4cU1wCQz3TXgAYT
nH7lmWDvwCMufFN7SIR4bt6ep707PGaw+GlnUNl9JNZM0bNsgGc=
=fkEX
-----END PGP SIGNATURE-----

--=-D0ikVV8XcqjJkyFMem/j--
