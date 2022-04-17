Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80EF35049AD
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 00:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235122AbiDQWQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Apr 2022 18:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232635AbiDQWQg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Apr 2022 18:16:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30EF1657D
        for <stable@vger.kernel.org>; Sun, 17 Apr 2022 15:14:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A5F260E87
        for <stable@vger.kernel.org>; Sun, 17 Apr 2022 22:13:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43ABC385A4;
        Sun, 17 Apr 2022 22:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650233639;
        bh=CL9P8E1czNOLjhNYGYts87EVDD6bi01Y7lDJ370Y1to=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dZXixh9ZaASnzGiLssCTBogpNXYpZl0hekS2DVpzMauN1Qewu17Ef/u9x5giKsrid
         nXiDO7W20E3Z6XSx7In8Ei1jL6Jn9HulvKvdC8gsHkBGZGmPOwCxY/Lo2E+OkJ7oUm
         /gfk6AIV4hJWH7u4a3sPP1Ll+SZJeqsNNk3NnsHiCA3/QCYOonIYOYb5SvcHps2Pd2
         vVGbYqMItFyy2TumwcGio+ZZ1aOlUTPN8ppUigPbCgk6GftX15d15LMLy+f8kO1iIL
         ZPextmajTYj7D+WBS8j8ci1ciOAJgGUP+m5qe0Ug4fMkFvaM1VdJMsTCKjsodmJdSt
         M7nVj+ijtPMrw==
Date:   Sun, 17 Apr 2022 23:13:54 +0100
From:   Mark Brown <broonie@kernel.org>
To:     kernelci-results@groups.io, bot@kernelci.org
Cc:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org
Subject: Re: stable-rc/linux-5.17.y baseline: 145 runs, 2 regressions
 (v5.17.3)
Message-ID: <YlyRIgMxGt1g1JCA@sirena.org.uk>
References: <625c801f.1c69fb81.b3d2e.9577@mx.google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="THQbIqKhcGXOCG14"
Content-Disposition: inline
In-Reply-To: <625c801f.1c69fb81.b3d2e.9577@mx.google.com>
X-Cookie: Stay on the trail.
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--THQbIqKhcGXOCG14
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 17, 2022 at 02:01:19PM -0700, KernelCI bot wrote:

> at91sam9g20ek | arm  | lab-broonie | gcc-10   | at91_dt_defconfig  | 1   =
      =20
> at91sam9g20ek | arm  | lab-broonie | gcc-10   | multi_v5_defconfig | 1   =
      =20
These appear to be spurious due to what looks like multiple things
outputting to the serial console causing the test automation to miss a
message.

--THQbIqKhcGXOCG14
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmJckSEACgkQJNaLcl1U
h9DPeAf/X+ogTEwST7cWit2lvNSXaU8JVb7lqsvMhqD5U8bI5vQMsDhHT+2rmAA5
/lqFAIrFgOdJ0XOZkqqd5w8Nohsd2RhqAK2svm5nn3qNb3vB9E/k8c4XEw8Yk/qF
5fOBNfkRjKL/teq2R3Yvs0hhqpgsp8bmzu5KYud5r9+SfFWK2C3nXHQTx1p912Fx
BwxI9gSe4wAMamCIdH3nEr5yO1ukGlUInO5IwWnJaOsjnptdOteqlhnBI1hpppDa
pwKM3aiD22A/O8BPXA0f+ju2GhYJ2PphHp67e9cVEmDr8U61cz87AoPQHD0pvMdI
TVhW80AeICcqqhqcW+BbE639fm8RjA==
=3tig
-----END PGP SIGNATURE-----

--THQbIqKhcGXOCG14--
