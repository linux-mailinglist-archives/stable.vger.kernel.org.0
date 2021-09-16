Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC9A240E06D
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241198AbhIPQVV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:21:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241307AbhIPQP1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:15:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DE9460F6C;
        Thu, 16 Sep 2021 16:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808699;
        bh=4hIy8UnwQrH4j2ngGlzjY5U9vxLNhjopSfaM/eeqlH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ve+JZHcM23cvRnthS3H4SfSMEcYf6An4ZiHDQUCF6LZbH96zCk/ZyS7N84srr5CZz
         fCX5X5CHL/DlXLok7pC+vm4dHk1Q0o0HPGLc8FrqSSAn6WKUZk63CgtF4tCRow2ryM
         XJW/ZxMZvAXBaA8hdLgCo0l+/1J7fgxdkrWt+PLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 190/306] arm64: dts: qcom: sdm660: use reg value for memory node
Date:   Thu, 16 Sep 2021 17:58:55 +0200
Message-Id: <20210916155800.557077834@linuxfoundation.org>
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



