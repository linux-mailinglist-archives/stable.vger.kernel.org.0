Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C433568CC7D
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 03:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbjBGCOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 21:14:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBGCOl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 21:14:41 -0500
Received: from mx.socionext.com (mx.socionext.com [202.248.49.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C25F8126C1;
        Mon,  6 Feb 2023 18:14:39 -0800 (PST)
Received: from unknown (HELO kinkan2-ex.css.socionext.com) ([172.31.9.52])
  by mx.socionext.com with ESMTP; 07 Feb 2023 11:14:39 +0900
Received: from mail.mfilter.local (m-filter-1 [10.213.24.61])
        by kinkan2-ex.css.socionext.com (Postfix) with ESMTP id 0F2FF2019C61;
        Tue,  7 Feb 2023 11:14:39 +0900 (JST)
Received: from 172.31.9.51 (172.31.9.51) by m-FILTER with ESMTP; Tue, 7 Feb 2023 11:14:49 +0900
Received: from plum.e01.socionext.com (unknown [10.212.243.119])
        by kinkan2.css.socionext.com (Postfix) with ESMTP id 93782A8556;
        Tue,  7 Feb 2023 11:14:38 +0900 (JST)
From:   Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
To:     soc@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        stable@vger.kernel.org
Subject: [PATCH] arm64: dts: uniphier: Fix property name in PXs3 USB node
Date:   Tue,  7 Feb 2023 11:14:29 +0900
Message-Id: <20230207021429.28925-1-hayashi.kunihiko@socionext.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The property "snps,usb2_gadget_lpm_disable" is wrong.
It should be fixed to "snps,usb2-gadget-lpm-disable".

Cc: stable@vger.kernel.org
Fixes: 19fee1a1096d ("arm64: dts: uniphier: Add USB-device support for PXs3 reference board")
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
---
 arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget0.dts | 2 +-
 arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget1.dts | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget0.dts b/arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget0.dts
index 7069f51bc120..99136adb1857 100644
--- a/arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget0.dts
+++ b/arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget0.dts
@@ -24,7 +24,7 @@ &usb0 {
 	snps,dis_enblslpm_quirk;
 	snps,dis_u2_susphy_quirk;
 	snps,dis_u3_susphy_quirk;
-	snps,usb2_gadget_lpm_disable;
+	snps,usb2-gadget-lpm-disable;
 	phy-names = "usb2-phy", "usb3-phy";
 	phys = <&usb0_hsphy0>, <&usb0_ssphy0>;
 };
diff --git a/arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget1.dts b/arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget1.dts
index a3cfa8113ffb..4c960f455461 100644
--- a/arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget1.dts
+++ b/arch/arm64/boot/dts/socionext/uniphier-pxs3-ref-gadget1.dts
@@ -24,7 +24,7 @@ &usb1 {
 	snps,dis_enblslpm_quirk;
 	snps,dis_u2_susphy_quirk;
 	snps,dis_u3_susphy_quirk;
-	snps,usb2_gadget_lpm_disable;
+	snps,usb2-gadget-lpm-disable;
 	phy-names = "usb2-phy", "usb3-phy";
 	phys = <&usb1_hsphy0>, <&usb1_ssphy0>;
 };
-- 
2.25.1

