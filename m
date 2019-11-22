Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08887106ED6
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730855AbfKVK7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:59:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:49580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730507AbfKVK67 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:58:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84F4420706;
        Fri, 22 Nov 2019 10:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420339;
        bh=k8Y5H6Z36lm9qTZE69Um8n6ih5/V0cui+ibzPJzQNgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F4Y3jJjQ1Gm2kOdTlJGDaYCZvsgCi/2l3M/IX7aBjOPwaXVRSa00eSp8NTg/beYiC
         FRe4/Z18L/WMeQwj1CtBvgdGpmtA2acqxyotECsd2JUohqBmF5eqADA9/HBsC0nyn9
         3Ky299flvfYwiEJ5qlmrdwBS+lzzDgPhyIchWt5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 071/220] ARM: dts: at91: at91sam9x5cm: fix addressable nand flash size
Date:   Fri, 22 Nov 2019 11:27:16 +0100
Message-Id: <20191122100917.312639816@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

[ Upstream commit 6f270d88a0c4a11725afd8fd2001ae408733afbf ]

at91sam9x5cm comes with a 2Gb NAND flash. Fix the rootfs size to
match this limit.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Signed-off-by: Ludovic Desroches <ludovic.desroches@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/at91sam9x5cm.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/at91sam9x5cm.dtsi b/arch/arm/boot/dts/at91sam9x5cm.dtsi
index 4908ee07e6287..993eabe1cf7a5 100644
--- a/arch/arm/boot/dts/at91sam9x5cm.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5cm.dtsi
@@ -100,7 +100,7 @@
 
 						rootfs@800000 {
 							label = "rootfs";
-							reg = <0x800000 0x1f800000>;
+							reg = <0x800000 0x0f800000>;
 						};
 					};
 				};
-- 
2.20.1



