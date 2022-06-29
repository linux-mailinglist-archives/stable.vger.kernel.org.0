Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8EC95600BA
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 15:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233647AbiF2NDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 09:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233654AbiF2NDg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 09:03:36 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10224120BA;
        Wed, 29 Jun 2022 06:03:35 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id CA9FA1C0BCC; Wed, 29 Jun 2022 15:03:33 +0200 (CEST)
Date:   Wed, 29 Jun 2022 15:03:33 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Xiang wangx <wangxiang@cdjrlc.com>,
        Helge Deller <deller@gmx.de>, daniel.vetter@ffwll.ch,
        geert@linux-m68k.org, cssk@net-c.es, tzimmermann@suse.de,
        bhelgaas@google.com, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH AUTOSEL 4.9 05/13] video: fbdev: skeletonfb: Fix syntax
 errors in comments
Message-ID: <20220629130333.GC13395@duo.ucw.cz>
References: <20220628022657.597208-1-sashal@kernel.org>
 <20220628022657.597208-5-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="IpbVkmxF4tDyP/Kb"
Content-Disposition: inline
In-Reply-To: <20220628022657.597208-5-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--IpbVkmxF4tDyP/Kb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Xiang wangx <wangxiang@cdjrlc.com>
>=20
> [ Upstream commit fc378794a2f7a19cf26010dc33b89ba608d4c70f ]
>=20
> Delete the redundant word 'its'.

Calling typo in comment "syntax error" is ... interesting. Anyway, we
don't need this in stable.

Best regards,
								Pavel

> +++ b/drivers/video/fbdev/skeletonfb.c
> @@ -96,7 +96,7 @@ static struct fb_fix_screeninfo xxxfb_fix =3D {
> =20
>      /*
>       * 	Modern graphical hardware not only supports pipelines but some=
=20
> -     *  also support multiple monitors where each display can have its =
=20
> +     *  also support multiple monitors where each display can have
>       *  its own unique data. In this case each display could be =20
>       *  represented by a separate framebuffer device thus a separate=20
>       *  struct fb_info. Now the struct xxx_par represents the graphics
> --=20
> 2.35.1

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--IpbVkmxF4tDyP/Kb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYrxNpQAKCRAw5/Bqldv6
8gI/AJwOATMguvVavkA6qthRvcBNeklk7gCgrMYEh/s4HDh+efnrHln00b0Oi7E=
=GTfr
-----END PGP SIGNATURE-----

--IpbVkmxF4tDyP/Kb--
