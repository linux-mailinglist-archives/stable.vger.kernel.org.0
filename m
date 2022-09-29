Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7245C5EF0C6
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 10:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234766AbiI2Irb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 04:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234218AbiI2Ira (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 04:47:30 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB0A12DEF1;
        Thu, 29 Sep 2022 01:47:26 -0700 (PDT)
X-UUID: 57d1a879de2e456c883ec01a9bed887e-20220929
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=WYHMETprlxCSlcsR6AUgF7th2hMnQkiMFVz9edPawAU=;
        b=sje336XFuNVLHdoAVA7Uyta43RUR0DU1G/VEPRaLi4GGgP6QVBAKMqnnLOSd1CRzK1EGvPF6WKHZdog1YTK5pL0QR9Z5xhjQyyis/SKcMPH0A6x78lBzZ1aON4X62TXfYHmHyADMaSm87OpP+Wq/STdce3NkuqvlpCKxbEeuq9E=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.11,REQID:bb9a92e0-89bc-4ab8-ad00-fc3956a1c4e6,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:39a5ff1,CLOUDID:c1a87ba3-dc04-435c-b19b-71e131a5fc35,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: 57d1a879de2e456c883ec01a9bed887e-20220929
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <macpaul.lin@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1136124860; Thu, 29 Sep 2022 16:47:21 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Thu, 29 Sep 2022 16:47:20 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 29 Sep 2022 16:47:20 +0800
From:   Macpaul Lin <macpaul.lin@mediatek.com>
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
        Macpaul Lin <macpaul.lin@mediatek.com>,
        Macpaul Lin <macpaul@gmail.com>, <linux-usb@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: [PATCH v2] arm64: dts: mediatek: mt8195-demo: fix the memory size of node secmon
Date:   Thu, 29 Sep 2022 16:47:14 +0800
Message-ID: <20220929084714.15143-1-macpaul.lin@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20220922091648.2821-1-macpaul.lin@mediatek.com>
References: <20220922091648.2821-1-macpaul.lin@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The size of device tree node secmon (bl31_secmon_reserved) was
incorrect. It should be increased to 2MiB (0x200000).

The origin setting will cause some abnormal behavior due to
trusted-firmware-a and related firmware didn't load correctly.
The incorrect behavior may vary because of different software stacks.
For example, it will cause build error in some Yocto project because
it will check if there was enough memory to load trusted-firmware-a
to the reserved memory.

When mt8195-demo.dts sent to the upstream, at that time the size of
BL31 was small. Because supported functions and modules in BL31 are
basic sets when the board was under early development stage.

Now BL31 includes more firmwares of coprocessors and maturer functions
so the size has grown bigger in real applications. According to the value
reported by customers, we think reserved 2MiB for BL31 might be enough
for maybe the following 2 or 3 years.

Cc: stable@vger.kernel.org      # v5.19
Fixes: 6147314aeedc ("arm64: dts: mediatek: Add device-tree for MT8195 Demo board")
Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
Reviewed-by: Miles Chen <miles.chen@mediatek.com>
---
Changes for v2
 - Add more information about the size difference for BL31 in commit message.
   Thanks for Miles's review.

 arch/arm64/boot/dts/mediatek/mt8195-demo.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8195-demo.dts b/arch/arm64/boot/dts/mediatek/mt8195-demo.dts
index 4fbd99eb496a..dec85d254838 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195-demo.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8195-demo.dts
@@ -56,10 +56,10 @@
 		#size-cells = <2>;
 		ranges;
 
-		/* 192 KiB reserved for ARM Trusted Firmware (BL31) */
+		/* 2 MiB reserved for ARM Trusted Firmware (BL31) */
 		bl31_secmon_reserved: secmon@54600000 {
 			no-map;
-			reg = <0 0x54600000 0x0 0x30000>;
+			reg = <0 0x54600000 0x0 0x200000>;
 		};
 
 		/* 12 MiB reserved for OP-TEE (BL32)
-- 
2.18.0

