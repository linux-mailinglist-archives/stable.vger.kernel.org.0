Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47571644C27
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 20:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiLFTCx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 14:02:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiLFTCx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 14:02:53 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E713F4F;
        Tue,  6 Dec 2022 11:02:49 -0800 (PST)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id D58DE84494;
        Tue,  6 Dec 2022 20:02:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1670353366;
        bh=qFsFrDF4S9vHBWurtsKa8StwT7cxQ0FXPVtnqJMfQ+Y=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Td/VLngOI6zCjCelD905cqKnH91oxZHaR35osfLQfJhIQC/xGNXqcu6I5IgG6yWXW
         Y1RttbSfg3sPH1dnOw7ey4nt1FrSKoCeEn9uj/yNqO1XMZwoXWoc72khQmIrqBFc7s
         XmBp6meJWb5r/67by1/B4YJJm7NLw2hFfSHQxl2cD9Mo98Dc/dFDYwDCaaFvtiUDPL
         GC+hZcNbmLMGipgInK90f664UCGDedHkcg9n39CPNT2l1wm2yFfa4hFBPFBY4AzCE6
         3SXsctkOaGgkuVWQ0X0f7vQTQJrEQtDvaPQiI2rl012f13pYnEaS+SmHoQcQ/owk3f
         k/CzrZpwZeMfQ==
Message-ID: <738f260d-225b-7ecf-20b2-a7541c368d36@denx.de>
Date:   Tue, 6 Dec 2022 20:02:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v1] Revert "ARM: dts: imx7: Fix NAND controller
 size-cells"
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Francesco Dolcini <francesco@dolcini.it>
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
        stable@vger.kernel.org
References: <20221205152327.26881-1-francesco@dolcini.it>
 <0aa2d48b-35a0-1781-f265-0387d213bdd6@denx.de>
 <20221205185859.433d6cbf@xps-13>
 <f69746b0-51c0-041c-4035-679c27fcba64@denx.de>
 <20221205191828.3072d872@xps-13>
 <29260d63-3240-6660-b002-cd00dc051574@denx.de>
 <Y45BZs7dZokgz83I@francesco-nb.int.toradex.com>
 <20221206111643.1af08a9b@xps-13>
From:   Marek Vasut <marex@denx.de>
In-Reply-To: <20221206111643.1af08a9b@xps-13>
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

On 12/6/22 11:16, Miquel Raynal wrote:
> Hi Francesco,

Hello everyone,

> francesco@dolcini.it wrote on Mon, 5 Dec 2022 20:07:18 +0100:
> 
>> On Mon, Dec 05, 2022 at 07:52:08PM +0100, Marek Vasut wrote:
>>> On 12/5/22 19:18, Miquel Raynal wrote:
>>>> marex@denx.de wrote on Mon, 5 Dec 2022 19:07:14 +0100:
>>>>> On 12/5/22 18:58, Miquel Raynal wrote:
>>>>>> , it's not
>>>>>> complex to do, there are plenty of examples. This would be IMHO a
>>>>>> better step ahead rather than just a cell change. Anyway, I don't mind
>>>>>> reverting this once we've sorted this mess out and fixed U-Boot.
>>>>>
>>>>> Won't we still have issues with older bootloader versions which
>>>>> paste partitions directly into this &gpmi {} node, and which needs
>>>>> to be fixed up in the parser in the end ?
>>>>
>>>> I believe fdt_fixup_mtdparts() should be killed, so we should no longer
>>>> have this problem.
>>>
>>> The fdt_fixup_mtdparts is U-Boot code. If contemporary Linux kernel is
>>> booted with ancient U-Boot, then you would still get defective DT passed to
>>> Linux, and that should be fixed up by Linux. Removing fdt_fixup_mtdparts()
>>> from current mainline U-Boot won't solve this problem.
>>>
>>> I think this is also what Francesco is trying to convey (please correct me
>>> if I'm wrong).
> 
> If we can get rid of fdt_fixup_mtdparts(), it means someone has to
> create the partitions. I guess the easy way would be to just provide
> mtdparts to Linux like all the other boards and let Linux deal with it.

This is based on an assumption that the platform kernel command line can 
be updated to insert such a workaround. If Francesco cannot update the 
bootloader, the kernel command line may be immutable all the same.

> Then we can just assume in Linux that perhaps if the partitions are
> invalid (#size-cell is wrong?) then we should just stop their creation
> and fallback to another mechanism instead of failing entirely. This way
> no need for hackish changes in the parsers and compatibility is still
> valid with old U-Boot (if mtdparts was provided on the cmdline, to be
> checked). Otherwise we'll have to deal with it in Linux, that's a pity.

I am very much banking toward -- fix it up in the parser, just like any 
other firmware issue. Esp. since the fix up is printing a warning, and 
it is like a 2-liner patch.
