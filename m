Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06C13205CE1
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388453AbgFWUGT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:06:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388450AbgFWUGS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:06:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C08812064B;
        Tue, 23 Jun 2020 20:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942778;
        bh=NUV7KWqtjBx+rwaxIhAbNyWL2HuwPznETRhWqAOl53E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ep3CgSYPW26WRSZvM/4i3vbmbch0XMSOjAhmODW++Xx3g6ZL7WuuPjAen2rVIjUOq
         z+M36lzCRcgwdhs8dw//3CCK66szSM2f2BUi+sS2lRwleMW0rFTddQFZEc5jRuFw5g
         WfgaahTMMGy8FG2tmJYFZXgqt/EAfStXIjN1LFU0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Jonathan Marek <jonathan@marek.ca>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 130/477] arm64: dts: qcom: fix pm8150 gpio interrupts
Date:   Tue, 23 Jun 2020 21:52:07 +0200
Message-Id: <20200623195413.751145369@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b6e304748a576..c0b197458665d 100644
--- a/arch/arm64/boot/dts/qcom/pm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/pm8150.dtsi
@@ -73,18 +73,8 @@
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
index 322379d5c31f9..40b5d75a4a1dc 100644
--- a/arch/arm64/boot/dts/qcom/pm8150b.dtsi
+++ b/arch/arm64/boot/dts/qcom/pm8150b.dtsi
@@ -62,18 +62,8 @@
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
index eb0e9a090e420..cf05e0685d101 100644
--- a/arch/arm64/boot/dts/qcom/pm8150l.dtsi
+++ b/arch/arm64/boot/dts/qcom/pm8150l.dtsi
@@ -56,18 +56,8 @@
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



