Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB58621572
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235274AbiKHOM3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:12:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235277AbiKHOMJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:12:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C9557B79
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:11:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5580FB81ADB
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:11:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A80E6C433C1;
        Tue,  8 Nov 2022 14:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916697;
        bh=dJLGHYHjSS/73auXxWo3FqX7HzTjQuYn7SuFazyZjg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WFpEm1ICWuqo9GUpugGPVoO7gq52rkQvLQFSmG8vUsn2MbnJ1ZCp1T0m9w2oKj0GV
         IA0faB5UAoFm1GovPU308Y3zvUPiFwFayvnEMH7QpwrevPF/tlZ7zauLYGs47R7IjM
         rifyTZ1keaCYs3GM4ZRqNqHk26v45eYeJ1Y3X4kA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, David Wolfe <david.wolfe@nxp.com>,
        Haibo Chen <haibo.chen@nxp.com>, Jacky Bai <ping.bai@nxp.com>,
        Peng Fan <peng.fan@nxp.com>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 105/197] arm64: dts: imx93: correct gpio-ranges
Date:   Tue,  8 Nov 2022 14:39:03 +0100
Message-Id: <20221108133359.619581157@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit d92a110130d492bd5eab81827ce3730581dc933a ]

Per imx93-pinfunc.h and pinctrl-imx93.c, correct gpio-ranges.

Fixes: ec8b5b5058ea ("arm64: dts: freescale: Add i.MX93 dtsi support")
Reported-by: David Wolfe <david.wolfe@nxp.com>
Reviewed-by: Haibo Chen <haibo.chen@nxp.com>
Reviewed-by: Jacky Bai <ping.bai@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx93.dtsi | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx93.dtsi b/arch/arm64/boot/dts/freescale/imx93.dtsi
index b04735004fdf..6981d3b0e274 100644
--- a/arch/arm64/boot/dts/freescale/imx93.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx93.dtsi
@@ -298,7 +298,7 @@ gpio2: gpio@43810080 {
 			clocks = <&clk IMX93_CLK_GPIO2_GATE>,
 				 <&clk IMX93_CLK_GPIO2_GATE>;
 			clock-names = "gpio", "port";
-			gpio-ranges = <&iomuxc 0 32 32>;
+			gpio-ranges = <&iomuxc 0 4 30>;
 		};
 
 		gpio3: gpio@43820080 {
@@ -312,7 +312,8 @@ gpio3: gpio@43820080 {
 			clocks = <&clk IMX93_CLK_GPIO3_GATE>,
 				 <&clk IMX93_CLK_GPIO3_GATE>;
 			clock-names = "gpio", "port";
-			gpio-ranges = <&iomuxc 0 64 32>;
+			gpio-ranges = <&iomuxc 0 84 8>, <&iomuxc 8 66 18>,
+				      <&iomuxc 26 34 2>, <&iomuxc 28 0 4>;
 		};
 
 		gpio4: gpio@43830080 {
@@ -326,7 +327,7 @@ gpio4: gpio@43830080 {
 			clocks = <&clk IMX93_CLK_GPIO4_GATE>,
 				 <&clk IMX93_CLK_GPIO4_GATE>;
 			clock-names = "gpio", "port";
-			gpio-ranges = <&iomuxc 0 96 32>;
+			gpio-ranges = <&iomuxc 0 38 28>, <&iomuxc 28 36 2>;
 		};
 
 		gpio1: gpio@47400080 {
@@ -340,7 +341,7 @@ gpio1: gpio@47400080 {
 			clocks = <&clk IMX93_CLK_GPIO1_GATE>,
 				 <&clk IMX93_CLK_GPIO1_GATE>;
 			clock-names = "gpio", "port";
-			gpio-ranges = <&iomuxc 0 0 32>;
+			gpio-ranges = <&iomuxc 0 92 16>;
 		};
 	};
 };
-- 
2.35.1



