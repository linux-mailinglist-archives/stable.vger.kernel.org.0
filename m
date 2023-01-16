Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8C166D1DA
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 23:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234127AbjAPWiu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 17:38:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233398AbjAPWis (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 17:38:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E0D234CD;
        Mon, 16 Jan 2023 14:38:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B508A61172;
        Mon, 16 Jan 2023 22:38:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A306C433EF;
        Mon, 16 Jan 2023 22:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673908726;
        bh=AVdJVesBckUshztYPU/EucowrURa2SthZW3QIezS5SE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Uzlp303vcC7QkFxTNFu5Ng6WtujujepOR/4tumyWz9e1EGpMPenfUxID0dhpoA81x
         v0hjMGuDs5+iQmIUp1lCFHrk5km3VWKpVRRk3mwcVvR6kkq2OHmD4K8iPvSAe85Rec
         NIKUW13aNe92nEhQWJmotTjZMZcgR7n2VQjT614WLChNB85qnG+iQrSvNHpHi6YJB1
         oq7EDgPtgqTAyrQHA07EMWwcz9C+Q1ODnOx7JZa6cajwWttCRAqfB9p4O8q7/AvqC7
         n7boAnyuBZNSyH2EaUaT9QRp0NDXq4VPNyJblKtCxPWWUj19+rDBMpqO9Giw8sAe4g
         3xS3rkw+8alAA==
Date:   Mon, 16 Jan 2023 22:38:40 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/183] 6.1.7-rc1 review
Message-ID: <Y8XR8L+l4iBoUXGs@spud>
References: <20230116154803.321528435@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="db4sbOaDAH1NeJaV"
Content-Disposition: inline
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--db4sbOaDAH1NeJaV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Greg,

On Mon, Jan 16, 2023 at 04:48:43PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.7 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.7-r=
c1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.1.y
> and the diffstat can be found below.

As far as my HW is concerned, looks grand on the RISC-V front..

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.


--db4sbOaDAH1NeJaV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY8XR8AAKCRB4tDGHoIJi
0r9lAQDt37XJ8yRGSjuc2R6ScAar48FCmlIkgMaaiY0v0Lx8UQD+PzVQ6pwvwrLb
Ql/qmgl9X6s4iVKj3AY4ZOuB2Wtz8gs=
=REs2
-----END PGP SIGNATURE-----

--db4sbOaDAH1NeJaV--
