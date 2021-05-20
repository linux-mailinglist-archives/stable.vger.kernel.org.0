Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47EE238A817
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238018AbhETKqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:46:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:43868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238126AbhETKoW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:44:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC8A661CA1;
        Thu, 20 May 2021 09:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504631;
        bh=3jVJDP9/py77/Uq8+q13bPlWQmnShOUQPdHx3Jdi0Xg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WYM8e/ibKlM3W7X+4ixrZjJI0D7orfEqxyVWwV5IyDIqyU7d85leuquKCra4VQk4c
         0USvdx6weqMsNnsHgMGnefvrLEOdfoZuZdQmKFAwPUveRHHo6FZKWp0UInz3sbpSRT
         zosdZ887mdSriy+K3SnCzhLcy+MTmil7aAQm8FgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH 4.9 010/240] arm64: dts: mt8173: fix property typo of phys in dsi node
Date:   Thu, 20 May 2021 11:20:02 +0200
Message-Id: <20210520092108.956922543@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

commit e4e5d030bd779fb8321d3b8bd65406fbe0827037 upstream.

Use 'phys' instead of 'phy'.

Fixes: 81ad4dbaf7af ("arm64: dts: mt8173: Add display subsystem related nodes")
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Reviewed-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210316092232.9806-5-chunfeng.yun@mediatek.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/mediatek/mt8173.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/mediatek/mt8173.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
@@ -914,7 +914,7 @@
 				 <&mmsys CLK_MM_DSI1_DIGITAL>,
 				 <&mipi_tx1>;
 			clock-names = "engine", "digital", "hs";
-			phy = <&mipi_tx1>;
+			phys = <&mipi_tx1>;
 			phy-names = "dphy";
 			status = "disabled";
 		};


