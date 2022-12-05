Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E627F642FB1
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 19:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231828AbiLESQ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 13:16:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231963AbiLESQN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 13:16:13 -0500
Received: from smtp-out-01.comm2000.it (smtp-out-01.comm2000.it [212.97.32.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 893DD20BC5;
        Mon,  5 Dec 2022 10:16:07 -0800 (PST)
Received: from francesco-nb.int.toradex.com (31-10-206-125.static.upc.ch [31.10.206.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: francesco@dolcini.it)
        by smtp-out-01.comm2000.it (Postfix) with ESMTPSA id B475C843CEA;
        Mon,  5 Dec 2022 19:15:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailserver.it;
        s=mailsrv; t=1670264165;
        bh=i2fxvVG/OMTVFtDkYPsQVjpZTCVwhtrudWILsoMensE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=Slx6qj40YwzzbDrVsAY6atWaqvM2owKNtyiaEGzxmv7VjuTv7Ux2jCHugIGNX/L2Y
         5pajr20sSnaYTyLnrxrneiiWpiLE8/6Mz+Y6K2IWW2IzUc4SrnXuZd28v6bLMjs5bs
         byyWPoQqTKxEVuouuWjllj5CKL/nFXIy08ypTlDNEfGT5scozi51wdDsnJx52Ztdfh
         mjLr3bZbOyeyXijH9858SA6F4U+pcqa6THkze74ZBsVSHZXyInB9Jh+2BpkGTjQ16C
         GUDfHB6H7ozCnrlhnccVEKiLMo+IFhqFQG3etCgUjDuKpbued4bF+D4uzvnEsjrUjF
         ZO0bBgVpwgbTg==
Date:   Mon, 5 Dec 2022 19:15:56 +0100
From:   Francesco Dolcini <francesco@dolcini.it>
To:     Marek Vasut <marex@denx.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Francesco Dolcini <francesco@dolcini.it>,
        Shawn Guo <shawnguo@kernel.org>,
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
Message-ID: <Y441XJ/aSAt31HD9@francesco-nb.int.toradex.com>
References: <20221205152327.26881-1-francesco@dolcini.it>
 <0aa2d48b-35a0-1781-f265-0387d213bdd6@denx.de>
 <20221205185859.433d6cbf@xps-13>
 <f69746b0-51c0-041c-4035-679c27fcba64@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f69746b0-51c0-041c-4035-679c27fcba64@denx.de>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 05, 2022 at 07:07:14PM +0100, Marek Vasut wrote:
> On 12/5/22 18:58, Miquel Raynal wrote:
> > marex@denx.de wrote on Mon, 5 Dec 2022 17:26:53 +0100:
> > , it's not
> > complex to do, there are plenty of examples. This would be IMHO a
> > better step ahead rather than just a cell change. Anyway, I don't mind
> > reverting this once we've sorted this mess out and fixed U-Boot.
> 
> Won't we still have issues with older bootloader versions which paste
> partitions directly into this &gpmi {} node, and which needs to be fixed up
> in the parser in the end ?

Yes, I think so. While I do agree on printk warning and deprecated
functions and use more modern and less problematic stuff, this should
not come at the cost of failing the boot on board using some old U-Boot
version.

Francesco

