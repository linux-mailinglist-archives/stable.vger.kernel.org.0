Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5A1C44B593
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343827AbhKIWVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:21:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:40832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245662AbhKIWUr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:20:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E62261502;
        Tue,  9 Nov 2021 22:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496261;
        bh=SYD5ZipJa5WF41gMUTj1a17w9sTSlV8llQ2Krnb/aA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=leZ1/VrtAIxsUtB/2PSXL2XMH2Cn6G8iRy7KvffMuKzutn1mMGU9JKaw4pfsox4Eq
         hBED85VdGVTo+juj9SuMAvCYX8B8eC34df5sNAULQBFCbZ+SCqH+fnG3MuSZbgfaOH
         rxt/GiuykI4lChSbmuwNha8B2AEZgWs7ezCf/4jz+G1ZzBX4VlbC5CqU4WYdce3wjt
         6cceUJJHZI6PL6wP9n/cA12BS8TABgggVESu18mBJpI+I43bB0Sgwr615InOWwPkEg
         dp53m4fUzStMkkch84ZvVGM4tanp3oc4b1oUFA4W8UssyxwwdcTWSpvHfXMiaBfjX0
         aZa+eD33CnXpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shawn Guo <shawn.guo@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 29/82] arm64: dts: qcom: ipq6018: Fix qcom,controlled-remotely property
Date:   Tue,  9 Nov 2021 17:15:47 -0500
Message-Id: <20211109221641.1233217-29-sashal@kernel.org>
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

[ Upstream commit 3509de752ea14c7e5781b3a56a4a0bf832f5723a ]

Property qcom,controlled-remotely should be boolean.  Fix it.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210829111628.5543-2-shawn.guo@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq6018.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq6018.dtsi b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
index d2fe58e0eb7aa..7b6205c180df1 100644
--- a/arch/arm64/boot/dts/qcom/ipq6018.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
@@ -200,7 +200,7 @@
 			clock-names = "bam_clk";
 			#dma-cells = <1>;
 			qcom,ee = <1>;
-			qcom,controlled-remotely = <1>;
+			qcom,controlled-remotely;
 			qcom,config-pipe-trust-reg = <0>;
 		};
 
-- 
2.33.0

