Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 356796485B5
	for <lists+stable@lfdr.de>; Fri,  9 Dec 2022 16:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbiLIPjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Dec 2022 10:39:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbiLIPjD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Dec 2022 10:39:03 -0500
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41671944DE;
        Fri,  9 Dec 2022 07:38:37 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 1B515240007;
        Fri,  9 Dec 2022 15:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1670600315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iEZQ7a3rtGPOj2loD/oWZkyH/UPYQamMD++xVLPyjxU=;
        b=UqeC9/7xfyDro4Vdn/TMvdKer07QL9tkNgkjMEGojQaS4CHRS7505GOMSfwaFbtJxgKiUd
        JMbDh4qigIO/mEhhwVUnJeAQHH7TusS3DZOw0gJ2jruaU92ZBTzQsqzGZJOEB+I85kryjZ
        6vlo9Q4JNO9d7LKbsbbCN80Nhm69NUeHkkhHuuVETBgSZLbc5ukg6DWCzzSpLIQBieYLJ3
        iQ9h6a4fp73rdzz3rTtjc38NQPxenYWtIiT9kAfqY1k2W7eVhdq+WIg5G+ijIV2O9Uj2/9
        DqqNmw/uBHwrUPRPqM30IxG9D57QAmsdzqCOf8/crRtAstsd+gmXY0AGkXbyWg==
Date:   Fri, 9 Dec 2022 16:38:30 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     "Arnd Bergmann" <arnd@arndb.de>
Cc:     "Thorsten Leemhuis" <regressions@leemhuis.info>,
        "Marek Vasut" <marex@denx.de>, "Shawn Guo" <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        "Francesco Dolcini" <francesco.dolcini@toradex.com>,
        "Rob Herring" <robh+dt@kernel.org>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        "Sascha Hauer" <s.hauer@pengutronix.de>,
        "Pengutronix Kernel Team" <kernel@pengutronix.de>,
        "Fabio Estevam" <festevam@gmail.com>,
        "NXP Linux Team" <linux-imx@nxp.com>, devicetree@vger.kernel.org,
        linux-mtd@lists.infradead.org, stable@vger.kernel.org,
        "Francesco Dolcini" <francesco@dolcini.it>
Subject: Re: [PATCH v1] Revert "ARM: dts: imx7: Fix NAND controller
 size-cells"
Message-ID: <20221209163830.4b47ccb5@xps-13>
In-Reply-To: <dbdb4417-a1cf-4613-8f7a-98b524bfdedc@app.fastmail.com>
References: <20221205152327.26881-1-francesco@dolcini.it>
        <0aa2d48b-35a0-1781-f265-0387d213bdd6@denx.de>
        <20221208115124.6cc7a8bf@xps-13>
        <Y5ITkZtKWHzWaLS4@francesco-nb.int.toradex.com>
        <bb4e185a-c4db-428b-a1ee-ee1ba767fffb@leemhuis.info>
        <dbdb4417-a1cf-4613-8f7a-98b524bfdedc@app.fastmail.com>
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

Hi Arnd,

arnd@arndb.de wrote on Fri, 09 Dec 2022 16:25:28 +0100:

> On Fri, Dec 9, 2022, at 14:30, Thorsten Leemhuis wrote:
> > On 08.12.22 17:40, Francesco Dolcini wrote: =20
> >> + Arnd =20
> >
> > Arnd, have you seen this? We haven't heard anything from Shawn afaics,
> > who normally would take care of a patch like this. Hence could you
> > consider picking up the patch at the start of this thread (e.g.
> > https://lore.kernel.org/all/20221205152327.26881-1-francesco@dolcini.it/
> > ) and send it to Linus in the next 48 hours? It seems low-risk and fixes
> > a regression introduced this cycle various people care about. That's why
> > I'll likely ask Linus to consider picking this up directly before
> > releasing 6.1, if I don't hear anything from you soon. But I'd prefer if
> > the patch would go through at least somewhat the proper channels;
> > alternatively a ACK from you to signal Linus "yeah, pick this up" would
> > help as well. =20
>=20
> Done now.
>=20
>    Arnd

Thanks a lot.

Miqu=C3=A8l
