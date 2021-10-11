Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 016F9429143
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241753AbhJKOQ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:16:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237280AbhJKOO5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:14:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B01C61353;
        Mon, 11 Oct 2021 14:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633961100;
        bh=k50ZKT8agpX/HBWINfIl13FTeAPQEn1UItCaWf+ONEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GtThsGzaRrE20j6QXQHd31dlEnDQ4UF4DVt+dOxeCuglfXqH1GBC4rlLeAQ83enet
         UveCS4EXV/YntiJMSpPISmZnHEV4ZOVDIxqKPEOCJ/JIlJHeDXWI0u3PestpY9GvJt
         8H95U8q8BTe0tUzoD/D3c9IFu8hgpB0b95eUN04E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roger Quadros <rogerq@kernel.org>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 4.19 08/28] ARM: dts: omap3430-sdp: Fix NAND device node
Date:   Mon, 11 Oct 2021 15:46:58 +0200
Message-Id: <20211011134640.978241558@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134640.711218469@linuxfoundation.org>
References: <20211011134640.711218469@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roger Quadros <rogerq@kernel.org>

commit 80d680fdccba214e8106dc1aa33de5207ad75394 upstream.

Nand is on CS1 so reg properties first field should be 1 not 0.

Fixes: 44e4716499b8 ("ARM: dts: omap3: Fix NAND device nodes")
Cc: stable@vger.kernel.org # v4.6+
Signed-off-by: Roger Quadros <rogerq@kernel.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/omap3430-sdp.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/omap3430-sdp.dts
+++ b/arch/arm/boot/dts/omap3430-sdp.dts
@@ -104,7 +104,7 @@
 
 	nand@1,0 {
 		compatible = "ti,omap2-nand";
-		reg = <0 0 4>; /* CS0, offset 0, IO size 4 */
+		reg = <1 0 4>; /* CS1, offset 0, IO size 4 */
 		interrupt-parent = <&gpmc>;
 		interrupts = <0 IRQ_TYPE_NONE>, /* fifoevent */
 			     <1 IRQ_TYPE_NONE>;	/* termcount */


