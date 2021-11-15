Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02BF54511C7
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244479AbhKOTPC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:15:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:42970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244240AbhKOTMO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:12:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6558E634A8;
        Mon, 15 Nov 2021 18:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000371;
        bh=OAX4fnghNW392E2IeNfOChmlLqD1OWEfT+wl3RBJPnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LNEe9x/NNJRMq9NJsL6yQwG7msPMIzp6IPte8fgAkIyBe5VjGiFfe6cqPZmVUkNNz
         IHqvH7VvsfgM3YfoXOWHLRGujzT2MIu7RZC9OLsb/alDMTGgnAoez2PYXCtSZBHZ+/
         pCoIDxOT7/njrlOME3ZSOnaEUML/2razegMveh04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 635/849] arm64: dts: qcom: sdm845: Use RPMH_CE_CLK macro directly
Date:   Mon, 15 Nov 2021 18:01:58 +0100
Message-Id: <20211115165441.752149173@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bhupesh Sharma <bhupesh.sharma@linaro.org>

[ Upstream commit eed1d9b6e36b06faa53c6dc74134ec21b1336d94 ]

In commit 3e482859f1ef ("dts: qcom: sdm845: Add dt entries
to support crypto engine."), we decided to use the value indicated
by constant RPMH_CE_CLK rather than using it directly.

Now that the same RPMH clock value might be used for other
SoCs (in addition to sdm845), let's use the constant
RPMH_CE_CLK to make sure that this dtsi is compatible with the
other qcom ones.

Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
Reviewed-by: Thara Gopinath <thara.gopinath@linaro.org>
Link: https://lore.kernel.org/r/20210519143700.27392-8-bhupesh.sharma@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index 0a86fe71a66d1..2ec4be930fd6f 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -2316,7 +2316,7 @@
 			compatible = "qcom,bam-v1.7.0";
 			reg = <0 0x01dc4000 0 0x24000>;
 			interrupts = <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rpmhcc 15>;
+			clocks = <&rpmhcc RPMH_CE_CLK>;
 			clock-names = "bam_clk";
 			#dma-cells = <1>;
 			qcom,ee = <0>;
@@ -2332,7 +2332,7 @@
 			reg = <0 0x01dfa000 0 0x6000>;
 			clocks = <&gcc GCC_CE1_AHB_CLK>,
 				 <&gcc GCC_CE1_AHB_CLK>,
-				 <&rpmhcc 15>;
+				 <&rpmhcc RPMH_CE_CLK>;
 			clock-names = "iface", "bus", "core";
 			dmas = <&cryptobam 6>, <&cryptobam 7>;
 			dma-names = "rx", "tx";
-- 
2.33.0



