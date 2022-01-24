Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560A649A99D
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444565AbiAYDYe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:24:34 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54970 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445185AbiAXVC0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:02:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BD7E60B03;
        Mon, 24 Jan 2022 21:02:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54624C340E5;
        Mon, 24 Jan 2022 21:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058146;
        bh=m10dGPwTZNb6ccoaErXekfq341WXRr3rw/+jU8rdugk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aEfk+Hb347E6yUr5ppKZEpqUKvxB5yLOwqkatoJjDMz09CTI1KR4VvTAuTINsw55p
         5Qtj6wpunXIpBvWa7Mn44C5mb9KRTDEuRRk1BwjMN85iLX4vBrdhSuYo3EbbadIML+
         QkAToun5SStC4c1mzy7IFMrNZyVHlcnmt97CMP/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prasad Malisetty <pmaliset@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0162/1039] arm64: dts: qcom: sc7280: Fix incorrect clock name
Date:   Mon, 24 Jan 2022 19:32:31 +0100
Message-Id: <20220124184130.660003489@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index 365a2e04e285b..cb94b877d6246 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -576,7 +576,7 @@
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



