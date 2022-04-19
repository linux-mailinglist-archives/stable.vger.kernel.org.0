Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0C135077CC
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 20:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356684AbiDSSSq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 14:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356664AbiDSSRl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 14:17:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00EDC3DA42;
        Tue, 19 Apr 2022 11:13:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F90060C83;
        Tue, 19 Apr 2022 18:13:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BFE1C385A9;
        Tue, 19 Apr 2022 18:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650391985;
        bh=8nST6yhUe8j5cQ2n3gZhfsMoH2V/JDXypguacgx/52Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nlIDQGqOTbP9400815krB6M0cb2iFAs8yo4KbOZ3L09yR0QVrfSQ1VC0nFNlwFSng
         j6RE5dZvLOk73SpfZIop2vpFIjamowzsAEVFKo8mDKnGNtghQdsnLUxEcRVr2l03SV
         PlCNUND2xhQCP9hvokwIVjkU8RQVtrLSvaYz/iYVhgFHWqmGzpoPd/cbBUubb332XX
         9ocAK4lz+Q+sTFhz59TGNI2XiwmrddABCSYW/780uX0r34QLY43lFNyCq4CsuWKg5V
         XhV1SLPThgRlxkxalhIrjYYYJcVO5eBIg5dMThe1BtKsltp7/sy2frZHd5JVvyytnH
         SeJQITnMpbnmg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Herring <robh@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, shawnguo@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 07/27] arm64: dts: imx: Fix imx8*-var-som touchscreen property sizes
Date:   Tue, 19 Apr 2022 14:12:22 -0400
Message-Id: <20220419181242.485308-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419181242.485308-1-sashal@kernel.org>
References: <20220419181242.485308-1-sashal@kernel.org>
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
index 1dc9d187601c..a0bd540f27d3 100644
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
index b16c7caf34c1..87b5e23c766f 100644
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

