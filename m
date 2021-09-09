Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC114051BB
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353238AbhIIMiV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:38:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:39852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241056AbhIIMc6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:32:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7A4561B56;
        Thu,  9 Sep 2021 11:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188391;
        bh=+mysz30YchQW0dOOi+B6qmUk5Y0BtIkVvvixWjv2ans=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gcGqysr03kS3RHwVLBXsQNC9uvsoJxBwbhWbfPoTKvIlOqWMr7hxTbLATcelts5Hd
         Z/2EqpcgIRy5QqNkVGFpBMtY//vE3hqnLAOZLhX3mYOtyWULt2nRNgRw9JF2h1hJxE
         zUCk/uvRvU+2HbsJXr2oQcvpQYuTsPgLkTM0Q1Ie8QZ/A4f4ui+63BLVBAS/ZK69g6
         hbc0wGETcjto2mlQwjYZ1RIYPdJh3wtv+VSFwp7aiKi4Y8CrfM57d3Er7fOunMC8li
         lWPHpMLcw1ukX3/H1P2GdiCg3UBpcDyfBa13aA7AUGUtac3xT08WaqurZjEUZlyoQC
         fjNCp3sVAJ88g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 088/176] arm64: dts: qcom: msm8996: don't use underscore in node name
Date:   Thu,  9 Sep 2021 07:49:50 -0400
Message-Id: <20210909115118.146181-88-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

