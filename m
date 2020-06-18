Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF8F1FE790
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732865AbgFRCmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:42:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728861AbgFRBMJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:12:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3495D20EDD;
        Thu, 18 Jun 2020 01:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442729;
        bh=NznlWfKmX/UWHufbw5kvuUbn4Bkrlk5WDFiJ3oJ4Oiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GhFk5Dw0u3OhnRJAuo5JKURn61Kt0+tpOt2QLMPMBbWiG3RRl5st+Kdh7HFLw+/YP
         BdrCVxuSfYsoWZz4kGel5cB4+Gi+JxIZs/9P+ZuX/MUFxwdm1V12mgdcQvUc0OuvxD
         dD2f1eWzi8k7hg7TvbAkSG2+x3AyYtIQCEF4lBVg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 185/388] arm64: dts: msm8996: Fix CSI IRQ types
Date:   Wed, 17 Jun 2020 21:04:42 -0400
Message-Id: <20200618010805.600873-185-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Loic Poulain <loic.poulain@linaro.org>

[ Upstream commit 4a4a26317ec8aba575f6b85789a42639937bc1a4 ]

Each IRQ_TYPE_NONE interrupt causes a warning at boot.
Fix that by defining an appropriate type.

Fixes: e0531312e78f ("arm64: dts: qcom: msm8996: Add CAMSS support")
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Link: https://lore.kernel.org/r/1587470425-13726-1-git-send-email-loic.poulain@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8996.dtsi | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index 98634d5c4440..d22c364b520a 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -989,16 +989,16 @@ camss: camss@a00000 {
 				"csi_clk_mux",
 				"vfe0",
 				"vfe1";
-			interrupts = <GIC_SPI 78 0>,
-				<GIC_SPI 79 0>,
-				<GIC_SPI 80 0>,
-				<GIC_SPI 296 0>,
-				<GIC_SPI 297 0>,
-				<GIC_SPI 298 0>,
-				<GIC_SPI 299 0>,
-				<GIC_SPI 309 0>,
-				<GIC_SPI 314 0>,
-				<GIC_SPI 315 0>;
+			interrupts = <GIC_SPI 78 IRQ_TYPE_EDGE_RISING>,
+				<GIC_SPI 79 IRQ_TYPE_EDGE_RISING>,
+				<GIC_SPI 80 IRQ_TYPE_EDGE_RISING>,
+				<GIC_SPI 296 IRQ_TYPE_EDGE_RISING>,
+				<GIC_SPI 297 IRQ_TYPE_EDGE_RISING>,
+				<GIC_SPI 298 IRQ_TYPE_EDGE_RISING>,
+				<GIC_SPI 299 IRQ_TYPE_EDGE_RISING>,
+				<GIC_SPI 309 IRQ_TYPE_EDGE_RISING>,
+				<GIC_SPI 314 IRQ_TYPE_EDGE_RISING>,
+				<GIC_SPI 315 IRQ_TYPE_EDGE_RISING>;
 			interrupt-names = "csiphy0",
 				"csiphy1",
 				"csiphy2",
-- 
2.25.1

