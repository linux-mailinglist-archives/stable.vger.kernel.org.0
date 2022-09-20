Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44EDF5BE783
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 15:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbiITNsj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 09:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiITNsi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 09:48:38 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CBE956B8C;
        Tue, 20 Sep 2022 06:48:35 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 678AB1C0003; Tue, 20 Sep 2022 15:48:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ucw.cz; s=gen1;
        t=1663681713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LMWgtZekcEigY07GE7Rgrxe8a63TCCCCmIA3rHO/7ts=;
        b=hwATHZQAyROmF5XEgiIGhMzxryLKLMf3wRGld3G+8pxwqvmVyKk26dwh+3Vv0IV1VXU9LB
        1Uxz+kQFxPz29R2t589s4gUqDb14bPrc5jR1hEJkTaN+F5rXGJssTZXj5GtaJw68cCiZgc
        WHNFWcO3HV4j/WTSDG6D+42ti3geA0I=
Date:   Tue, 20 Sep 2022 15:48:32 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Sasha Levin <sashal@kernel.org>, Greg KH <greg@kroah.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>,
        Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>,
        Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.9 01/13] spi: spi-cadence: Fix SPI CS gets
 toggling sporadically
Message-ID: <20220920134832.GA19086@duo.ucw.cz>
References: <20220914090540.471725-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
In-Reply-To: <20220914090540.471725-1-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>
>=20
> [ Upstream commit 21b511ddee09a78909035ec47a6a594349fe3296 ]
>=20
> As part of unprepare_transfer_hardware, SPI controller will be disabled
> which will indirectly deassert the CS line. This will create a problem
> in some of the devices where message will be transferred with
> cs_change flag set(CS should not be deasserted).
> As per SPI controller implementation, if SPI controller is disabled then
> all output enables are inactive and all pins are set to input mode which
> means CS will go to default state high(deassert). This leads to an issue
> when core explicitly ask not to deassert the CS (cs_change =3D 1). This
> patch fix the above issue by checking the Slave select status bits from
> configuration register before disabling the SPI.

My records say this was already submitted to AUTOSEL at "Jun
27". There are more patches from that era that were reviewed in
AUTOSEL but not merged anywhere. Can you investigate?

Best regards,
								Pavel

a 4.9 01/13] spi: spi-cadence: Fix SPI CS gets toggling sporadic
a 4.9 02/13] spi: cadence: Detect transmit FIFO depth
n unused preparation 4.9 03/13] drm/vc4: crtc: Use an union to store the pa=
ge f\
l
a 4.9 04/13] drivers/net/ethernet/neterion/vxge: Fix a use-af
n just a comment fix 4.9 05/13] video: fbdev: skeletonfb: Fix syntax errors=
 in \
c
a just a printk tweak 4.9 06/13] video: fbdev: intelfb: Use aperture size f=
rom \
pc
a 4.9 07/13] video: fbdev: pxa3xx-gcu: Fix integer overflow i
n just a cleanup 4.9 08/13] video: fbdev: simplefb: Check before clk_put() n
a 4.9 09/13] mips: lantiq: falcon: Fix refcount leak bug in s
a 4.9 10/13] mips: lantiq: xway: Fix refcount leak bug in sys
n we still have reference to the name, it is not safe to put it 4.9 11/13] =
mips\
/pic32/pic32mzda: Fix refcount leak bugs
a 4.9 12/13] mips: lantiq: Add missing of_node_put() in irq.c

a 4.19 03/22] ALSA: usb-audio: US16x08: Move overflow check b
n unused preparation 4.19 05/22] drm/vc4: crtc: Move the BO handling out of=
 com\
m
! do we have everything? 4.19 06/22] ALSA: x86: intel_hdmi_audio: enable pm=
_run\
time
! 4.19 07/22] hamradio: 6pack: fix array-index-out-of-bounds
a 4.19 13/22] arch: mips: generic: Add missing of_node_put()
a 4.19 14/22] mips: mti-malta: Fix refcount leak in malta-tim
a 4.19 15/22] mips: ralink: Fix refcount leak in of.c
a 4.19 20/22] drm/sun4i: Add DMA mask and segment size
! 4.19 21/22] drm/amdgpu: Adjust logic around GTT size (v3)

--=20
People of Russia, stop Putin before his war on Ukraine escalates.

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYynEsAAKCRAw5/Bqldv6
8luBAJ9OZ67f7QmMHV8I0fI6mhl5V8eB4ACgiefn0m6xPtyoWiXiT/59AaF1ZJM=
=7rpI
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
