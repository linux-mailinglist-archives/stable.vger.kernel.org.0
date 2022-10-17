Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28625600D88
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 13:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiJQLPs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 07:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbiJQLPk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 07:15:40 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD4B5F22D;
        Mon, 17 Oct 2022 04:15:39 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 22EE51C0016; Mon, 17 Oct 2022 13:15:38 +0200 (CEST)
Date:   Mon, 17 Oct 2022 13:15:37 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Haibo Chen <haibo.chen@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 4.9 1/6] ARM: dts: imx7d-sdb: config the max
 pressure for tsc2046
Message-ID: <20221017111537.GB15612@duo.ucw.cz>
References: <20221011145425.1625494-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Fba/0zbH8Xs+Fj9o"
Content-Disposition: inline
In-Reply-To: <20221011145425.1625494-1-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Fba/0zbH8Xs+Fj9o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Haibo Chen <haibo.chen@nxp.com>
>=20
> [ Upstream commit e7c4ebe2f9cd68588eb24ba4ed122e696e2d5272 ]
>=20
> Use the general touchscreen method to config the max pressure for
> touch tsc2046(data sheet suggest 8 bit pressure), otherwise, for
> ABS_PRESSURE, when config the same max and min value, weston will
> meet the following issue,
>=20
> [17:19:39.183] event1  - ADS7846 Touchscreen: is tagged by udev as: Touch=
screen
> [17:19:39.183] event1  - ADS7846 Touchscreen: kernel bug: device has min =
=3D=3D max on ABS_PRESSURE
> [17:19:39.183] event1  - ADS7846 Touchscreen: was rejected
> [17:19:39.183] event1  - not using input device '/dev/input/event1'
>=20
> This will then cause the APP weston-touch-calibrator can't list touch dev=
ices.
>=20
> root@imx6ul7d:~# weston-touch-calibrator
> could not load cursor 'dnd-move'
> could not load cursor 'dnd-copy'
> could not load cursor 'dnd-none'
> No devices listed.
>=20
> And accroding to binding Doc, "ti,x-max", "ti,y-max", "ti,pressure-max"
> belong to the deprecated properties, so remove them. Also for "ti,x-min",
> "ti,y-min", "ti,x-plate-ohms", the value set in dts equal to the default
> value in driver, so are redundant, also remove here.

Did someone check the source code in 4.9? AFAICT it still tries to use
the properties, and probing seems to be different from newer kernels.

Best regards,
								Pavel
--
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--Fba/0zbH8Xs+Fj9o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY005WQAKCRAw5/Bqldv6
8hccAKDCLsfD88KzTSLTJCyKlR44Pz+rZQCffKcurZ+6+8K/4KiZSQeKKp58rYI=
=AGG5
-----END PGP SIGNATURE-----

--Fba/0zbH8Xs+Fj9o--
