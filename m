Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C59210274E
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 15:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfKSOt4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 09:49:56 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46082 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726682AbfKSOt4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 09:49:56 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iX4pG-0005Rc-3m; Tue, 19 Nov 2019 14:49:54 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iX4pF-0007XN-Ii; Tue, 19 Nov 2019 14:49:53 +0000
Message-ID: <c6b2760910e576af7e40e6b9da47eb81b1cdae68.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 58/87] cifs: add spinlock for the openFileList to
 cifsInodeInfo
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Pavel Shilovskiy <pshilov@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc:     "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steven French <Steven.French@microsoft.com>
Date:   Tue, 19 Nov 2019 14:49:46 +0000
In-Reply-To: <8301f887ce091340b6662371ab2bd1628a06118e.camel@decadent.org.uk>
References: <lsq.1570043210.379046399@decadent.org.uk>
         <lsq.1570043211.844466427@decadent.org.uk>
         <DM5PR21MB0185257853E50A73C593B891B6660@DM5PR21MB0185.namprd21.prod.outlook.com>
         <8301f887ce091340b6662371ab2bd1628a06118e.camel@decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-jIHon0KlM5YvVgUpMrbO"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-jIHon0KlM5YvVgUpMrbO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-10-29 at 14:15 +0100, Ben Hutchings wrote:
> On Mon, 2019-10-28 at 22:19 +0000, Pavel Shilovskiy wrote:
> > > -----Original Message-----
> > > From: Ben Hutchings <ben@decadent.org.uk>
> > > Sent: Wednesday, October 2, 2019 12:07 PM
> > > To: linux-kernel@vger.kernel.org; stable@vger.kernel.org
> > > Cc: akpm@linux-foundation.org; Denis Kirjanov <kda@linux-powerpc.org>=
; Ronnie Sahlberg <lsahlber@redhat.com>; Steven French <Steven.French@micro=
soft.com>; Pavel Shilovskiy <pshilov@microsoft.com>
> > > Subject: [PATCH 3.16 58/87] cifs: add spinlock for the openFileList t=
o cifsInodeInfo
> > >=20
> > > 3.16.75-rc1 review patch.  If anyone has any objections, please let m=
e know.
> > >=20
> > > ------------------
> > >=20
> > > From: Ronnie Sahlberg <lsahlber@redhat.com>
> > >=20
> > > commit 487317c99477d00f22370625d53be3239febabbe upstream.
> [...]
> > We have recently found regressions in this patch that are addressed in =
the following two patches:
> >=20
> > cb248819d209d ("cifs: use cifsInodeInfo->open_file_lock while iterating=
 to avoid a panic")
> > 1a67c41596575 ("CIFS: Fix use after free of file info structures")
> >=20
> > So, I would suggest either to apply those two patches above or to rever=
t this one.
>=20
> Thanks for pointing thse out.  I will try to include those in a later
> update.

I've now queued these up.

Ben.

--=20
Ben Hutchings
Theory and practice are closer in theory than in practice - John Levine



--=-jIHon0KlM5YvVgUpMrbO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl3UAQoACgkQ57/I7JWG
EQmlwhAAiqQmyuFbwROid6rD4i7mIcfgW5VWNChNV64Hiklf68L6Q/GHFHVqCkcR
w4Iaowh7PMBzLt4VOWLJV3IvRQsrzFRZq29MwKfeGFt2E7xlWY+GDbazEdnJjVFm
mv8aqaLMuZH0yIaidTB0l5vfwS+zqvb9rmSDt1SAEwzQx43+bWXeG68puVyRCXU5
zyYXFbfjKp0Q74FaACDXmbwL3hcJlDm5bNL14ONwrFjZ9ApBrYjgBgIDV4cYos4g
GQA8qlk9eE9OhaBuWJWOWUYB2BLhy10CnRufT/qXFs0mPHTnhQYXdZISZzl6pkhn
SJ0q8NB5sq+7yhpkCWMVLdY4GhgZKFgv0jGQrrDRxwcFmFjtWs4YMlVPZ/BYw6cI
StEiWz1s4JBABC2+gRgvJ4E1qIKIWc6lvQTP5YAcwin2VBnbgafHha36mzyYPE/V
eR1nnLXtUqp8tssEABjYu45QK7CdOqKcBWBd6AB2A6cjJ3CeLzYs8XlkgypWUKau
DAUxa9BqiggR8vdCj1ayTE6kkctHA8+bkWFF9xcZnhvuKgTYFKhyx7BEKKcXP2xT
FU+gEmJzSdFaWJInDxh/qduzkvg2VTA/Z0UQR5iwdShdLr3e+B4q2BjcCiC1K9mq
gLJqOxbbU7ELYwknZK4GBaUUlRi8O/vmgwR1O+52AVs46//Jnzo=
=Cbuz
-----END PGP SIGNATURE-----

--=-jIHon0KlM5YvVgUpMrbO--
