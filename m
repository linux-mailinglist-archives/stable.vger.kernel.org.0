Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD68B328FFC
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242242AbhCAUAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:00:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:55158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241825AbhCATrJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:47:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55683652E7;
        Mon,  1 Mar 2021 17:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620433;
        bh=CGGT42tboDqfsk1AL7bzSKuvQUA1wcuNQHGG7dOHCg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y0QQ8vxhRPyfDc3W4sIbQO0EFCDkaL15VQHKMRWfkMWwIggV0X733C/+7wg/keqEx
         Wb/+mylxL4hsCBtkq25zLwko0MWX4ghyYk7jhSppsfgr/WnvZu1LHTSvdpdvdf0id2
         AKXCX4ZZdnXR2Jgm+MHzUhbKzjumdCU30STXUDLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yongqiang Niu <yongqiang.niu@mediatek.com>,
        Hsin-Yi Wang <hsinyi@chromium.org>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 152/775] arm64: dts: mt8183: rename rdma fifo size
Date:   Mon,  1 Mar 2021 17:05:20 +0100
Message-Id: <20210301161209.162363850@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yongqiang Niu <yongqiang.niu@mediatek.com>

[ Upstream commit 431368c2648b59e5485a1b5f1276a83d885fb44b ]

property name must include only lowercase and '-'

Fixes: 91f9c963ce79 ("arm64: dts: mt8183: Add display nodes for MT8183")
Signed-off-by: Yongqiang Niu <yongqiang.niu@mediatek.com>
Signed-off-by: Hsin-Yi Wang <hsinyi@chromium.org>
Reviewed-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Reviewed-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Link: https://lore.kernel.org/r/20210128112314.1304160-2-hsinyi@chromium.org
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183.dtsi b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
index 5b782a4769e7e..6c84ccb709af6 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
@@ -1011,7 +1011,7 @@
 			clocks = <&mmsys CLK_MM_DISP_RDMA0>;
 			iommus = <&iommu M4U_PORT_DISP_RDMA0>;
 			mediatek,larb = <&larb0>;
-			mediatek,rdma_fifo_size = <5120>;
+			mediatek,rdma-fifo-size = <5120>;
 			mediatek,gce-client-reg = <&gce SUBSYS_1400XXXX 0xb000 0x1000>;
 		};
 
@@ -1023,7 +1023,7 @@
 			clocks = <&mmsys CLK_MM_DISP_RDMA1>;
 			iommus = <&iommu M4U_PORT_DISP_RDMA1>;
 			mediatek,larb = <&larb0>;
-			mediatek,rdma_fifo_size = <2048>;
+			mediatek,rdma-fifo-size = <2048>;
 			mediatek,gce-client-reg = <&gce SUBSYS_1400XXXX 0xc000 0x1000>;
 		};
 
-- 
2.27.0



