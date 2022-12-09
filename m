Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3E836482CB
	for <lists+stable@lfdr.de>; Fri,  9 Dec 2022 14:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbiLINat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Dec 2022 08:30:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiLINat (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Dec 2022 08:30:49 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F851789F;
        Fri,  9 Dec 2022 05:30:47 -0800 (PST)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1p3dSY-0004xm-Q5; Fri, 09 Dec 2022 14:30:38 +0100
Message-ID: <bb4e185a-c4db-428b-a1ee-ee1ba767fffb@leemhuis.info>
Date:   Fri, 9 Dec 2022 14:30:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v1] Revert "ARM: dts: imx7: Fix NAND controller
 size-cells"
Content-Language: en-US, de-DE
To:     Arnd Bergmann <arnd@arndb.de>
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
        stable@vger.kernel.org, Francesco Dolcini <francesco@dolcini.it>,
        Miquel Raynal <miquel.raynal@bootlin.com>
References: <20221205152327.26881-1-francesco@dolcini.it>
 <0aa2d48b-35a0-1781-f265-0387d213bdd6@denx.de>
 <20221208115124.6cc7a8bf@xps-13>
 <Y5ITkZtKWHzWaLS4@francesco-nb.int.toradex.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <Y5ITkZtKWHzWaLS4@francesco-nb.int.toradex.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1670592648;8c9799b5;
X-HE-SMSGID: 1p3dSY-0004xm-Q5
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08.12.22 17:40, Francesco Dolcini wrote:
> + Arnd

Arnd, have you seen this? We haven't heard anything from Shawn afaics,
who normally would take care of a patch like this. Hence could you
consider picking up the patch at the start of this thread (e.g.
https://lore.kernel.org/all/20221205152327.26881-1-francesco@dolcini.it/
) and send it to Linus in the next 48 hours? It seems low-risk and fixes
a regression introduced this cycle various people care about. That's why
I'll likely ask Linus to consider picking this up directly before
releasing 6.1, if I don't hear anything from you soon. But I'd prefer if
the patch would go through at least somewhat the proper channels;
alternatively a ACK from you to signal Linus "yeah, pick this up" would
help as well.

Ciao, Thorsten


> On Thu, Dec 08, 2022 at 11:51:24AM +0100, Miquel Raynal wrote:
>> marex@denx.de wrote on Mon, 5 Dec 2022 17:26:53 +0100:
>>> On 12/5/22 16:23, Francesco Dolcini wrote:
>>>> From: Francesco Dolcini <francesco.dolcini@toradex.com>
>>>>
>>>> This reverts commit 753395ea1e45c724150070b5785900b6a44bd5fb.
>>>>
>>>> It introduced a boot regression on colibri-imx7, and potentially any
>>>> other i.MX7 boards with MTD partition list generated into the fdt by
>>>> U-Boot.
>>>>
>>>> While the commit we are reverting here is not obviously wrong, it fixes
>>>> only a dt binding checker warning that is non-functional, while it
>>>> introduces a boot regression and there is no obvious fix ready.
>>>>
>>>> Cc: stable@vger.kernel.org
>>>> Fixes: 753395ea1e45 ("ARM: dts: imx7: Fix NAND controller size-cells")
>>>> Link: https://lore.kernel.org/all/Y4dgBTGNWpM6SQXI@francesco-nb.int.toradex.com/
>>>> Link: https://lore.kernel.org/all/20221205144917.6514168a@xps-13/
>>>> Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
>> [...]
>>> Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
>> [...]
>>> Acked-by: Marek Vasut <marex@denx.de>
>> [...]
>>
>> As discussed in the above links, boot is broken on imx7 Colibri boards,
>> this revert was the most quick and straightforward fix we agreed upon
>> with the hope (~ duty?) it would make it in v6.1. Any chance you could
>> pick this up rapidly and forward it to Linus? Or should we involve
>> him directly (Thorsten?).
> 
> Hello Arnd,
> FYI - see Miquel explanation above.
> 
> Francesco
> 
