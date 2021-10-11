Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 906FB429059
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238123AbhJKOH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:07:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:56422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238787AbhJKOF1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:05:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D16C610EA;
        Mon, 11 Oct 2021 13:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960780;
        bh=BNX4EXfjjaZr44YUYPfN2wif3E1Q8SQH3KTnvFVee/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l0WT77qQubLw16Rwve3pGXiWrhffH1euatSETlCQQ8BbdB+8rtRinVzJgEDQG8dn6
         l8pAULJZp9y7dA5yK8rSTcHKJLc7HDBhJoiknXlOzlleANVc6395mavLMMTt5FACGB
         11SawtvKq3WD0oj5lrAXRoGoyyVIrBXToOF/Xx2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthias Kaehlcke <mka@chromium.org>,
        Sibi Sankar <sibis@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 039/151] Revert "arm64: dts: qcom: sc7280: Fixup the cpufreq node"
Date:   Mon, 11 Oct 2021 15:45:11 +0200
Message-Id: <20211011134519.116235410@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit a48c730a4e0bf480bcde12d795a9cd6f9ef14d1e ]

This reverts commit 11e03d692101e484df9322f892a8b6e111a82bfd.

As per discussion [1] the patch shouldn't have landed. Let's revert.

[1] https://lore.kernel.org/r/fde7bac239f796b039b9be58b391fb77@codeaurora.org/

Fixes: 11e03d692101 ("arm64: dts: qcom: sc7280: Fixup the cpufreq node")
Reported-by: Matthias Kaehlcke <mka@chromium.org>
Cc: Sibi Sankar <sibis@codeaurora.org>
Cc: Matthias Kaehlcke <mka@chromium.org>
Cc: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210907121220.1.I08460f490473b70de0d768db45f030a4d5c17828@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index c08f07410699..188c5768a55a 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -1437,9 +1437,9 @@
 
 		cpufreq_hw: cpufreq@18591000 {
 			compatible = "qcom,cpufreq-epss";
-			reg = <0 0x18591100 0 0x900>,
-			      <0 0x18592100 0 0x900>,
-			      <0 0x18593100 0 0x900>;
+			reg = <0 0x18591000 0 0x1000>,
+			      <0 0x18592000 0 0x1000>,
+			      <0 0x18593000 0 0x1000>;
 			clocks = <&rpmhcc RPMH_CXO_CLK>, <&gcc GCC_GPLL0>;
 			clock-names = "xo", "alternate";
 			#freq-domain-cells = <1>;
-- 
2.33.0



