Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E054F4EC3A9
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 14:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345028AbiC3MLb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 08:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347051AbiC3MFu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 08:05:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A3D5299A59;
        Wed, 30 Mar 2022 05:00:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9D62B81C29;
        Wed, 30 Mar 2022 12:00:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53970C340F2;
        Wed, 30 Mar 2022 12:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648641652;
        bh=mGIdFN2hBOqp+cqvzAkpx41arTM1NYj9iwoDe56VnbU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m2ETwEIV+o9p39koZgMWirI+rgblDUpfDI6vNBx/vYoss+7XlcOBAST/AK7yM4438
         HqVJ9FluaNHAJe4IGJ7MBYVq1qIHV9sTDtZ0JzVBBdgQEYeBFgs9+xWZMsyEmtrJt7
         ZEy8NPJsAKr+yDujMUrLDsB/rJ8CKtdcNre/6ujebWCknjQj5xFcJNoo1N5TNRbd5h
         vGcCG/K1rsJzQfqrRJtddx3NvFmvEFCBl+GmKQ463FBOSWmAzkVlE1G5AZr9WlQIOA
         jWfSrQCanvt4au0srg8O+70kqT1kR+dyIN5Gb6j3Ca5sfV94zCtF9MAk8eHcBGUNhI
         miNqrxE9x8RtQ==
Date:   Wed, 30 Mar 2022 13:00:47 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        =?iso-8859-1?Q?P=E9ter?= Ujfalusi 
        <peter.ujfalusi@linux.intel.com>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: Re: [PATCH AUTOSEL 5.17 58/66] ASoC: Intel: Revert "ASoC: Intel:
 sof_es8336: add quirk for Huawei D15 2021"
Message-ID: <YkRGb9uDhWV9GQfn@sirena.org.uk>
References: <20220330114646.1669334-1-sashal@kernel.org>
 <20220330114646.1669334-58-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="utOV3yk5eFjiGqrz"
Content-Disposition: inline
In-Reply-To: <20220330114646.1669334-58-sashal@kernel.org>
X-Cookie: Two is company, three is an orgy.
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--utOV3yk5eFjiGqrz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 30, 2022 at 07:46:37AM -0400, Sasha Levin wrote:
> From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
>=20
> [ Upstream commit 1b5283483a782f6560999d8d5965b1874d104812 ]
>=20
> This reverts commit ce6a70bfce21bb4edb7c0f29ecfb0522fa34ab71.
>=20
> The next patch will add run-time detection of the required SSP and
> this hard-coded quirk is not needed.

This is reverting a commit which was bacported earlier in this series?

--utOV3yk5eFjiGqrz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmJERm4ACgkQJNaLcl1U
h9AI5gf/XYRZRk5VaiBgcNnLN3y2HWSpoxCbcV8Z5WTeqckhdWB5gRYS90qlr+Vs
6l9fFJF96dq2CfbEneiOv+q1v4J0qI1wt9evoLODgebiq/JrFb+bf5jySjMuqk7Q
ffhx+AtSB0ZHFHVStm2NCiLXVfU4lY5o/ZAjKPPHbuD8bTncqz9Rxas10dUp2WzC
kB6xIrs6ZQeI77nevWv0TyBzbPlh3tAcg11TH+OraCOl70AqrdyAKXl7krqLd5A7
vV5IoU86gM5wK+Z0eOwvqqwzABwogd56dJ7Jv4yDVjcaX1/g4TdpLU52CKHzzsYu
YclGwQS+jGSdFPlfEvUvL/yNIWbYpg==
=wWkO
-----END PGP SIGNATURE-----

--utOV3yk5eFjiGqrz--
