Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62678591ABD
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 15:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239617AbiHMNod (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 09:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239563AbiHMNoY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 09:44:24 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6CC8DF2E;
        Sat, 13 Aug 2022 06:44:19 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id CCBDE1C0010; Sat, 13 Aug 2022 15:44:17 +0200 (CEST)
Date:   Sat, 13 Aug 2022 15:44:11 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
        Steven Price <steven.price@arm.com>, robh@kernel.org,
        tomeu.vizoso@collabora.com, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH AUTOSEL 5.10 05/46] drm/panfrost: Handle
 HW_ISSUE_TTRX_2968_TTRX_3162
Message-ID: <20220813134411.GD24517@duo.ucw.cz>
References: <20220811160421.1539956-1-sashal@kernel.org>
 <20220811160421.1539956-5-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="n/aVsWSeQ4JHkrmm"
Content-Disposition: inline
In-Reply-To: <20220811160421.1539956-5-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--n/aVsWSeQ4JHkrmm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
>=20
> [ Upstream commit 382435709516c1a7dc3843872792abf95e786c83 ]
>=20
> Add handling for the HW_ISSUE_TTRX_2968_TTRX_3162 quirk. Logic ported
> from kbase. kbase lists this workaround as used on Mali-G57.

AFAICT this quirk is not used anywhere in 5.10, and its users are not
queued. We don't need this in 5.10.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--n/aVsWSeQ4JHkrmm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYveqqwAKCRAw5/Bqldv6
8urJAKCrXQlYnGzP07bFxiXqaP7i9ZQL9ACgppi35hinxJlTlyfFeAY9Grmxdqs=
=0Cas
-----END PGP SIGNATURE-----

--n/aVsWSeQ4JHkrmm--
