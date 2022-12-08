Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB19E647113
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 14:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbiLHNyr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 08:54:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiLHNyr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 08:54:47 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B7837F89;
        Thu,  8 Dec 2022 05:54:46 -0800 (PST)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 00038817FB;
        Thu,  8 Dec 2022 14:54:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1670507685;
        bh=5xDJlwrd0zqkIN9nBK5C7VNF8PbYTDTfmRcPZ8Vq1Z0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=wU/A1kV8m0n1cx/qEnXp2O4vGbBSDCrYgDizeWdVesl1jCHZUKqUyesyxZZDMB1L7
         6mkXR7pmTmFRA6AouvQz9LePzEnGUh8yGsb3IVE4oagU4IEEwWuOJpRWWMszafM4Qw
         KSFsbgAI/4YFkx4Cnyp0KvlWDE65GF7bDN/joANbTr6pUZjm8hzX8f5hWaGMiqz6wz
         o44cdjhmkfkJJjfLgd94rzhurtM+qUWA2HuiH7S1p5nBGyYO+CMeI9t6vkl02EjrqO
         AbJU0tNVMNo9vFkp/gcfIa8lwq2GN3wKqVGLEtZxWboyCXZC/oTTmF9s8SVTK349zf
         +RXKJQiNb2vsA==
Message-ID: <108503ba-f4a8-a9de-20ee-f8f1f90965a2@denx.de>
Date:   Thu, 8 Dec 2022 14:54:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v1] Revert "ARM: dts: imx7: Fix NAND controller
 size-cells"
Content-Language: en-US
To:     Francesco Dolcini <francesco@dolcini.it>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Shawn Guo <shawnguo@kernel.org>,
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
References: <20221205152327.26881-1-francesco@dolcini.it>
 <0aa2d48b-35a0-1781-f265-0387d213bdd6@denx.de>
 <20221208115124.6cc7a8bf@xps-13>
 <2a6c5a08-1649-3f80-cc37-a425f09f3a67@denx.de>
 <544539BE-F7C2-4484-9588-6428EFA8A537@dolcini.it>
From:   Marek Vasut <marex@denx.de>
In-Reply-To: <544539BE-F7C2-4484-9588-6428EFA8A537@dolcini.it>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/8/22 14:49, Francesco Dolcini wrote:
> Il 8 dicembre 2022 14:21:31 CET, Marek Vasut <marex@denx.de> ha scritto:
>> On 12/8/22 11:51, Miquel Raynal wrote:
>>> Hi Shawn,
>>
>> Hi,
>>
>>> + Thorsten
>>>
>>> marex@denx.de wrote on Mon, 5 Dec 2022 17:26:53 +0100:
>>>
>>>> On 12/5/22 16:23, Francesco Dolcini wrote:
>>>>> From: Francesco Dolcini <francesco.dolcini@toradex.com>
>>>>>
>>>>> This reverts commit 753395ea1e45c724150070b5785900b6a44bd5fb.
>>>>>
>>>>> It introduced a boot regression on colibri-imx7, and potentially any
>>>>> other i.MX7 boards with MTD partition list generated into the fdt by
>>>>> U-Boot.
>>>>>
>>>>> While the commit we are reverting here is not obviously wrong, it fixes
>>>>> only a dt binding checker warning that is non-functional, while it
>>>>> introduces a boot regression and there is no obvious fix ready.
>>>>>
>>>>> Cc: stable@vger.kernel.org
>>>>> Fixes: 753395ea1e45 ("ARM: dts: imx7: Fix NAND controller size-cells")
>>>>> Link: https://lore.kernel.org/all/Y4dgBTGNWpM6SQXI@francesco-nb.int.toradex.com/
>>>>> Link: https://lore.kernel.org/all/20221205144917.6514168a@xps-13/
>>>>> Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
>>> [...]
>>>> Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
>>> [...]
>>>> Acked-by: Marek Vasut <marex@denx.de>
>>> [...]
>>>
>>> As discussed in the above links, boot is broken on imx7 Colibri boards,
>>> this revert was the most quick and straightforward fix we agreed upon
>>> with the hope (~ duty?) it would make it in v6.1. Any chance you could
>>> pick this up rapidly and forward it to Linus? Or should we involve
>>> him directly (Thorsten?).
>>
>> It seems neither Francesco nor me agree that this is the right approach and rather the fix should be the two-liner change to the OF partition parser, so maybe this should not be picked ?
> 
> I think that the 2 lines change might not be good enough to properly handle the U-Boot generated OF partitions in the general case, even if it fixes my specific issue.
> 
> Given that I would do the revert as an immediate first step.

Then that's fine, let's do it.

Will you also follow up on the parser fix please ?
