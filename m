Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 712101B7D52
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 19:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbgDXRy4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 13:54:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56856 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726793AbgDXRy4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 13:54:56 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jS2XO-0008CD-FM; Fri, 24 Apr 2020 18:54:54 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jS2XO-00FO0e-0s; Fri, 24 Apr 2020 18:54:54 +0100
Message-ID: <4614381d6b2115dd9d19900509965fb2c419ae2c.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 000/247] 3.16.83-rc2 review
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Denis Kirjanov <kda@linux-powerpc.org>
Date:   Fri, 24 Apr 2020 18:54:49 +0100
In-Reply-To: <67f1b156-1e65-aef7-f0e3-a15f637dbe71@roeck-us.net>
References: <lsq.1587743245.5555628@decadent.org.uk>
         <67f1b156-1e65-aef7-f0e3-a15f637dbe71@roeck-us.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-PZuy/PW7HmAZwMjlHo6s"
User-Agent: Evolution 3.36.1-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-PZuy/PW7HmAZwMjlHo6s
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2020-04-24 at 10:48 -0700, Guenter Roeck wrote:
> On 4/24/20 8:47 AM, Ben Hutchings wrote:
> > This is the start of the stable review cycle for the 3.16.83 release.
> > There are 247 patches in this series, which will be posted as responses
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Tue Apr 28 18:00:00 UTC 2020.
> > Anything received after that time might be too late.
> >=20
>=20
> For v3.16.82-247-gffbdbb4fe113:
>=20
> Build results:
> 	total: 135 pass: 135 fail: 0
> Qemu test results:
> 	total: 233 pass: 233 fail: 0

Great, thanks for testing again.

Ben.

--=20
Ben Hutchings
Knowledge is power.  France is bacon.



--=-PZuy/PW7HmAZwMjlHo6s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl6jJ+kACgkQ57/I7JWG
EQl1BQ/+MQzytDFTQq2eButY9lqNhNQiDYjyNclEQb9ibRS9XAu5U+OumgCpoLP4
8xrrCZ+cbAH6pBy6uWJdq+P5OXENFtAXCIvtStBjD+R77D5n/OLfMMKQRMcQWais
lNtAta5dhgoPek+9aSt9flM4ilim0d9jjrIwvK0WM6nlqjrwoCThFokfrx6v/FKG
kBpVq49xSIg6ArfZiyUfgQKmApu/SAOU8QK3Bp6+/HmmZSJZJFDK+ltkh4nrjOqa
ulMWthhvLBfBU+mW4U847khq0bDBUpB7IGDSvDftFK0iC7EhysTPduuH1cs+2Uuq
19AHY0Ud2J2zgXQmV453Bkd1ubfEJaV7HgOK1jRWsPQjlp9tt99ydTOezYLTZJEM
FBxdCD9zAXeuhJHnAZ7F6AkXm/V48+P2MdJxtF6tulcnNnXarI+a8fiCwjG8V2gS
wYN/ICiQJqRh7pu6STCWUNBZEYsYWnsoPwWLpLOBrl6a0B4Ftcjes0+n9HbWZwkf
A/RhDrCIkdOUTOM0/PGWthHMYvyKRmrlW6t8vMJxqTzYJVFjwAe5+cxlMgtxya4X
Q3LW8W7ybqiStq1Fvl/QLm6kE/ugIAbZ7t3I4ehI0YuuAKfZijT4kvWSS0VnHV5m
tjW+jMz8dh2uh7mIc2R3MVWcFg7FRoq9xADY5vAPjqzGfjb0Cnw=
=tyso
-----END PGP SIGNATURE-----

--=-PZuy/PW7HmAZwMjlHo6s--
