Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49CC444B6B6
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344359AbhKIW30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:29:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:50870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343696AbhKIW0t (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:26:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB510619BB;
        Tue,  9 Nov 2021 22:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496393;
        bh=0gXeWluNELyp0i714wNX8k1QJpp8DwHecK86s26ltss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KSXgJNer81N2ro0jXRIo9iKtZWFK+3gWn3pIRbn1Waj2/F8zuhvaHZxJfBOAtZT0L
         JXesiAOSO0sc1bx8Ufz5TDWHp6FOwVsY9CjyCAyNAQZ9sK/XaM1DyJSEtTzkvS1lZQ
         RTJwUdunBpMD2FkCAgxbw43331biGaU3NYIhTkOqMZrmleXtBki0TiVgByPQwz+WFL
         Vv+6J7Y4K0yqwZGjJmRHq+aaE5qtanOZe47JkfkLfES5eHQufNskEjHUcqGSsgLYQ4
         WiZmr8QWff6ZnvPztT5Jx2ZAyDmqhAQtQf5E0YedbIfu8Izx9Tf3bQFM+HmzYHsN5x
         VuZfPrLKZm8AA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shawn Guo <shawn.guo@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.14 27/75] arm64: dts: qcom: ipq6018: Fix qcom,controlled-remotely property
Date:   Tue,  9 Nov 2021 17:18:17 -0500
Message-Id: <20211109221905.1234094-27-sashal@kernel.org>
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
index 23ee1bfa43189..81a29d87997a4 100644
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

