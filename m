Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7156C272C58
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbgIUQbm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:31:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:56684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728074AbgIUQbm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:31:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9221020757;
        Mon, 21 Sep 2020 16:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600705902;
        bh=9yR2eMshZReNeRLY8vsw/6kWqvZTHx00cYrwLvrRyOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YqmjqI7krIvCdKXLJbs9Xoi3lIgaCRZrkAal46B/BG4KBaOLZJ6VmaML54ITgJcmL
         UcsoqbdQSvdUY0W6GpBBhBv8FPsiToyY6eJezxRr+QgtGZu0DiUjdwsIsn1KbrsGy2
         m4YUy30YMz/oRB5k3zBah8eM//1/AeeL9fW4fwvM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinh Nguyen <dinguyen@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 01/46] ARM: dts: socfpga: fix register entry for timer3 on Arria10
Date:   Mon, 21 Sep 2020 18:27:17 +0200
Message-Id: <20200921162033.421728084@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162033.346434578@linuxfoundation.org>
References: <20200921162033.346434578@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinh Nguyen <dinguyen@kernel.org>

[ Upstream commit 0ff5a4812be4ebd4782bbb555d369636eea164f7 ]

Fixes the register address for the timer3 entry on Arria10.

Fixes: 475dc86d08de4 ("arm: dts: socfpga: Add a base DTSI for Altera's Arria10 SOC")
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/socfpga_arria10.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/socfpga_arria10.dtsi b/arch/arm/boot/dts/socfpga_arria10.dtsi
index cce9e50acf68a..b648b1b253c5e 100644
--- a/arch/arm/boot/dts/socfpga_arria10.dtsi
+++ b/arch/arm/boot/dts/socfpga_arria10.dtsi
@@ -652,7 +652,7 @@
 		timer3: timer3@ffd00100 {
 			compatible = "snps,dw-apb-timer";
 			interrupts = <0 118 IRQ_TYPE_LEVEL_HIGH>;
-			reg = <0xffd01000 0x100>;
+			reg = <0xffd00100 0x100>;
 			clocks = <&l4_sys_free_clk>;
 			clock-names = "timer";
 		};
-- 
2.25.1



