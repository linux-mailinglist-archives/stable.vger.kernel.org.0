Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487213CE377
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346144AbhGSPij (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:38:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:59724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348778AbhGSPfa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25E406113B;
        Mon, 19 Jul 2021 16:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711281;
        bh=cyssPot+2ta3N6rVaE2Dy+1Sk+5cmyL76+LCPB/deyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BdrEDLKW3jLWs6jEmhHOQYFxKTpEEYv6qoby8xQ3oeWENFqrEkZVP92Xyai+zMRFX
         nLRzVZQx6nzhqEuab2m5EK32kUsgFawfkwsGzYHErU2f+onHqfcEbNonreib+mMdbr
         tsh2sWxTBHYUbON4fc7TnUMe5b76DQ4Efph8C3bo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 295/351] ARM: dts: qcom: sdx55-telit: Represent secure-regions as 64-bit elements
Date:   Mon, 19 Jul 2021 16:54:01 +0200
Message-Id: <20210719144954.791379133@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 0fa1baeedf06765ec6b441692ba2a2e83b7d17dc ]

The corresponding MTD code expects the regions to be of 64-bit elements.
Hence, prefix "/bits/ 64", otherwise the regions will not be parsed
correctly.

Fixes: 6a5d3c611930 ("ARM: dts: qcom: sdx55: Add basic devicetree support for Telit FN980 TLB")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20210512050141.43338-2-manivannan.sadhasivam@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-sdx55-telit-fn980-tlb.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-sdx55-telit-fn980-tlb.dts b/arch/arm/boot/dts/qcom-sdx55-telit-fn980-tlb.dts
index 3065f84634b8..80c40da79604 100644
--- a/arch/arm/boot/dts/qcom-sdx55-telit-fn980-tlb.dts
+++ b/arch/arm/boot/dts/qcom-sdx55-telit-fn980-tlb.dts
@@ -250,8 +250,8 @@
 		nand-ecc-step-size = <512>;
 		nand-bus-width = <8>;
 		/* ico and efs2 partitions are secured */
-		secure-regions = <0x500000 0x500000
-				  0xa00000 0xb00000>;
+		secure-regions = /bits/ 64 <0x500000 0x500000
+					    0xa00000 0xb00000>;
 	};
 };
 
-- 
2.30.2



