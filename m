Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBB406C13F8
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 14:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjCTNut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 09:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231247AbjCTNus (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 09:50:48 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E95F81205E;
        Mon, 20 Mar 2023 06:50:30 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 27BA91C0DC0; Mon, 20 Mar 2023 14:50:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ucw.cz; s=gen1;
        t=1679320229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=90dCNq8uKAzv+tQjFAiOpm/ZaHLWbi5q9XNYIDbKdIc=;
        b=NJcovw0bg1qX6e96jxbLJa2y8mTGIbrL+w8Ois4fCSDnyOZ9ue5stSfT/18TaL9qbnX+Qn
        FDtHXjQ+4wrJM5zwG3bdcPAcweTGGGiIGAo49MYyuDiUBRk6DTp9Ud/Mh0VzACU+RNhimL
        +Ej6fQwExTzpl0bkYatIcR4cQ0fLDLE=
Date:   Mon, 20 Mar 2023 14:50:28 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>, markgross@kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 12/15] platform/x86: ISST: Increase range of
 valid mail box commands
Message-ID: <ZBhkpDB5xSfP+MAK@duo.ucw.cz>
References: <20230320005559.1429040-1-sashal@kernel.org>
 <20230320005559.1429040-12-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="aRgdwLarlWDLbRM/"
Content-Disposition: inline
In-Reply-To: <20230320005559.1429040-12-sashal@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--aRgdwLarlWDLbRM/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
>=20
> [ Upstream commit 95ecf90158522269749f1b7ce98b1eed66ca087b ]
>=20
> A new command CONFIG_TDP_GET_RATIO_INFO is added, with sub command type
> of 0x0C. The previous range of valid sub commands was from 0x00 to 0x0B.
> Change the valid range from 0x00 to 0x0C.

Not sure why this was selected for stable.

We don't have CONFIG_TDP_GET_RATIO_INFO in 5.10, so we should not have
this.

Best regards,
								Pavel
							=09
> +++ b/drivers/platform/x86/intel_speed_select_if/isst_if_common.c
> @@ -47,7 +47,7 @@ struct isst_cmd_set_req_type {
> =20
>  static const struct isst_valid_cmd_ranges isst_valid_cmds[] =3D {
>  	{0xD0, 0x00, 0x03},
> -	{0x7F, 0x00, 0x0B},
> +	{0x7F, 0x00, 0x0C},
>  	{0x7F, 0x10, 0x12},
>  	{0x7F, 0x20, 0x23},
>  	{0x94, 0x03, 0x03},

--=20
People of Russia, stop Putin before his war on Ukraine escalates.

--aRgdwLarlWDLbRM/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZBhkpAAKCRAw5/Bqldv6
8ulbAKC95CvBmi5a0s3qjwNxPsG01uVeVQCeNQw1j0qbJf6gNp0WlOJ2NNcBQ/Y=
=Y4+C
-----END PGP SIGNATURE-----

--aRgdwLarlWDLbRM/--
