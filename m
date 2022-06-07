Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E35095414B0
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358645AbiFGUVp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359827AbiFGUVU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:21:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35DF179C14;
        Tue,  7 Jun 2022 11:30:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B07FB8237C;
        Tue,  7 Jun 2022 18:30:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D8BBC385A2;
        Tue,  7 Jun 2022 18:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626643;
        bh=l53PuloLp8snpYt+EpBaWYwIsGqjonPLm9LcERIFfJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q0iylEJhikylgfvDEMUnvTNGRqE7vZpTrZ75vcHXFZ5QI4eFM3/zA+ju7aozFvjWW
         XvkvlGbdoEX1cv9/vogms3t3JCiHCDTYo9vyOMGZrnC+G3eq0VL0tTliTxCQGKZts6
         5Wfg1aCocgVtnkaGt2OacFO2shBJgSAhAN91ImN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Allen-KH Cheng <allen-kh.cheng@mediatek.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Miles Chen <miles.chen@mediatek.com>,
        "=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" 
        <nfraprado@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 452/772] arm64: dts: mt8192: Fix nor_flash status disable typo
Date:   Tue,  7 Jun 2022 19:00:44 +0200
Message-Id: <20220607165002.321644159@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAD_ENC_HEADER,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Allen-KH Cheng <allen-kh.cheng@mediatek.com>

[ Upstream commit 27f0eb16b0d417c155e96b5d3b89074699944e09 ]

Correct nor_flash status disable typo of mt8192 SoC.

Fixes: d0a197a0d064a ("arm64: dts: mt8192: add nor_flash device node")

Signed-off-by: Allen-KH Cheng <allen-kh.cheng@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Miles Chen <miles.chen@mediatek.com>
Reviewed-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Link: https://lore.kernel.org/r/20220318144534.17996-11-allen-kh.cheng@mediatek.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8192.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8192.dtsi b/arch/arm64/boot/dts/mediatek/mt8192.dtsi
index 53d790c335f9..cd010185753e 100644
--- a/arch/arm64/boot/dts/mediatek/mt8192.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8192.dtsi
@@ -470,7 +470,7 @@
 			clock-names = "spi", "sf", "axi";
 			#address-cells = <1>;
 			#size-cells = <0>;
-			status = "disable";
+			status = "disabled";
 		};
 
 		audsys: clock-controller@11210000 {
-- 
2.35.1



