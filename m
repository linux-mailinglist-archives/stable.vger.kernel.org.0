Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E73C44B7E5
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239600AbhKIWjI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:39:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:56632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238194AbhKIWgM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:36:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42ED9619E8;
        Tue,  9 Nov 2021 22:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496563;
        bh=zhOUR5eBmmE/KSTcstVZXg+nI/BUaA1923/70sCiLjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YTxrcpRRRMBKzQSj7Gmnm87Y/wpADycJ/Att4y1LHbaa8kchjsVX0JlBZDOeZrRo1
         ALsuwwcrSNfHVqAyeVC9Y0cg5/muQTPTXU0njHUaYcBhFPfl4iXc/XYp9izafJCVIj
         llV/9uIxijVWuvwTLRiSt7/UJ2ihRBfxNblQUyUeKxiYCrkif2XIIsMjq/V6yaldMF
         KmVwMevLslcPEUF8oau4mE+zJdr70Qy2g89n6HA8Y9ysHyA2HGyLzETLOLdclbguak
         j+auz3Jt8iV+xyx95G6qgwH5DaX5tFIUWheznFEKAOuwboYm8fbQG7zHo4aw5GjuJS
         /xaqaNEndtH5w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephan Gerhold <stephan@gerhold.net>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 11/30] arm64: dts: qcom: msm8916: Add unit name for /soc node
Date:   Tue,  9 Nov 2021 17:22:05 -0500
Message-Id: <20211109222224.1235388-11-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222224.1235388-1-sashal@kernel.org>
References: <20211109222224.1235388-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit 7a62bfebc8c94bdb6eb8f54f49889dc6b5b79601 ]

This fixes the following warning when building with W=1:
Warning (unit_address_vs_reg): /soc: node has a reg or ranges property,
but no unit name

Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210921152120.6710-1-stephan@gerhold.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8916.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8916.dtsi b/arch/arm64/boot/dts/qcom/msm8916.dtsi
index 449843f2184d8..1063f64f73ca4 100644
--- a/arch/arm64/boot/dts/qcom/msm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916.dtsi
@@ -358,7 +358,7 @@
 		};
 	};
 
-	soc: soc {
+	soc: soc@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
 		ranges = <0 0 0 0xffffffff>;
-- 
2.33.0

