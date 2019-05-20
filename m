Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45D9F23462
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389295AbfETM0T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:26:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:41604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389284AbfETM0P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:26:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9E9C20645;
        Mon, 20 May 2019 12:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355175;
        bh=xxLEzmsGULtUDU3Io0agV8eEWFU+4vqzpgbIFY8kxKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m8DS3pPZHlm/o1jNb2nsVOQulxPhyJPaET2fb/61sMC1t8KYFW4XcpWDOPXp5Y5uB
         ivLdBkvzjH9CV0j8nPVMAnuKGMXq2QWUgfYcB3qI2ObgfuEGs+RekkV8UfmrbzuZ1W
         k1lVfG/JGe8lAZ446blGGWmLVpofpRr0bRfa02eM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stuart Menefy <stuart.menefy@mathembedded.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 5.0 008/123] ARM: dts: exynos: Fix interrupt for shared EINTs on Exynos5260
Date:   Mon, 20 May 2019 14:13:08 +0200
Message-Id: <20190520115245.785495883@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stuart Menefy <stuart.menefy@mathembedded.com>

commit b7ed69d67ff0788d8463e599dd5dd1b45c701a7e upstream.

Fix the interrupt information for the GPIO lines with a shared EINT
interrupt.

Fixes: 16d7ff2642e7 ("ARM: dts: add dts files for exynos5260 SoC")
Cc: stable@vger.kernel.org
Signed-off-by: Stuart Menefy <stuart.menefy@mathembedded.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/exynos5260.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/exynos5260.dtsi
+++ b/arch/arm/boot/dts/exynos5260.dtsi
@@ -223,7 +223,7 @@
 			wakeup-interrupt-controller {
 				compatible = "samsung,exynos4210-wakeup-eint";
 				interrupt-parent = <&gic>;
-				interrupts = <GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts = <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>;
 			};
 		};
 


