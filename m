Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A0037CC63
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238186AbhELQoo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:44:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242282AbhELQeC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:34:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 975E361CB6;
        Wed, 12 May 2021 15:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835147;
        bh=4u3HRLjPhZGibyYJX7Qa4AXlhhMpE0nwRimAW0zMkeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MAogZCtW0RfSLhpCL8sMnwBUrflAQoiGrcxx0Pu+9VCMirKKyf1bgKoQFIqZJeLyI
         rbRi5LhHiutTr+GFGNRNfu/PypKYgnGssME7KoCVeumyTADdCvsccP55XayZc43+FI
         FA0BmP+GCWMXACuaqbadIJe9L1QAX8Q2H93POGhU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 192/677] arm64: dts: qcom: sm8250: Fix level triggered PMU interrupt polarity
Date:   Wed, 12 May 2021 16:43:58 +0200
Message-Id: <20210512144843.629857745@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>

[ Upstream commit 93138ef5ac923b10f81575d35dbcb83136cbfc40 ]

As per interrupt documentation for SM8250 SoC, the polarity
for level triggered PMU interrupt is low, fix this.

Fixes: 60378f1a171e ("arm64: dts: qcom: sm8250: Add sm8250 dts file")
Signed-off-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Link: https://lore.kernel.org/r/96680a1c6488955c9eef7973c28026462b2a4ec0.1613468366.git.saiprakash.ranjan@codeaurora.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index 947e1accae3a..1864c459a563 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -279,7 +279,7 @@
 
 	pmu {
 		compatible = "arm,armv8-pmuv3";
-		interrupts = <GIC_PPI 7 IRQ_TYPE_LEVEL_HIGH>;
+		interrupts = <GIC_PPI 7 IRQ_TYPE_LEVEL_LOW>;
 	};
 
 	psci {
-- 
2.30.2



