Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F22BB643105
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbiLETHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:07:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbiLETHg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:07:36 -0500
Received: from smtp-out-03.comm2000.it (smtp-out-03.comm2000.it [212.97.32.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2000427F;
        Mon,  5 Dec 2022 11:07:33 -0800 (PST)
Received: from francesco-nb.int.toradex.com (unknown [213.55.243.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: francesco@dolcini.it)
        by smtp-out-03.comm2000.it (Postfix) with ESMTPSA id 43E18B474AA;
        Mon,  5 Dec 2022 20:07:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailserver.it;
        s=mailsrv; t=1670267252;
        bh=2PZUfJSYd8pUEKuEGRJQTqBQHftyQpzKMAjMYXWyBWg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=z99rN3uXoOuGkbIA01MARMuQWaogCP7WHvnxIiAcmdKCnlE9dE02ZMl/xs13R+9Yh
         TEgc3QR+O15gGaIUAwK0DigCJnO3AuGwKDmk35O8yLjJ1jtzXlUD1CAnUZlVGPMkQj
         KSOz0WkKVoVtxcLZ5xzVhssN0t/3S3uQbX2x0QMwhLYmAx6xw5h2FMxvjGdXN46jmN
         ynE12mXtO4Cz0Cpuzj1O0bBEBL4QmgSIgQu7zWwXkYFzLDFv8zmuqeXoxvKxh+HuyV
         6CGmC7k6GZTdMgeTgWuFmhOgoayVKZ+QpcSwzdyuMO1SlmbpdqYULl2XIfiGnq5IDc
         N8UdzevdkWwAg==
Date:   Mon, 5 Dec 2022 20:07:18 +0100
From:   Francesco Dolcini <francesco@dolcini.it>
To:     Marek Vasut <marex@denx.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Francesco Dolcini <francesco@dolcini.it>,
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
Message-ID: <Y45BZs7dZokgz83I@francesco-nb.int.toradex.com>
References: <20221205152327.26881-1-francesco@dolcini.it>
 <0aa2d48b-35a0-1781-f265-0387d213bdd6@denx.de>
 <20221205185859.433d6cbf@xps-13>
 <f69746b0-51c0-041c-4035-679c27fcba64@denx.de>
 <20221205191828.3072d872@xps-13>
 <29260d63-3240-6660-b002-cd00dc051574@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29260d63-3240-6660-b002-cd00dc051574@denx.de>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 05, 2022 at 07:52:08PM +0100, Marek Vasut wrote:
> On 12/5/22 19:18, Miquel Raynal wrote:
> > marex@denx.de wrote on Mon, 5 Dec 2022 19:07:14 +0100:
> > > On 12/5/22 18:58, Miquel Raynal wrote:
> > > > , it's not
> > > > complex to do, there are plenty of examples. This would be IMHO a
> > > > better step ahead rather than just a cell change. Anyway, I don't mind
> > > > reverting this once we've sorted this mess out and fixed U-Boot.
> > > 
> > > Won't we still have issues with older bootloader versions which
> > > paste partitions directly into this &gpmi {} node, and which needs
> > > to be fixed up in the parser in the end ?
> > 
> > I believe fdt_fixup_mtdparts() should be killed, so we should no longer
> > have this problem.
> 
> The fdt_fixup_mtdparts is U-Boot code. If contemporary Linux kernel is
> booted with ancient U-Boot, then you would still get defective DT passed to
> Linux, and that should be fixed up by Linux. Removing fdt_fixup_mtdparts()
> from current mainline U-Boot won't solve this problem.
> 
> I think this is also what Francesco is trying to convey (please correct me
> if I'm wrong).

Yes, exactly, thanks!

Francesco

