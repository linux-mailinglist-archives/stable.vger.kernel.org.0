Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39E434CCF99
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 09:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbiCDIF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 03:05:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233520AbiCDIFm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 03:05:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20826158DA1;
        Fri,  4 Mar 2022 00:04:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 860F560A52;
        Fri,  4 Mar 2022 08:04:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28DFBC340E9;
        Fri,  4 Mar 2022 08:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646381093;
        bh=Tgs03jOO+tOMUPi4cSw7bkrOng84ePRbUUCWr093Xso=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G/a9fYk7Sz8kRE1rBq+1OlGNk3DjOENsuu/a7IGyMAAwTaUIZ5e1zUQF9boXkZSUA
         zJicuz5qfLidVnYM4LOTPqo5YGRrjOJI8jz2snHQLr8JCVSgOQrtT2HumtDwsIjPFk
         JnJtbewltNbbez95C5WiKKlFG5h7/oWgjHwyFq1uN5hl58rIN0psdUI99P76JLEJ0l
         XzWxLHGjvS2qosAGcAg/OYJkdH6RthnVyjJfq0njwJPNWbSALBQn99XHAJbqZu1/JR
         d/dxGdsV6S6S6CyjkKLC+xKBkFNPPrJi7yRtvS9jNjGQnHGA2v92J7/CPgMbrxD5Dj
         906CIa0v5yEEg==
Date:   Fri, 4 Mar 2022 09:04:50 +0100
From:   Wolfram Sang <wsa@kernel.org>
To:     Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc:     Michael Walle <michael@walle.cc>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] i2c: at91: use dma safe buffers
Message-ID: <YiHIIjSs03gDJmHV@shikoro>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        Michael Walle <michael@walle.cc>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sumit Semwal <sumit.semwal@linaro.org>, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, stable@vger.kernel.org
References: <20220303161724.3324948-1-michael@walle.cc>
 <fff424e7-247c-38d8-4151-8b0503a16a7d@amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="q4xj+Sj+I6MT188+"
Content-Disposition: inline
In-Reply-To: <fff424e7-247c-38d8-4151-8b0503a16a7d@amd.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--q4xj+Sj+I6MT188+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Christian,

> Maybe call your variable differently. DMA-buf is an inter driver buffer
> sharing frame we use for GPU acceleration and V4L.
>=20
> It doesn't cause any technical issues, but the maintainer regex now trigg=
ers
> on that. So you are CCing people not related to this code in any way.

Frankly, I think the 'dma_buf' regex is a bit too generic. 'dma_buf'
seems like a reasonable name to me if some subsystem has to deal with
different buffers which can be DMA or non-DMA, like I2C. If you git-grep
the tree, you will find it in quite some places.

We could now think of renaming the variable to 'dmabuf' but this is
a strange and kind of arbitrary rule to remember IMO.

I wonder if you'd miss a lot of patches if we remove 'dma_buf' from the
regex and keep 'dma_fence' and 'dma_resv'? Or extend it to 'dma_buf_' or
'struct dma_buf'?

All the best,

   Wolfram


--q4xj+Sj+I6MT188+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmIhyB4ACgkQFA3kzBSg
KbZqdRAAk+1zEkJ+HS3V9yeKstHw9UOXqDrYgWXd3rMh8oZLB3UzVrnqkpzd7Orz
wlpxLWSd7RGuCNYxCAYvB3NfH4tVG/PSDcZcGTENYiEnRYuCXh03Nz0GNkUEdwVQ
LM//a5UketKvg/saVj3LduoK7KgfjsJcGi0XqpFxFHsKuFOvb9aL7MsP8oY1L2GB
41DcnvbtS9lYrseEAHl3qVKcT+TinRFygpxlgVcoS1r01Sji59q7ew2ul6Wp8KDm
jIFHwlnLAhWGAJXAvBr3GV0jHGmMxu6Z0jnYwypr1xQX3OCndb92qqmWA0qeCjkB
ligfcv7lcJ+gUBFZghoULph6GSpGEgSC81kxBpcaGPWKBA/Lb8N46sCM1e2XVfGg
fY8xt7yR45gC2jYAQQRhlzjBSlmmws5PE147DwLzr1rYsGv8vKRYBfdmRD16WZz8
MkV+GdqE71UZSS4ja62vld6WiyPVBWb6ZcYeBZEuVdLiFCVbPj5ZWBf/idMar7Up
+iyXvzNPFVUMFIsiEwU3SER5RQGUAHF9l573OY1GdUMAhO2qcy90BB4MOq2f3ayi
hhW1k9yWqbij7GjVlKsXMUmHilxJZhGD6DCbumQztP6EHYEO+M4HRa7WEuGh5Q+s
ZlOgSXwkubk7bLCa0qXxAv1SIwDj07ew/kbYxiMI7ieDDFdqVVY=
=g1ks
-----END PGP SIGNATURE-----

--q4xj+Sj+I6MT188+--
