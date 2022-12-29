Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C27DC658DF4
	for <lists+stable@lfdr.de>; Thu, 29 Dec 2022 15:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbiL2Ok5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Dec 2022 09:40:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiL2Ok4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Dec 2022 09:40:56 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DAF2BCE;
        Thu, 29 Dec 2022 06:40:54 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id B38CA1C09F6; Thu, 29 Dec 2022 15:40:52 +0100 (CET)
Date:   Thu, 29 Dec 2022 15:40:51 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, nathan@kernel.org,
        andrii@kernel.org, dave.stevenson@raspberrypi.com
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/731] 5.15.86-rc1 review
Message-ID: <Y62m85tYWONgSWmm@duo.ucw.cz>
References: <20221228144256.536395940@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="W8blxuT7XABTLSOh"
Content-Disposition: inline
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--W8blxuT7XABTLSOh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.15.86 release.
> There are 731 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

These are just kCFI annotations. I don't believe we need them in 5.10
(and 5.15).

> Nathan Chancellor <nathan@kernel.org>
>     net: ethernet: ti: Fix return type of netcp_ndo_start_xmit()
> Nathan Chancellor <nathan@kernel.org>
>     drm/fsl-dcu: Fix return type of fsl_dcu_drm_connector_mode_valid()
> Nathan Chancellor <nathan@kernel.org>
>     drm/sti: Fix return type of sti_{dvo,hda,hdmi}_connector_mode_valid()

These are just preparation for "bpf: allow precision tracking for
programs with subprogs", but that is not queued here. We should not
need them.

> Andrii Nakryiko <andrii@kernel.org>
>     bpf: propagate precision in ALU/ALU64 operations
> Andrii Nakryiko <andrii@kernel.org>
>     bpf: propagate precision across all frames, not just the last one

AFAICT, DRM_FORMAT_P030 is not used anywhere in 5.15, so we should not
need this one.

> Dave Stevenson <dave.stevenson@raspberrypi.com>
>     drm/fourcc: Add packed 10bit YUV 4:2:0 format


Best regards,
								Pavel


--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--W8blxuT7XABTLSOh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY62m8wAKCRAw5/Bqldv6
8j7yAJ4rUOX3Dt8E1bP6zL5pGApVesVLIQCbBvlubrU138IwhRD3SLxSA9ScK6Q=
=UqqX
-----END PGP SIGNATURE-----

--W8blxuT7XABTLSOh--
