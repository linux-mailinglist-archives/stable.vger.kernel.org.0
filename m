Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35E337CC20
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243234AbhELQkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:40:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:50690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242308AbhELQeO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:34:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28E2761CBB;
        Wed, 12 May 2021 15:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835162;
        bh=ZtIhpQ3r/3UWxO4IUg57Z/OdOaYGmaZe35ax2o4HeJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sX15UXreqzmNkYijx2b9uK+pwSVGioQInY3Th1rfieOpYRegC0dN5UNJ//Kk061NC
         I8vuurGr7gyMP95/+RGe4ZWPDc/ktMPhilkA4gjFrlr0NA+oA6IILDPADJMUBEB6w8
         WBgnyjiwrg4V/Ztb30XVQsl7Xt4OUlP0926l7PPU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 234/677] arm64: dts: mt8173: fix wrong power-domain phandle of pmic
Date:   Wed, 12 May 2021 16:44:40 +0200
Message-Id: <20210512144845.010225714@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

[ Upstream commit 4db2b9af3ee92e6c51c6a9a5dc2748e4bc1800f9 ]

Due to power domain controller is added, the power domain's
phanle is also changed from 'scpsys' to 'spm', but forget to
modify pmic node's

Fixes: 8b6562644df9 ("arm64: dts: mediatek: Add mt8173 power domain controller")
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Reviewed-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Link: https://lore.kernel.org/r/1616048328-13579-1-git-send-email-chunfeng.yun@mediatek.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8173-evb.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8173-evb.dts b/arch/arm64/boot/dts/mediatek/mt8173-evb.dts
index 6dffada2e66b..28aa634c9780 100644
--- a/arch/arm64/boot/dts/mediatek/mt8173-evb.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8173-evb.dts
@@ -294,7 +294,7 @@
 
 &pwrap {
 	/* Only MT8173 E1 needs USB power domain */
-	power-domains = <&scpsys MT8173_POWER_DOMAIN_USB>;
+	power-domains = <&spm MT8173_POWER_DOMAIN_USB>;
 
 	pmic: mt6397 {
 		compatible = "mediatek,mt6397";
-- 
2.30.2



