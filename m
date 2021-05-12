Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB21A37CBF6
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239432AbhELQjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:39:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:50690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241891AbhELQbD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:31:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EC3B61C51;
        Wed, 12 May 2021 15:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835063;
        bh=rKL868noUL5uE6Dk7EGh5h8is5SjrEFWLvkhtXN6vmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZMyHTmt5oPen+WOc7JTJQaTRUXpTmWbLKEORYRORscvLT1txHtZs4hYmoO2AfxNmy
         /zadG1YQGXfC75Rz8PCBbGUy/1JHcK1a7JCtQE8On7Krt7QZHhMms2BTEhklUWLyih
         V+6HJSQuuhd75bYCEqrKOzdS7JeAgXmCKQNLp4C8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 194/677] arm64: dts: qcom: sm8250: Fix timer interrupt to specify EL2 physical timer
Date:   Wed, 12 May 2021 16:44:00 +0200
Message-Id: <20210512144843.695310436@linuxfoundation.org>
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
index 1864c459a563..3232ac6253bb 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -3754,7 +3754,7 @@
 				(GIC_CPU_MASK_SIMPLE(8) | IRQ_TYPE_LEVEL_LOW)>,
 			     <GIC_PPI 11
 				(GIC_CPU_MASK_SIMPLE(8) | IRQ_TYPE_LEVEL_LOW)>,
-			     <GIC_PPI 12
+			     <GIC_PPI 10
 				(GIC_CPU_MASK_SIMPLE(8) | IRQ_TYPE_LEVEL_LOW)>;
 	};
 
-- 
2.30.2



