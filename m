Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1049E29BCA2
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802414AbgJ0Qem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:34:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:49218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802437AbgJ0Psi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:48:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E10152065C;
        Tue, 27 Oct 2020 15:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813717;
        bh=swjl4p7RllGljrdM008F8gqHzyP1dgi3X4kHCB5vjAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QxgAjryoDOIsxqWqRwTaCfugzHg1E4vsio0uPjMrIzB0mDJ17A+/NrOcFWvFyER42
         fc3sLSfhC+qQiSV57UUuexgCBn+eJ8F17JxkMrLWRRoEJ8ptJoYbB63NoeaiW2APv9
         oWwnAjCCzXbbbMUp30m1PbpVF5hmIpm+W6pX8jEM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cristian Ciocaltea <cristian.ciocaltea@gmail.com>,
        Peter Korsgaard <peter@korsgaard.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 615/757] ARM: dts: owl-s500: Fix incorrect PPI interrupt specifiers
Date:   Tue, 27 Oct 2020 14:54:25 +0100
Message-Id: <20201027135519.391149487@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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
index 5ceb6cc4451d2..1dbe4e8b38ac7 100644
--- a/arch/arm/boot/dts/owl-s500.dtsi
+++ b/arch/arm/boot/dts/owl-s500.dtsi
@@ -84,21 +84,21 @@ scu: scu@b0020000 {
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



