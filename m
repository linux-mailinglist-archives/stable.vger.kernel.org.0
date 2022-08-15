Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD67593E66
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235324AbiHOUnU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345786AbiHOUjx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:39:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B2AAED82;
        Mon, 15 Aug 2022 12:07:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C194EB81107;
        Mon, 15 Aug 2022 19:07:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB854C433C1;
        Mon, 15 Aug 2022 19:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590437;
        bh=z1ZB++8FbLhpxiPezMZYl+ulr53Ss6UfSvXyYxPc2Vw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cM326932xDwxuXqWl7c5cwWWm8lDiKbji/czXuan8F9TtJeZRx/2l4lD/qyG3a6Nv
         FY7R3eienB+4rTYztFIyFRzjgz3urA1bNJEDyk+BPx2c426B2MhfJ8JJjHP28cdqH+
         ArFZ1QztwB5T8nPgey2Ff7ZP/MLstIL3MPE5Va8E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan+linaro@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0258/1095] arm64: dts: qcom: sc7280: drop PCIe PHY clock index
Date:   Mon, 15 Aug 2022 19:54:17 +0200
Message-Id: <20220815180440.423509547@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit 531c738fb36069d60aff267a0b25533a35d59fd0 ]

The QMP PCIe PHY provides a single clock so drop the redundant clock
index.

Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Fixes: bd7d507935ca ("arm64: dts: qcom: sc7280: Add pcie clock support")
Fixes: 92e0ee9f83b3 ("arm64: dts: qcom: sc7280: Add PCIe and PHY related  nodes")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220705114032.22787-2-johan+linaro@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index 7925c8561117..86898d0b4124 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -810,7 +810,7 @@ gcc: clock-controller@100000 {
 			reg = <0 0x00100000 0 0x1f0000>;
 			clocks = <&rpmhcc RPMH_CXO_CLK>,
 				 <&rpmhcc RPMH_CXO_CLK_A>, <&sleep_clk>,
-				 <0>, <&pcie1_lane 0>,
+				 <0>, <&pcie1_lane>,
 				 <0>, <0>, <0>, <0>;
 			clock-names = "bi_tcxo", "bi_tcxo_ao", "sleep_clk",
 				      "pcie_0_pipe_clk", "pcie_1_pipe_clk",
@@ -1914,7 +1914,7 @@ pcie1_lane: lanes@1c0e200 {
 				clock-names = "pipe0";
 
 				#phy-cells = <0>;
-				#clock-cells = <1>;
+				#clock-cells = <0>;
 				clock-output-names = "pcie_1_pipe_clk";
 			};
 		};
-- 
2.35.1



