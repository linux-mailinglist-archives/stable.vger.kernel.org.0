Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A27844B62C
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344187AbhKIWZa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:25:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:41662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344342AbhKIWXZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:23:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DA71611C9;
        Tue,  9 Nov 2021 22:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496330;
        bh=YnSUH4i92y3wsbYvZQr2aBVb4zHiBKZF4DdXLYi017w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hUAFKsPA1Jhmmep97CfgQJveZvTfuDMiauNQaIAEjiBfdMK0MZtKF5869qmF5Aqbr
         6yfaRzRI8skf2k1otnyl7zC0bJLUoH03QDRcsOkc4zE1aLA4IDc8KFoOgB/iLntvlk
         t1jteDWTsnrl4txDIJokCwIzTq58BL106dob7XfswS2sRIIlvUcxiOdyTTSh4nNSSb
         1hPKYfZJ1k6OuQR5/PZtLQuvbQE55pOQD86oURy5StvdHpXEE2AvFrucOP50sc0VXg
         daXEqdINAJ9P8dEiW10x0U6ed3fnHxphBlfDdwMUVkKUwASewpVTy+6hNBugAEdzCE
         Ury+QS+AWhVGQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Heidelberg <david@ixit.cz>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 74/82] ARM: dts: qcom: fix memory and mdio nodes naming for RB3011
Date:   Tue,  9 Nov 2021 17:16:32 -0500
Message-Id: <20211109221641.1233217-74-sashal@kernel.org>
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

From: David Heidelberg <david@ixit.cz>

[ Upstream commit 14a1f6c9d8017ffbf388e82e1a1f023196d98612 ]

Fixes warnings regarding to memory and mdio nodes and
apply new naming following dt-schema.

Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20211020214741.261509-1-david@ixit.cz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-ipq8064-rb3011.dts | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-ipq8064-rb3011.dts b/arch/arm/boot/dts/qcom-ipq8064-rb3011.dts
index f7ea2e5dd1914..971d2e2292600 100644
--- a/arch/arm/boot/dts/qcom-ipq8064-rb3011.dts
+++ b/arch/arm/boot/dts/qcom-ipq8064-rb3011.dts
@@ -19,12 +19,12 @@
 		stdout-path = "serial0:115200n8";
 	};
 
-	memory@0 {
+	memory@42000000 {
 		reg = <0x42000000 0x3e000000>;
 		device_type = "memory";
 	};
 
-	mdio0: mdio@0 {
+	mdio0: mdio-0 {
 		status = "okay";
 		compatible = "virtual,mdio-gpio";
 		gpios = <&qcom_pinmux 1 GPIO_ACTIVE_HIGH>,
@@ -91,7 +91,7 @@
 		};
 	};
 
-	mdio1: mdio@1 {
+	mdio1: mdio-1 {
 		status = "okay";
 		compatible = "virtual,mdio-gpio";
 		gpios = <&qcom_pinmux 11 GPIO_ACTIVE_HIGH>,
-- 
2.33.0

