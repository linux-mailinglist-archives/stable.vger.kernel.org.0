Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B92436E81A7
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 21:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbjDSTEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 15:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjDSTEm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 15:04:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC864EE6;
        Wed, 19 Apr 2023 12:04:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2D2D64053;
        Wed, 19 Apr 2023 19:04:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F141FC433D2;
        Wed, 19 Apr 2023 19:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681931080;
        bh=+9gwLKkZO2yJ/Q/em5Gert+OcxDCNLdwlQfxK0qa/rI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KZhLcQTnSTX1zz+3jSoyrXQKMdJgLdbpz64iuYPc5QxBA7kn8Au17hWm7bpJ3+tVh
         wTzMK1RnkrZwYuEhzxRvHxTZMWZ3LQp0T/GW3QUiO7Zl59Q8/3B4nlmMSF2jOf9HTW
         hixXsH6RK42fyzoo7fdTam8bwzNFlJtV7rq2t5UQsTMv3MgH1qNfT0M9pVhrL6Z7tw
         /eUGHxLUpUTsG7VySdZq7sN7LzSlSH+xmM/X87HYnsdFzd5Xk2FHB//HgCAADjfNC5
         +cSwRks6h/JizPS2N2lSK96avdfNwKY7Z8OmIOwgDMSTYLVuo4kfzxUi6SHeaf98tf
         Q3i34cAxIEWOg==
Date:   Wed, 19 Apr 2023 20:04:34 +0100
From:   Conor Dooley <conor@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/129] 6.1.25-rc3 review
Message-ID: <20230419-coagulant-impotent-fd5286eb0c4c@spud>
References: <20230419132048.193275637@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fmBKVWwP5N1qNapY"
Content-Disposition: inline
In-Reply-To: <20230419132048.193275637@linuxfoundation.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--fmBKVWwP5N1qNapY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 19, 2023 at 03:21:54PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.25 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Fri, 21 Apr 2023 13:20:20 +0000.
> Anything received after that time might be too late.

Ditto here, thanks for sorting it out.

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--fmBKVWwP5N1qNapY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZEA7QgAKCRB4tDGHoIJi
0pvjAP4vGrv6Adseo742np0eYKtyCUX3t8ta0FOVFJCcJgO6ewD/cQFZT8GiOGEd
dZAkzHx4ouh1oXVGGnsw/Z7Y+o1L3Q0=
=cqux
-----END PGP SIGNATURE-----

--fmBKVWwP5N1qNapY--
