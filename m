Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E3137C7FC
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235350AbhELQD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:03:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:44390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234223AbhELP6F (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:58:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68F676194F;
        Wed, 12 May 2021 15:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833508;
        bh=VueTanl08Ztp8xt2xWiXT7ArSZm0qBaUbyNUsH4IVO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GVF3IEqPEguURXc0uRu+mEhYyLdKFqvH7ikyrxk6g0howk/9wrWftIclFyjVnKNnI
         WBwVUVQ/C2Q7ULBaw3Dt2d/1dtc58PIF0bAU6ho/8BOW0d9a2s+e9ELeSirzlJX2H+
         xopYxcnZiMhmCLrEEnGhmtQEk4WHJ+swZTOPfp/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 176/601] arm64: dts: qcom: sm8250: Fix level triggered PMU interrupt polarity
Date:   Wed, 12 May 2021 16:44:13 +0200
Message-Id: <20210512144833.639389128@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
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
index 1ae90e8b70f3..ad2d6758fed8 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -216,7 +216,7 @@
 
 	pmu {
 		compatible = "arm,armv8-pmuv3";
-		interrupts = <GIC_PPI 7 IRQ_TYPE_LEVEL_HIGH>;
+		interrupts = <GIC_PPI 7 IRQ_TYPE_LEVEL_LOW>;
 	};
 
 	psci {
-- 
2.30.2



