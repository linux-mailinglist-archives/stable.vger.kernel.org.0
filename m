Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3284562B852
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 11:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbiKPK3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 05:29:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbiKPK3L (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 05:29:11 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47CA52FC1C
        for <stable@vger.kernel.org>; Wed, 16 Nov 2022 02:25:51 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id E92911C09F6; Wed, 16 Nov 2022 11:25:49 +0100 (CET)
Date:   Wed, 16 Nov 2022 11:25:49 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        wengjianfeng <wengjianfeng@yulong.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 024/118] NFC: nxp-nci: remove unnecessary labels
Message-ID: <Y3S6rSLK1Xx7sL9p@duo.ucw.cz>
References: <20221108133340.718216105@linuxfoundation.org>
 <20221108133341.716314975@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="MP6c9xx7/oXGF3+6"
Content-Disposition: inline
In-Reply-To: <20221108133341.716314975@linuxfoundation.org>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--MP6c9xx7/oXGF3+6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: wengjianfeng <wengjianfeng@yulong.com>
>=20
> [ Upstream commit 96a19319921ceb4b2f4c49d1b9bf9de1161e30ca ]
>=20
> Simplify the code by removing unnecessary labels and returning
> directly.

Ok, but is there reason for changing the error code? ENOTSUPP ->
EOPNOTSUPP?

Best regards,
								Pavel

> +++ b/drivers/nfc/nxp-nci/core.c
> @@ -70,21 +70,16 @@ static int nxp_nci_send(struct nci_dev *ndev, struct =
sk_buff *skb)
>  	struct nxp_nci_info *info =3D nci_get_drvdata(ndev);
>  	int r;
> =20
> -	if (!info->phy_ops->write) {
> -		r =3D -ENOTSUPP;
> -		goto send_exit;
> -	}
> +	if (!info->phy_ops->write)
> +		return -EOPNOTSUPP;
>

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--MP6c9xx7/oXGF3+6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY3S6rQAKCRAw5/Bqldv6
8opHAKDDvYTUSXz/b3zY8uDlieVgnOYxOgCfd7fU/XnXtKDp9Lk0BYO6lEmS5/8=
=z3r+
-----END PGP SIGNATURE-----

--MP6c9xx7/oXGF3+6--
