Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0388D644124
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 11:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232865AbiLFKQw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 05:16:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232568AbiLFKQu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 05:16:50 -0500
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E71DB9B;
        Tue,  6 Dec 2022 02:16:48 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 7DDC140003;
        Tue,  6 Dec 2022 10:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1670321806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ons113hSb6tX+xTERA8DOW/78mOwkkaZ9ZxNswFoU4A=;
        b=Iln7tYOPNg+p89W844U31Y67FURDYoEdysuuQiq0vnbir2dudWkJaF0UHMR+BvYVtGr8Pq
        hz5JPvc0CHX7H6dfdq1XDDJ2hAGzZEjzpyaDCxaNfqppjCO1XUKrd5ez6y5+LDCGHCznhF
        kmvPd4Y/gZLjaXJR0k2wmLmRLt2YG3o2Cm4LauyGUIZ7PoN3XsAnwhQzRRsIzgpRNZ/lo3
        hmBRx5O+2Lv/dGVdkJFTnDPxM0O0ELs6+8q0aAK9VruaEVW63iwILlplJ069gNS2KcOeWC
        rnmQ0i7w2plhVfbLSgp66W/CI9yi8+qBlK0bQ2k6GIjuOPK29E6BlCtlUapPhg==
Date:   Tue, 6 Dec 2022 11:16:43 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Francesco Dolcini <francesco@dolcini.it>
Cc:     Marek Vasut <marex@denx.de>, Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org, linux-mtd@lists.infradead.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v1] Revert "ARM: dts: imx7: Fix NAND controller
 size-cells"
Message-ID: <20221206111643.1af08a9b@xps-13>
In-Reply-To: <Y45BZs7dZokgz83I@francesco-nb.int.toradex.com>
References: <20221205152327.26881-1-francesco@dolcini.it>
        <0aa2d48b-35a0-1781-f265-0387d213bdd6@denx.de>
        <20221205185859.433d6cbf@xps-13>
        <f69746b0-51c0-041c-4035-679c27fcba64@denx.de>
        <20221205191828.3072d872@xps-13>
        <29260d63-3240-6660-b002-cd00dc051574@denx.de>
        <Y45BZs7dZokgz83I@francesco-nb.int.toradex.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Francesco,

francesco@dolcini.it wrote on Mon, 5 Dec 2022 20:07:18 +0100:

> On Mon, Dec 05, 2022 at 07:52:08PM +0100, Marek Vasut wrote:
> > On 12/5/22 19:18, Miquel Raynal wrote: =20
> > > marex@denx.de wrote on Mon, 5 Dec 2022 19:07:14 +0100: =20
> > > > On 12/5/22 18:58, Miquel Raynal wrote: =20
> > > > > , it's not
> > > > > complex to do, there are plenty of examples. This would be IMHO a
> > > > > better step ahead rather than just a cell change. Anyway, I don't=
 mind
> > > > > reverting this once we've sorted this mess out and fixed U-Boot. =
=20
> > > >=20
> > > > Won't we still have issues with older bootloader versions which
> > > > paste partitions directly into this &gpmi {} node, and which needs
> > > > to be fixed up in the parser in the end ? =20
> > >=20
> > > I believe fdt_fixup_mtdparts() should be killed, so we should no long=
er
> > > have this problem. =20
> >=20
> > The fdt_fixup_mtdparts is U-Boot code. If contemporary Linux kernel is
> > booted with ancient U-Boot, then you would still get defective DT passe=
d to
> > Linux, and that should be fixed up by Linux. Removing fdt_fixup_mtdpart=
s()
> > from current mainline U-Boot won't solve this problem.
> >=20
> > I think this is also what Francesco is trying to convey (please correct=
 me
> > if I'm wrong). =20

If we can get rid of fdt_fixup_mtdparts(), it means someone has to
create the partitions. I guess the easy way would be to just provide
mtdparts to Linux like all the other boards and let Linux deal with it.
Then we can just assume in Linux that perhaps if the partitions are
invalid (#size-cell is wrong?) then we should just stop their creation
and fallback to another mechanism instead of failing entirely. This way
no need for hackish changes in the parsers and compatibility is still
valid with old U-Boot (if mtdparts was provided on the cmdline, to be
checked). Otherwise we'll have to deal with it in Linux, that's a pity.

Thanks,
Miqu=C3=A8l
