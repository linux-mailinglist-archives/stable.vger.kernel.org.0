Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D032609A63
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 08:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiJXGSQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 02:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiJXGSO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 02:18:14 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF58E1B;
        Sun, 23 Oct 2022 23:18:12 -0700 (PDT)
X-UUID: 451950a68d834db0b95e77b74606e3f3-20221024
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:CC:To:Subject:MIME-Version:Date:Message-ID; bh=4d4OABhk3db1wBMRWNegWhxHRdnBMljaS9nufvBF9VM=;
        b=oTaOsrBZLxm3vaSkx/d71Z7fXU1K+yUYzjSVK/NadMfTBn15QTr0ycWC6Ozdsx7nbFGCQ6Rph3qcoPIECE9AW+YWO13ohbebXb5mXYc9TZ2+Re1yfU9DU1sVqPfu2N+DiYKqvim9ex1EfB2k1duWmJ4T42LIiv9R+L3w5l9/xHE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.12,REQID:3b92bf8f-6a31-4200-9dd7-623b427c7342,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:62cd327,CLOUDID:17d877c8-03ab-4171-989e-341ab5339257,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: 451950a68d834db0b95e77b74606e3f3-20221024
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 19267619; Mon, 24 Oct 2022 14:18:08 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Mon, 24 Oct 2022 14:18:06 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkmbs13n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.15 via Frontend
 Transport; Mon, 24 Oct 2022 14:18:06 +0800
Message-ID: <da9f8b90-e4d1-5893-f656-1bb0221ea7f7@mediatek.com>
Date:   Mon, 24 Oct 2022 14:18:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v2] arm64: dts: mediatek: mt8195-demo: fix the memory size
 of node secmon
Content-Language: en-US
To:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Fabien Parent <fparent@baylibre.com>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     Miles Chen <miles.chen@mediatek.com>,
        Bear Wang <bear.wang@mediatek.com>,
        Pablo Sun <pablo.sun@mediatek.com>,
        Macpaul Lin <macpaul@gmail.com>, <linux-usb@vger.kernel.org>,
        <stable@vger.kernel.org>, Matthias Brugger <mbrugger@suse.com>
References: <20220922091648.2821-1-macpaul.lin@mediatek.com>
 <20220929084714.15143-1-macpaul.lin@mediatek.com>
From:   Macpaul Lin <macpaul.lin@mediatek.com>
In-Reply-To: <20220929084714.15143-1-macpaul.lin@mediatek.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/29/22 16:47, Macpaul Lin wrote:
> The size of device tree node secmon (bl31_secmon_reserved) was
> incorrect. It should be increased to 2MiB (0x200000).
> 
> The origin setting will cause some abnormal behavior due to
> trusted-firmware-a and related firmware didn't load correctly.
> The incorrect behavior may vary because of different software stacks.
> For example, it will cause build error in some Yocto project because
> it will check if there was enough memory to load trusted-firmware-a
> to the reserved memory.
> 
> When mt8195-demo.dts sent to the upstream, at that time the size of
> BL31 was small. Because supported functions and modules in BL31 are
> basic sets when the board was under early development stage.
> 
> Now BL31 includes more firmwares of coprocessors and maturer functions
> so the size has grown bigger in real applications. According to the value
> reported by customers, we think reserved 2MiB for BL31 might be enough
> for maybe the following 2 or 3 years.

Dear Matthias, sorry for a gentle reminder. MediaTek hope this simple 
fix could be applied to 6.1-rc and be picked-up to current stable tree 
after v5.19. Thanks a lot.

> Cc: stable@vger.kernel.org      # v5.19
> Fixes: 6147314aeedc ("arm64: dts: mediatek: Add device-tree for MT8195 Demo board")
> Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
> Reviewed-by: Miles Chen <miles.chen@mediatek.com>
> ---
> Changes for v2
>   - Add more information about the size difference for BL31 in commit message.
>     Thanks for Miles's review.
> 
>   arch/arm64/boot/dts/mediatek/mt8195-demo.dts | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/mediatek/mt8195-demo.dts b/arch/arm64/boot/dts/mediatek/mt8195-demo.dts
> index 4fbd99eb496a..dec85d254838 100644
> --- a/arch/arm64/boot/dts/mediatek/mt8195-demo.dts
> +++ b/arch/arm64/boot/dts/mediatek/mt8195-demo.dts
> @@ -56,10 +56,10 @@
>   		#size-cells = <2>;
>   		ranges;
>   
> -		/* 192 KiB reserved for ARM Trusted Firmware (BL31) */
> +		/* 2 MiB reserved for ARM Trusted Firmware (BL31) */
>   		bl31_secmon_reserved: secmon@54600000 {
>   			no-map;
> -			reg = <0 0x54600000 0x0 0x30000>;
> +			reg = <0 0x54600000 0x0 0x200000>;
>   		};
>   
>   		/* 12 MiB reserved for OP-TEE (BL32)

Regards,
Macpaul Lin
