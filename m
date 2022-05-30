Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F999538492
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 17:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238296AbiE3PRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 11:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238435AbiE3PQh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 11:16:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4C7703E5;
        Mon, 30 May 2022 07:17:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B138BB80DC0;
        Mon, 30 May 2022 14:17:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0347FC385B8;
        Mon, 30 May 2022 14:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653920243;
        bh=PT8uDFaGOFF2MB58Pm6uS89RmOeOqkNAq1Wym4ZMLZA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lCCC2hp9RMqW+PoqLZU2Z1QsnGonkhN1IFKdSQsyc9pAQHlOCNFVTq/VLmEk/Vtpc
         fUoTRQ32F5WLWoA3nT7J7/2aun2S+p826+bvwVB1mp35D9smGZy8NAGlW0f6TfU7dT
         vOS/97u7RAwgUIG1zDZulIJIkxxOQ6iei9jfzJ8B6yzCbYrFJJiB1jI95xluKuwo7Z
         bQPkBxy1u0McbJdS99xlyU/A8vKZpGE/Uc/j4+dGKAHkNUmmbHc0X0xOje63OMVItZ
         fD5SibbdXZftMRcOZDTS65xMd68n+6cuxZ83HfLns4dYNEbTmud8FS1trrCGdjKHdo
         KAGD5M+pfC1vA==
Date:   Mon, 30 May 2022 16:17:19 +0200
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Catalin Marinas <catalin.marinas@arm.com>, will@kernel.org,
        maz@kernel.org, mark.rutland@arm.com, vladimir.murzin@arm.com,
        joey.gouly@arm.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.18 063/159] arm64/sme: Add ID_AA64SMFR0_EL1 to
 __read_sysreg_by_encoding()
Message-ID: <YpTR7/g7R73RCJBj@sirena.org.uk>
References: <20220530132425.1929512-1-sashal@kernel.org>
 <20220530132425.1929512-63-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="xXcXVJYOzJBiovYa"
Content-Disposition: inline
In-Reply-To: <20220530132425.1929512-63-sashal@kernel.org>
X-Cookie: May your camel be as swift as the wind.
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--xXcXVJYOzJBiovYa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 30, 2022 at 09:22:48AM -0400, Sasha Levin wrote:
> From: Mark Brown <broonie@kernel.org>
>=20
> [ Upstream commit 8a58bcd00e2e8d46afce468adc09fcd7968f514c ]
>=20
> We need to explicitly enumerate all the ID registers which we rely on
> for CPU capabilities in __read_sysreg_by_encoding(), ID_AA64SMFR0_EL1 was
> missed from this list so we trip a BUG() in paths which rely on that
> function such as CPU hotplug. Add the register.

> +	read_sysreg_case(SYS_ID_AA64SMFR0_EL1);

This won't build on v5.18 since it does not contain SME support
and therefore lacks the definition for the SME feature register.

--xXcXVJYOzJBiovYa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmKU0e4ACgkQJNaLcl1U
h9CYFwf/UkNQiuhL11ocuNQ5OW5J92pfRiJSjL0UI5eOUydKfWx9N3vy0hq6lxjU
Q7RnTFiQAT1lvCzW5zwHj5QFRBn9m3z7v4aXoYESxBRcNlUxjwxdN6ALOEdyRVDi
aoIu0XHHXPP2ReCRXvxGJfUu4vfNn1Jfj2rCw8FOqtZjsPa4H9pLXvjNt/f8DKs0
8aM4WTYnX7DrxJ1nckUfMSi+bjIk+dZjJ3h7QcsVMsTvDjQwXujmLCDtABJFsJHL
yH3EGy5qzgcJQXISR+LidGX7rQC+NCY4APrDnclRCCJxcc7s8aeMr8ZXzY8Q9Ofo
ssmVftxfRLwlwmVCs7OUuHqoxOsKrQ==
=Ot1b
-----END PGP SIGNATURE-----

--xXcXVJYOzJBiovYa--
