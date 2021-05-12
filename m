Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAB9A37C3EB
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233729AbhELPXy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:23:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:59826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233853AbhELPVj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:21:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD8FB61454;
        Wed, 12 May 2021 15:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832134;
        bh=E62k1cuOMxY+vCfIvH9O1qZGVdzTTtfHu3g5jmImJfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HhWbY0H/pC1vqyOKk0v479G0348LVLTcs2G3r1eTnCu+WQNJcAv4BXquNEk9dPZt3
         Wik8rvf+TdD296vIkGflQNyqza1/3RbYweqbYaYHvK1XG0xiXKl+RTustpGTZ9am+V
         U0ueVDSo4wI7yJFDqxXQf08x15tiAzqsV0S3JveA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 156/530] arm64: dts: qcom: sm8250: Fix timer interrupt to specify EL2 physical timer
Date:   Wed, 12 May 2021 16:44:26 +0200
Message-Id: <20210512144824.975144787@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>

[ Upstream commit 29a3349543e4ce3fe4e2a761403cc629e3534c67 ]

ARM architected timer interrupts DT property specifies EL2/HYP
physical interrupt and not EL2/HYP virtual interrupt for the 4th
interrupt property. As per interrupt documentation for SM8250 SoC,
the EL2/HYP physical timer interrupt is 10 and EL2/HYP virtual timer
interrupt is 12, so fix the 4th timer interrupt to be EL2 physical
timer interrupt (10 in this case).

Fixes: 60378f1a171e ("arm64: dts: qcom: sm8250: Add sm8250 dts file")
Signed-off-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Link: https://lore.kernel.org/r/744e58f725d279eb2b049a7da42b0f09189f4054.1613468366.git.saiprakash.ranjan@codeaurora.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index 3bcd067c0dcd..f96c8a4fc3cc 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -2379,7 +2379,7 @@
 				(GIC_CPU_MASK_SIMPLE(8) | IRQ_TYPE_LEVEL_LOW)>,
 			     <GIC_PPI 11
 				(GIC_CPU_MASK_SIMPLE(8) | IRQ_TYPE_LEVEL_LOW)>,
-			     <GIC_PPI 12
+			     <GIC_PPI 10
 				(GIC_CPU_MASK_SIMPLE(8) | IRQ_TYPE_LEVEL_LOW)>;
 	};
 
-- 
2.30.2



