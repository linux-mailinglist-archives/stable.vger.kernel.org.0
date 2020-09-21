Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B37A3272D08
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729012AbgIUQgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:36:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729007AbgIUQgr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:36:47 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83242238E6;
        Mon, 21 Sep 2020 16:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706207;
        bh=90afgub8iWbgLpmOgjXNjlcBv1zQ7dExnTHIGd9uBdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pzTTCIX3+HUcx2Owvoyb8PziYU5SW44Nosit3WJolFCnGejfilYYh1O1qrT9LGuvw
         HQCtzeBf80F/98q3vO6cWkm6ZZc6Sr4udqRVbct9mrdPp0t/nYyTqszYnHszhZzcMe
         tjSVI6MqfOnuZjgKBqIMLIBc9Z2223p8/F7JSEKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinh Nguyen <dinguyen@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 01/94] ARM: dts: socfpga: fix register entry for timer3 on Arria10
Date:   Mon, 21 Sep 2020 18:26:48 +0200
Message-Id: <20200921162035.619383995@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.541285330@linuxfoundation.org>
References: <20200921162035.541285330@linuxfoundation.org>
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
index 672e73e35228c..64f30676b285d 100644
--- a/arch/arm/boot/dts/socfpga_arria10.dtsi
+++ b/arch/arm/boot/dts/socfpga_arria10.dtsi
@@ -779,7 +779,7 @@
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



