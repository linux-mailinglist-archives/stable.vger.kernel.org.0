Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D550C3CE404
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347650AbhGSPlo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:41:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348757AbhGSPfa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57F026113A;
        Mon, 19 Jul 2021 16:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711278;
        bh=v8/fH8vt3ZYanw6Nbkc0VurSBavd0JBh7biQHhn9k/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fMzzhYKqp3A3ef5xUQ9aAFbZmRxL9HqXI+gXROGGUAeipy3YikttnqxSqJcHplf2g
         n+mXN3sIkLyYXDLK8g8TSQDI2/Cc776euJf1uHFWOS2++J3V7jXgZXjZTl5DhaxEMC
         8izjeVS/uE2RECNBg/KKFeclwnf0CV8N/RVCPmk0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 294/351] ARM: dts: qcom: sdx55-t55: Represent secure-regions as 64-bit elements
Date:   Mon, 19 Jul 2021 16:54:00 +0200
Message-Id: <20210719144954.759258520@linuxfoundation.org>
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

[ Upstream commit 619d3c4bf8f346ac9192d3c266efc9e231ca5d17 ]

The corresponding MTD code expects the regions to be of 64-bit elements.
Hence, prefix "/bits/ 64", otherwise the regions will not be parsed
correctly.

Fixes: 3263d4be5788 ("ARM: dts: qcom: sdx55: Add basic devicetree support for Thundercomm T55")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20210512050141.43338-1-manivannan.sadhasivam@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-sdx55-t55.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/qcom-sdx55-t55.dts b/arch/arm/boot/dts/qcom-sdx55-t55.dts
index ddcd53aa533d..2ffcd085904d 100644
--- a/arch/arm/boot/dts/qcom-sdx55-t55.dts
+++ b/arch/arm/boot/dts/qcom-sdx55-t55.dts
@@ -250,7 +250,7 @@
 		nand-ecc-step-size = <512>;
 		nand-bus-width = <8>;
 		/* efs2 partition is secured */
-		secure-regions = <0x500000 0xb00000>;
+		secure-regions = /bits/ 64 <0x500000 0xb00000>;
 	};
 };
 
-- 
2.30.2



