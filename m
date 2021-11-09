Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54D5444B62A
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344193AbhKIWZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:25:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:41760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344366AbhKIWX2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:23:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A31F56152A;
        Tue,  9 Nov 2021 22:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496333;
        bh=u9lcDjWyBGUbuieQbADVPuw7NpTyX3Tab5S9QV3nZEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zkp2OHtKwMeVKNlQleVZQFBFOKE7XlDhoA12mX3Bru891JfhLKR1IkKk1kPNA+z4U
         TAJPc7SZ2wiI3EpdVGAicWz/xmJULRsd6Rqq/ajCFphxQPS+bzj1XWa+dpc7qJ2FJa
         3LzMH2k1g4Xa50mjDSM513GKoUIweubxczw0fO8AG3FvS+fnqojY+ZI6JHyy5fX6SA
         P2Xuk7e5zC0XLKbIxwBoT5OuZyA9TAHFDsyYDJHZQb0nRI9QkRy6KT1uZITCVRYPg2
         kD7sNrHCckqT+44XOH/FScN16rnm0On9R+8cS7ZnEfzHE0/aCfcgIVwBA9d+X2PxsU
         iNJHqTOwsRX/g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephan Gerhold <stephan@gerhold.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 75/82] arm64: dts: qcom: Fix node name of rpm-msg-ram device nodes
Date:   Tue,  9 Nov 2021 17:16:33 -0500
Message-Id: <20211109221641.1233217-75-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221641.1233217-1-sashal@kernel.org>
References: <20211109221641.1233217-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit 179811bebc7b91e0f9d0adee9bfa3d2af9c43869 ]

According to the new DT schema for qcom,rpm-msg-ram the node name
should be sram@. memory@ is reserved for definition of physical RAM
(usable by Linux).

This fixes the following dtbs_check error on various device trees:
memory@60000: 'device_type' is a required property
        From schema: dtschema/schemas/memory.yaml

Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20211018110009.30837-1-stephan@gerhold.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8916.dtsi | 2 +-
 arch/arm64/boot/dts/qcom/msm8994.dtsi | 2 +-
 arch/arm64/boot/dts/qcom/msm8996.dtsi | 2 +-
 arch/arm64/boot/dts/qcom/msm8998.dtsi | 2 +-
 arch/arm64/boot/dts/qcom/qcs404.dtsi  | 2 +-
 arch/arm64/boot/dts/qcom/sdm630.dtsi  | 2 +-
 arch/arm64/boot/dts/qcom/sm6125.dtsi  | 2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8916.dtsi b/arch/arm64/boot/dts/qcom/msm8916.dtsi
index c9467665250e7..b9d465b578760 100644
--- a/arch/arm64/boot/dts/qcom/msm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916.dtsi
@@ -453,7 +453,7 @@
 			};
 		};
 
-		rpm_msg_ram: memory@60000 {
+		rpm_msg_ram: sram@60000 {
 			compatible = "qcom,rpm-msg-ram";
 			reg = <0x00060000 0x8000>;
 		};
diff --git a/arch/arm64/boot/dts/qcom/msm8994.dtsi b/arch/arm64/boot/dts/qcom/msm8994.dtsi
index 986fe60dec5fb..5a9a5ed0565f6 100644
--- a/arch/arm64/boot/dts/qcom/msm8994.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8994.dtsi
@@ -715,7 +715,7 @@
 			reg = <0xfc400000 0x2000>;
 		};
 
-		rpm_msg_ram: memory@fc428000 {
+		rpm_msg_ram: sram@fc428000 {
 			compatible = "qcom,rpm-msg-ram";
 			reg = <0xfc428000 0x4000>;
 		};
diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index 52df22ab3f6ae..f8d28dd76cfa8 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -638,7 +638,7 @@
 			};
 		};
 
-		rpm_msg_ram: memory@68000 {
+		rpm_msg_ram: sram@68000 {
 			compatible = "qcom,rpm-msg-ram";
 			reg = <0x00068000 0x6000>;
 		};
diff --git a/arch/arm64/boot/dts/qcom/msm8998.dtsi b/arch/arm64/boot/dts/qcom/msm8998.dtsi
index 5a221cfc41387..228339f81c327 100644
--- a/arch/arm64/boot/dts/qcom/msm8998.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998.dtsi
@@ -861,7 +861,7 @@
 			reg = <0x00100000 0xb0000>;
 		};
 
-		rpm_msg_ram: memory@778000 {
+		rpm_msg_ram: sram@778000 {
 			compatible = "qcom,rpm-msg-ram";
 			reg = <0x00778000 0x7000>;
 		};
diff --git a/arch/arm64/boot/dts/qcom/qcs404.dtsi b/arch/arm64/boot/dts/qcom/qcs404.dtsi
index 339790ba585de..ca5be16479809 100644
--- a/arch/arm64/boot/dts/qcom/qcs404.dtsi
+++ b/arch/arm64/boot/dts/qcom/qcs404.dtsi
@@ -318,7 +318,7 @@
 			status = "disabled";
 		};
 
-		rpm_msg_ram: memory@60000 {
+		rpm_msg_ram: sram@60000 {
 			compatible = "qcom,rpm-msg-ram";
 			reg = <0x00060000 0x6000>;
 		};
diff --git a/arch/arm64/boot/dts/qcom/sdm630.dtsi b/arch/arm64/boot/dts/qcom/sdm630.dtsi
index 9c7f87e42fccd..a8724fd60645f 100644
--- a/arch/arm64/boot/dts/qcom/sdm630.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm630.dtsi
@@ -541,7 +541,7 @@
 					<&sleep_clk>;
 		};
 
-		rpm_msg_ram: memory@778000 {
+		rpm_msg_ram: sram@778000 {
 			compatible = "qcom,rpm-msg-ram";
 			reg = <0x00778000 0x7000>;
 		};
diff --git a/arch/arm64/boot/dts/qcom/sm6125.dtsi b/arch/arm64/boot/dts/qcom/sm6125.dtsi
index 2b37ce6a9f9c5..9f476e3d0720b 100644
--- a/arch/arm64/boot/dts/qcom/sm6125.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6125.dtsi
@@ -380,7 +380,7 @@
 			status = "disabled";
 		};
 
-		rpm_msg_ram: memory@45f0000 {
+		rpm_msg_ram: sram@45f0000 {
 			compatible = "qcom,rpm-msg-ram";
 			reg = <0x045f0000 0x7000>;
 		};
-- 
2.33.0

