Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAF5D4C38E2
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 23:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235655AbiBXWl7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 17:41:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235653AbiBXWl6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 17:41:58 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 041CE20C1B6;
        Thu, 24 Feb 2022 14:41:28 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id C228A1C0B82; Thu, 24 Feb 2022 23:41:26 +0100 (CET)
Date:   Thu, 24 Feb 2022 23:41:26 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Wolfram Sang <wsa@kernel.org>,
        krzysztof.kozlowski@canonical.com, semen.protsenko@linaro.org,
        robh@kernel.org, yangyicong@hisilicon.com, geert+renesas@glider.be,
        sven@svenpeter.dev, jie.deng@intel.com, bence98@sch.bme.hu,
        lukas.bulwahn@gmail.com, linux-i2c@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 12/13] i2c: qup: allow COMPILE_TEST
Message-ID: <20220224224126.GC6522@duo.ucw.cz>
References: <20220223023152.242065-1-sashal@kernel.org>
 <20220223023152.242065-12-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="5QAgd0e35j3NYeGe"
Content-Disposition: inline
In-Reply-To: <20220223023152.242065-12-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--5QAgd0e35j3NYeGe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 5de717974005fcad2502281e9f82e139ca91f4bb ]
>=20
> Driver builds fine with COMPILE_TEST. Enable it for wider test coverage
> and easier maintenance.

I believe this does not fix a bug and so is not suitable for stable.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--5QAgd0e35j3NYeGe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYhgJlgAKCRAw5/Bqldv6
8kzrAJwIZg94IIqQJJX8/1MldsEW5DWfFgCfadX3BksxlWl5kx5bh7Bwwz85eC0=
=jpxD
-----END PGP SIGNATURE-----

--5QAgd0e35j3NYeGe--
