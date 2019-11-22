Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11F0C106C20
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbfKVKuH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:50:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:59946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727994AbfKVKuH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:50:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C8F720656;
        Fri, 22 Nov 2019 10:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419806;
        bh=ZCHLhni9I5Hq8zgWjDgMU4vLfAwPEpoV4JgK5zdxmCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dn+ZKgQ2VKoDJVBB+YW6gkgrz/h+kmjPDYlvpaTsOJVjHBThCX8V15FdkW6lvsVVa
         xaWbkqCv/2WhS3ZstkVwu6fIIMGuuYT9FdN7pvTsDNfVk3y6UfgsKErFW/JqLoaox5
         H3hAuonqDTtktcLw8Glgu4KYhBxCh0a9/jRs7jnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Rossak <embed3d@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 016/122] ARM: dts: sun8i: h3-h5: ir register size should be the whole memory block
Date:   Fri, 22 Nov 2019 11:27:49 +0100
Message-Id: <20191122100734.304732181@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100722.177052205@linuxfoundation.org>
References: <20191122100722.177052205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Rossak <embed3d@gmail.com>

[ Upstream commit 6c700289a3e84d5d3f2a95cf27732a7f7fce105b ]

The size of the register should be the size of the whole memory block,
not just the registers, that are needed.

Signed-off-by: Philipp Rossak <embed3d@gmail.com>
Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sunxi-h3-h5.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sunxi-h3-h5.dtsi b/arch/arm/boot/dts/sunxi-h3-h5.dtsi
index 11240a8313c26..03f37081fc64e 100644
--- a/arch/arm/boot/dts/sunxi-h3-h5.dtsi
+++ b/arch/arm/boot/dts/sunxi-h3-h5.dtsi
@@ -594,7 +594,7 @@
 			clock-names = "apb", "ir";
 			resets = <&r_ccu RST_APB0_IR>;
 			interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
-			reg = <0x01f02000 0x40>;
+			reg = <0x01f02000 0x400>;
 			status = "disabled";
 		};
 
-- 
2.20.1



