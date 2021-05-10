Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE5B1378728
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233414AbhEJLOL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:14:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:44218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236093AbhEJLHg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:07:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 917916191E;
        Mon, 10 May 2021 10:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644289;
        bh=rQEo2YwU+00SnbgGaM7Djx95pfqgGL6aVw7u+Wc3sE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0MhnHHxYOROguKW1U8QuGzWfPmtDwnZ2YBE/6M61WOOkG1Wz0teBKB2OtEjMnDkEI
         nsfzvk6oHGPLvJcqWo7deseVv++W4ydgJfJ2EJmDQ0YNoRGR83mQTfH80zg6TuGwox
         p4C+0coZqZLiWTHS/a6S22cUVYLOmvQ5HJWNq7A8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH 5.12 021/384] arm64: dts: mt8173: fix property typo of phys in dsi node
Date:   Mon, 10 May 2021 12:16:50 +0200
Message-Id: <20210510102015.574950163@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
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
@@ -1235,7 +1235,7 @@
 				 <&mmsys CLK_MM_DSI1_DIGITAL>,
 				 <&mipi_tx1>;
 			clock-names = "engine", "digital", "hs";
-			phy = <&mipi_tx1>;
+			phys = <&mipi_tx1>;
 			phy-names = "dphy";
 			status = "disabled";
 		};


