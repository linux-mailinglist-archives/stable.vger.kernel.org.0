Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25D904996F4
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446443AbiAXVIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:08:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54954 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445206AbiAXVCb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:02:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59544B810BD;
        Mon, 24 Jan 2022 21:02:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8087DC340E5;
        Mon, 24 Jan 2022 21:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058149;
        bh=3yYTdBly+sCfC5UGnyLhL5seRIkMZilstI3NlwH1Dqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lapmvaEAW4oQx/orCfXlCnT4qetT40vD2LXeRUIK5QVsX9TLM6dizz9rXb25linHe
         qWM3odPOTF948e9GpW0yHZyy6mMZoSVz7YdnjPvqWRRGQamgb9X2cGqsjZy25iWbql
         nT+Kc5E7ykheCpbTdUg3E+Ap54UALevJ1Hrat8VU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prasad Malisetty <pmaliset@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0163/1039] arm64: dts: qcom: sc7280: Fix interrupt-map parent address cells
Date:   Mon, 24 Jan 2022 19:32:32 +0100
Message-Id: <20220124184130.691686284@linuxfoundation.org>
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

[ Upstream commit 66b788133030f0c69a0ecc7f72f7939b119c9a69 ]

Update interrupt-map parent address cells for sc7280
Similar to existing Qcom SoCs.

Fixes: 92e0ee9f8 ("arm64: dts: qcom: sc7280: Add PCIe and PHY related nodes")
Signed-off-by: Prasad Malisetty <pmaliset@codeaurora.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/1637060508-30375-4-git-send-email-pmaliset@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index cb94b877d6246..6e27a1beaa33a 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -1592,10 +1592,10 @@
 			interrupt-names = "msi";
 			#interrupt-cells = <1>;
 			interrupt-map-mask = <0 0 0 0x7>;
-			interrupt-map = <0 0 0 1 &intc 0 434 IRQ_TYPE_LEVEL_HIGH>,
-					<0 0 0 2 &intc 0 435 IRQ_TYPE_LEVEL_HIGH>,
-					<0 0 0 3 &intc 0 438 IRQ_TYPE_LEVEL_HIGH>,
-					<0 0 0 4 &intc 0 439 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-map = <0 0 0 1 &intc 0 0 0 434 IRQ_TYPE_LEVEL_HIGH>,
+					<0 0 0 2 &intc 0 0 0 435 IRQ_TYPE_LEVEL_HIGH>,
+					<0 0 0 3 &intc 0 0 0 438 IRQ_TYPE_LEVEL_HIGH>,
+					<0 0 0 4 &intc 0 0 0 439 IRQ_TYPE_LEVEL_HIGH>;
 
 			clocks = <&gcc GCC_PCIE_1_PIPE_CLK>,
 				 <&gcc GCC_PCIE_1_PIPE_CLK_SRC>,
-- 
2.34.1



