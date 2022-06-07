Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D38AC541BEB
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381735AbiFGVzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382947AbiFGVwH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:52:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD0A23F89A;
        Tue,  7 Jun 2022 12:10:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0CB061846;
        Tue,  7 Jun 2022 19:10:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC22C385A2;
        Tue,  7 Jun 2022 19:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629006;
        bh=ghnyZk8Ge/7Ge9bH2SGblDxlalkQ6+ik5emQgvTZezc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j1D8P4R9v3fw93NnST9ndHYzqSCn2sFiKDoD7oPYNhmb1p5m44BKbH1tBS3ahTtqa
         8tTNKaAHRue8G2JcLTr6/A6T9w4OIVmpO3hQqlwKOIReGKkAEm5irA0ggI+VzN/FsO
         u6SRHBcip2r4oP37led8Txgrm0KH/2EFp3MP1NUQ=
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
Subject: [PATCH 5.18 534/879] arm64: dts: mt8192: Fix nor_flash status disable typo
Date:   Tue,  7 Jun 2022 19:00:52 +0200
Message-Id: <20220607165018.373137565@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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
index 411feb294613..bcecc7484453 100644
--- a/arch/arm64/boot/dts/mediatek/mt8192.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8192.dtsi
@@ -679,7 +679,7 @@
 			assigned-clock-parents = <&clk26m>;
 			#address-cells = <1>;
 			#size-cells = <0>;
-			status = "disable";
+			status = "disabled";
 		};
 
 		audsys: clock-controller@11210000 {
-- 
2.35.1



