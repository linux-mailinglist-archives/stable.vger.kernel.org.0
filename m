Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A955112B9E
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 13:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbfLDMiS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 07:38:18 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:54932 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbfLDMiR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Dec 2019 07:38:17 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 4DD3F1C25CF; Wed,  4 Dec 2019 13:38:16 +0100 (CET)
Date:   Wed, 4 Dec 2019 13:38:15 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 187/306] net: hns3: bugfix for
 is_valid_csq_clean_head()
Message-ID: <20191204123815.GC29179@duo.ucw.cz>
References: <20191127203114.766709977@linuxfoundation.org>
 <20191127203128.927710566@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ZARJHfwaSJQLOEUz"
Content-Disposition: inline
In-Reply-To: <20191127203128.927710566@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ZARJHfwaSJQLOEUz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Huazhong Tan <tanhuazhong@huawei.com>
>=20
> [ Upstream commit 6d71ec6cbf74ac9c2823ef751b1baa5b889bb3ac ]
>=20
> The HEAD pointer of the hardware command queue maybe equal to the command
> queue's next_to_use in the driver, so that does not belong to the invalid
> HEAD pointer, since the hardware may not process the command in time,
> causing the HEAD pointer to be too late to update. The variables' name
> in this function is unreadable, so give them a more readable one.
>=20

> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
> @@ -24,15 +24,15 @@ static int hclge_ring_space(struct hclge_cmq_ring *ri=
ng)
>  	return ring->desc_num - used - 1;
>  }
> =20
> -static int is_valid_csq_clean_head(struct hclge_cmq_ring *ring, int h)
> +static int is_valid_csq_clean_head(struct hclge_cmq_ring *ring, int head)
>  {
=2E..
> -	if (unlikely(h >=3D ring->desc_num))
> -		return 0;

This sanity check was removed, and it is not mentioned in the
changelog. Is it intended?

Best regards,
							Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--ZARJHfwaSJQLOEUz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXeeotwAKCRAw5/Bqldv6
8kw6AJ9lWCvcGClFCqWfamchhJ0Pm6qXagCdHMT7YH7MJa/eTaWTgXzxi06CY0U=
=9rax
-----END PGP SIGNATURE-----

--ZARJHfwaSJQLOEUz--
