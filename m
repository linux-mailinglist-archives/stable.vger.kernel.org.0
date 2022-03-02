Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 071CD4CB089
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 22:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbiCBVCG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 16:02:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbiCBVCE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 16:02:04 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFCA1D2050;
        Wed,  2 Mar 2022 13:01:19 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 9AFA71C0B81; Wed,  2 Mar 2022 22:01:17 +0100 (CET)
Date:   Wed, 2 Mar 2022 22:01:17 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Daniel Starke <daniel.starke@siemens.com>
Subject: Re: [PATCH 4.9 26/29] tty: n_gsm: fix encoding of control signal
 octet bit DV
Message-ID: <20220302210117.GA9613@duo.ucw.cz>
References: <20220228172141.744228435@linuxfoundation.org>
 <20220228172144.329264359@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <20220228172144.329264359@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: daniel.starke@siemens.com <daniel.starke@siemens.com>
>=20
> commit 737b0ef3be6b319d6c1fd64193d1603311969326 upstream.
>=20
=2E..
> Signed-off-by: Daniel Starke <daniel.starke@siemens.com>

It is probably too late to fix it now, but it would be nice to have
matching From: and Signed-off-by: and have real name in From:.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYh/bHQAKCRAw5/Bqldv6
8jMbAJ4t323uweinj+02FeQMo4Co7eNuIQCeL84GcRDxT2/tFrAORw/z05Xl3PA=
=HhfQ
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
