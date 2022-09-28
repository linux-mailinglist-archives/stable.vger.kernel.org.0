Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01B9E5ED2C0
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 03:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbiI1BsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 21:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiI1BsD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 21:48:03 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07B8110EC9;
        Tue, 27 Sep 2022 18:47:57 -0700 (PDT)
X-UUID: 2798c900a05b4374ac9f07e832846b2e-20220928
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=A+qXPRA7ywTuXXDRS+dWtKCRO57wsD96NnkHKCFHm4w=;
        b=EiKXtB0fDGaYwn+THx+6Mzrwx6ggIQwjZnKD4BXrTg4V+C6GFmPcyqv8WsCxgK40PZ1BHDQ5yXO67jebzMgTq3Jnf8+nWMlbFj5k3ZXgInWeBjC1PBHlYgfcrBsjUYsxVcDWhGjQm2qazVwmOKDliXIqfu/jl4v3I7Youc6eWPY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.11,REQID:98814aa8-e18f-4e2b-bbef-61184b346dae,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:39a5ff1,CLOUDID:c97c4aa3-dc04-435c-b19b-71e131a5fc35,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:-5,EDM:-3,IP:nil,
        URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: 2798c900a05b4374ac9f07e832846b2e-20220928
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <miles.chen@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 362543260; Wed, 28 Sep 2022 09:47:52 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Wed, 28 Sep 2022 09:47:50 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Wed, 28 Sep 2022 09:47:50 +0800
From:   Miles Chen <miles.chen@mediatek.com>
To:     <macpaul.lin@mediatek.com>
CC:     <bear.wang@mediatek.com>, <devicetree@vger.kernel.org>,
        <fparent@baylibre.com>, <krzysztof.kozlowski+dt@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <macpaul@gmail.com>, <matthias.bgg@gmail.com>,
        <miles.chen@mediatek.com>, <pablo.sun@mediatek.com>,
        <robh+dt@kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH] arm64: dts: mediatek: mt8195-demo: fix the memory size of
Date:   Wed, 28 Sep 2022 09:47:50 +0800
Message-ID: <20220928014750.17054-1-miles.chen@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <664f3b7d-d629-5af1-cae4-cb5b638a5da1@mediatek.com>
References: <664f3b7d-d629-5af1-cae4-cb5b638a5da1@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        T_SPF_TEMPERROR,UNPARSEABLE_RELAY,URIBL_CSS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>On 9/26/22 15:05, Miles Chen wrote:
>> Hi Macpaul,
>> 
>>> The size of device tree node secmon (bl31_secmon_reserved) was
>>> incorrect. It should be increased to 2MiB (0x200000).
>> 
>> 192K should work when the patch(6147314aeedc) was accepted.
>> Does the trusted-firmware-a get larger now, so we need to
>> increase the size to 2MiB?
>> 
>> thanks,
>> Miles
>
>When mt8195-demo.dts sent to the upstream, at that time the size of
>BL31 was small. Because supported functions and modules in BL31 are 
>basic sets when the board was under early development stage.
>
>Now BL31 includes more firmwares of coprocessors and maturer functions
>so the size has grown bigger in real applications. According to the 
>value reported by customers, we think reserved 2MiB for BL31 might be 
>enough for maybe the following 2 or 3 years.

Thanks for your explanation,
please add this to the commit message and submit next version.

With that, feel free to add:
Reviewed-by: Miles Chen <miles.chen@mediatek.com> 

thanks,
Miles
