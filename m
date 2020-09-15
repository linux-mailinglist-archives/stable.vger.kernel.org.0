Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2E126B6CF
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbgIPAL6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:11:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:41427 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726943AbgIOO0a (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:26:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D6902245A;
        Tue, 15 Sep 2020 14:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179562;
        bh=BAD7MJZDhiMFrBZy24x5q3ExUwMZLvdGyxskvCgd3Lo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m7M3UnM5VckATJcVesZGu0/X1JoW+QS9bfPM612r3+qaP7Gk/c3MH8LsmFGTtM7vI
         x32FTP7ou/o6dQxXW/ys5lJwk6dlCDwZ1Occwa/8Chjys67fXX+gqJ7n6XCRMwFbim
         wQHMv7WmOFAMvzv4mIlaWGVoK664HVuOP0T/DzMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinh Nguyen <dinguyen@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 006/132] ARM: dts: socfpga: fix register entry for timer3 on Arria10
Date:   Tue, 15 Sep 2020 16:11:48 +0200
Message-Id: <20200915140644.388494013@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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
index 906bfb580e9e7..f261a33440710 100644
--- a/arch/arm/boot/dts/socfpga_arria10.dtsi
+++ b/arch/arm/boot/dts/socfpga_arria10.dtsi
@@ -819,7 +819,7 @@
 		timer3: timer3@ffd00100 {
 			compatible = "snps,dw-apb-timer";
 			interrupts = <0 118 IRQ_TYPE_LEVEL_HIGH>;
-			reg = <0xffd01000 0x100>;
+			reg = <0xffd00100 0x100>;
 			clocks = <&l4_sys_free_clk>;
 			clock-names = "timer";
 			resets = <&rst L4SYSTIMER1_RESET>;
-- 
2.25.1



