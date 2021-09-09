Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F09F404F04
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238592AbhIIMQc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:16:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347796AbhIIMMO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:12:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B37E161A50;
        Thu,  9 Sep 2021 11:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188131;
        bh=grpqI8sJsgtdBrayXqXN5K8Cvo1phWPDGxjB1M24YFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dtr4LBTm/uFZlN1JqxUJZCE2S1HeouNjz3Xcjxf91huzbn9EGP46rikMv/hJ7lqOS
         u2YCe/MA0+o4Rs0TGzE49xv3e3RNyIrvIQv9mQJWHPRAEs4BKANOinI8h0FxqPTf2W
         vXhY7U21PszOPcsIJ1VXQ810cyVWa++LAzJ1gSwxtNkhjTuS44dLdUiXPrCk+QuPLF
         qIrGApdRgNKchbpGKfqUsAb70VGLw//AOAtWZ7G9FBYqNTHLW/GUcmPdGgCvPjXrZS
         mxlfku8HiesUNvmLVrlWp1GusIsTJxMbIwDsSt8nffxmue3G55WNdIbbxjJ5zE0fxU
         RlBQND4U+3XQQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 105/219] arm64: dts: qcom: ipq6018: drop '0x' from unit address
Date:   Thu,  9 Sep 2021 07:44:41 -0400
Message-Id: <20210909114635.143983-105-sashal@kernel.org>
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
index 9fa5b028e4f3..23ee1bfa4318 100644
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

