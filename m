Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9C25FB6FF
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 17:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbiJKP0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 11:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbiJKP0H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 11:26:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA2B4DB767;
        Tue, 11 Oct 2022 08:17:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3865B8136F;
        Tue, 11 Oct 2022 15:04:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5680C433B5;
        Tue, 11 Oct 2022 15:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665500687;
        bh=n7jP6tXz9ptPp7fQFOYcwp6XPTxuRhGbK+fN6cHhBhc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dReV+Hp//vdyymJcPPt2oz+mvhKJpMhgwTCoVslc6Zg266GXgE6+fzGOFxAlVpVou
         FriXPXGSPKLU2xe1NzGP94w+mpEgRnI/eajv0ijyse7W16RZWbPhy3q/Gcj7OD6eib
         GDNyCrZmwO8Hg0uGhgXGRNPHttIci3octka66gFsOmibm0F8ZNdHINVLjE640OVaUY
         1V4+VcBDS5S16YeAEMuh7jbWrX/8mkZc7AcOkYiT3LM9hDdScSXw4U6/vgbitRViyY
         1jAl/Gdvpck4S1wQZ/ggLWx000INrWFixrNCwIc0VQZksPkwVfujcFTquBi0xe29VG
         fuM7agerep7Gg==
Date:   Tue, 11 Oct 2022 16:04:42 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>, will@kernel.org,
        shuah@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.0 15/46] kselftest/arm64: Allow larger buffers
 in get_signal_context()
Message-ID: <Y0WGCuHDriRctkeL@sirena.org.uk>
References: <20221011145015.1622882-1-sashal@kernel.org>
 <20221011145015.1622882-15-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ZXVbpL80mW+WN6mn"
Content-Disposition: inline
In-Reply-To: <20221011145015.1622882-15-sashal@kernel.org>
X-Cookie: I had pancake makeup for brunch!
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ZXVbpL80mW+WN6mn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 11, 2022 at 10:49:43AM -0400, Sasha Levin wrote:
> From: Mark Brown <broonie@kernel.org>
>=20
> [ Upstream commit 38150a6204c731a4846786682e500d132571fd82 ]
>=20
> In order to allow testing of signal contexts that overflow the base signal
> frame allow callers to pass the buffer size for the user context into
> get_signal_context(). No functional change.

This doesn't obviously make sense independently, even by the relaxed
standards stable uses these days?

--ZXVbpL80mW+WN6mn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmNFhgkACgkQJNaLcl1U
h9B99Af+J61/eNy1lXZrZld4WN7Zff8TQf6QIsHw0uhVuMdtgiiS0YOHH45HzaSh
FkSNR7bkWv42XQMeLONOVCISMuy93stVc0lFZuzfTW2ByxUSLJ8FwICVZxRc8azL
LVhH4xLAQCVq1NVzNEhhA1P9xQlvEIgDh2IN+Pg7Fxnp4uLRSNWu1ngdm0r1Tsm2
qTAZfaCDnJ6jza1IphzUtN6QyKyvyq7mNVVBpW4tPHGdwD+/dXtwppfckrEC4aiP
dNPnCr/OW1RNrMgVvt+1KNt6cnNfdUf5lnxYGKjsmTAxEf7e0JZ2o6Pdp5oGPmNv
qBlr5Gf8L8WTFTAdx/MXePRE+LrjxQ==
=mPaI
-----END PGP SIGNATURE-----

--ZXVbpL80mW+WN6mn--
