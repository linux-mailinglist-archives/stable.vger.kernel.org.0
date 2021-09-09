Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F82B4051B8
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345793AbhIIMiT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:38:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:39608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351286AbhIIMcN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:32:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E1B861B44;
        Thu,  9 Sep 2021 11:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188389;
        bh=IXtcjioRtU0TNwHJMz03CSvANeFnPsGhvu0CryO4+8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J8ALBh4OSwTtH6yLlHYN3mcRuE9CdEqq5DwIJWVCaeDO3IqpVbnUl1jtRbZCqmur9
         WEDK9FUFDmTvsNBlPvJrqGru2ppkaRDiQn0+75F/12iZS/y27bf9ABRs3zxwE25+iZ
         /s17BBC9C4o9e0PGBB2ntLBRmB0rWWxsP5uNFiiyTFKjo6B3cmtsR5mJvPSfhVTb/j
         bkX6i6YUylZ+0Hx1RqiNrdMe/ALnyRC5kDBlWIFiMpsCniNbMoMRmA/Y5HASAckBrm
         8WvTfOVW/BluyPXDZDtFr1YUjTb4v65Ut1nL1jqM7rc8mUeox8slyPLiJ4+Op142vC
         zJwjNY+eXf5jg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 086/176] arm64: dts: qcom: sdm630: don't use underscore in node name
Date:   Thu,  9 Sep 2021 07:49:48 -0400
Message-Id: <20210909115118.146181-86-sashal@kernel.org>
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

[ Upstream commit 639dfdbecd88ec05bda87b1d5d419afad50af21c ]

We have underscore (_) in node name so fix that up as well.

Fix this by changing node name to use dash (-)

Signed-off-by: Vinod Koul <vkoul@kernel.org>
Link: https://lore.kernel.org/r/20210308060826.3074234-11-vkoul@kernel.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm630.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm630.dtsi b/arch/arm64/boot/dts/qcom/sdm630.dtsi
index ee7fcf4c158f..f87054575ce7 100644
--- a/arch/arm64/boot/dts/qcom/sdm630.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm630.dtsi
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

