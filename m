Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAEF44B690
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236605AbhKIW2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:28:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:50982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344104AbhKIW0w (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:26:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8088E61A4F;
        Tue,  9 Nov 2021 22:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496394;
        bh=w+4Bs9R4K3n/crljo1SdSWzZieTF0os7KzwVd+iDamk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iNZUmSuVW3N2AWyf62yw3qpBfvAEqew8ADL74zWrpE85SG1j7ifMChY+52m+oXQse
         AMo9f5l2QaDR8ks7F2E2/Ey0R3wZua4XQHNbbQlv6nS5s8oHy5HJYKb7EYS2G0Q6n9
         K7mcY1zt/lI+K1VgmZVeMfMHvZ7SHpll5CnbnY9ca2aTNNJu/mPVtugl/6Vi3wIfO0
         TZlLkiiOhq+tFibPinlkJJMbki0g4Jo5WrGc8GjdoH+s/Bl5MGV1Wg85Tk+z81jB+y
         8XxM/CRzev+5mfS5vuH2cMUs7Ryai6r6G6MQyGfwoPhoU0B2Nlds1mQ1nnrell+M9K
         BkKJcPts+QVeA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shawn Guo <shawn.guo@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.14 28/75] arm64: dts: qcom: sdm845: Fix qcom,controlled-remotely property
Date:   Tue,  9 Nov 2021 17:18:18 -0500
Message-Id: <20211109221905.1234094-28-sashal@kernel.org>
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

From: Shawn Guo <shawn.guo@linaro.org>

[ Upstream commit 1c8bf398b6b51eb085a49036ad8f9c000171cce1 ]

Property qcom,controlled-remotely should be boolean.  Fix it.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210829111628.5543-4-shawn.guo@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index 0a86fe71a66d1..56e71106fb537 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -2320,7 +2320,7 @@
 			clock-names = "bam_clk";
 			#dma-cells = <1>;
 			qcom,ee = <0>;
-			qcom,controlled-remotely = <1>;
+			qcom,controlled-remotely;
 			iommus = <&apps_smmu 0x704 0x1>,
 				 <&apps_smmu 0x706 0x1>,
 				 <&apps_smmu 0x714 0x1>,
-- 
2.33.0

