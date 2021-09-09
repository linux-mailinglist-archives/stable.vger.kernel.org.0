Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75654404EF5
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348641AbhIIMQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:16:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347173AbhIIMMO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:12:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D4D661A09;
        Thu,  9 Sep 2021 11:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188130;
        bh=4hIy8UnwQrH4j2ngGlzjY5U9vxLNhjopSfaM/eeqlH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lwKLTG1Tihu/k0dE/5BhwZYiuX2zuVGWPX4UZ+VOhsQ38hRS0PQrRbatJ5fmdbtfq
         QLerrz78flMK14L573PEE9QAQTJFoWh60Fcz64cSoELH8tlvfOIzdQQhCvS2RIqXCE
         QXuQjkvVKuCMBhCsTqxqW2KTHInjDQd9kzMKUsx3wcnYrsjUTWM5xdUBNkEC65Q4nh
         zWMgR1kc6jG6N2rXMpuxWcSnR6bAcmvCCj7iyl+h71PlRl7cxjt0TzTmvghIEvpsKK
         6CSEIP7K1+1BgvF1/x9hzC1NCURYw3hqU3AVL9TbWSnzYQZg1Ys4ITrLTOEb9pn8kC
         SR5POsoV9eFQQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 104/219] arm64: dts: qcom: sdm660: use reg value for memory node
Date:   Thu,  9 Sep 2021 07:44:40 -0400
Message-Id: <20210909114635.143983-104-sashal@kernel.org>
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

