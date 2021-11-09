Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A520644B598
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245481AbhKIWVg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:21:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:41654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245697AbhKIWUt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:20:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AD13611C9;
        Tue,  9 Nov 2021 22:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496266;
        bh=RDmwiYO4HkITLfoI+bA/V+iudDN6wtg8El5W0Y6qSFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dkyqz9/OFR+9aOtfhfINuRgnTy6sLoEy8tjJkFjyAlcoUQGBYE/9CtZ4R4gX5hrEo
         ewxPrN/oaKcPYNnbUntaLJXyOezXSsjtg9z8H7FjX286xPLvxOBLAAIisJ4twLh/Kn
         e9z9AlDwL7fime+ufTS3Oxzufx6HjiLChNYFh1vpBEs1wXkuWuzu1bIio4wdKDtoTF
         qZKh221QXUl8nJ2LjfI5/SHtlwGhpaVdQjY4iLwxNxCJkfKEN5un5Qg+0YBXs8u0yE
         N+1aoc0ucORb/aZMEBdB9HGf3pJmhvn4dhb6qUHbJQnvZY+vVaqH92vtNntfOGcCz+
         1yuHdjPu5wcdQ==
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
Subject: [PATCH AUTOSEL 5.15 32/82] arm64: dts: qcom: msm8916: Add unit name for /soc node
Date:   Tue,  9 Nov 2021 17:15:50 -0500
Message-Id: <20211109221641.1233217-32-sashal@kernel.org>
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
index 3f85e34a8ce6f..7c656bde927f7 100644
--- a/arch/arm64/boot/dts/qcom/msm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916.dtsi
@@ -414,7 +414,7 @@
 		};
 	};
 
-	soc: soc {
+	soc: soc@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
 		ranges = <0 0 0 0xffffffff>;
-- 
2.33.0

