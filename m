Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E5837C82D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238452AbhELQFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:05:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236009AbhELQCA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:02:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60B1D61CD9;
        Wed, 12 May 2021 15:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833597;
        bh=ZtIhpQ3r/3UWxO4IUg57Z/OdOaYGmaZe35ax2o4HeJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=InQkoTnfS5eZjYXpPsxqe07CfRcJPUq8PdyRFxWAyW3p0ZzuDobzNPnw1sPUaqUJN
         I+74JhMEbtvVc2K0+SUOxDv7vknP74xo/JNtKsF3fmg6pMx9GWGC+gQYqbbmAsBWPe
         KCZEcEzCIUVglZINAfde+Qvp+uUJO2VjPIbKr5s8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 212/601] arm64: dts: mt8173: fix wrong power-domain phandle of pmic
Date:   Wed, 12 May 2021 16:44:49 +0200
Message-Id: <20210512144834.823578354@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
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



