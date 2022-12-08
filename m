Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8FE64743A
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 17:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbiLHQ1Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 11:27:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbiLHQ1O (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 11:27:14 -0500
Received: from smtp-out-06.comm2000.it (smtp-out-06.comm2000.it [212.97.32.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606226FF33;
        Thu,  8 Dec 2022 08:27:06 -0800 (PST)
Received: from francesco-nb.int.toradex.com (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: francesco@dolcini.it)
        by smtp-out-06.comm2000.it (Postfix) with ESMTPSA id 863E9563354;
        Thu,  8 Dec 2022 17:26:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailserver.it;
        s=mailsrv; t=1670516824;
        bh=rdeoMNE1kwBUdyuSy1B7RJ6YEuK71LUPeP7eu0W/ywQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=XwxvG3+3OBpe8DbDc2YoCP8YuoV1THJlsiPBxrPbasWx+zTatEn/fgU7YqHwCINO9
         Hl7VDpjB+EMnwXinVq5bVpmYDvQgPH1XdpCBs7tZSJ2N/khCXAL3DuxGm7uSzziSkc
         aAcFWNVCFhFj5qaN850+bzX7dZGnJReYDgBYD+p/1YQe8uMBFNmcb5IMhanDgRfOlh
         iTAjKn0nXSENfuliYm8h4WcVdXgMoiMr7WOyIuH1PIc2k/z/20UCh9YSkmPIAqj+aW
         2bHciZbeL5jJ3sYGiqF5vdPLSUEzfTQqrgnaJuPbBFFGbDxTWHjzDWFA3s4IuQIRf+
         KMZxtaJQA4mJw==
Date:   Thu, 8 Dec 2022 17:26:47 +0100
From:   Francesco Dolcini <francesco@dolcini.it>
To:     Marek Vasut <marex@denx.de>
Cc:     Francesco Dolcini <francesco@dolcini.it>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
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
        stable@vger.kernel.org,
        Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: [PATCH v1] Revert "ARM: dts: imx7: Fix NAND controller
 size-cells"
Message-ID: <Y5IQRzXBJignWMaK@francesco-nb.int.toradex.com>
References: <20221205152327.26881-1-francesco@dolcini.it>
 <0aa2d48b-35a0-1781-f265-0387d213bdd6@denx.de>
 <20221208115124.6cc7a8bf@xps-13>
 <2a6c5a08-1649-3f80-cc37-a425f09f3a67@denx.de>
 <544539BE-F7C2-4484-9588-6428EFA8A537@dolcini.it>
 <108503ba-f4a8-a9de-20ee-f8f1f90965a2@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <108503ba-f4a8-a9de-20ee-f8f1f90965a2@denx.de>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 08, 2022 at 02:54:43PM +0100, Marek Vasut wrote:
> On 12/8/22 14:49, Francesco Dolcini wrote:
> > Given that I would do the revert as an immediate first step.
> 
> Then that's fine, let's do it.
> 
> Will you also follow up on the parser fix please ?

Yep, I'll try to squeeze some time to work on it in the next weeks.

Francesco

