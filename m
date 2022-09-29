Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E64645EF710
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 16:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235315AbiI2OCA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 10:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235342AbiI2OB7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 10:01:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D2014F804;
        Thu, 29 Sep 2022 07:01:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F43661357;
        Thu, 29 Sep 2022 14:01:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D65C433D6;
        Thu, 29 Sep 2022 14:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664460117;
        bh=NbQBK0K88I2R53On1jgQPc/QM3SMeQ/eMk4dHm80OcQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gmTbcvC1yEmw7F1GRoHapSzLYj+IdmomGJ9jUk7Jl8mdnbYj+Dm3ElgvlF0dA/jWb
         Svrd/TMipM3+QYV7JkG62nFhywTSSJmdSz2fZmVlKMZwHM95FaFw/pARM+5J/b0LKw
         MAGMKL+5ywEvTN4waqtEaf+3qJsNdBAbS5BswiOI/O7l8JizhSmMsRFgo3Le4V0wSt
         0/Uct1OMyKAuIUo31E1sLbPdqyIGvDYKFXfR322owxrU83lW4fGVETV2CBXM0VA/t7
         /7JdEZbyIZyui75PabnkE1VD21g+weqdYESr1JfN1KIpHXpi1CZM/eYyHZGFDQm0zO
         Gp6A25qEFK/kg==
Date:   Thu, 29 Sep 2022 15:01:51 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Banajit Goswami <bgoswami@quicinc.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] ASoC: wcd-mbhc-v2: Revert "ASoC: wcd-mbhc-v2: use
 pm_runtime_resume_and_get()"
Message-ID: <YzWlT11jj0ES0Alv@sirena.org.uk>
References: <20220929131528.217502-1-krzysztof.kozlowski@linaro.org>
 <YzWgescSJMKzYTAo@sirena.org.uk>
 <88035bdd-3aeb-640e-c001-8823013e5929@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Ri3zr+BP8FJRoKsl"
Content-Disposition: inline
In-Reply-To: <88035bdd-3aeb-640e-c001-8823013e5929@linaro.org>
X-Cookie: Last week's pet, this week's special.
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Ri3zr+BP8FJRoKsl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 29, 2022 at 04:00:26PM +0200, Krzysztof Kozlowski wrote:
> On 29/09/2022 15:41, Mark Brown wrote:
> > On Thu, Sep 29, 2022 at 03:15:28PM +0200, Krzysztof Kozlowski wrote:
> >=20
> >> Cc: <stable@vger.kernel.org>
> >> Fixes: ddea4bbf287b ("ASoC: wcd-mbhc-v2: use pm_runtime_resume_and_get=
()")
> >=20
> > That commit isn't in a released kernel.
>=20
> Oh, indeed, thanks. I'll send a v2 without it.

It's fine.

--Ri3zr+BP8FJRoKsl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmM1pU8ACgkQJNaLcl1U
h9CMAAf9Fc6oFeIp3nEEwGKdOHM5vdwkRlxMVNCluVg7AYY64AweWItcTH5zClZA
mBq8cw1B5aHq+4P8XPgXpfIxw32ITy2mHSIp2B71RAc6RU3mf3ZTFQWCf6WACEl5
/CcBVxTBFthM2OGUWLjlut3BI6X0bC3V25KQCll3B285BYnE5hZdD52Eq8RO5/e4
zJ/B7ltFz9EHIIFvtdYbJsz8JQLKlNGgwNQwAovvgT6JdW/P4QlPad8ZQEzA0hNk
tLn0cC650U9ju/qb9nvVBhkdBt+Hfc+moyjp8obA6JJrC29Ce+hRserfZZlQaj+m
UetNBjR8IsIrJhMffTaNUTPiJRJXaQ==
=PNpT
-----END PGP SIGNATURE-----

--Ri3zr+BP8FJRoKsl--
