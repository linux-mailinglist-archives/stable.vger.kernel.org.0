Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB7650B5E9
	for <lists+stable@lfdr.de>; Fri, 22 Apr 2022 13:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446863AbiDVLMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Apr 2022 07:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446834AbiDVLMZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Apr 2022 07:12:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A93B56231
        for <stable@vger.kernel.org>; Fri, 22 Apr 2022 04:09:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D30A8B82C2E
        for <stable@vger.kernel.org>; Fri, 22 Apr 2022 11:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B22C385A4;
        Fri, 22 Apr 2022 11:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650625769;
        bh=oiHWHx8QNbDrocY3AMVWCGs1Lxm4DwtN3oBFt280AZs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rixZNHblteoWaCje1q4aP53hiO0VGPyMYNO51KbQ0eHmNQyfKJ9d14jJ+gXYm6RXQ
         G5cV56xBtMTOsBYA7JT4vcR8tzEgPxkRyOxPfz+SxAVi5P/hus1eoZ2ZXTPshgnGW1
         ZQroPpvzV+JltyCBqntXCvIYDqcoChjwhedNwrALU0mb66ZqvXdYLeeJi79xni7udX
         o/CJNc89wcrFOVoSVHHCSx99d+vuCylKGTXuSDA2VdiX4JBBBWPl7+Qjq4HsM3pxYV
         ATrNxCgEfNrS7biURckaKa9vUdP70gvBI78ote57EBQoV+/dwp5L4r5F/RoRcDvnSr
         fxrf/btH8pn5g==
Date:   Fri, 22 Apr 2022 12:09:24 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Mike Rapoport <rppt@linux.ibm.com>
Cc:     Tony Lindgren <tony@atomide.com>,
        Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernelci-results@groups.io, bot@kernelci.org,
        gtucker@collabora.com, stable@vger.kernel.org
Subject: Re: stable-rc/linux-5.4.y bisection: baseline.login on
 qemu_arm-virt-gicv2-uefi
Message-ID: <YmKM5H3BCmjnFgfj@sirena.org.uk>
References: <625c8753.1c69fb81.b232.69bb@mx.google.com>
 <Yl65zxGgFzF1Okac@sirena.org.uk>
 <Yl/PzFKR6U0bH43T@linux.ibm.com>
 <Yl/3Z+QMCPbDafbC@sirena.org.uk>
 <YmD83PYEMhzqehXo@linux.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="UizkQDv8e8FAaOZI"
Content-Disposition: inline
In-Reply-To: <YmD83PYEMhzqehXo@linux.ibm.com>
X-Cookie: Whoever dies with the most toys wins.
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--UizkQDv8e8FAaOZI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 21, 2022 at 09:42:36AM +0300, Mike Rapoport wrote:

> The problem is that memremap() uses pfn_valid() to check if RAM resource can
> be accessed via linear mapping and this check is wrong.
> The problem does not manifest on more recent kernels because the way ARM
> registers "System RAM" resources was updated so that it skipped NOMAP
> memory.

> Can you please give a whirl to the patch below? If it's Ok I'll extend it
> to include arm64 and will send a formal patch.

Looks to have tested out OK:

https://linux.kernelci.org/test/job/broonie-misc/branch/for-kernelci/kernel/v5.4-18289-g6ebcdf39c03b/plan/baseline/

Tested-by: Mark Brown <broonie@kernel.org>

--UizkQDv8e8FAaOZI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmJijOMACgkQJNaLcl1U
h9CNtggAhVgBrRZyTuV76iHbSTKSNqo+3qejFHrkMc3bMmbhDm2CPSUyoRn+61VX
a/BsZJdgXph/t4BYjyH2I0dzNm64g8NXETVtuj8xGKOUH0yO9Q10CxRFGymL5b9Z
1X3UGCvZSHwl4KWsEiV8qYBezj4Q0EOm4xN5p9pv6hxNpvbdcIUXVOpO8//IyJnb
mdXFUsNfosy6iDbgnBvI6A6TMbkrjV6DISZWvrLhtgEmoRFhBOPi1gAMSHM2/s04
0B1uSQX16VooH/Cmlh3Do5R+81ygjgfgQoMiY1875VWTit0BcD6ytGaKGiKf4fUx
UtFXS2zjT5ocRQUWLc9JxsfghPMI7A==
=PtIG
-----END PGP SIGNATURE-----

--UizkQDv8e8FAaOZI--
