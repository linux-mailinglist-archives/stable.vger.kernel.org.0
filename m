Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6194C38D7
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 23:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbiBXWjo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 17:39:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbiBXWjn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 17:39:43 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8FD81D0358;
        Thu, 24 Feb 2022 14:39:11 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id CBC621C0B7F; Thu, 24 Feb 2022 23:39:08 +0100 (CET)
Date:   Thu, 24 Feb 2022 23:39:08 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Yongzhi Liu <lyz_cs@pku.edu.cn>, Vinod Koul <vkoul@kernel.org>,
        christophe.jaillet@wanadoo.fr, arnd@arndb.de,
        laurent.pinchart@ideasonboard.com, dmaengine@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.16 24/30] dmaengine: shdma: Fix runtime PM
 imbalance on error
Message-ID: <20220224223908.GA6522@duo.ucw.cz>
References: <20220223022820.240649-1-sashal@kernel.org>
 <20220223022820.240649-24-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
In-Reply-To: <20220223022820.240649-24-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Yongzhi Liu <lyz_cs@pku.edu.cn>
>=20
> [ Upstream commit 455896c53d5b803733ddd84e1bf8a430644439b6 ]
>=20
> pm_runtime_get_() increments the runtime PM usage counter even
> when it returns an error code, thus a matching decrement is needed on
> the error handling path to keep the counter balanced.

I don't think that's right.

Notice that -ret is ignored (checked 4.4 and 5.10), so we don't
actually abort/return error; we just printk. We'll do two
pm_runtime_put's after the "fix".

Please drop from -stable.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYhgJDAAKCRAw5/Bqldv6
8oWyAJ9lGSwTzx09P/PLH+RIdOJFoShGuQCgsWAGPCISnvCtle6/TZL/Vum6l9o=
=UDM1
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
