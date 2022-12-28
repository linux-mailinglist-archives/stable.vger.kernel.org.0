Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 061A665793D
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233319AbiL1O7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:59:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233329AbiL1O65 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:58:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29FAA12AB7
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:58:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB5EA61540
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:58:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1B87C433EF;
        Wed, 28 Dec 2022 14:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239535;
        bh=xBGGz7xQCydoAMkMhr0MZjjfNOa0L1obhG/G9+6689o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tbEYtrVf28ETmOAxk+acRspnS3+PhjM/N64dBlm3QcCrSLv8LxYGhdCXluroJHzdo
         Stp7Ssjl0elOdhKDYeQaKuzheYPhdPsmgWOGn0fPEZf/xQyBufaXXHoZE8bFduvjFL
         1Lo+C/Yv1ay0kaU5n0lT+DZUDAePF2Sj9OKHaP0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Frank Wunderlich <frank-w@public-files.de>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0047/1073] arm64: dts: mt7986: fix trng node name
Date:   Wed, 28 Dec 2022 15:27:15 +0100
Message-Id: <20221228144329.396723276@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank Wunderlich <frank-w@public-files.de>

[ Upstream commit 07ce611c705217507c2a036bba8695cbd82c9e36 ]

Binding requires node name to be rng not trng:

trng@1020f000: $nodename:0: 'trng@1020f000' does not match '^rng@[0-9a-f]+$'

Fixes: 50137c150f5f ("arm64: dts: mediatek: add basic mt7986 support")
Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20221027151022.5541-1-linux@fw-web.de
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
index e3a407d03551..12c259ec042e 100644
--- a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
@@ -162,7 +162,7 @@ sgmiisys1: syscon@10070000 {
 			#clock-cells = <1>;
 		};
 
-		trng: trng@1020f000 {
+		trng: rng@1020f000 {
 			compatible = "mediatek,mt7986-rng",
 				     "mediatek,mt7623-rng";
 			reg = <0 0x1020f000 0 0x100>;
-- 
2.35.1



