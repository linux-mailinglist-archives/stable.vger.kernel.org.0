Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15FA44B596
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343837AbhKIWVe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:21:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:40914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245694AbhKIWUt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:20:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 660896152A;
        Tue,  9 Nov 2021 22:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496264;
        bh=AtPmvg4tSzhdcAs+DDit6hV1uneoZd06J3tJ2IKjhok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T7LhnRSPKn8yM1CDoDEOSh/8P/FHBrFFbGaCRmHwyP+INUThsByV+5w8VA37oBqe8
         q0ZJS3WZjhMMDtRkkyvLMKnL/dMshKTN9s/bCA4AIGEOh/Cqkdk8ktIbMY56XilAB/
         s1GhnDS5u8+Nrh9Ch7ijYzW5E6410qvCjMk2jbcyqYgjd9sWmRC2jhj5721f4wNsjl
         rfzozWoOQ+bIPWj9Mcq2C6mvSe2RgGj2q4d2F72xp4ctrbd4vFhurmJL0rQXBiYxdS
         I4uGB0SnZ9jruyhhRnwsyDuNwomoEkjYXDP+IVdQnTPNiWSdsZw3Qdo+m7qdDjevGR
         cHxIU9tp4xM8A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shawn Guo <shawn.guo@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 31/82] arm64: dts: qcom: sdm845: Fix qcom,controlled-remotely property
Date:   Tue,  9 Nov 2021 17:15:49 -0500
Message-Id: <20211109221641.1233217-31-sashal@kernel.org>
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
index b3b9119261844..23ec00a6264bf 100644
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

