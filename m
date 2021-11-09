Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A414744B77E
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344547AbhKIWfQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:35:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:55748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345124AbhKIWd3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:33:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B123861AA8;
        Tue,  9 Nov 2021 22:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496503;
        bh=g+IK4tugMcqN/w2rXb8kU9s+3UO5IS4HgrSzRgfbPfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j9iI81yIKe2kk7KGXrEpER0AqDcRhOpLBkiLtlyklCkKZ+luF9qb88f853BMV2hHU
         U+owvSf9v7LrqHjkUIr0nKab9kmE8h0DZmIgay+3BW1qSHEZr9yEnctbK5W64VndAr
         i95G2gWfAz8eS4Pl/AY4OYGPdiHXug2e92aOi5NXpVqhf8eJUUwuUpF/pFB2gJqSoi
         sp5gAAQYZ/0Bbi2pUzQZpuGVjOT6goe8LQ+y1pbhvTHFhgmOjIriTuCC6UG2IxwM1n
         NDxk/iIRPzIXRV9lBUBJJwajIFeicQZx1ZeXcK5B6hOlHTnVsLUW2ETi1Apo2cWr4G
         6zJVBWDP7fNog==
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
Subject: [PATCH AUTOSEL 5.10 23/50] arm64: dts: qcom: msm8916: Add unit name for /soc node
Date:   Tue,  9 Nov 2021 17:20:36 -0500
Message-Id: <20211109222103.1234885-23-sashal@kernel.org>
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
index 0e34ed48b9fae..277f9e8a281ad 100644
--- a/arch/arm64/boot/dts/qcom/msm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916.dtsi
@@ -384,7 +384,7 @@
 		};
 	};
 
-	soc: soc {
+	soc: soc@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
 		ranges = <0 0 0 0xffffffff>;
-- 
2.33.0

