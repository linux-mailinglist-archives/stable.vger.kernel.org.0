Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75E3D4D8393
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240997AbiCNMRK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241031AbiCNMQW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:16:22 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA5435246;
        Mon, 14 Mar 2022 05:12:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9F3F0CE1269;
        Mon, 14 Mar 2022 12:12:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EFABC340E9;
        Mon, 14 Mar 2022 12:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259920;
        bh=Lyw+ZXk7GHxG2xiXqfRcAOOq65X5ixi5FjKzltQwq4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dsQnLcFYfFlGfCy8leLh2CABVZdfg9fdUYPk33sRnymEUNAlpau/hllDVsohVjVgL
         gljpTUYd/x8FzXZorafuYFyO2+H04XmmmkYrc/D6HiIanQC7mVD6m3iB9WD4d6bquC
         mfucg1eRhDCsyrvf0zswpYy6UkZdQSeyRtdXgzOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 001/121] arm64: dts: qcom: sm8350: Describe GCC dependency clocks
Date:   Mon, 14 Mar 2022 12:53:04 +0100
Message-Id: <20220314112744.164558746@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konrad Dybcio <konrad.dybcio@somainline.org>

[ Upstream commit 9ea9eb36b3c046fc48e737db4de69f7acd12f9be ]

Add all the clock names that the GCC driver expects to get via DT, so that the
clock handles can be filled as the development progresses.

Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20211114012755.112226-8-konrad.dybcio@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index c13858cf50dd..db102b293154 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -583,8 +583,30 @@ gcc: clock-controller@100000 {
 			#clock-cells = <1>;
 			#reset-cells = <1>;
 			#power-domain-cells = <1>;
-			clock-names = "bi_tcxo", "sleep_clk";
-			clocks = <&rpmhcc RPMH_CXO_CLK>, <&sleep_clk>;
+			clock-names = "bi_tcxo",
+				      "sleep_clk",
+				      "pcie_0_pipe_clk",
+				      "pcie_1_pipe_clk",
+				      "ufs_card_rx_symbol_0_clk",
+				      "ufs_card_rx_symbol_1_clk",
+				      "ufs_card_tx_symbol_0_clk",
+				      "ufs_phy_rx_symbol_0_clk",
+				      "ufs_phy_rx_symbol_1_clk",
+				      "ufs_phy_tx_symbol_0_clk",
+				      "usb3_phy_wrapper_gcc_usb30_pipe_clk",
+				      "usb3_uni_phy_sec_gcc_usb30_pipe_clk";
+			clocks = <&rpmhcc RPMH_CXO_CLK>,
+				 <&sleep_clk>,
+				 <0>,
+				 <0>,
+				 <0>,
+				 <0>,
+				 <0>,
+				 <0>,
+				 <0>,
+				 <0>,
+				 <0>,
+				 <0>;
 		};
 
 		ipcc: mailbox@408000 {
-- 
2.34.1



