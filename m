Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 041051B3DF9
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730245AbgDVKXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:23:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:59688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730302AbgDVKXR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:23:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CFD72076B;
        Wed, 22 Apr 2020 10:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550997;
        bh=UCBTEmjPwfYxedLpiloHCMhgXUjd7KM5HX10MVfS7vk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OoImiid6NkLZFI1ToVJqUZvH4/JIgbWU7R0DohuW9RrhQWPwiPU7PQ8cD6iCrf61V
         BXfBfgGPCTW1A6KTnbCrhN+OYfGWPb/XN9GiA4BxnVAuiiWm6dI6Qxdz4HxLKjJcQV
         SSX+ZnsDsB2SZduPJLkvcoIV8HHW9tqxOdBhSXPQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@siol.net>,
        Chen-Yu Tsai <wens@csie.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 058/166] arm64: dts: allwinner: a64: Fix display clock register range
Date:   Wed, 22 Apr 2020 11:56:25 +0200
Message-Id: <20200422095055.101757354@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@siol.net>

[ Upstream commit 3e9a1a8b7f811de3eb1445d72f68766b704ad17c ]

Register range of display clocks is 0x10000, as it can be seen from
DE2 documentation.

Fix it.

Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Fixes: 2c796fc8f5dbd ("arm64: dts: allwinner: a64: add necessary device tree nodes for DE2 CCU")
[wens@csie.org: added fixes tag]
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
index 862b47dc9dc90..baa6f08dc1087 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
@@ -264,7 +264,7 @@
 
 			display_clocks: clock@0 {
 				compatible = "allwinner,sun50i-a64-de2-clk";
-				reg = <0x0 0x100000>;
+				reg = <0x0 0x10000>;
 				clocks = <&ccu CLK_BUS_DE>,
 					 <&ccu CLK_DE>;
 				clock-names = "bus",
-- 
2.20.1



