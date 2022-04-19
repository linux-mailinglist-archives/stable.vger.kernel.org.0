Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDA5650782F
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 20:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356861AbiDSSWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 14:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356889AbiDSSVt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 14:21:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F3040E70;
        Tue, 19 Apr 2022 11:14:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C009B60A75;
        Tue, 19 Apr 2022 18:14:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0234DC385A5;
        Tue, 19 Apr 2022 18:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650392049;
        bh=wpC6UqRnKxV//FhoQ/Rg1fnAdop8hYek9oBjdN28NH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DAYXQ3I7G0jR9VmOrBbLqIVOGs7Fpw1+/mzVGL/84uOdzVTZWLaLmvI4LNelj7m1+
         RQ+8bXPjD0iZwv7K71HAALIsY7CfnPjQJP1MndE9riL+IErwZHUWldxcqSubiRBHrh
         1ePwiVh0CREFe/2tvThGDgqQkxwRulnXy7kI08wKjojnFkPtXxpHwDyM75tHdWQoBb
         ZsYdcFH/Flxl1ShIh64+wI4xI5WcXVqD7CnrKfdIE6yn5rue0lFmJtShV3kgr07Qal
         sOdPEQJwUzLZbRmIdqdLX5KH3VUzHVH+sLIjfLr+jdI3nUTK3SYW2VngtpXJoYg7TN
         xMGieQykvbCug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Herring <robh@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, shawnguo@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 05/18] arm64: dts: imx: Fix imx8*-var-som touchscreen property sizes
Date:   Tue, 19 Apr 2022 14:13:39 -0400
Message-Id: <20220419181353.485719-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419181353.485719-1-sashal@kernel.org>
References: <20220419181353.485719-1-sashal@kernel.org>
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

From: Rob Herring <robh@kernel.org>

[ Upstream commit 1bc12d301594eafde0a8529d28d459af81053b3a ]

The common touchscreen properties are all 32-bit, not 16-bit. These
properties must not be too important as they are all ignored in case of an
error reading them.

Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/Yk3moe6Hz8ELM0iS@robh.at.kernel.org'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-var-som.dtsi | 8 ++++----
 arch/arm64/boot/dts/freescale/imx8mn-var-som.dtsi | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-var-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-var-som.dtsi
index 49082529764f..0fac1f3f7f47 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-var-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-var-som.dtsi
@@ -89,12 +89,12 @@ touchscreen@0 {
 		pendown-gpio = <&gpio1 3 GPIO_ACTIVE_LOW>;
 
 		ti,x-min = /bits/ 16 <125>;
-		touchscreen-size-x = /bits/ 16 <4008>;
+		touchscreen-size-x = <4008>;
 		ti,y-min = /bits/ 16 <282>;
-		touchscreen-size-y = /bits/ 16 <3864>;
+		touchscreen-size-y = <3864>;
 		ti,x-plate-ohms = /bits/ 16 <180>;
-		touchscreen-max-pressure = /bits/ 16 <255>;
-		touchscreen-average-samples = /bits/ 16 <10>;
+		touchscreen-max-pressure = <255>;
+		touchscreen-average-samples = <10>;
 		ti,debounce-tol = /bits/ 16 <3>;
 		ti,debounce-rep = /bits/ 16 <1>;
 		ti,settle-delay-usec = /bits/ 16 <150>;
diff --git a/arch/arm64/boot/dts/freescale/imx8mn-var-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mn-var-som.dtsi
index 7f356edf9f91..f6287f174355 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn-var-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn-var-som.dtsi
@@ -70,12 +70,12 @@ touchscreen@0 {
 		pendown-gpio = <&gpio1 3 GPIO_ACTIVE_LOW>;
 
 		ti,x-min = /bits/ 16 <125>;
-		touchscreen-size-x = /bits/ 16 <4008>;
+		touchscreen-size-x = <4008>;
 		ti,y-min = /bits/ 16 <282>;
-		touchscreen-size-y = /bits/ 16 <3864>;
+		touchscreen-size-y = <3864>;
 		ti,x-plate-ohms = /bits/ 16 <180>;
-		touchscreen-max-pressure = /bits/ 16 <255>;
-		touchscreen-average-samples = /bits/ 16 <10>;
+		touchscreen-max-pressure = <255>;
+		touchscreen-average-samples = <10>;
 		ti,debounce-tol = /bits/ 16 <3>;
 		ti,debounce-rep = /bits/ 16 <1>;
 		ti,settle-delay-usec = /bits/ 16 <150>;
-- 
2.35.1

