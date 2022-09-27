Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0D85EB90D
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 06:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiI0EAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 00:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbiI0EAl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 00:00:41 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81304491F4;
        Mon, 26 Sep 2022 21:00:36 -0700 (PDT)
X-UUID: d7636c1e3c094e3badf6b572f4aecd08-20220927
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:CC:To:Subject:MIME-Version:Date:Message-ID; bh=3ahXguKncQoP96BTrWTBp8+5vM5nwnwdJveXeSEIm9c=;
        b=VPNODF5t4Ad3dBeM+YXSyMLxzcetbcDKcVFmO0VOS12C3TYRZkv2E3pLPWAmzA9szzy4D34N+ui5XM76adrYztg0qYPswsOjXd8rUYAx7ADFZa5OpZdCsVwqhLdwt37XH0jTmgz7UVqHRgulw4ezYb0yoLedmQ40O/szqTuk43w=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.11,REQID:762235ad-4de9-4145-9256-d3458c5415da,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:45,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:45
X-CID-INFO: VERSION:1.1.11,REQID:762235ad-4de9-4145-9256-d3458c5415da,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:45,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
        elease,TS:45
X-CID-META: VersionHash:39a5ff1,CLOUDID:813654e4-87f9-4bb0-97b6-34957dc0fbbe,B
        ulkID:220926150559TV5JQC0T,BulkQuantity:69,Recheck:0,SF:28|17|19|48|823|82
        4,TC:nil,Content:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:40,QS:nil,BEC:nil,COL
        :0
X-UUID: d7636c1e3c094e3badf6b572f4aecd08-20220927
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 113336129; Tue, 27 Sep 2022 12:00:30 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Tue, 27 Sep 2022 12:00:29 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 27 Sep 2022 12:00:29 +0800
Message-ID: <664f3b7d-d629-5af1-cae4-cb5b638a5da1@mediatek.com>
Date:   Tue, 27 Sep 2022 12:00:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] arm64: dts: mediatek: mt8195-demo: fix the memory size of
 node secmon
Content-Language: en-US
To:     Miles Chen <miles.chen@mediatek.com>
CC:     <bear.wang@mediatek.com>, <devicetree@vger.kernel.org>,
        <fparent@baylibre.com>, <krzysztof.kozlowski+dt@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <macpaul@gmail.com>, <matthias.bgg@gmail.com>,
        <pablo.sun@mediatek.com>, <robh+dt@kernel.org>,
        <stable@vger.kernel.org>
References: <20220922091648.2821-1-macpaul.lin@mediatek.com>
 <20220926070544.13257-1-miles.chen@mediatek.com>
From:   Macpaul Lin <macpaul.lin@mediatek.com>
In-Reply-To: <20220926070544.13257-1-miles.chen@mediatek.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,URIBL_CSS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/26/22 15:05, Miles Chen wrote:
> Hi Macpaul,
> 
>> The size of device tree node secmon (bl31_secmon_reserved) was
>> incorrect. It should be increased to 2MiB (0x200000).
> 
> 192K should work when the patch(6147314aeedc) was accepted.
> Does the trusted-firmware-a get larger now, so we need to
> increase the size to 2MiB?
> 
> thanks,
> Miles

When mt8195-demo.dts sent to the upstream, at that time the size of
BL31 was small. Because supported functions and modules in BL31 are 
basic sets when the board was under early development stage.

Now BL31 includes more firmwares of coprocessors and maturer functions
so the size has grown bigger in real applications. According to the 
value reported by customers, we think reserved 2MiB for BL31 might be 
enough for maybe the following 2 or 3 years.

>>
>> The origin setting will cause some abnormal behavior due to
>> trusted-firmware-a and related firmware didn't load correctly.
>> The incorrect behavior may vary because of different software stacks.
>> For example, it will cause build error in some Yocto project because
>> it will check if there was enough memory to load trusted-firmware-a
>> to the reserved memory.
>>
>> Cc: stable@vger.kernel.org      # v5.19
>> Fixes: 6147314aeedc ("arm64: dts: mediatek: Add device-tree for MT8195 Demo board")
>> Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>

Thanks
Macpaul Lin
