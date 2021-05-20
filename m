Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66AE738A238
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233064AbhETJjf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:39:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:35870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232598AbhETJhx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:37:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C414C6141A;
        Thu, 20 May 2021 09:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503029;
        bh=IESpczNtRztp3kHwM5MjHK41+QGSr+LUIIq929RjlQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CPZqyW5Ma1Pix31zajlKqGTSqAgKHBhvBcrYhH7JRhdhPsNW3kn6RKGJh30s9P+/A
         2okTdVsAJwS8s9bJKojuC81gbJ4NGisMXHojJWdIjmWjKiHs2GaIM7+IJghyZ5We7v
         g1H9V3brM8SGQFy0s9RG5V0hMmQDGrwyUZHkYs0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH 4.19 007/425] arm64: dts: mt8173: fix property typo of phys in dsi node
Date:   Thu, 20 May 2021 11:16:16 +0200
Message-Id: <20210520092131.573372632@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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
@@ -1111,7 +1111,7 @@
 				 <&mmsys CLK_MM_DSI1_DIGITAL>,
 				 <&mipi_tx1>;
 			clock-names = "engine", "digital", "hs";
-			phy = <&mipi_tx1>;
+			phys = <&mipi_tx1>;
 			phy-names = "dphy";
 			status = "disabled";
 		};


