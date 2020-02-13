Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B96A15C4DC
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387990AbgBMPvX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:51:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:44408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387512AbgBMP0P (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:26:15 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53C5F218AC;
        Thu, 13 Feb 2020 15:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607575;
        bh=1Cokn1pviuR+T44ILUmue+s8elSDJo3wXVwwfeJefyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TfUL9wh+mM9rCYYq0gkzIPvh/CokTstrZLFeS/RO4X3HYgm17T3r0lfc4nITm1xTB
         BWkVCh+0M4ohyPbP3U/kAoYS+6hd1wzIu/Fn4mh82QjFq5uPhMfDid6ZRV1cL8RYn2
         FH62X9Fj+VaRMt9g3oXExaTWkqYN1M8T8PKPcnQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Brodkin <abrodkin@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 4.14 153/173] ARC: [plat-axs10x]: Add missing multicast filter number to GMAC node
Date:   Thu, 13 Feb 2020 07:20:56 -0800
Message-Id: <20200213152010.011238652@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>

commit 7980dff398f86a618f502378fa27cf7e77449afa upstream.

Add a missing property to GMAC node so that multicast filtering works
correctly.

Fixes: 556cc1c5f528 ("ARC: [axs101] Add support for AXS101 SDP (software development platform)")
Acked-by: Alexey Brodkin <abrodkin@synopsys.com>
Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arc/boot/dts/axs10x_mb.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arc/boot/dts/axs10x_mb.dtsi
+++ b/arch/arc/boot/dts/axs10x_mb.dtsi
@@ -70,6 +70,7 @@
 			interrupt-names = "macirq";
 			phy-mode = "rgmii";
 			snps,pbl = < 32 >;
+			snps,multicast-filter-bins = <256>;
 			clocks = <&apbclk>;
 			clock-names = "stmmaceth";
 			max-speed = <100>;


