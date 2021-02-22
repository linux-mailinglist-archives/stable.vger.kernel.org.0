Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA97322088
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 20:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232791AbhBVTy6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 14:54:58 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:47596 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbhBVTy5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 14:54:57 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 8A5B21C0B85; Mon, 22 Feb 2021 20:54:15 +0100 (CET)
Date:   Mon, 22 Feb 2021 20:54:15 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 5.10 03/29] vdpa_sim: store parsed MAC address in a buffer
Message-ID: <20210222195414.GA24405@amd>
References: <20210222121019.444399883@linuxfoundation.org>
 <20210222121020.153222666@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
In-Reply-To: <20210222121020.153222666@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Stefano Garzarella <sgarzare@redhat.com>
>=20
> commit cf1a3b35382c10ce315c32bd2b3d7789897fbe13 upstream.
>=20
> As preparation for the next patches, we store the MAC address,
> parsed during the vdpasim_create(), in a buffer that will be used
> to fill 'config' together with other configurations.

I'm not sure why this series is in stable. It is not documented to fix
anything bad.=20

> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> @@ -42,6 +42,8 @@ static char *macaddr;
>  module_param(macaddr, charp, 0);
>  MODULE_PARM_DESC(macaddr, "Ethernet MAC address");
> =20
> +u8 macaddr_buf[ETH_ALEN];
> +

Should this be static?

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmA0C+YACgkQMOfwapXb+vKlewCeNE2LGhbCR7ndoidHEsOGq8RP
aDsAn2GpF/7+JA0ST+xN2YqR4K+kFG+U
=8oea
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
