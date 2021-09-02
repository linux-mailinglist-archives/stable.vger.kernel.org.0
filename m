Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F406A3FEBBF
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 11:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236202AbhIBJ7b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 05:59:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:41348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232644AbhIBJ7a (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Sep 2021 05:59:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5135360F6C;
        Thu,  2 Sep 2021 09:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630576712;
        bh=q8E+E2rYJkV7BQee24UsqEKlRCaqEhysh5UMj0qQ8s4=;
        h=From:To:Cc:Subject:Date:From;
        b=sdEgqb3FIGTAiH2nvKXrniMgXmZiqLlwkAmvCDNHptfN55A7p8D3mI2cwTZUczA99
         4YLjT0UeAXmS7TUoiHO8OY05w0iOufK1dvHrT5XR/5oKn3XUpgxsBPJrfdlM0fSeoT
         hPNDM272Z6LCbfTxSqo8NIMeCJTvdhI004oDK24GFSxzBxSbbrm0vcj8LRBgOSJ1vY
         hsRMSDV+sZTAiDZkLSodD07sQ9QwGIAQhTV6LpQd/47pXRQvOzVpU8JhvxxP33iOUp
         lidyQoUsob7oalHv4b8IFoNS0oCwakNqVHYUMFru4LKlSHvlla+dN4evFwcpCcfCnZ
         wh7hIHoKzyNVQ==
From:   Roger Quadros <rogerq@kernel.org>
To:     tony@atomide.com
Cc:     linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Roger Quadros <rogerq@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH] ARM: dts: omap3430-sdp: Fix NAND device node
Date:   Thu,  2 Sep 2021 12:58:28 +0300
Message-Id: <20210902095828.16788-1-rogerq@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Nand is on CS1 so reg properties first field should be 1 not 0.

Fixes: 44e4716499b8 ("ARM: dts: omap3: Fix NAND device nodes")
Cc: stable@vger.kernel.org # v4.6+
Signed-off-by: Roger Quadros <rogerq@kernel.org>
---
 arch/arm/boot/dts/omap3430-sdp.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/omap3430-sdp.dts b/arch/arm/boot/dts/omap3430-sdp.dts
index c5b903718414..7d530ae3483b 100644
--- a/arch/arm/boot/dts/omap3430-sdp.dts
+++ b/arch/arm/boot/dts/omap3430-sdp.dts
@@ -101,7 +101,7 @@
 
 	nand@1,0 {
 		compatible = "ti,omap2-nand";
-		reg = <0 0 4>; /* CS0, offset 0, IO size 4 */
+		reg = <1 0 4>; /* CS1, offset 0, IO size 4 */
 		interrupt-parent = <&gpmc>;
 		interrupts = <0 IRQ_TYPE_NONE>, /* fifoevent */
 			     <1 IRQ_TYPE_NONE>;	/* termcount */
-- 
2.17.1

