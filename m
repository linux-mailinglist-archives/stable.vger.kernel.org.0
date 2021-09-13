Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 023F5409507
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345578AbhIMOhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:37:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347647AbhIMOfR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:35:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 236D26187D;
        Mon, 13 Sep 2021 13:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541204;
        bh=7/K3anEu52+99rFCHckyXcVwciHV5nVMsssw/LnaCiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hFq9eA2edtUnrVCOn9y7P+yfys7CJqXdNzq1TWs4PfRcl7DbMCsrhUz5jpBq0F6Zi
         hSrhqAxfgVAoYWkBujLBnO7dMdW2a7fNdFT8YusO+n5B065WKSvOBH3aMEfsNc6I3X
         R3mpkZgOCMTjEvsfB0rSeWZVpuc/n/LwhvMCZ7xU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sibi Sankar <sibis@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 173/334] arm64: dts: qcom: sc7280: Fixup the cpufreq node
Date:   Mon, 13 Sep 2021 15:13:47 +0200
Message-Id: <20210913131119.199413572@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sibi Sankar <sibis@codeaurora.org>

[ Upstream commit 11e03d692101e484df9322f892a8b6e111a82bfd ]

Fixup the register regions used by the cpufreq node on SC7280 SoC to
support per core L3 DCVS.

Fixes: 7dbd121a2c58 ("arm64: dts: qcom: sc7280: Add cpufreq hw node")
Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/1627581885-32165-4-git-send-email-sibis@codeaurora.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index 188c5768a55a..c08f07410699 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -1437,9 +1437,9 @@
 
 		cpufreq_hw: cpufreq@18591000 {
 			compatible = "qcom,cpufreq-epss";
-			reg = <0 0x18591000 0 0x1000>,
-			      <0 0x18592000 0 0x1000>,
-			      <0 0x18593000 0 0x1000>;
+			reg = <0 0x18591100 0 0x900>,
+			      <0 0x18592100 0 0x900>,
+			      <0 0x18593100 0 0x900>;
 			clocks = <&rpmhcc RPMH_CXO_CLK>, <&gcc GCC_GPLL0>;
 			clock-names = "xo", "alternate";
 			#freq-domain-cells = <1>;
-- 
2.30.2



