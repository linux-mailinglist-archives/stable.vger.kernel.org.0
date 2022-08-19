Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94E02599CE5
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 15:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbiHSN2e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 09:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348542AbiHSN2d (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 09:28:33 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF97241D1A;
        Fri, 19 Aug 2022 06:28:31 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 9DA6A1C0010; Fri, 19 Aug 2022 15:28:30 +0200 (CEST)
Date:   Fri, 19 Aug 2022 15:28:30 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>, Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 615/779] mfd: t7l66xb: Drop platform disable callback
Message-ID: <20220819132830.GE11901@duo.ucw.cz>
References: <20220815180337.130757997@linuxfoundation.org>
 <20220815180403.651006449@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="qFgkTsE6LiHkLPZw"
Content-Disposition: inline
In-Reply-To: <20220815180403.651006449@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--qFgkTsE6LiHkLPZw
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

On Mon 2022-08-15 20:04:19, Greg Kroah-Hartman wrote:
> From: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
>=20
> [ Upstream commit 128ac294e1b437cb8a7f2ff8ede1cde9082bddbe ]
>=20
> None of the in-tree instantiations of struct t7l66xb_platform_data
> provides a disable callback. So better don't dereference this function
> pointer unconditionally. As there is no user, drop it completely instead
> of calling it conditional.
>=20
> This is a preparation for making platform remove callbacks return void.

I'm not sure if we need this in stable; this does not really fix
anything, it is just a cleanup.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--qFgkTsE6LiHkLPZw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYv+P/gAKCRAw5/Bqldv6
8pvPAKC7p4CucX2yYDYm4pR9PPoD/crrLgCfa6yNWtF9xoJzVrJTLiV3b4A6GBU=
=v2gB
-----END PGP SIGNATURE-----

--qFgkTsE6LiHkLPZw--
