Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9F1944B884
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345632AbhKIWow (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:44:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:34964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241405AbhKIWmN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:42:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E90F961B3C;
        Tue,  9 Nov 2021 22:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496650;
        bh=u/I56GRwtTcKSHg3nKUPUeSkPN08FMTItD1vbc3pHDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WrEeZIh+AzbUxILdQMDZ3/IWD4V9xyUieYcEu1bEPJ7pjYbaSKgBNHxzRYXN57A/s
         aPS6Ss+TIYTevlv+3sU4QzJL5NfFASSQguJm+IeHuhKd1tKjGiPZafp/wsUvgVxqt6
         zF93qZJzpkue2+U8PIpsVL4szZc2b59W0k7j4851tzrFTy79wLtqrNmoLPLPtRhL0j
         0Qd6IJoqbF//0Wt+ec0AM/ENT9xy9ifmJNuLgitaEY9Ctpyy0wvVaEbCSIAYGWWraD
         vwyKEBgK7qKA1ftKIHElOOIXZ5FYarriqT42V76IkVcXXvJxn+iwPLXIPpLuGEP4dS
         FL+ThU4c6iBvw==
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
Subject: [PATCH AUTOSEL 4.9 03/13] arm64: dts: qcom: msm8916: Add unit name for /soc node
Date:   Tue,  9 Nov 2021 17:23:54 -0500
Message-Id: <20211109222405.1236040-3-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222405.1236040-1-sashal@kernel.org>
References: <20211109222405.1236040-1-sashal@kernel.org>
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
index c2557cf43b3dc..eb806e73d598b 100644
--- a/arch/arm64/boot/dts/qcom/msm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916.dtsi
@@ -243,7 +243,7 @@
 		};
 	};
 
-	soc: soc {
+	soc: soc@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
 		ranges = <0 0 0 0xffffffff>;
-- 
2.33.0

