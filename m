Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF720405561
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358826AbhIINJo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:09:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:42450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357668AbhIINDP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 09:03:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 725B26328D;
        Thu,  9 Sep 2021 11:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188782;
        bh=mJMmkxwxd9M8+jmz6WOQ+szENOwFVOrm9qIV68A5zwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C+FeLS0EcveMg19fMxWmPgg+/uevzJpYwnZKq7NanYWBPSYnE6QgFOxnaZmBmF76f
         PKueYRshlQYGL01f2Fb1Fn/BEy7VF0JnSP7LWFzPsj0vGo+bsmhpcZdPjWC4zS46cl
         gxAJwTc2hTIEc1TRkJ0x1fx0TZyOTyjQFCMO0x7xRJsx7J96Z6G+MXnoOflsueUdiY
         /92BVGiOKHAO47VeRi8iBgoe3UH+lCCSE1P6n+/EJBx+CDoTpr6tv3cYWLTL3NWnaX
         wQH92UqFqXzQ4HcmoKAj5cpYJOd2cYef1ILsrilAfEJR7YbvbC6N6AOZhGCwuzlL4o
         7ZxLAgi093fFw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 33/59] arm64: dts: qcom: sdm660: use reg value for memory node
Date:   Thu,  9 Sep 2021 07:58:34 -0400
Message-Id: <20210909115900.149795-33-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115900.149795-1-sashal@kernel.org>
References: <20210909115900.149795-1-sashal@kernel.org>
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
index 6a838b5d321e..1ab7deeb2497 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074-hk01.dts
+++ b/arch/arm64/boot/dts/qcom/ipq8074-hk01.dts
@@ -27,7 +27,7 @@ chosen {
 		stdout-path = "serial0";
 	};
 
-	memory {
+	memory@40000000 {
 		device_type = "memory";
 		reg = <0x0 0x40000000 0x0 0x20000000>;
 	};
-- 
2.30.2

