Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C82A44B592
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240745AbhKIWVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:21:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:41598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245665AbhKIWUr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:20:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B714E6162E;
        Tue,  9 Nov 2021 22:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496263;
        bh=kTJkctlIB7qi4umI2Ug4hRWDczQzGgxoWdw6dcLY4v0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JGjLGBrj3yr4bpidgGkZeiSEwYPWOon3FrEUOPHoQ+gZMfrAbgO7qUjZX2hyNu0ke
         jzMx3aqHO749ZroxIOKFCqfB4LuWiSyVQ0rcKRfMtW51D1nX8bSZfioKy+6ooLpVgj
         Q0+BvhNUyHC8/WOc5k6+M9f3zYlZSxOquZ2XnSAo+9q2h6iAn91zh2tPDWgiRfVIkT
         CWgihKBrOxNMayv07agbhViEwgil2TdOkrGLGdr9Yal62bKRonRYE3fzFr0e2dNziX
         2+pLLktbhjlbLLtzTi1B/UK2PBbBKtRHMr36q682gM5p2EcNbHSE6PBWs7Ak+ZUUfd
         It6mRxq6GgC/Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shawn Guo <shawn.guo@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 30/82] arm64: dts: qcom: ipq8074: Fix qcom,controlled-remotely property
Date:   Tue,  9 Nov 2021 17:15:48 -0500
Message-Id: <20211109221641.1233217-30-sashal@kernel.org>
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

From: Shawn Guo <shawn.guo@linaro.org>

[ Upstream commit 8c97f0ac4dc8f1743eb8e8a49f66189e13ae45e9 ]

Property qcom,controlled-remotely should be boolean.  Fix it.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210829111628.5543-3-shawn.guo@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq8074.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq8074.dtsi b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
index db333001df4d6..97f99663c132e 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
@@ -220,7 +220,7 @@
 			clock-names = "bam_clk";
 			#dma-cells = <1>;
 			qcom,ee = <1>;
-			qcom,controlled-remotely = <1>;
+			qcom,controlled-remotely;
 			status = "disabled";
 		};
 
-- 
2.33.0

