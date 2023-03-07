Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 393586AEE0E
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbjCGSJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:09:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232331AbjCGSJG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:09:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 716BC96613
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:03:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2DE9B819C9
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:03:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F75C433D2;
        Tue,  7 Mar 2023 18:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212194;
        bh=uqI6aRolVZjlzdegOLfEgpqZ5KEAX980zGV5Qb490Og=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HDhLlHzrnwmgpXuD89orkd2rf/F9/L7lXn2QKJjji5uFZ3hGiSVHcGz/lWFA/T7wD
         +zFCB2Gt6a2OZ/N4UYOyulf8vs6U7IZ60ZTNulxwa6NvZZAkai+csLI9xtluAwkkBg
         6/zZHwNM+JNHmRkyj+CemdXe0i8I+EbkWQot5yjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 080/885] arm64: dts: mediatek: mt7622: Add missing pwm-cells to pwm node
Date:   Tue,  7 Mar 2023 17:50:14 +0100
Message-Id: <20230307170005.279658604@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 22925af785fa3470efdf566339616d801119d348 ]

Specify #pwm-cells on pwm@11006000 to make it actually usable.

Fixes: ae457b7679c4 ("arm64: dts: mt7622: add SoC and peripheral related device nodes")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20221128112028.58021-2-angelogioacchino.delregno@collabora.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7622.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt7622.dtsi b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
index 146e18b5b1f46..7bb316922a3a9 100644
--- a/arch/arm64/boot/dts/mediatek/mt7622.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
@@ -435,6 +435,7 @@ uart3: serial@11005000 {
 	pwm: pwm@11006000 {
 		compatible = "mediatek,mt7622-pwm";
 		reg = <0 0x11006000 0 0x1000>;
+		#pwm-cells = <2>;
 		interrupts = <GIC_SPI 77 IRQ_TYPE_LEVEL_LOW>;
 		clocks = <&topckgen CLK_TOP_PWM_SEL>,
 			 <&pericfg CLK_PERI_PWM_PD>,
-- 
2.39.2



