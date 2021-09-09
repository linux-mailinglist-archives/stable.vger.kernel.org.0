Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED7FE404F4B
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231607AbhIIMQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:16:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:53562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344601AbhIIMNG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:13:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F21AA61A51;
        Thu,  9 Sep 2021 11:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188132;
        bh=e4TbRqrlT9HprV2lUzQMVPH5udOoHeA2y0wRp2sP4t4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f6tVf0sbj1H1gPCZKNYcND5rIhrz1eRNtmWuNABzxsNn9+o5ikEugxCtx584eNmbt
         Gx5JWQ4RUBh/WJbNwfSHNjFrIfqz/K7TLwv35qecdk/gEs2dVuvbzZc3uf0CwjaZVf
         99hM6VIrJMfkV2fbHIKeSrEM5kgLulLUSeYBbocTURQWdRDRUUyXzyeCj/Ao/2rrcD
         /CR7wNOvutJF3CXIVhyBHAgkgXdwQLrlHnjnAtItoGq3jEQKj9H9ILMysQOlFa++e5
         KKPyEZJLsM6YsJhIzIbJ7kYZizKpGvreQ1SDTKJAGHvUoU+rc/+9T/yJ2077iZS1TY
         oNYR00zUBUOuA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 106/219] arm64: dts: qcom: sdm630: don't use underscore in node name
Date:   Thu,  9 Sep 2021 07:44:42 -0400
Message-Id: <20210909114635.143983-106-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
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
index 5b73659f2a75..06a0ae773ad5 100644
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

