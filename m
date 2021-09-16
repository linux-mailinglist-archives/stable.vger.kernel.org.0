Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2F740E019
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235476AbhIPQSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:18:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:55232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236985AbhIPQQQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:16:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 649616124F;
        Thu, 16 Sep 2021 16:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808708;
        bh=TYnTM6irSzRisHVyIZScuhsSNua4F2UTUECQVQIdccU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lGeDKFQ6YxeVV7zjEw+yBraH51S5x8Cfd79+s8UXG1wV/2rQvGwPD7RZMuGXe8YW5
         kxcgyyGMrX0L6CmcqgWyWznlHLCUAluy5h0Yc8CsA3ZfAai2ByGMxZS08ST9KmQcP7
         hc0iS8Ejv3ffKqcgAOya1Rzen9nm73ocnYPtO5w8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 193/306] arm64: dts: qcom: msm8994: dont use underscore in node name
Date:   Thu, 16 Sep 2021 17:58:58 +0200
Message-Id: <20210916155800.650881573@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinod Koul <vkoul@kernel.org>

[ Upstream commit 8c678beca7ed3fa8a2c6d86f6603bc23400f9ad8 ]

We have underscore (_) in node name leading to warning:
arch/arm64/boot/dts/qcom/msm8994-msft-lumia-octagon-cityman.dt.yaml: clocks: xo_board: {'type': 'object'} is not allowed for {'compatible': ['fixed-clock'], '#clock-cells': [[0]], 'clock-frequency': [[19200000]], 'phandle': [[26]]}
arch/arm64/boot/dts/qcom/msm8994-msft-lumia-octagon-cityman.dt.yaml: clocks: sleep_clk: {'type': 'object'} is not allowed for {'compatible': ['fixed-clock'], '#clock-cells': [[0]], 'clock-frequency': [[32768]]}

Fix this by changing node name to use dash (-)

Signed-off-by: Vinod Koul <vkoul@kernel.org>
Link: https://lore.kernel.org/r/20210308060826.3074234-9-vkoul@kernel.org
[bjorn: Added clock-output-names to satisfy parent_names]
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8994.dtsi | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8994.dtsi b/arch/arm64/boot/dts/qcom/msm8994.dtsi
index 6707f898607f..45f9a44326a6 100644
--- a/arch/arm64/boot/dts/qcom/msm8994.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8994.dtsi
@@ -14,16 +14,18 @@ / {
 	chosen { };
 
 	clocks {
-		xo_board: xo_board {
+		xo_board: xo-board {
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
 			clock-frequency = <19200000>;
+			clock-output-names = "xo_board";
 		};
 
-		sleep_clk: sleep_clk {
+		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
 			clock-frequency = <32768>;
+			clock-output-names = "sleep_clk";
 		};
 	};
 
-- 
2.30.2



