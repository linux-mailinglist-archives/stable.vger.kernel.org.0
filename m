Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7ED34EC2D2
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 14:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244560AbiC3MBX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 08:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344211AbiC3Lzl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:55:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 280B32CCB9;
        Wed, 30 Mar 2022 04:53:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8DBD616E0;
        Wed, 30 Mar 2022 11:53:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 929A0C3410F;
        Wed, 30 Mar 2022 11:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648641226;
        bh=5DhYdPpy5hGpue8wLGlBJX3nNYuxCqm2NqDqAHyvBQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bw6OxbEsq2XHUtfEbexXnv/Tjbl3TR31QQjf4/I3mLKVUexh28rooQdsx4gS8+tgX
         9ll5rRGk+I3Y/xYo7xhyaik+QfrdiN25lgliJe+EUrzXOjM/sYziw320kwqxlqT16w
         UnaeqaHFWwYj/dOTgtnnfyW6U2xoVZ1p+/KcACJiXhqOdytoz53BZbGyZIyOFih4ox
         366rIr8uEKNHDPrI9JkBDKQrwmgV+ax1qAaHP4koqnF3X7L+s/5G+RrQDSisirufGU
         hZAISoIKy9Yi/yx1tnxS/m2TP9M5etQPoo1hAL8T6BzIcqb1IjUcQXqc12i5HeywzS
         trQ3KuRbfa2Xw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Heidelberg <david@ixit.cz>,
        LogicalErzor <logicalerzor@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, andy.gross@linaro.org,
        david.brown@linaro.org, robh+dt@kernel.org, mark.rutland@arm.com,
        linux@armlinux.org.uk, linux-arm-msm@vger.kernel.org,
        linux-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 05/20] ARM: dts: qcom: fix gic_irq_domain_translate warnings for msm8960
Date:   Wed, 30 Mar 2022 07:53:21 -0400
Message-Id: <20220330115336.1672930-5-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330115336.1672930-1-sashal@kernel.org>
References: <20220330115336.1672930-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Heidelberg <david@ixit.cz>

[ Upstream commit 6f7e221e7a5cfc3299616543fce42b36e631497b ]

IRQ types blindly copied from very similar APQ8064.

Fixes warnings as:
WARNING: CPU: 0 PID: 1 at drivers/irqchip/irq-gic.c:1080 gic_irq_domain_translate+0x118/0x120
...

Tested-by: LogicalErzor <logicalerzor@gmail.com> # boot-tested on Samsung S3
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220108174229.60384-1-david@ixit.cz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-msm8960.dtsi | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-msm8960.dtsi b/arch/arm/boot/dts/qcom-msm8960.dtsi
index 1733d8f40ab1..b256fda0f5ea 100644
--- a/arch/arm/boot/dts/qcom-msm8960.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8960.dtsi
@@ -140,7 +140,9 @@
 			reg		= <0x108000 0x1000>;
 			qcom,ipc	= <&l2cc 0x8 2>;
 
-			interrupts	= <0 19 0>, <0 21 0>, <0 22 0>;
+			interrupts	= <GIC_SPI 19 IRQ_TYPE_EDGE_RISING>,
+					  <GIC_SPI 21 IRQ_TYPE_EDGE_RISING>,
+					  <GIC_SPI 22 IRQ_TYPE_EDGE_RISING>;
 			interrupt-names	= "ack", "err", "wakeup";
 
 			regulators {
@@ -186,7 +188,7 @@
 				compatible = "qcom,msm-uartdm-v1.3", "qcom,msm-uartdm";
 				reg = <0x16440000 0x1000>,
 				      <0x16400000 0x1000>;
-				interrupts = <0 154 0x0>;
+				interrupts = <GIC_SPI 154 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&gcc GSBI5_UART_CLK>, <&gcc GSBI5_H_CLK>;
 				clock-names = "core", "iface";
 				status = "disabled";
@@ -312,7 +314,7 @@
 				#address-cells = <1>;
 				#size-cells = <0>;
 				reg = <0x16080000 0x1000>;
-				interrupts = <0 147 0>;
+				interrupts = <GIC_SPI 147 IRQ_TYPE_LEVEL_HIGH>;
 				spi-max-frequency = <24000000>;
 				cs-gpios = <&msmgpio 8 0>;
 
-- 
2.34.1

