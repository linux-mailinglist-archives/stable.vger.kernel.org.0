Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADA6378144
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbhEJKZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:25:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:58196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231205AbhEJKZE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:25:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A86361466;
        Mon, 10 May 2021 10:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642239;
        bh=y43KoCPzgz8yjoh0Nm8TK/OQDXeSBOd5O6MkvblvPiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0rF0iAQTgB0TvNqPW2sY/CzyTuUE4ay2sxcFCB3s4ESkb8evOPhd/USBpS+puAow4
         kK7XgAMEyS2Yvj2Yj4doMFzM7Jileh4Ykd2/pP2O4QrzDEuJqkfqownTgSSpW43J9i
         k3wKAfQij3WplH4qkDGvMw4oRjvMiJU5hskBwlK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH 5.4 007/184] arm64: dts: mt8173: fix property typo of phys in dsi node
Date:   Mon, 10 May 2021 12:18:21 +0200
Message-Id: <20210510101950.443297099@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
References: <20210510101950.200777181@linuxfoundation.org>
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
@@ -1137,7 +1137,7 @@
 				 <&mmsys CLK_MM_DSI1_DIGITAL>,
 				 <&mipi_tx1>;
 			clock-names = "engine", "digital", "hs";
-			phy = <&mipi_tx1>;
+			phys = <&mipi_tx1>;
 			phy-names = "dphy";
 			status = "disabled";
 		};


