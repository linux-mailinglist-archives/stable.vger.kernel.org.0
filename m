Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76640E8928
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 14:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388225AbfJ2NP5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 09:15:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43694 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388105AbfJ2NP5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Oct 2019 09:15:57 -0400
Received: from [91.217.168.176] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iPRLm-00015Z-Qa; Tue, 29 Oct 2019 13:15:54 +0000
Received: from ben by deadeye with local (Exim 4.92.2)
        (envelope-from <ben@decadent.org.uk>)
        id 1iPRLm-0000r3-3e; Tue, 29 Oct 2019 14:15:54 +0100
Message-ID: <8301f887ce091340b6662371ab2bd1628a06118e.camel@decadent.org.uk>
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
Date:   Tue, 29 Oct 2019 14:15:45 +0100
In-Reply-To: <DM5PR21MB0185257853E50A73C593B891B6660@DM5PR21MB0185.namprd21.prod.outlook.com>
References: <lsq.1570043210.379046399@decadent.org.uk>
         <lsq.1570043211.844466427@decadent.org.uk>
         <DM5PR21MB0185257853E50A73C593B891B6660@DM5PR21MB0185.namprd21.prod.outlook.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-aXEdqtHx4Y9xfbklpuEp"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 91.217.168.176
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-aXEdqtHx4Y9xfbklpuEp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2019-10-28 at 22:19 +0000, Pavel Shilovskiy wrote:
> > -----Original Message-----
> > From: Ben Hutchings <ben@decadent.org.uk>
> > Sent: Wednesday, October 2, 2019 12:07 PM
> > To: linux-kernel@vger.kernel.org; stable@vger.kernel.org
> > Cc: akpm@linux-foundation.org; Denis Kirjanov <kda@linux-powerpc.org>; =
Ronnie Sahlberg <lsahlber@redhat.com>; Steven French <Steven.French@microso=
ft.com>; Pavel Shilovskiy <pshilov@microsoft.com>
> > Subject: [PATCH 3.16 58/87] cifs: add spinlock for the openFileList to =
cifsInodeInfo
> >=20
> > 3.16.75-rc1 review patch.  If anyone has any objections, please let me =
know.
> >=20
> > ------------------
> >=20
> > From: Ronnie Sahlberg <lsahlber@redhat.com>
> >=20
> > commit 487317c99477d00f22370625d53be3239febabbe upstream.
[...]
> We have recently found regressions in this patch that are addressed in th=
e following two patches:
>=20
> cb248819d209d ("cifs: use cifsInodeInfo->open_file_lock while iterating t=
o avoid a panic")
> 1a67c41596575 ("CIFS: Fix use after free of file info structures")
>=20
> So, I would suggest either to apply those two patches above or to revert =
this one.

Thanks for pointing thse out.  I will try to include those in a later
update.

Ben.

--=20
Ben Hutchings
Any sufficiently advanced bug is indistinguishable from a feature.



--=-aXEdqtHx4Y9xfbklpuEp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl24O4EACgkQ57/I7JWG
EQlO+Q/9ERJdUmTM9CMXqx1b2UvtT8KH+GAuF75obVUHZCN3ysjyLINP5J+I/QjQ
MfefJCJXd7+kFtp7kTe6w+EdxEms6QCQzHmGDGMSzW3wrdMD0ct5N0/3VED8Jqsz
f0kchBegnpNbThc5xMnhpStkcASRlWmrhGMrMIKrN6ybR8doroJ7hD2R6EQ28RPd
j62twwV3v0G1a3BX1DwDuLH3ZuGJhiDZE4AZdLIdZfhZXc9+QX9SOPcCV/i3Zxvp
d/TWzbfaX9jC/K+FlbFIzTYRAIKKLnvSpHEZTnj3qzYR3iO93qvTiILUcxB6z5j5
2cHwcKwINMh/cL+elIVGDqztqcc4vIdqybtGGXkmjRyH3B5BW/3wvpACGHW2Fghw
2f44m4jGHk/VfKemmbBD2NSegKpzffM5g2ioTa6aZT55oMD4yA2Caj3KfGK4nuUc
s5lYXuwXbhRH7HdvIJkK5juoEppbZVvuR/IYGNyXZpqw7ANL+t8AdUu99uyPXSMn
OUGZD25awMkcXTTSD/IMZhrRg4HeaMbQw56QjC/fLwbiwP7BCQowodoXiX82HfKC
GmjfAJsNdJHJzX8s9cnv0lkkGAs9SWO8h5YvHMavoZGmkRzAy4cf+8tUUy0ImR/3
RIcr81FYQ6NLLBC2oWZ3DpbkAg5osjeF2JthnyeuP7w+QW2wVts=
=8ShN
-----END PGP SIGNATURE-----

--=-aXEdqtHx4Y9xfbklpuEp--
