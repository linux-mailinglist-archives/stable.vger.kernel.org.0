Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA26566632C
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 19:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238045AbjAKS4v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 13:56:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbjAKS4u (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 13:56:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 750201B0;
        Wed, 11 Jan 2023 10:56:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2633FB81BB2;
        Wed, 11 Jan 2023 18:56:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2BDBC433D2;
        Wed, 11 Jan 2023 18:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673463406;
        bh=f8ehkPRhHvV4m7LtWW7PXiL69ZVJua3vpOb9mfjdtdE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CTC5LydZRZRfJKyil15GzxfhFdFn0DmoTPXH9ptU4zHksDXPYeJiO4Hsvg25XebWv
         34lzPhxy9XDe2ivG/uFVSjx3H0+1Ml3xH63vD4e0pGdn9CD19yNVD1gCRnealOe3vm
         U1bubACchyII08Ln7rwoKgVXT1gWq2Vl4PC2gTod4q/qQKGE7aD2a6gET9EESpNLBf
         1BGcQbodA/xJ09MDE6AzXbI4BL0K1o1HWvYnO7UFm7ajeXHnR3pX1KP9I74uGF4Xt7
         4fxQOV8iaU9MofweW/fXWsphy+o6SZxM8MOiSRQEODez1XEI+kylTXwYuU4I7Q00OG
         KzWdbL5PyNTXQ==
Date:   Wed, 11 Jan 2023 18:56:41 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/148] 6.0.19-rc1 review
Message-ID: <Y78GafBrQyywPXJE@spud>
References: <20230110180017.145591678@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bAdeVB51TK1R1zyN"
Content-Disposition: inline
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bAdeVB51TK1R1zyN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 10, 2023 at 07:01:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.19 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> NOTE, this will probably be the LAST 6.0.y release.  If there is
> anything preventing you from moving to 6.1.y right now, please let me
> know.
>=20
> Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.19-=
rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.0.y
> and the diffstat can be found below.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.


--bAdeVB51TK1R1zyN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY78GaQAKCRB4tDGHoIJi
0hjiAPwI9gIMKNfvL9N+noXsBQnD1KZLqtNo/LJGWXiuLI5LSwEA7hu31GyC6QQe
xtS9CSeR2IPw2AyqDZiKvLca9DF6Www=
=J4si
-----END PGP SIGNATURE-----

--bAdeVB51TK1R1zyN--
