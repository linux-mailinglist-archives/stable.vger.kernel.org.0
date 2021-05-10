Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A34D378327
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232326AbhEJKm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:42:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:48872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233001AbhEJKk5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:40:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4E7361108;
        Mon, 10 May 2021 10:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642697;
        bh=5ZyFABkoK2sJ5o/a0aWZqMArQAsOHUDRrePcWg/z8Go=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PiNDUudIBdvoxP71Bla9959CIoTYntU02OgiXYYeggsABRoCjUmNVGVi0vYluI+vK
         rvcr5I2t+VylYVgGfSrcW7OQ+nSZjKA5uJPc5+G1EoT1ipsDRyxlDryQqor8Vn5VJX
         6cgPd1fWfEKk757sWqxbgDhBhHYPvHW9QHNk7KC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH 5.10 015/299] arm64: dts: mt8173: fix property typo of phys in dsi node
Date:   Mon, 10 May 2021 12:16:52 +0200
Message-Id: <20210510102005.347517657@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
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
@@ -1169,7 +1169,7 @@
 				 <&mmsys CLK_MM_DSI1_DIGITAL>,
 				 <&mipi_tx1>;
 			clock-names = "engine", "digital", "hs";
-			phy = <&mipi_tx1>;
+			phys = <&mipi_tx1>;
 			phy-names = "dphy";
 			status = "disabled";
 		};


