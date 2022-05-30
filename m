Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2339E5384A4
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 17:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240560AbiE3PSr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 11:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238438AbiE3PSf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 11:18:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FDC2EBAA8;
        Mon, 30 May 2022 07:20:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 270A0B80DA7;
        Mon, 30 May 2022 14:20:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538F4C3411C;
        Mon, 30 May 2022 14:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653920406;
        bh=mqoAqsjBcDXcw9PiUEES97ufmThPSY4MfFp/E6LjfcY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pG1EQ9MYt1rwtjTf6xMu41KnNZKqIkFxQChFq7ffaXaZSxj2Qy4KjwdM3/0azsH8C
         5cSu0LrHFOda0VvlO6vv/UzUt4TnrvkSAaa8scZp6jwaM9tVxbD5s2Mgc4QydRcmYr
         /u0jdjfDejga2mqShdrkBcdfwEwxbKqos+vfGXDpc0AG6Kbah8q30TNIX0kpd/RwI1
         SYSenxoK2qgjboLkqtjGFJtwmESG73dV9r0zLJMJo/jLpz1CGDor9AzOwwzj+u70y8
         w1BoGzV+uTOzxLbZ43OlBqK+KQvXbpGEHrt80cViQBJUqQor1Hcen7GlwHHEGNICjW
         UxzfMvA/ZDolA==
Date:   Mon, 30 May 2022 16:20:02 +0200
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        steven.eckhoff.opensource@gmail.com, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: Re: [PATCH AUTOSEL 5.18 089/159] ASoC: tscs454: Add endianness flag
 in snd_soc_component_driver
Message-ID: <YpTSkjYKAZLcOykC@sirena.org.uk>
References: <20220530132425.1929512-1-sashal@kernel.org>
 <20220530132425.1929512-89-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="HrYJqQMmui+RX7XF"
Content-Disposition: inline
In-Reply-To: <20220530132425.1929512-89-sashal@kernel.org>
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


--HrYJqQMmui+RX7XF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 30, 2022 at 09:23:14AM -0400, Sasha Levin wrote:
> From: Charles Keepax <ckeepax@opensource.cirrus.com>
>=20
> [ Upstream commit ff69ec96b87dccb3a29edef8cec5d4fefbbc2055 ]
>=20
> The endianness flag is used on the CODEC side to specify an
> ambivalence to endian, typically because it is lost over the hardware
> link. This device receives audio over an I2S DAI and as such should
> have endianness applied.
>=20
> A fixup is also required to use the width directly rather than relying
> on the format in hw_params, now both little and big endian would be
> supported. It is worth noting this changes the behaviour of S24_LE to
> use a word length of 24 rather than 32. This would appear to be a
> correction since the fact S24_LE is stored as 32 bits should not be
> presented over the bus.

This series of commits doesn't feel like a good idea for stable,
it will probably be safe but it's effectively new feature stuff
so out of scope and there's some possibility we might uncover
some bug which might've been being masked.

--HrYJqQMmui+RX7XF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmKU0pIACgkQJNaLcl1U
h9Ahbgf+LHN76oP+HIfs5W8ozL7j+orPH45zHI+PQPZeiSMVQbPsakBwTf5fOMi4
vDOwGGNz5r3D/OYytHbH7v89EFqwJI0zRpopIiaC9rkUOKBVc6c4/dBfddj0Fhjp
5UOzUjzLP7n4IfYdwFcN/ThC/vAo4B2mn0nm4Syj1VC1Ayavzl/976zR83eVpvBX
rtT1MR1k/j44UMGkRdyNYC/WbkGYGRXuq3wfnlYc6e9tW+YOQrPkk1pvEOZFrQoO
ZyAKV2ANrudifVI2AnvIQ02rviWsL0f89Wjg3MWuF7bjf4gojlW+PwHon4o83JuL
MJpR6ljgbtubclAUhYL9ac5tTzJXMA==
=Kb3f
-----END PGP SIGNATURE-----

--HrYJqQMmui+RX7XF--
