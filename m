Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E13B560115
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 15:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233560AbiF2NKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 09:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233720AbiF2NKd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 09:10:33 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 807FB11C11;
        Wed, 29 Jun 2022 06:10:31 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 316B81C0B8F; Wed, 29 Jun 2022 15:10:30 +0200 (CEST)
Date:   Wed, 29 Jun 2022 15:10:29 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Maxime Ripard <maxime@cerno.tech>,
        Melissa Wen <mwen@igalia.com>, emma@anholt.net,
        mripard@kernel.org, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH AUTOSEL 4.19 04/22] drm/vc4: crtc: Use an union to store
 the page flip callback
Message-ID: <20220629131029.GF13395@duo.ucw.cz>
References: <20220628022518.596687-1-sashal@kernel.org>
 <20220628022518.596687-4-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="aPdhxNJGSeOG9wFI"
Content-Disposition: inline
In-Reply-To: <20220628022518.596687-4-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--aPdhxNJGSeOG9wFI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Maxime Ripard <maxime@cerno.tech>
>=20
> [ Upstream commit 2523e9dcc3be91bf9fdc0d1e542557ca00bbef42 ]
>=20
> We'll need to extend the vc4_async_flip_state structure to rely on
> another callback implementation, so let's move the current one into a
> union.

This and [04/22] drm/vc4: crtc: Use an union to store the page flip
callback is queued for 4.9 / 4.19, preparing for change that is not
queued into 4.19.

Please drop at least from 4.9 and 4.19.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--aPdhxNJGSeOG9wFI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYrxPRQAKCRAw5/Bqldv6
8vunAJ9lfwO+e+BGTRNn3nLenP8oCx3WkACeKN+qG6clKzbdd92Cy422TOmsId8=
=f3LC
-----END PGP SIGNATURE-----

--aPdhxNJGSeOG9wFI--
