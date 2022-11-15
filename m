Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2C30629528
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 11:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbiKOKCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 05:02:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237742AbiKOKCH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 05:02:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 303CE23EAB;
        Tue, 15 Nov 2022 02:02:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9126B8188D;
        Tue, 15 Nov 2022 10:02:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0BD0C433D7;
        Tue, 15 Nov 2022 10:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668506524;
        bh=dQIm0jpNMea512ml4HBeW/HoNsS6JaZjSzioGFYiMtI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VnWWfGT9+g2uCNjVsvYXKMBtSm3SRUE+8rXskzlGhiDPHsepcfau5f/xmMTWFsxM9
         FFfVeC8TJthKMmvWOo3LvI9ZgNarP0q1E2BNbHSNJ0wHUYh3fJRDKoPx2x8RhwDWH/
         FGr+YsFNLKKRFeYR+MXdmwhkcOz4uNAJR1KMKhOe1g6TpRioSpm++PJqeb1hTmt+yS
         FFLTOPZHDsnuFbFc4PIAgZSqOiG1+r2j/s9AuIC4nrZtH2boQ8EK/3W4e9lXFBkS9l
         zCOCh5W6vofTOsSUXM3FGsyWonuERq95rAR+l3ykPZ8NI1LR+G0NJypXQnmVHNmdQM
         dZSz/0UGefD8A==
Date:   Tue, 15 Nov 2022 10:02:01 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: WARNING: CPU: 0 PID: 1111 at arch/arm64/kernel/fpsimd.c:464
 fpsimd_save+0x170/0x1b0
Message-ID: <Y3NjmfPGK6qjh5LP@sirena.org.uk>
References: <CA+G9fYuXG7Rh_A8W1NRVWbgWjozwzxzQY7tYw7bA4NsCuSovMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="yRsqSy0P+bXdS5Uu"
Content-Disposition: inline
In-Reply-To: <CA+G9fYuXG7Rh_A8W1NRVWbgWjozwzxzQY7tYw7bA4NsCuSovMg@mail.gmail.com>
X-Cookie: Ego sum ens omnipotens.
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--yRsqSy0P+bXdS5Uu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 15, 2022 at 12:57:53PM +0530, Naresh Kamboju wrote:
> Following kernel warning noticed while running kselftest arm64 sve-ptrace
> on qemu-arm64 on ampere-altra server.

> [  422.607034] ------------[ cut here ]------------
> [  422.615382] WARNING: CPU: 0 PID: 1111 at
> arch/arm64/kernel/fpsimd.c:464 fpsimd_save+0x170/0x1b0
> [  422.617588] Modules linked in: cfg80211 bluetooth rfkill
> crct10dif_ce sm3_ce sm3 sha3_ce sha512_ce sha512_arm64 fuse drm

Without the ability to reproduce this or more information this
isn't really actionable - since I'm not seeing any changes that
look in the least bit relevant in the stable queue I'm guessing
that it's just happened once?

You mention that this is hosted on an Altra but it looks like
you're running the TCG backend, if there's some reason to expect
that qemu might be unstable when hosted on that platform it's
probably worth looping the qemu people in.

--yRsqSy0P+bXdS5Uu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmNzY5gACgkQJNaLcl1U
h9CQzAf+IcSnHQ+8izD9i0xRCF2SV8pNK6d/Qa4aZblAfooRyn4EKZg+BuCepH1y
siNIaqR6hKO8q1yqnrjSEDAfyYJVw3Gr9KEdmY2VvccFWeudquYSD4+QnmgvgJbz
sLNHVCvirGKzvno1B1spCosYwFmElA74AfcbIrPBFhlwPQj8akU8ydB0tCy5lCLb
eCS/NhD44VnQzJIQGHeJhFj4JsgqqlnF9WCl+QX7qkMKvtrMui97yOzom4ZAvpaU
Adqtuecvus1r47qlYahceVJGsbWmFjYs+WIMEICyXNNrkzDgYRoGnm2kWibEWWTT
201nrRDJM/MK5QH/lK/NljHBDS+Mww==
=myaL
-----END PGP SIGNATURE-----

--yRsqSy0P+bXdS5Uu--
