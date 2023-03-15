Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF57C6BBB7C
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 18:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbjCORzZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 13:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231564AbjCORzX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 13:55:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB8D2706;
        Wed, 15 Mar 2023 10:55:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E353B81E9C;
        Wed, 15 Mar 2023 17:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C824BC433D2;
        Wed, 15 Mar 2023 17:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678902917;
        bh=nvkbBnA1mkxbeGAtvPj2WMk3ljn/r3AnYo78Vjywe5E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cZAlb6PbCRHDBke0C6XYDVA0gq5qHbConBcajLSA+s9zjDcCW72UJkDLSJ930P7iV
         11N1VZL1NJoYX6zrPK4fnybw7PkLpS9WbnxflnXka5o/LNkJ8wddI5AeSbBkrnJBpu
         yKuZnoPa17o0vk6Xv8b0U6LfdLJISZVfsVQ41e7IYPtJ4lKSONJUKKCksyuG5A9uC3
         ERR8Cn8tzDqbuCTKvtav25od47kR92jw20aRTbKpgVjbAI0ONrnmx0FWRiN3g2shZ7
         GaUUqp8DTGSKP12w9LW/uIq2ZDcEKPRuSistpXD7AlSTehBd1NiMq35vcfejRYAnhB
         wc2MO7aIhcuTg==
Date:   Wed, 15 Mar 2023 17:55:11 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/143] 6.1.20-rc1 review
Message-ID: <b3619d01-fa8c-4a6b-b253-0a25ceb9a5b9@spud>
References: <20230315115740.429574234@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tkXsLAyeyUPziKqZ"
Content-Disposition: inline
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--tkXsLAyeyUPziKqZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 15, 2023 at 01:11:26PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.20 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Looks grand on RISC-V..

Tested-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--tkXsLAyeyUPziKqZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZBIGfwAKCRB4tDGHoIJi
0lN0AP9BG2ptLIz3K8IkW10PLUW77gmV/Y1aDfrjFFztTWc1nQEAlo9jReR/GhVm
dLNOY4aiRECr0TEiCdDguXSfVClbWAc=
=Jr7k
-----END PGP SIGNATURE-----

--tkXsLAyeyUPziKqZ--
