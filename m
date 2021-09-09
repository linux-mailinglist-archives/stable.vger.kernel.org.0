Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A66404B52
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242185AbhIILv1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:51:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:55596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237093AbhIILt0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:49:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2ACD6127B;
        Thu,  9 Sep 2021 11:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187820;
        bh=4hIy8UnwQrH4j2ngGlzjY5U9vxLNhjopSfaM/eeqlH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wp766NH7k1IapoltLkL51UlWcWHds3BWXbI2vi4oOzrqdX3s8wGJIuzp55gpe8d0Q
         hCqeOeKWnZKeQHOnrJQc+0SKB1asq5CuTP36jNAhuvybSe9iVz8Oawmkaso3Krcxrb
         F1zjLGgiQCC18f/o35zWoRXTiaA/cW74mPqCEbKwKrWwaYOTuMHfUy8zYvci+ttkkw
         npQ0tdtd6THkEFkcnnb6DjY9UOda+SCpzESFKnr3JWGA/B6B9Ss/fLkFpEht3jLHS1
         SqVs8HwZFAvTyQ1tVPvPjJhwisWA+7hO0GhmkVr11juNpcEgsbRVVrdIbNLFRA6MiR
         A4NIsrxIUb4Sw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 119/252] arm64: dts: qcom: sdm660: use reg value for memory node
Date:   Thu,  9 Sep 2021 07:38:53 -0400
Message-Id: <20210909114106.141462-119-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinod Koul <vkoul@kernel.org>

[ Upstream commit c81210e38966cfa1c784364e4035081c3227cf5b ]

memory node like other node should be node@reg, which is missing in this
case, so fix it up

arch/arm64/boot/dts/qcom/ipq8074-hk01.dt.yaml: /: memory: False schema does not allow {'device_type': ['memory'], 'reg': [[0, 1073741824, 0, 536870912]]}

Signed-off-by: Vinod Koul <vkoul@kernel.org>
Link: https://lore.kernel.org/r/20210308060826.3074234-18-vkoul@kernel.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq8074-hk01.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq8074-hk01.dts b/arch/arm64/boot/dts/qcom/ipq8074-hk01.dts
index e8c37a1693d3..cc08dc4eb56a 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074-hk01.dts
+++ b/arch/arm64/boot/dts/qcom/ipq8074-hk01.dts
@@ -20,7 +20,7 @@ chosen {
 		stdout-path = "serial0";
 	};
 
-	memory {
+	memory@40000000 {
 		device_type = "memory";
 		reg = <0x0 0x40000000 0x0 0x20000000>;
 	};
-- 
2.30.2

