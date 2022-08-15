Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94A035946A5
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345860AbiHOW7z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345352AbiHOW6d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:58:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 380A075FEE;
        Mon, 15 Aug 2022 12:56:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7F8C60FD8;
        Mon, 15 Aug 2022 19:56:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B621FC433D6;
        Mon, 15 Aug 2022 19:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593388;
        bh=LlyLbRg2vFLS4ph5qJL+ouCVBytnnYnLYD7VRmv8WO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xSDz/K4yg63s+rEe82kCojFJF6cnbRHjGA+GxanUfwLlvDSyg2HLpWGlYinPgBj6u
         Nv7Yj3MJAd+PKynR1W056V5wpsMjvzli43RsMMJxkl1sIASAf3PTeihlLZii//OBCY
         bTqOmYTqwQR51p5kiQkT4jV1yT6HhDT+nrQ5Nd3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan+linaro@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0260/1157] arm64: dts: qcom: sm8250: add missing PCIe PHY clock-cells
Date:   Mon, 15 Aug 2022 19:53:36 +0200
Message-Id: <20220815180449.977511505@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

[ Upstream commit d9fd162ce764c227fcfd4242f6c1639895a9481f ]

Add the missing '#clock-cells' properties to the PCIe QMP PHY nodes.

Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Fixes: e53bdfc00977 ("arm64: dts: qcom: sm8250: Add PCIe support")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220705114032.22787-3-johan+linaro@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index d0760e6ec942..e8cdca50bc83 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -1884,6 +1884,8 @@ pcie0_lane: phy@1c06200 {
 				clock-names = "pipe0";
 
 				#phy-cells = <0>;
+
+				#clock-cells = <0>;
 				clock-output-names = "pcie_0_pipe_clk";
 			};
 		};
@@ -1990,6 +1992,8 @@ pcie1_lane: phy@1c0e200 {
 				clock-names = "pipe0";
 
 				#phy-cells = <0>;
+
+				#clock-cells = <0>;
 				clock-output-names = "pcie_1_pipe_clk";
 			};
 		};
@@ -2096,6 +2100,8 @@ pcie2_lane: phy@1c16200 {
 				clock-names = "pipe0";
 
 				#phy-cells = <0>;
+
+				#clock-cells = <0>;
 				clock-output-names = "pcie_2_pipe_clk";
 			};
 		};
-- 
2.35.1



