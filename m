Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07F0429C628
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1825776AbgJ0SNz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 14:13:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756502AbgJ0ONr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:13:47 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB03622202;
        Tue, 27 Oct 2020 14:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808027;
        bh=g5CftcDNGEmvZBPsOs9Z2qFMY7FoPoqNiPm0iEZXBC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nrfjbg3IuiOjrLLv3Xh8dtSVsKlLvkXTaHZ1phTVsE+fOf3K/8Dutyysfy1zrasP8
         T28i1w5D2471wFqpTylW2ZqFncU1ct98ZlOFNa2pNVl7NRY2SCtRyMgr1WKC0Ei4rF
         pAL5v84uFdY1EOiarwBR64bmbvI7cm6NSy+Ruy9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Ciocaltea <cristian.ciocaltea@gmail.com>,
        Peter Korsgaard <peter@korsgaard.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 129/191] ARM: dts: owl-s500: Fix incorrect PPI interrupt specifiers
Date:   Tue, 27 Oct 2020 14:49:44 +0100
Message-Id: <20201027134915.910056333@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134909.701581493@linuxfoundation.org>
References: <20201027134909.701581493@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Ciocaltea <cristian.ciocaltea@gmail.com>

[ Upstream commit 55f6c9931f7c32f19cf221211f099dfd8dab3af9 ]

The PPI interrupts for cortex-a9 were incorrectly specified, fix them.

Fixes: fdfe7f4f9d85 ("ARM: dts: Add Actions Semi S500 and LeMaker Guitar")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
Reviewed-by: Peter Korsgaard <peter@korsgaard.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/owl-s500.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/owl-s500.dtsi b/arch/arm/boot/dts/owl-s500.dtsi
index 51a48741d4c01..2557ce026add2 100644
--- a/arch/arm/boot/dts/owl-s500.dtsi
+++ b/arch/arm/boot/dts/owl-s500.dtsi
@@ -82,21 +82,21 @@ scu: scu@b0020000 {
 		global_timer: timer@b0020200 {
 			compatible = "arm,cortex-a9-global-timer";
 			reg = <0xb0020200 0x100>;
-			interrupts = <GIC_PPI 0 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_EDGE_RISING)>;
+			interrupts = <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_EDGE_RISING)>;
 			status = "disabled";
 		};
 
 		twd_timer: timer@b0020600 {
 			compatible = "arm,cortex-a9-twd-timer";
 			reg = <0xb0020600 0x20>;
-			interrupts = <GIC_PPI 2 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_EDGE_RISING)>;
+			interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_EDGE_RISING)>;
 			status = "disabled";
 		};
 
 		twd_wdt: wdt@b0020620 {
 			compatible = "arm,cortex-a9-twd-wdt";
 			reg = <0xb0020620 0xe0>;
-			interrupts = <GIC_PPI 3 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_EDGE_RISING)>;
+			interrupts = <GIC_PPI 14 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_EDGE_RISING)>;
 			status = "disabled";
 		};
 
-- 
2.25.1



