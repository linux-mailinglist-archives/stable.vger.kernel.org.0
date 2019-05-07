Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0526516A60
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 20:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727274AbfEGSiO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 14:38:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32956 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726634AbfEGSiO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 14:38:14 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hO4ye-0007Da-Sv; Tue, 07 May 2019 19:38:08 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hO4ye-0003xw-Fr; Tue, 07 May 2019 19:38:08 +0100
Message-ID: <55c963dce43d8cf614a5401a23750d3b30399e45.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 23/99] tty/ldsem: Wake up readers after timed out
 down_write()
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Dmitry Safonov <0x7f454c46@gmail.com>
Cc:     open list <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>,
        kernel test robot <rong.a.chen@intel.com>,
        Dmitry Safonov <dima@arista.com>,
        Peter Zijlstra <peterz@infradead.org>
Date:   Tue, 07 May 2019 19:38:03 +0100
In-Reply-To: <2aa7996d-708a-b6b9-3197-94814b708881@gmail.com>
References: <lsq.1554212307.17110877@decadent.org.uk>
         <lsq.1554212307.770456214@decadent.org.uk>
         <CAJwJo6ahUWWSMWfM+qk109YfzJAB0HBMKcrVFqK2wzdBv_OtGQ@mail.gmail.com>
         <0fb333560ad4ed9d5c8bc0f71a46fee5b448f9e6.camel@decadent.org.uk>
         <2aa7996d-708a-b6b9-3197-94814b708881@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-fyFX1eJkFug4YCxhk3cw"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-fyFX1eJkFug4YCxhk3cw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-04-02 at 15:39 +0100, Dmitry Safonov wrote:
> On 4/2/19 3:32 PM, Ben Hutchings wrote:
> > On Tue, 2019-04-02 at 15:22 +0100, Dmitry Safonov wrote:
[...]
> > > - "tty: Hold tty_ldisc_lock() during tty_reopen()" commit 83d817f4107=
0
> > >   with follow-up fixup "tty: Don't hold ldisc lock in tty_reopen() if
> > > ldisc present"
> > >   commit d3736d82e816
> > [...]
> >=20
> > I will include these in a later update, unless you think they are
> > really urgent and should be added to this one.
>=20
> Well, I thought worth to mention those patches, but in reality haven't
> checked if they are applicable to v3.16.
> It's just I remember "tty: Hold tty_ldisc_lock() during tty_reopen()"
> was the main fix in the set, as many people suffered from issue under
> it, so I thought strange that only a side-patch (which can lead to soft
> lockup, so probably also important) is ported. But I managed to forget
> that the code has changes since v3.16.

I couldn't see how to apply these to 3.16, so you will need to send me
backports if they are needed.  They are also missing from 3.18 and 4.4.

Ben.

--=20
Ben Hutchings
Teamwork is essential - it allows you to blame someone else.



--=-fyFX1eJkFug4YCxhk3cw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAlzR0IsACgkQ57/I7JWG
EQndXBAAhp51IeuLn3MOsPrqYMJqn/E9ATZ/IK7LgZxrPNX5Pses/FdLwbn7pA+k
JZgIdVeqqNcOn0hLC/63loyJkwi2cEfdfRcymCILgcJM72SJ4TdOEkY/BB7aUj9g
x+/8yPm2w8HvIe/jFdkpFdfeKS7mtSaL+xJhIqmlS5xHMJKctujUV1Jo3wX94yDz
+JgfwStnJWme8N4hf/3Hcw3vipl6p6qBskeyds7tKhilDxCqRvJzeGs/Ah9VEJkX
oATVckH7gK0bzvHXv/lyE2g1w1Fyc2QybylCzKMSBU28oIAXIsV2kk4/MRr7MuRZ
p7n5pB9ZGYMzT4e4ZPFFq6fX6EdJunpQM6zKFZcLYCKC2YR6ry4rCtYREufWQ/yC
KMq55Fy0+d+EI3i/o2UeA8nJQAESMoDkC/I5q7cRbx+Lui8GP9CqYSXLbxsNWEM0
nzUVV93/xB5pgV8LYN01rvCSueQ5iiRMU8sebKiF3j1kUtzAVOeF4xM6VZXpmXf5
7tNqv3vNo3ynBeJiYPFn++izsnvMmDw9ATHqYDJJccxD0MB4hP75Yot8507akslq
1Xb5rih26+hAi6uZ55rFll4K2vy9A5oGUWL+v0HFh6XxctbHtw6yUundKRvn2RSz
1p0LhZvtRSM6PX3k5G2XZHhSr8drtmnDGEsgsKvIEqivRRs3tcA=
=6x9T
-----END PGP SIGNATURE-----

--=-fyFX1eJkFug4YCxhk3cw--
