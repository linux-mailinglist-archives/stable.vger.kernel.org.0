Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB7A85EA1AC
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236671AbiIZKzU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237194AbiIZKyw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:54:52 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00654E617;
        Mon, 26 Sep 2022 03:29:03 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 03AF41C0016; Mon, 26 Sep 2022 12:27:59 +0200 (CEST)
Date:   Mon, 26 Sep 2022 12:28:01 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Xiang wangx <wangxiang@cdjrlc.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.9 04/30] video: fbdev: skeletonfb: Fix syntax errors in
 comments
Message-ID: <20220926102801.GA8978@amd>
References: <20220926100736.153157100@linuxfoundation.org>
 <20220926100736.313886468@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
In-Reply-To: <20220926100736.313886468@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2022-09-26 12:11:35, Greg Kroah-Hartman wrote:
> From: Xiang wangx <wangxiang@cdjrlc.com>
>=20
> [ Upstream commit fc378794a2f7a19cf26010dc33b89ba608d4c70f ]
>=20
> Delete the redundant word 'its'.

This does not belong in stable.

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

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmMxfrEACgkQMOfwapXb+vL1iQCeOC+PPkQaXq4wQASnxzsDbLUg
i8oAnjr5Sexl4mbg2UbrtFvmd8FGYGbd
=y5Nw
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
