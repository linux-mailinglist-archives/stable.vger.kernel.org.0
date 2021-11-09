Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB19144B775
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345098AbhKIWfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:35:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:55112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344751AbhKIWcu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:32:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED6F661ABF;
        Tue,  9 Nov 2021 22:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496501;
        bh=t6AzhWTFVPennLsUMaqa2vYkOYQZYqkGok37nqKV0Xg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VnNnaxWSyHET+ORaPGct5Ocj8gGct5uXZ03zdwlH8ha+67rRIeBVZlY/lmsSOHdzu
         BhbUINI30H8IeEB139Gjp1VS0yRzSpLEWsownPOOeTvHrQwYynKh0g65W9cNa1KPA7
         a/S34bfle4jRK161NQQa8lbJa+FIy56Xq2V78Ntr7WH30IrsEJHttAvziqB6IehqbD
         A1jSdssfM9tSY3H/jFkP9LPEUH9x7cxeAuE0V0PdtXcOIFAXVstEReV+1S+gXk3W82
         dCsOWQBMs1OtBO7sB16FTLHfIwsJmYVieirXYS9oR94WFSCNa+mzUctiUnix4nWGqE
         7KwP2g9PtuyNA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shawn Guo <shawn.guo@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 22/50] arm64: dts: qcom: ipq6018: Fix qcom,controlled-remotely property
Date:   Tue,  9 Nov 2021 17:20:35 -0500
Message-Id: <20211109222103.1234885-22-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222103.1234885-1-sashal@kernel.org>
References: <20211109222103.1234885-1-sashal@kernel.org>
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
index 3ceb36cac512f..9cb8f7a052df9 100644
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

