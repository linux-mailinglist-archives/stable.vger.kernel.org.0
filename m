Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B826C3238A5
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 09:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233743AbhBXIa4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 03:30:56 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:34734 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233146AbhBXIax (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Feb 2021 03:30:53 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 5BA741C0B81; Wed, 24 Feb 2021 09:29:55 +0100 (CET)
Date:   Wed, 24 Feb 2021 09:29:54 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 5.10 03/29] vdpa_sim: store parsed MAC address in a buffer
Message-ID: <20210224082954.GB8058@amd>
References: <20210222121019.444399883@linuxfoundation.org>
 <20210222121020.153222666@linuxfoundation.org>
 <20210222195414.GA24405@amd>
 <20210223080655.ps7ujvgvs6wtlszf@steredhat>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ZoaI/ZTpAVc4A5k6"
Content-Disposition: inline
In-Reply-To: <20210223080655.ps7ujvgvs6wtlszf@steredhat>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ZoaI/ZTpAVc4A5k6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> >>+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> >>@@ -42,6 +42,8 @@ static char *macaddr;
> >> module_param(macaddr, charp, 0);
> >> MODULE_PARM_DESC(macaddr, "Ethernet MAC address");
> >>
> >>+u8 macaddr_buf[ETH_ALEN];
> >>+
> >
> >Should this be static?
>=20
> Yes, there is already a patch [1] queued by Michael but not yet upstream.
> When it will be merged upstream I will make sure it will be backported.

Having it in mainline is enough, I don't really think it causes
anything user-visible, so it does not need to be in stable.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--ZoaI/ZTpAVc4A5k6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmA2DoIACgkQMOfwapXb+vLgNACgj1vpwEzOIwV7Y/g16yUsIzIt
nXAAoLMothbUEz/o+N8pICvYVwEgfNz7
=HZ2x
-----END PGP SIGNATURE-----

--ZoaI/ZTpAVc4A5k6--
