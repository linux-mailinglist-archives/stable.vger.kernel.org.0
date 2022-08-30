Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD295A6B7F
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbiH3R7K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbiH3R6s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:58:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6534A28E29;
        Tue, 30 Aug 2022 10:58:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1ABD5B81D44;
        Tue, 30 Aug 2022 17:58:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E7B2C433C1;
        Tue, 30 Aug 2022 17:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661882292;
        bh=sybPumXRTrZl2VUTu1Lul+2QtsmCj+bXbYY0Ec9V6Nc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F/kq8cXE+OBDPeYGcLVKD7LAAPXvfffIjNmrdN7JICx0jHC5rZjDtjNXiIMof9XDx
         Dp89MRx4or0pCiPChJieA4of8rBpgn/z33h54tVBJ8QHqmaEypKUKp/ZrYRK9KHvkI
         47eRucrG6j1s1Z3WOFNuEJpDXcIgmIp+f+mXvj+alcSVtpMHkEqBPNY3AkMrfQg3GE
         eZuP6SCTbpTu/vR1FoYJmEOmCHTf/DPFAp4jm+4fRkbPI2BPb2WhKSHsPl78T9smoI
         ag8RGM6/MpBEuTq6wDugRaXdm7PzX/iKRvvCSUfj31xRSRIoI17rqwEG9HD1mkEHja
         CbxX1yn+2BaPA==
Date:   Tue, 30 Aug 2022 18:58:09 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, seanjc@google.com,
        mark.rutland@arm.com, elver@google.com, david.engraf@sysgo.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.15 14/23] arm64/signal: Raise limit on stack
 frames
Message-ID: <Yw5PgFEtUloKxRNQ@sirena.org.uk>
References: <20220830172141.581086-1-sashal@kernel.org>
 <20220830172141.581086-14-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5BnFLNDp644MiSfw"
Content-Disposition: inline
In-Reply-To: <20220830172141.581086-14-sashal@kernel.org>
X-Cookie: Necessity is a mother.
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--5BnFLNDp644MiSfw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 30, 2022 at 01:21:31PM -0400, Sasha Levin wrote:
> From: Mark Brown <broonie@kernel.org>
>=20
> [ Upstream commit 7ddcaf78e93c9282b4d92184f511b4d5bee75355 ]
>=20
> The signal code has a limit of 64K on the size of a stack frame that it
> will generate, if this limit is exceeded then a process will be killed if

I don't believe this is relevant to kernels without SME support.

--5BnFLNDp644MiSfw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmMOT7EACgkQJNaLcl1U
h9BqAAf+P0C3w4jbPe9ZwvlXlJ5Lxcz1wmkm/TM/Ybj/OgRPqAlAy8JcHq9TqPDD
WxMUfFH8yYktrmFZJfhxOwWOuBpDIMHOebd/7c07LvcOzEEdCzKK3YS1Gb8pv1xJ
nsHnONwiWFlsubP7MtJL9NuDO9tSlCK1dqTbWmCpIe7AdnwI0d5yUMcqJYT8rw78
ZFNcjBrrKYcFHE9k1/mZNvxbUEDmKgfOYgmSB7KNEn9JPB4+1UMPpXCuTsgf+aMl
UrmpcL3ZHrAFGQ5U2hVhzQLMhqYHFGnmbVYYO6C5fvLYjbZAoIJQEfdBhw0QJdZJ
AWNDcwm4RtAEnfekY8ooobBFr69g5A==
=E+48
-----END PGP SIGNATURE-----

--5BnFLNDp644MiSfw--
