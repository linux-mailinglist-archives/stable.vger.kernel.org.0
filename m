Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C08C9499263
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348842AbiAXUTW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:19:22 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42826 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380744AbiAXUQv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:16:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CC686091A;
        Mon, 24 Jan 2022 20:16:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068BFC340E5;
        Mon, 24 Jan 2022 20:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055410;
        bh=LXCnAdlwZsWaJMfvC9G5RI+dkOsFueE+RgYoeHYqS7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AVAKlyiFwc3dfccxVeIck1ptZmzCoyRr1JPuEoh+lTjAaEYBjoMjzbe1mkfzGCAhx
         DMO81/O6HdPHvAfSoRhqnHJ0NqywDWOdIjZiE3vqo5rabi6oFwgsWH+8aduvEbyLTz
         iAmvFhEa/0IYaqPzrP0akHonkN39jyD621/Zs2ns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prasad Malisetty <pmaliset@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 141/846] arm64: dts: qcom: sc7280: Fix incorrect clock name
Date:   Mon, 24 Jan 2022 19:34:18 +0100
Message-Id: <20220124184105.850912402@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prasad Malisetty <pmaliset@codeaurora.org>

[ Upstream commit fa09b2248714c64644576d8064e9bd292a504a0e ]

Replace pcie_1_pipe-clk clock name with pcie_1_pipe_clk
To match with dt binding.

Fixes: ab7772de8612 ("arm64: dts: qcom: SC7280: Add rpmhcc clock controller node")
Signed-off-by: Prasad Malisetty <pmaliset@codeaurora.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/1637060508-30375-2-git-send-email-pmaliset@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index f58336536a92a..692973c4f4344 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -429,7 +429,7 @@
 				 <&rpmhcc RPMH_CXO_CLK_A>, <&sleep_clk>,
 				 <0>, <0>, <0>, <0>, <0>, <0>;
 			clock-names = "bi_tcxo", "bi_tcxo_ao", "sleep_clk",
-				      "pcie_0_pipe_clk", "pcie_1_pipe-clk",
+				      "pcie_0_pipe_clk", "pcie_1_pipe_clk",
 				      "ufs_phy_rx_symbol_0_clk", "ufs_phy_rx_symbol_1_clk",
 				      "ufs_phy_tx_symbol_0_clk",
 				      "usb3_phy_wrapper_gcc_usb30_pipe_clk";
-- 
2.34.1



