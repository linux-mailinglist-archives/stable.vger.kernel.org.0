Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 510A940E065
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237575AbhIPQVJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:21:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238908AbhIPQQ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:16:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E57AE60FA0;
        Thu, 16 Sep 2021 16:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808713;
        bh=+mysz30YchQW0dOOi+B6qmUk5Y0BtIkVvvixWjv2ans=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DmsXcNlLidz5jzmeVmCegoCeepRIf1eFAfjmzS1XmSh/VtI3CyeDTuO1fLqQEiqiS
         TQRklerS+c+aHEmNH8d8rNU9XitWc/yp7ZWZNcK7sr+63khMHdd84zxkp5NnygB3Nh
         YRW7NSf13Uf0r7WTLOWSeXyGvTTO6vqmmra0OYBI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 194/306] arm64: dts: qcom: msm8996: dont use underscore in node name
Date:   Thu, 16 Sep 2021 17:58:59 +0200
Message-Id: <20210916155800.683633817@linuxfoundation.org>
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

[ Upstream commit 84f3efbe5b4654077608bc2fc027177fe4592321 ]

We have underscore (_) in node name leading to warning:

arch/arm64/boot/dts/qcom/apq8096-db820c.dt.yaml: clocks: $nodename:0: 'clocks' does not match '^([a-z][a-z0-9\\-]+-bus|bus|soc|axi|ahb|apb)(@[0-9a-f]+)?$'
arch/arm64/boot/dts/qcom/apq8096-db820c.dt.yaml: clocks: xo_board: {'type': 'object'} is not allowed for {'compatible': ['fixed-clock'], '#clock-cells': [[0]], 'clock-frequency': [[19200000]], 'clock-output-names': ['xo_board'], 'phandle': [[115]]}

Fix this by changing node name to use dash (-)

Signed-off-by: Vinod Koul <vkoul@kernel.org>
Link: https://lore.kernel.org/r/20210308060826.3074234-10-vkoul@kernel.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8996.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index fd6ae5464dea..eef17434d12a 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -17,14 +17,14 @@ / {
 	chosen { };
 
 	clocks {
-		xo_board: xo_board {
+		xo_board: xo-board {
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
 			clock-frequency = <19200000>;
 			clock-output-names = "xo_board";
 		};
 
-		sleep_clk: sleep_clk {
+		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
 			clock-frequency = <32764>;
-- 
2.30.2



