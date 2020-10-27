Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1937D29BBE5
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802698AbgJ0Puy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:50:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802358AbgJ0Pq2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:46:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F3AF22265;
        Tue, 27 Oct 2020 15:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813588;
        bh=EpWlPeKkN3GPtcXmybBb3CwSOJntCNCw/WMcgU0NyTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=alFW5h0uMKwHyL7zYrAaushPq8thNhtaIg3j0tyfw7a6J4dZBbfdNIsDChFH+90vF
         R1d6Gpcc+2IefGr1LKtPSJ593+cMvBCFmXMHitu8Or3ITVRA0uRn7pJXDo+MUuKs5I
         li+12udBBEvXikOLuOg6BpsZEShrMkEHU+LonPIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kalyan Thota <kalyan_t@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 602/757] arm64: dts: qcom: sc7180: Drop flags on mdss irqs
Date:   Tue, 27 Oct 2020 14:54:12 +0100
Message-Id: <20201027135518.780532197@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit 51e9874d382e089f664b3ce12773bbbaece5f369 ]

The number of interrupt cells for the mdss interrupt controller is 1,
meaning there should only be one cell for the interrupt number, not two
where the second cell is the irq flags. Drop the second cell to match
the binding.

Cc: Kalyan Thota <kalyan_t@codeaurora.org>
Cc: Harigovindan P <harigovi@codeaurora.org
Fixes: a3db7ad1af49 ("arm64: dts: sc7180: add display dt nodes")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20200811192503.1811462-1-swboyd@chromium.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7180.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
index e875f6c3b6639..a6be72d8f6fde 100644
--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -2785,7 +2785,7 @@ mdp: mdp@ae01000 {
 				power-domains = <&rpmhpd SC7180_CX>;
 
 				interrupt-parent = <&mdss>;
-				interrupts = <0 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts = <0>;
 
 				status = "disabled";
 
@@ -2833,7 +2833,7 @@ dsi0: dsi@ae94000 {
 				reg-names = "dsi_ctrl";
 
 				interrupt-parent = <&mdss>;
-				interrupts = <4 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts = <4>;
 
 				clocks = <&dispcc DISP_CC_MDSS_BYTE0_CLK>,
 					 <&dispcc DISP_CC_MDSS_BYTE0_INTF_CLK>,
-- 
2.25.1



