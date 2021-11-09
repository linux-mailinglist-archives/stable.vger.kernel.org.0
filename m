Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 603A944B72B
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344620AbhKIWcf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:32:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:51090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344686AbhKIWad (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:30:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACB4A6134F;
        Tue,  9 Nov 2021 22:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496453;
        bh=YnSUH4i92y3wsbYvZQr2aBVb4zHiBKZF4DdXLYi017w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d+vjipqVsD9N7wdmWuvanQOYF0YfqjQVDUIIwcHtbry9e3V9Ji/uuK4Jv0m8QAud/
         nsbjRJONAU0SOibp/Xy7wUev3Io7UT/TrRIgV2xl9663w7fnRyTxBlb+ZNKi5m2lLv
         /vlKywS0wPrRFYt80ILH8Zf95kDOkWg7t3olmq/cnKNF8BACQbpP5gpISGMlLjAASt
         t4ndupDZKbmnm2CNaIoZLmRYQ6BzVsvr73ovifq/bCcmji99a0c1x3Xu+QrXI8ebYZ
         KiF9YzOElo7KAJbGZuzUGYcb1GznI3ToMenyM+fPLIGxzcWfnbkgoMG80wPByDsO45
         uxiHzfT+Nj/Rg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Heidelberg <david@ixit.cz>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.14 69/75] ARM: dts: qcom: fix memory and mdio nodes naming for RB3011
Date:   Tue,  9 Nov 2021 17:18:59 -0500
Message-Id: <20211109221905.1234094-69-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221905.1234094-1-sashal@kernel.org>
References: <20211109221905.1234094-1-sashal@kernel.org>
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

