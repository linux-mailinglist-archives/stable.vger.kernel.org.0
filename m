Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4063931376D
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233671AbhBHPZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:25:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:60178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233657AbhBHPTq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:19:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 894E364EED;
        Mon,  8 Feb 2021 15:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797173;
        bh=zNhMlsgq60S4BnOolyPrz6VRVJNFAno/8PIq7TpNZnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MKslhgqaxHwqMT1F7EJZGJmZnO/bNaY650C3Ano3jr4wmY+LSR56y4zmGCY8RBzBy
         RomURF1y5swL37JFn7zGOlFNuRfXdsyHc7gILs0m1mtfSTtBmvBlhpDeo0X5S/24d3
         FsNv3dIxVyIi0EkIIi7GpMQUV4/Mj8ILO4OXE0F8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sandy Huang <hjc@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 018/120] arm64: dts: rockchip: fix vopl iommu irq on px30
Date:   Mon,  8 Feb 2021 16:00:05 +0100
Message-Id: <20210208145819.122937497@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sandy Huang <hjc@rock-chips.com>

[ Upstream commit 656c648354e1561fa4f445b0b3252ec1d24e3951 ]

The vop-mmu shares the irq with its matched vop but not the vpu.

Fixes: 7053e06b1422 ("arm64: dts: rockchip: add core dtsi file for PX30 SoCs")
Signed-off-by: Sandy Huang <hjc@rock-chips.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Ezequiel Garcia <ezequiel@collabora.com>
Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Tested-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Link: https://lore.kernel.org/r/20210108110627.3231226-1-heiko@sntech.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/px30.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/px30.dtsi b/arch/arm64/boot/dts/rockchip/px30.dtsi
index 2695ea8cda142..64193292d26c3 100644
--- a/arch/arm64/boot/dts/rockchip/px30.dtsi
+++ b/arch/arm64/boot/dts/rockchip/px30.dtsi
@@ -1097,7 +1097,7 @@
 	vopl_mmu: iommu@ff470f00 {
 		compatible = "rockchip,iommu";
 		reg = <0x0 0xff470f00 0x0 0x100>;
-		interrupts = <GIC_SPI 79 IRQ_TYPE_LEVEL_HIGH>;
+		interrupts = <GIC_SPI 78 IRQ_TYPE_LEVEL_HIGH>;
 		interrupt-names = "vopl_mmu";
 		clocks = <&cru ACLK_VOPL>, <&cru HCLK_VOPL>;
 		clock-names = "aclk", "iface";
-- 
2.27.0



