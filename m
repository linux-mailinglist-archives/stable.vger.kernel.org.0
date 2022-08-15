Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 304EA593DE4
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347095AbiHOUX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347295AbiHOUWN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:22:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C537C33378;
        Mon, 15 Aug 2022 12:02:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 528E461299;
        Mon, 15 Aug 2022 19:02:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F60C433C1;
        Mon, 15 Aug 2022 19:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590131;
        bh=ck8ZbF58sP5kOpHI71GDLb8PqPzc7D5LC9zDS/+kP+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L0ajLr43ywuzHBU5Hz5U/BVwXVaOlNGIcACwGDlzBle3YZCzK1dQMGfKDpYuioBQb
         pY92jxVG6RnEtsmAaPxKhNEB2fzG/vTdmZhaeYynQhiEaU0OxmxBid2HL5IFj8Ozmm
         1k35j/UCg3JsVLXkc9EECElvdHoPXIGV5DcIiwvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Heidelberg <david@ixit.cz>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0160/1095] arm64: dts: qcom: timer should use only 32-bit size
Date:   Mon, 15 Aug 2022 19:52:39 +0200
Message-Id: <20220815180436.185514993@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

[ Upstream commit 458ebdbb8e5d596a462d8125cec74142ff5dfa97 ]

There's no reason the timer needs > 32-bits of address or size.
Since we using 32-bit size, we need to define ranges properly.

Fixes warnings as:
```
arch/arm64/boot/dts/qcom/sdm845-oneplus-fajita.dt.yaml: timer@17c90000: #size-cells:0:0: 1 was expected
        From schema: Documentation/devicetree/bindings/timer/arm,arch_timer_mmio.yaml
```

Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220626105800.35586-1-david@ixit.cz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq6018.dtsi | 22 +++++++++++-----------
 arch/arm64/boot/dts/qcom/sc7180.dtsi  | 22 +++++++++++-----------
 arch/arm64/boot/dts/qcom/sc7280.dtsi  | 22 +++++++++++-----------
 arch/arm64/boot/dts/qcom/sdm845.dtsi  | 22 +++++++++++-----------
 arch/arm64/boot/dts/qcom/sm6350.dtsi  | 22 +++++++++++-----------
 arch/arm64/boot/dts/qcom/sm8150.dtsi  | 22 +++++++++++-----------
 arch/arm64/boot/dts/qcom/sm8250.dtsi  | 22 +++++++++++-----------
 arch/arm64/boot/dts/qcom/sm8350.dtsi  | 22 +++++++++++-----------
 arch/arm64/boot/dts/qcom/sm8450.dtsi  | 22 +++++++++++-----------
 9 files changed, 99 insertions(+), 99 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq6018.dtsi b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
index aac56575e30d..5cdec104d899 100644
--- a/arch/arm64/boot/dts/qcom/ipq6018.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
@@ -525,9 +525,9 @@ timer {
 		};
 
 		timer@b120000 {
-			#address-cells = <2>;
-			#size-cells = <2>;
-			ranges;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0 0 0 0x10000000>;
 			compatible = "arm,armv7-timer-mem";
 			reg = <0x0 0x0b120000 0x0 0x1000>;
 
@@ -535,49 +535,49 @@ frame@b120000 {
 				frame-number = <0>;
 				interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
 					     <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x0b121000 0x0 0x1000>,
-				      <0x0 0x0b122000 0x0 0x1000>;
+				reg = <0x0b121000 0x1000>,
+				      <0x0b122000 0x1000>;
 			};
 
 			frame@b123000 {
 				frame-number = <1>;
 				interrupts = <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0xb123000 0x0 0x1000>;
+				reg = <0x0b123000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@b124000 {
 				frame-number = <2>;
 				interrupts = <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x0b124000 0x0 0x1000>;
+				reg = <0x0b124000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@b125000 {
 				frame-number = <3>;
 				interrupts = <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x0b125000 0x0 0x1000>;
+				reg = <0x0b125000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@b126000 {
 				frame-number = <4>;
 				interrupts = <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x0b126000 0x0 0x1000>;
+				reg = <0x0b126000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@b127000 {
 				frame-number = <5>;
 				interrupts = <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x0b127000 0x0 0x1000>;
+				reg = <0x0b127000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@b128000 {
 				frame-number = <6>;
 				interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x0b128000 0x0 0x1000>;
+				reg = <0x0b128000 0x1000>;
 				status = "disabled";
 			};
 		};
diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
index e1c46b80f14a..e9fb3c9a2d6e 100644
--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -3388,9 +3388,9 @@ watchdog@17c10000 {
 		};
 
 		timer@17c20000{
-			#address-cells = <2>;
-			#size-cells = <2>;
-			ranges;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0 0 0 0x20000000>;
 			compatible = "arm,armv7-timer-mem";
 			reg = <0 0x17c20000 0 0x1000>;
 
@@ -3398,49 +3398,49 @@ frame@17c21000 {
 				frame-number = <0>;
 				interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
 					     <GIC_SPI 6 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17c21000 0 0x1000>,
-				      <0 0x17c22000 0 0x1000>;
+				reg = <0x17c21000 0x1000>,
+				      <0x17c22000 0x1000>;
 			};
 
 			frame@17c23000 {
 				frame-number = <1>;
 				interrupts = <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17c23000 0 0x1000>;
+				reg = <0x17c23000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c25000 {
 				frame-number = <2>;
 				interrupts = <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17c25000 0 0x1000>;
+				reg = <0x17c25000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c27000 {
 				frame-number = <3>;
 				interrupts = <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17c27000 0 0x1000>;
+				reg = <0x17c27000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c29000 {
 				frame-number = <4>;
 				interrupts = <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17c29000 0 0x1000>;
+				reg = <0x17c29000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c2b000 {
 				frame-number = <5>;
 				interrupts = <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17c2b000 0 0x1000>;
+				reg = <0x17c2b000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c2d000 {
 				frame-number = <6>;
 				interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17c2d000 0 0x1000>;
+				reg = <0x17c2d000 0x1000>;
 				status = "disabled";
 			};
 		};
diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index f0b64be63c21..8a4fd614d0a1 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -4395,9 +4395,9 @@ watchdog@17c10000 {
 		};
 
 		timer@17c20000 {
-			#address-cells = <2>;
-			#size-cells = <2>;
-			ranges;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0 0 0 0x20000000>;
 			compatible = "arm,armv7-timer-mem";
 			reg = <0 0x17c20000 0 0x1000>;
 
@@ -4405,49 +4405,49 @@ frame@17c21000 {
 				frame-number = <0>;
 				interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
 					     <GIC_SPI 6 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17c21000 0 0x1000>,
-				      <0 0x17c22000 0 0x1000>;
+				reg = <0x17c21000 0x1000>,
+				      <0x17c22000 0x1000>;
 			};
 
 			frame@17c23000 {
 				frame-number = <1>;
 				interrupts = <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17c23000 0 0x1000>;
+				reg = <0x17c23000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c25000 {
 				frame-number = <2>;
 				interrupts = <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17c25000 0 0x1000>;
+				reg = <0x17c25000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c27000 {
 				frame-number = <3>;
 				interrupts = <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17c27000 0 0x1000>;
+				reg = <0x17c27000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c29000 {
 				frame-number = <4>;
 				interrupts = <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17c29000 0 0x1000>;
+				reg = <0x17c29000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c2b000 {
 				frame-number = <5>;
 				interrupts = <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17c2b000 0 0x1000>;
+				reg = <0x17c2b000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c2d000 {
 				frame-number = <6>;
 				interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17c2d000 0 0x1000>;
+				reg = <0x17c2d000 0x1000>;
 				status = "disabled";
 			};
 		};
diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index ad21cf465c98..cd0029ff8246 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -4942,9 +4942,9 @@ slimbam: dma-controller@17184000 {
 		};
 
 		timer@17c90000 {
-			#address-cells = <2>;
-			#size-cells = <2>;
-			ranges;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0 0 0 0x20000000>;
 			compatible = "arm,armv7-timer-mem";
 			reg = <0 0x17c90000 0 0x1000>;
 
@@ -4952,49 +4952,49 @@ frame@17ca0000 {
 				frame-number = <0>;
 				interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>,
 					     <GIC_SPI 6 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17ca0000 0 0x1000>,
-				      <0 0x17cb0000 0 0x1000>;
+				reg = <0x17ca0000 0x1000>,
+				      <0x17cb0000 0x1000>;
 			};
 
 			frame@17cc0000 {
 				frame-number = <1>;
 				interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17cc0000 0 0x1000>;
+				reg = <0x17cc0000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17cd0000 {
 				frame-number = <2>;
 				interrupts = <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17cd0000 0 0x1000>;
+				reg = <0x17cd0000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17ce0000 {
 				frame-number = <3>;
 				interrupts = <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17ce0000 0 0x1000>;
+				reg = <0x17ce0000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17cf0000 {
 				frame-number = <4>;
 				interrupts = <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17cf0000 0 0x1000>;
+				reg = <0x17cf0000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17d00000 {
 				frame-number = <5>;
 				interrupts = <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17d00000 0 0x1000>;
+				reg = <0x17d00000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17d10000 {
 				frame-number = <6>;
 				interrupts = <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0 0x17d10000 0 0x1000>;
+				reg = <0x17d10000 0x1000>;
 				status = "disabled";
 			};
 		};
diff --git a/arch/arm64/boot/dts/qcom/sm6350.dtsi b/arch/arm64/boot/dts/qcom/sm6350.dtsi
index d7c9edff19f7..c31fe27a46f2 100644
--- a/arch/arm64/boot/dts/qcom/sm6350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6350.dtsi
@@ -1090,57 +1090,57 @@ timer@17c20000 {
 			compatible = "arm,armv7-timer-mem";
 			reg = <0x0 0x17c20000 0x0 0x1000>;
 			clock-frequency = <19200000>;
-			#address-cells = <2>;
-			#size-cells = <2>;
-			ranges;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0 0 0 0x20000000>;
 
 			frame@17c21000 {
 				frame-number = <0>;
 				interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
 					     <GIC_SPI 6 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c21000 0x0 0x1000>,
-				      <0x0 0x17c22000 0x0 0x1000>;
+				reg = <0x17c21000 0x1000>,
+				      <0x17c22000 0x1000>;
 			};
 
 			frame@17c23000 {
 				frame-number = <1>;
 				interrupts = <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c23000 0x0 0x1000>;
+				reg = <0x17c23000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c25000 {
 				frame-number = <2>;
 				interrupts = <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c25000 0x0 0x1000>;
+				reg = <0x17c25000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c27000 {
 				frame-number = <3>;
 				interrupts = <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c27000 0x0 0x1000>;
+				reg = <0x17c27000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c29000 {
 				frame-number = <4>;
 				interrupts = <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c29000 0x0 0x1000>;
+				reg = <0x17c29000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c2b000 {
 				frame-number = <5>;
 				interrupts = <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c2b000 0x0 0x1000>;
+				reg = <0x17c2b000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c2d000 {
 				frame-number = <6>;
 				interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c2d000 0x0 0x1000>;
+				reg = <0x17c2d000 0x1000>;
 				status = "disabled";
 			};
 		};
diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
index 15f3bf2e7ea0..d4f288edf3c9 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -3608,9 +3608,9 @@ watchdog@17c10000 {
 		};
 
 		timer@17c20000 {
-			#address-cells = <2>;
-			#size-cells = <2>;
-			ranges;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0 0 0 0x20000000>;
 			compatible = "arm,armv7-timer-mem";
 			reg = <0x0 0x17c20000 0x0 0x1000>;
 			clock-frequency = <19200000>;
@@ -3619,49 +3619,49 @@ frame@17c21000{
 				frame-number = <0>;
 				interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
 					     <GIC_SPI 6 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c21000 0x0 0x1000>,
-				      <0x0 0x17c22000 0x0 0x1000>;
+				reg = <0x17c21000 0x1000>,
+				      <0x17c22000 0x1000>;
 			};
 
 			frame@17c23000 {
 				frame-number = <1>;
 				interrupts = <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c23000 0x0 0x1000>;
+				reg = <0x17c23000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c25000 {
 				frame-number = <2>;
 				interrupts = <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c25000 0x0 0x1000>;
+				reg = <0x17c25000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c27000 {
 				frame-number = <3>;
 				interrupts = <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c26000 0x0 0x1000>;
+				reg = <0x17c26000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c29000 {
 				frame-number = <4>;
 				interrupts = <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c29000 0x0 0x1000>;
+				reg = <0x17c29000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c2b000 {
 				frame-number = <5>;
 				interrupts = <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c2b000 0x0 0x1000>;
+				reg = <0x17c2b000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c2d000 {
 				frame-number = <6>;
 				interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c2d000 0x0 0x1000>;
+				reg = <0x17c2d000 0x1000>;
 				status = "disabled";
 			};
 		};
diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index 1304b86af1a0..ed4e288c921f 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -4528,9 +4528,9 @@ watchdog@17c10000 {
 		};
 
 		timer@17c20000 {
-			#address-cells = <2>;
-			#size-cells = <2>;
-			ranges;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0 0 0 0x20000000>;
 			compatible = "arm,armv7-timer-mem";
 			reg = <0x0 0x17c20000 0x0 0x1000>;
 			clock-frequency = <19200000>;
@@ -4539,49 +4539,49 @@ frame@17c21000 {
 				frame-number = <0>;
 				interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
 					     <GIC_SPI 6 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c21000 0x0 0x1000>,
-				      <0x0 0x17c22000 0x0 0x1000>;
+				reg = <0x17c21000 0x1000>,
+				      <0x17c22000 0x1000>;
 			};
 
 			frame@17c23000 {
 				frame-number = <1>;
 				interrupts = <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c23000 0x0 0x1000>;
+				reg = <0x17c23000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c25000 {
 				frame-number = <2>;
 				interrupts = <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c25000 0x0 0x1000>;
+				reg = <0x17c25000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c27000 {
 				frame-number = <3>;
 				interrupts = <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c27000 0x0 0x1000>;
+				reg = <0x17c27000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c29000 {
 				frame-number = <4>;
 				interrupts = <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c29000 0x0 0x1000>;
+				reg = <0x17c29000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c2b000 {
 				frame-number = <5>;
 				interrupts = <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c2b000 0x0 0x1000>;
+				reg = <0x17c2b000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c2d000 {
 				frame-number = <6>;
 				interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c2d000 0x0 0x1000>;
+				reg = <0x17c2d000 0x1000>;
 				status = "disabled";
 			};
 		};
diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index 20f850b94158..d843a550314a 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -1752,9 +1752,9 @@ intc: interrupt-controller@17a00000 {
 
 		timer@17c20000 {
 			compatible = "arm,armv7-timer-mem";
-			#address-cells = <2>;
-			#size-cells = <2>;
-			ranges;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0 0 0 0x20000000>;
 			reg = <0x0 0x17c20000 0x0 0x1000>;
 			clock-frequency = <19200000>;
 
@@ -1762,49 +1762,49 @@ frame@17c21000 {
 				frame-number = <0>;
 				interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
 					     <GIC_SPI 6 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c21000 0x0 0x1000>,
-				      <0x0 0x17c22000 0x0 0x1000>;
+				reg = <0x17c21000 0x1000>,
+				      <0x17c22000 0x1000>;
 			};
 
 			frame@17c23000 {
 				frame-number = <1>;
 				interrupts = <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c23000 0x0 0x1000>;
+				reg = <0x17c23000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c25000 {
 				frame-number = <2>;
 				interrupts = <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c25000 0x0 0x1000>;
+				reg = <0x17c25000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c27000 {
 				frame-number = <3>;
 				interrupts = <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c27000 0x0 0x1000>;
+				reg = <0x17c27000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c29000 {
 				frame-number = <4>;
 				interrupts = <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c29000 0x0 0x1000>;
+				reg = <0x17c29000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c2b000 {
 				frame-number = <5>;
 				interrupts = <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c2b000 0x0 0x1000>;
+				reg = <0x17c2b000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17c2d000 {
 				frame-number = <6>;
 				interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17c2d000 0x0 0x1000>;
+				reg = <0x17c2d000 0x1000>;
 				status = "disabled";
 			};
 		};
diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index 7a14eb89e4ca..e5fe694b7be6 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -1203,9 +1203,9 @@ intc: interrupt-controller@17100000 {
 
 		timer@17420000 {
 			compatible = "arm,armv7-timer-mem";
-			#address-cells = <2>;
-			#size-cells = <2>;
-			ranges;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0 0 0 0x20000000>;
 			reg = <0x0 0x17420000 0x0 0x1000>;
 			clock-frequency = <19200000>;
 
@@ -1213,49 +1213,49 @@ frame@17421000 {
 				frame-number = <0>;
 				interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
 					     <GIC_SPI 6 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17421000 0x0 0x1000>,
-				      <0x0 0x17422000 0x0 0x1000>;
+				reg = <0x17421000 0x1000>,
+				      <0x17422000 0x1000>;
 			};
 
 			frame@17423000 {
 				frame-number = <1>;
 				interrupts = <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17423000 0x0 0x1000>;
+				reg = <0x17423000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17425000 {
 				frame-number = <2>;
 				interrupts = <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17425000 0x0 0x1000>;
+				reg = <0x17425000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17427000 {
 				frame-number = <3>;
 				interrupts = <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17427000 0x0 0x1000>;
+				reg = <0x17427000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@17429000 {
 				frame-number = <4>;
 				interrupts = <GIC_SPI 12 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x17429000 0x0 0x1000>;
+				reg = <0x17429000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@1742b000 {
 				frame-number = <5>;
 				interrupts = <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x1742b000 0x0 0x1000>;
+				reg = <0x1742b000 0x1000>;
 				status = "disabled";
 			};
 
 			frame@1742d000 {
 				frame-number = <6>;
 				interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
-				reg = <0x0 0x1742d000 0x0 0x1000>;
+				reg = <0x1742d000 0x1000>;
 				status = "disabled";
 			};
 		};
-- 
2.35.1



