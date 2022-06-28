Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3C255E0CB
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244215AbiF1CXx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244104AbiF1CXA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:23:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A60325596;
        Mon, 27 Jun 2022 19:22:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C92F6B81C13;
        Tue, 28 Jun 2022 02:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E629C341CB;
        Tue, 28 Jun 2022 02:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382942;
        bh=nwrR3WHan4fbIRem1b3D8PMhPSm7OyPpvcT0cJsGl0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SKfCEVnRky3LV+sXpObPIvKVNJnSp1tN2omUiVfz6Z693ahzqZ/JdmZblbgCSnTak
         Fb7MlhkIeObcyXvFnDieU7EXwpiziKGnGqavOTDV1F+RQevBP2HXNrGKHHwiDFyKmy
         YArWw6dFFU7HX0riGGQ9fRykZrRnifViwIVqJwa3PCpUFVPSRRHIbDaNVHcLqchtV3
         BX4VptjpmTQ6m4ToqEuZ5Ak+4IrFRsNqEggSoyDfT8tB/KelkJtcKDh3pzX2UAXW4V
         kInNNzc5rBXCLfbzcwyix7KzXCAflSNflxUNkQGhy7TxJRHC32lcZ0Pc1nalT2G/Px
         kq1kL/WCbKt9Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aidan MacDonald <aidanmacdonald.0x0@gmail.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, linux-mips@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 33/41] mips: dts: ingenic: Add TCU clock to x1000/x1830 tcu device node
Date:   Mon, 27 Jun 2022 22:20:52 -0400
Message-Id: <20220628022100.595243-33-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628022100.595243-1-sashal@kernel.org>
References: <20220628022100.595243-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aidan MacDonald <aidanmacdonald.0x0@gmail.com>

[ Upstream commit db30dc1a5226eb74d52f748989e9a06451333678 ]

This clock is a gate for the TCU hardware block on these SoCs, but
it wasn't included in the device tree since the ingenic-tcu driver
erroneously did not request it.

Reviewed-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Aidan MacDonald <aidanmacdonald.0x0@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/boot/dts/ingenic/x1000.dtsi | 5 +++--
 arch/mips/boot/dts/ingenic/x1830.dtsi | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/mips/boot/dts/ingenic/x1000.dtsi b/arch/mips/boot/dts/ingenic/x1000.dtsi
index dec7909d4baa..ab86b3632687 100644
--- a/arch/mips/boot/dts/ingenic/x1000.dtsi
+++ b/arch/mips/boot/dts/ingenic/x1000.dtsi
@@ -111,8 +111,9 @@ tcu: timer@10002000 {
 
 		clocks = <&cgu X1000_CLK_RTCLK>,
 			 <&cgu X1000_CLK_EXCLK>,
-			 <&cgu X1000_CLK_PCLK>;
-		clock-names = "rtc", "ext", "pclk";
+			 <&cgu X1000_CLK_PCLK>,
+			 <&cgu X1000_CLK_TCU>;
+		clock-names = "rtc", "ext", "pclk", "tcu";
 
 		interrupt-controller;
 		#interrupt-cells = <1>;
diff --git a/arch/mips/boot/dts/ingenic/x1830.dtsi b/arch/mips/boot/dts/ingenic/x1830.dtsi
index 215257f8bb1a..dd70aa9d87ee 100644
--- a/arch/mips/boot/dts/ingenic/x1830.dtsi
+++ b/arch/mips/boot/dts/ingenic/x1830.dtsi
@@ -104,8 +104,9 @@ tcu: timer@10002000 {
 
 		clocks = <&cgu X1830_CLK_RTCLK>,
 			 <&cgu X1830_CLK_EXCLK>,
-			 <&cgu X1830_CLK_PCLK>;
-		clock-names = "rtc", "ext", "pclk";
+			 <&cgu X1830_CLK_PCLK>,
+			 <&cgu X1830_CLK_TCU>;
+		clock-names = "rtc", "ext", "pclk", "tcu";
 
 		interrupt-controller;
 		#interrupt-cells = <1>;
-- 
2.35.1

