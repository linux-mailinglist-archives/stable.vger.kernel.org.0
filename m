Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81D291FE4CE
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728818AbgFRBSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:18:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729997AbgFRBSn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:18:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7F7521D7E;
        Thu, 18 Jun 2020 01:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443123;
        bh=iJLj1a92L/XXEgvAOBI4sMQdUEW6CU5xEvBS+HESanE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HJ7PzburPzm/pmVV4L39O2fDSAYne9kHtuqQIqZYWvRqg6LIxvRJc2cn4bFFRfxEC
         ImIfEqbt6T268963E9IYmI5O7LaDy7Tb1ImfQ+pw8zzqGOEy5mkIFgpLSMxin6ppEy
         EHCaJXkyoqxHZDUJGKT8RzBUQwT1+RRfYVS/GW/E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jonathan Marek <jonathan@marek.ca>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 097/266] arm64: dts: qcom: fix pm8150 gpio interrupts
Date:   Wed, 17 Jun 2020 21:13:42 -0400
Message-Id: <20200618011631.604574-97-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Marek <jonathan@marek.ca>

[ Upstream commit 61d2ca503d0b55d2849fd656ce51d8e1e9ba0b6c ]

This was mistakenly copied from the downstream dts, however the upstream
driver works differently.

I only tested this with the pm8150_gpios node (used with volume button),
but the 2 others should be the same.

Fixes: e92b61c8e775 ("arm64: dts: qcom: pm8150l: Add base dts file")
Fixes: 229d5bcad0d0 ("arm64: dts: qcom: pm8150b: Add base dts file")
Fixes: 5101f22a5c37 ("arm64: dts: qcom: pm8150: Add base dts file")
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Link: https://lore.kernel.org/r/20200420153543.14512-1-jonathan@marek.ca
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/pm8150.dtsi  | 14 ++------------
 arch/arm64/boot/dts/qcom/pm8150b.dtsi | 14 ++------------
 arch/arm64/boot/dts/qcom/pm8150l.dtsi | 14 ++------------
 3 files changed, 6 insertions(+), 36 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/pm8150.dtsi b/arch/arm64/boot/dts/qcom/pm8150.dtsi
index b6e304748a57..c0b197458665 100644
--- a/arch/arm64/boot/dts/qcom/pm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/pm8150.dtsi
@@ -73,18 +73,8 @@ pm8150_gpios: gpio@c000 {
 			reg = <0xc000>;
 			gpio-controller;
 			#gpio-cells = <2>;
-			interrupts = <0x0 0xc0 0x0 IRQ_TYPE_NONE>,
-				     <0x0 0xc1 0x0 IRQ_TYPE_NONE>,
-				     <0x0 0xc2 0x0 IRQ_TYPE_NONE>,
-				     <0x0 0xc3 0x0 IRQ_TYPE_NONE>,
-				     <0x0 0xc4 0x0 IRQ_TYPE_NONE>,
-				     <0x0 0xc5 0x0 IRQ_TYPE_NONE>,
-				     <0x0 0xc6 0x0 IRQ_TYPE_NONE>,
-				     <0x0 0xc7 0x0 IRQ_TYPE_NONE>,
-				     <0x0 0xc8 0x0 IRQ_TYPE_NONE>,
-				     <0x0 0xc9 0x0 IRQ_TYPE_NONE>,
-				     <0x0 0xca 0x0 IRQ_TYPE_NONE>,
-				     <0x0 0xcb 0x0 IRQ_TYPE_NONE>;
+			interrupt-controller;
+			#interrupt-cells = <2>;
 		};
 	};
 
diff --git a/arch/arm64/boot/dts/qcom/pm8150b.dtsi b/arch/arm64/boot/dts/qcom/pm8150b.dtsi
index 322379d5c31f..40b5d75a4a1d 100644
--- a/arch/arm64/boot/dts/qcom/pm8150b.dtsi
+++ b/arch/arm64/boot/dts/qcom/pm8150b.dtsi
@@ -62,18 +62,8 @@ pm8150b_gpios: gpio@c000 {
 			reg = <0xc000>;
 			gpio-controller;
 			#gpio-cells = <2>;
-			interrupts = <0x2 0xc0 0x0 IRQ_TYPE_NONE>,
-				     <0x2 0xc1 0x0 IRQ_TYPE_NONE>,
-				     <0x2 0xc2 0x0 IRQ_TYPE_NONE>,
-				     <0x2 0xc3 0x0 IRQ_TYPE_NONE>,
-				     <0x2 0xc4 0x0 IRQ_TYPE_NONE>,
-				     <0x2 0xc5 0x0 IRQ_TYPE_NONE>,
-				     <0x2 0xc6 0x0 IRQ_TYPE_NONE>,
-				     <0x2 0xc7 0x0 IRQ_TYPE_NONE>,
-				     <0x2 0xc8 0x0 IRQ_TYPE_NONE>,
-				     <0x2 0xc9 0x0 IRQ_TYPE_NONE>,
-				     <0x2 0xca 0x0 IRQ_TYPE_NONE>,
-				     <0x2 0xcb 0x0 IRQ_TYPE_NONE>;
+			interrupt-controller;
+			#interrupt-cells = <2>;
 		};
 	};
 
diff --git a/arch/arm64/boot/dts/qcom/pm8150l.dtsi b/arch/arm64/boot/dts/qcom/pm8150l.dtsi
index eb0e9a090e42..cf05e0685d10 100644
--- a/arch/arm64/boot/dts/qcom/pm8150l.dtsi
+++ b/arch/arm64/boot/dts/qcom/pm8150l.dtsi
@@ -56,18 +56,8 @@ pm8150l_gpios: gpio@c000 {
 			reg = <0xc000>;
 			gpio-controller;
 			#gpio-cells = <2>;
-			interrupts = <0x4 0xc0 0x0 IRQ_TYPE_NONE>,
-				     <0x4 0xc1 0x0 IRQ_TYPE_NONE>,
-				     <0x4 0xc2 0x0 IRQ_TYPE_NONE>,
-				     <0x4 0xc3 0x0 IRQ_TYPE_NONE>,
-				     <0x4 0xc4 0x0 IRQ_TYPE_NONE>,
-				     <0x4 0xc5 0x0 IRQ_TYPE_NONE>,
-				     <0x4 0xc6 0x0 IRQ_TYPE_NONE>,
-				     <0x4 0xc7 0x0 IRQ_TYPE_NONE>,
-				     <0x4 0xc8 0x0 IRQ_TYPE_NONE>,
-				     <0x4 0xc9 0x0 IRQ_TYPE_NONE>,
-				     <0x4 0xca 0x0 IRQ_TYPE_NONE>,
-				     <0x4 0xcb 0x0 IRQ_TYPE_NONE>;
+			interrupt-controller;
+			#interrupt-cells = <2>;
 		};
 	};
 
-- 
2.25.1

