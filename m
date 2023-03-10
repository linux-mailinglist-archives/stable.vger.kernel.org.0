Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A85106B46BF
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbjCJOqL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:46:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232903AbjCJOpt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:45:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA06B108C3B
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:45:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5675D6187C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:45:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3075EC433A0;
        Fri, 10 Mar 2023 14:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459546;
        bh=s4LDjqRyNm55MxcD9bWzEKxR+iaDqABeumDttUnzAuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ouzbvtkgrVfcwX4j8hkm/nYT9YHaV1cndQXRpXYDjxpAUCC3YeFw0uSP2F5Cj4f6M
         Yk+CUQlTIx91ZetnBLMdMHqvPpkuVJJOPFjlzMhk8H/5C9VsQ7PaAzfG/T4ZqBt7Mf
         +9T+8kLWaQP1HWz4sveBEJuctiPJMVC/zI3VXZnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 039/529] arm64: dts: mediatek: mt7622: Add missing pwm-cells to pwm node
Date:   Fri, 10 Mar 2023 14:33:02 +0100
Message-Id: <20230310133806.807205411@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index 7c6d871538a63..884930a5849a2 100644
--- a/arch/arm64/boot/dts/mediatek/mt7622.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
@@ -428,6 +428,7 @@ uart3: serial@11005000 {
 	pwm: pwm@11006000 {
 		compatible = "mediatek,mt7622-pwm";
 		reg = <0 0x11006000 0 0x1000>;
+		#pwm-cells = <2>;
 		interrupts = <GIC_SPI 77 IRQ_TYPE_LEVEL_LOW>;
 		clocks = <&topckgen CLK_TOP_PWM_SEL>,
 			 <&pericfg CLK_PERI_PWM_PD>,
-- 
2.39.2



