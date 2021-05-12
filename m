Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3237E37CC17
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242999AbhELQkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:40:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242286AbhELQeE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:34:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71F7561CB5;
        Wed, 12 May 2021 15:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835150;
        bh=Fhfyz8opL3zqIOOAwHks1RGCX8Huwe+QPutvFkocZic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BA+40oHmAh7x0xW1Yg8P3XQbtn6VS28Q3ynM49wazCFL0CJV86IDljaNz853LNtyp
         R8SVVJ1mbSmJftEL60Is+okU1RxhxBnxUhzS8NMVBxv6VUUSyot+tfWHM+MDZSnvvG
         jHlbemblq+Sd682S8kBw/QEif0Rtm80uMFDa5HHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 193/677] arm64: dts: qcom: sm8350: Fix level triggered PMU interrupt polarity
Date:   Wed, 12 May 2021 16:43:59 +0200
Message-Id: <20210512144843.662568725@linuxfoundation.org>
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

[ Upstream commit 794d3e309e44c99158d0166b1717f297341cf3ab ]

As per interrupt documentation for SM8350 SoC, the polarity
for level triggered PMU interrupt is low, fix this.

Fixes: b7e8f433a673 ("arm64: dts: qcom: Add basic devicetree support for SM8350 SoC")
Signed-off-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Link: https://lore.kernel.org/r/ca57409198477f7815e32a6a7467dcdc9b93dc4f.1613468366.git.saiprakash.ranjan@codeaurora.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index 5ef460458f5c..e8bf3f95c674 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -153,7 +153,7 @@
 
 	pmu {
 		compatible = "arm,armv8-pmuv3";
-		interrupts = <GIC_PPI 7 IRQ_TYPE_LEVEL_HIGH>;
+		interrupts = <GIC_PPI 7 IRQ_TYPE_LEVEL_LOW>;
 	};
 
 	psci {
-- 
2.30.2



