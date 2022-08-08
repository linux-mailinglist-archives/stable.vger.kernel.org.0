Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02CD958C08D
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243343AbiHHBwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243461AbiHHBvB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:51:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B16319281;
        Sun,  7 Aug 2022 18:38:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1973F60E65;
        Mon,  8 Aug 2022 01:38:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B01BC4347C;
        Mon,  8 Aug 2022 01:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922681;
        bh=bC4mioEGpy6YJ8y80rAi0DRjq8ciYbvHcfjOXcdJuiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=He7xufsQLfckxdGykRZ4m8Tc0xNrgX1Y7ThLc+j0E97mQ+/1SkUBr6Fa0KMAN/Zs1
         voQMzuPr6mfFj3dv1wlEWOXGZ42wec6QjFM2RFYV5Ed4r+tK+YDlbJcUpPntJDlxFR
         ok16XJeIBD+6O43TkOKF5Bq5fyzn/HCzomVwW+vg7BeoJqoRzy6ubjns7swKkoXpvk
         dqAQn2ktHmwectEWMShi7hlC8y14eOoRY580QJG2d8SKjSFAzHRoy7olNnrGlme9/r
         OMnpsdXZ4zY7rfCzcC/0QP4w7W3+tHk1D92SVKru6FnJB4gV6caQLEqSIBzbbX1DrU
         EzaibTNHWZECw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 11/29] ARM: dts: imx6ul: change operating-points to uint32-matrix
Date:   Sun,  7 Aug 2022 21:37:21 -0400
Message-Id: <20220808013741.316026-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013741.316026-1-sashal@kernel.org>
References: <20220808013741.316026-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit edb67843983bbdf61b4c8c3c50618003d38bb4ae ]

operating-points is a uint32-matrix as per opp-v1.yaml. Change it
accordingly. While at it, change fsl,soc-operating-points as well,
although there is no bindings file (yet). But they should have the same
format. Fixes the dt_binding_check warning:
cpu@0: operating-points:0: [696000, 1275000, 528000, 1175000, 396000,
1025000, 198000, 950000] is too long
cpu@0: operating-points:0: Additional items are not allowed (528000,
1175000, 396000, 1025000, 198000, 950000 were unexpected)

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6ul.dtsi | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/arch/arm/boot/dts/imx6ul.dtsi b/arch/arm/boot/dts/imx6ul.dtsi
index 34eccc1db12c..02640c19c1ec 100644
--- a/arch/arm/boot/dts/imx6ul.dtsi
+++ b/arch/arm/boot/dts/imx6ul.dtsi
@@ -62,20 +62,18 @@ cpu0: cpu@0 {
 			clock-frequency = <696000000>;
 			clock-latency = <61036>; /* two CLK32 periods */
 			#cooling-cells = <2>;
-			operating-points = <
+			operating-points =
 				/* kHz	uV */
-				696000	1275000
-				528000	1175000
-				396000	1025000
-				198000	950000
-			>;
-			fsl,soc-operating-points = <
+				<696000	1275000>,
+				<528000	1175000>,
+				<396000	1025000>,
+				<198000	950000>;
+			fsl,soc-operating-points =
 				/* KHz	uV */
-				696000	1275000
-				528000	1175000
-				396000	1175000
-				198000	1175000
-			>;
+				<696000	1275000>,
+				<528000	1175000>,
+				<396000	1175000>,
+				<198000	1175000>;
 			clocks = <&clks IMX6UL_CLK_ARM>,
 				 <&clks IMX6UL_CLK_PLL2_BUS>,
 				 <&clks IMX6UL_CLK_PLL2_PFD2>,
-- 
2.35.1

