Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC1D76AE878
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbjCGRQF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:16:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbjCGRPl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:15:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A79B234E1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:11:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23B85B8199E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:11:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D90C4339B;
        Tue,  7 Mar 2023 17:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209075;
        bh=u10q3oj9dI4Sa0jutyF/vTnJWuArr5WTLPDvTke4qFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2YItJ4emM9J8TnPIIfPsZW0Kds3My/u3q/6F7H8oUekM6upbz3n+Lt+fRJ1FMPiXc
         2dus8EJ5m7Kdqm2lQ+/VwPjjcw5H+CWVp9IGDSb8Zzyy6HFWRsy56BuRVjzBx2MGwz
         h0a/ubNzIlEy7U3GAnzFGSuGMx2v7VhWwPIEu7OI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Allen-KH Cheng <allen-kh.cheng@mediatek.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        "=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" 
        <nfraprado@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0103/1001] arm64: dts: mediatek: mt7986: Fix watchdog compatible
Date:   Tue,  7 Mar 2023 17:47:55 +0100
Message-Id: <20230307170026.624233107@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAD_ENC_HEADER,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Allen-KH Cheng <allen-kh.cheng@mediatek.com>

[ Upstream commit 70d24df30d06e5c822ba94751166ef55d0e28a89 ]

MT7986's watchdog embeds a reset controller and needs only the
mediatek,mt7986-wdt compatible string as the MT6589 one is there
for watchdogs that don't have any reset controller capability.

Fixes: 50137c150f5f ("arm64: dts: mediatek: add basic mt7986 support")
Signed-off-by: Allen-KH Cheng <allen-kh.cheng@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Link: https://lore.kernel.org/r/20221108033209.22751-4-allen-kh.cheng@mediatek.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
index 0e9406fc63e2d..0ed5e067928b5 100644
--- a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
@@ -167,8 +167,7 @@ topckgen: topckgen@1001b000 {
 		};
 
 		watchdog: watchdog@1001c000 {
-			compatible = "mediatek,mt7986-wdt",
-				     "mediatek,mt6589-wdt";
+			compatible = "mediatek,mt7986-wdt";
 			reg = <0 0x1001c000 0 0x1000>;
 			interrupts = <GIC_SPI 110 IRQ_TYPE_LEVEL_HIGH>;
 			#reset-cells = <1>;
-- 
2.39.2



