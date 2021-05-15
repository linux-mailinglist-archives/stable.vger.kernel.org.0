Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139273816F3
	for <lists+stable@lfdr.de>; Sat, 15 May 2021 10:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbhEOIii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 May 2021 04:38:38 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:50186 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234183AbhEOIic (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 May 2021 04:38:32 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 7E4651C0B81; Sat, 15 May 2021 10:37:18 +0200 (CEST)
Date:   Sat, 15 May 2021 10:37:17 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 380/530] udp: never accept GSO_FRAGLIST packets
Message-ID: <20210515083717.GD30461@amd>
References: <20210512144819.664462530@linuxfoundation.org>
 <20210512144832.263718249@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="2iBwrppp/7QCDedR"
Content-Disposition: inline
In-Reply-To: <20210512144832.263718249@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--2iBwrppp/7QCDedR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Paolo Abeni <pabeni@redhat.com>
>=20
> [ Upstream commit 78352f73dc5047f3f744764cc45912498c52f3c9 ]
>=20
> Currently the UDP protocol delivers GSO_FRAGLIST packets to
> the sockets without the expected segmentation.
>=20
> This change addresses the issue introducing and maintaining
> a couple of new fields to explicitly accept SKB_GSO_UDP_L4
> or GSO_FRAGLIST packets. Additionally updates  udp_unexpected_gso()
> accordingly.
>=20
> UDP sockets enabling UDP_GRO stil keep accept_udp_fraglist
> zeroed.

What is going on here? accept_udp_fraglist variable is read-only.

Should this be dropped? Should=20

commit d18931a92a0b5feddd8a39d097b90ae2867db02f
    vxlan: allow L4 GRO passthrough
   =20
be cherry-picked?

Best regards,
							Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--2iBwrppp/7QCDedR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmCfiD0ACgkQMOfwapXb+vIJjwCeP1CTpZD86zOct2i7KWCsnPQZ
aPoAnizcfWB9nBgjVVeSJsrz85m+8HnB
=7GSI
-----END PGP SIGNATURE-----

--2iBwrppp/7QCDedR--
