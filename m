Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2D94051B5
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353290AbhIIMiS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:38:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:39532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350417AbhIIMb6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:31:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16DED61B5D;
        Thu,  9 Sep 2021 11:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188387;
        bh=s44E5qAOsqWbcPp4zaQ2/YUdsSc6gezMCDsyo3w5oro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bca9QMbX6S/UGQ5NBfZGsYQGgRrOk/0s7oKR+TZ0mCYmWSP/U7LY7+FCtHcX96WTv
         2Ris3mV39EMNrNseDcCqQznLJQBl0vpSGHX2LqGk6LYXo5L5Ye+MLPHCSCTuQ51ExU
         9oz5qUAch8NDjJwMcEKOlZOIDwiskp0hqMQCLqmlBa6IW4VYWm1CGzsrH8fWC8kN0e
         wBCWe0hMytoWWz+zlgTd/psOT5q2BAIdsHB4ciCvlw8K2NqtJHFxvOWeVWZRkhQzrn
         yN8g5Icq9bQX5XATz3gLRpieyCcv+Glepb6PM8lLUg6rJ7bGokrHR3a0CGQpY8bLgk
         la7wyJFo1/Wdw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 085/176] arm64: dts: qcom: ipq6018: drop '0x' from unit address
Date:   Thu,  9 Sep 2021 07:49:47 -0400
Message-Id: <20210909115118.146181-85-sashal@kernel.org>
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

[ Upstream commit 1b91b8ef60e9a67141e66af3cca532c00f4605fe ]

Nodes need not contain '0x' for the unit address. Drop it to fix the
below warning:

arch/arm64/boot/dts/qcom/ipq6018-cp01-c1.dt.yaml: reserved-memory:
'memory@0x60000' does not match any of the regexes

Signed-off-by: Vinod Koul <vkoul@kernel.org>
Link: https://lore.kernel.org/r/20210308060826.3074234-19-vkoul@kernel.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq6018.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq6018.dtsi b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
index cdc1e3d60c58..3ceb36cac512 100644
--- a/arch/arm64/boot/dts/qcom/ipq6018.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
@@ -151,7 +151,7 @@ reserved-memory {
 		#size-cells = <2>;
 		ranges;
 
-		rpm_msg_ram: memory@0x60000 {
+		rpm_msg_ram: memory@60000 {
 			reg = <0x0 0x60000 0x0 0x6000>;
 			no-map;
 		};
-- 
2.30.2

