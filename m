Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC4D440E7A6
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242722AbhIPRfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:35:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348365AbhIPRcV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:32:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 487DE6320F;
        Thu, 16 Sep 2021 16:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810865;
        bh=4hIy8UnwQrH4j2ngGlzjY5U9vxLNhjopSfaM/eeqlH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DLNHxM42K2vuy3p1wv0uF3WawWkuZ/aQwln2LPCFOp4Z9rKhksc/iQ/vuNu26Ox73
         ThKXiBdDTIoYXxBgwrE1KwSAVuNMqgm54qrXglK0xEEQxxB1VVR0EbYgss17LqtByC
         HqanGSkdpEMk6WiKwQ1xJg920E33Ov3G3BLenwBg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 269/432] arm64: dts: qcom: sdm660: use reg value for memory node
Date:   Thu, 16 Sep 2021 18:00:18 +0200
Message-Id: <20210916155819.938319765@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



