Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 089811B7744
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 15:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgDXNnU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 09:43:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55704 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726946AbgDXNnU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 09:43:20 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRybu-0001RS-UP; Fri, 24 Apr 2020 14:43:19 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRybu-00EGsH-Az; Fri, 24 Apr 2020 14:43:18 +0100
Message-ID: <a7a895a0e21ebdd0cef5da847a96235c3964c3c2.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 000/245] 3.16.83-rc1 review
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Jann Horn <jannh@google.com>
Cc:     kernel list <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Denis Kirjanov <kda@linux-powerpc.org>
Date:   Fri, 24 Apr 2020 14:43:07 +0100
In-Reply-To: <CAG48ez0nyLsyAeLJXEnCnhkh26EnZGnam1cyd84a5LoFcEyMiw@mail.gmail.com>
References: <lsq.1587683027.831233700@decadent.org.uk>
         <CAG48ez0nyLsyAeLJXEnCnhkh26EnZGnam1cyd84a5LoFcEyMiw@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-J+m/50BuKvD37kKwBzv2"
User-Agent: Evolution 3.36.1-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-J+m/50BuKvD37kKwBzv2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2020-04-24 at 01:59 +0200, Jann Horn wrote:
> On Fri, Apr 24, 2020 at 1:03 AM Ben Hutchings <ben@decadent.org.uk> wrote=
:
> > This is the start of the stable review cycle for the 3.16.83 release.
> > There are 245 patches in this series, which will be posted as responses
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Tue Apr 28 18:00:00 UTC 2020.
> > Anything received after that time might be too late.
>=20
> Can you please add backports of the following patches? I asked for
> that in <https://lore.kernel.org/stable/CAG48ez29d-JJOw8XMp1Z=3D7sDj8Kvmt=
+9KXC9-ux-0OBhUP02Xg@mail.gmail.com/>;,
> but I guess that fell through the cracks somehow.

Sorry I forgot about this,

> 8019ad13ef7f64be44d4f892af9c840179009254 "futex: Fix inode life-time issu=
e"
> 8d67743653dce5a0e7aa500fcccb237cde7ad88e "futex: Unbreak futex hashing"
>=20
> Can those still go into 3.16.83, or is it too late for that now?

I'll add them and send an -rc2.

Ben.

--=20
Ben Hutchings
Knowledge is power.  France is bacon.



--=-J+m/50BuKvD37kKwBzv2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl6i7OwACgkQ57/I7JWG
EQlqAg/+MVr5Qnw2tXy9cp9lUsxuIpSVduJAm3cLck4birfJCMiG0aFSxlJ/RFhH
2zAXX+1ci6UOVo+wfKuqmgtR2IcMfrRATTQalyT7ffRrArIcVkoVEuC/Q8S/YJWU
UgtaQK+szp3O83TSWXr/PAibjMiUyT35pGnYGzlzHjTdQI/Bl4z7778zhDhykbRg
1LoASUemmyBkuZAcA6HWk51XNdzwmeADjE6Hzc0V4upUMVQFtBQOdiS1MTd3lpgu
vY/oGqQs+VwbhjU1Bn0tejWyUGDtduln9vtd1c401fNVqi3Xdb1b03UlsQNpH8dO
OGtf4zyuvLrqrXhzJkP8PbsbTIRuRmIPxYlrBtdK5BDS3glXXtEIg8va7NUc6YfI
6ipkRRw+Ei9JzPbvz4L0cgle7nRryGAp8R7g4eqfJL35OOpk0JXV0dxnpAnaXcYj
9VrZiFOuM2K6e3W+VlhecGQfikt2WLD3PsTFclPn4Oy19hkGQNAequrJwo0p3FdK
eUb2uw3qu/xk9Z21pL99TfnpwEpFp/wSejoFix/SEtyMvLHst676zqICwsvzmGQd
JFq4j1ccucysHXRg+jTVd84lQcwwvd7rXY7zKfHVMKRkc2QFs2Y2IsQYcLmCuhyW
zPYAKKgXZ1cwXjMDm91oHmgiSJLmZXw15V9zFdMw+OL/xDUnSQw=
=0FVp
-----END PGP SIGNATURE-----

--=-J+m/50BuKvD37kKwBzv2--
