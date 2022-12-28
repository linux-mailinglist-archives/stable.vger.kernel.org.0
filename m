Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B85657831
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232723AbiL1OsV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:48:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232755AbiL1OsB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:48:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042A311A18
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:48:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93C1C6153B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A543DC433EF;
        Wed, 28 Dec 2022 14:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672238880;
        bh=J2w4g/h/SHAQuuGTSvuU4kdSSXd9PpQSs1klVE/yScg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f/Qlr/K6vG0HFQHk+qSrCeb0ACDwVuia+or/tJzyk3PWmPU7iBUBbzxSyqqmyqe30
         hjfeBbEJzl8UPkmMIIWkCysxLJf8lG11mbHVXhf/GzPYVCHI7113h3qTQYhHj2GKsB
         tsLFp8L/IkQuSr7RDKSwrphMPHkqwKaOv9u9ERCU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 044/731] arm64: dts: mediatek: pumpkin-common: Fix devicetree warnings
Date:   Wed, 28 Dec 2022 15:32:31 +0100
Message-Id: <20221228144257.832094203@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 509438336ce75c8b4e6ce8e8d507dc77d0783bdd ]

Fix the pinctrl submodes and optee node to remove unneeded unit address,
fixing all unit_address_vs_reg warnings.

Fixes: 9983822c8cf9 ("arm64: dts: mediatek: add pumpkin board dts")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20221013152212.416661-8-angelogioacchino.delregno@collabora.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi b/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
index fcddec14738d..54514d62398f 100644
--- a/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
+++ b/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
@@ -17,7 +17,7 @@ chosen {
 	};
 
 	firmware {
-		optee: optee@4fd00000 {
+		optee: optee {
 			compatible = "linaro,optee-tz";
 			method = "smc";
 		};
@@ -210,7 +210,7 @@ pins_cmd_dat {
 		};
 	};
 
-	i2c0_pins_a: i2c0@0 {
+	i2c0_pins_a: i2c0 {
 		pins1 {
 			pinmux = <MT8516_PIN_58_SDA0__FUNC_SDA0_0>,
 				 <MT8516_PIN_59_SCL0__FUNC_SCL0_0>;
@@ -218,7 +218,7 @@ pins1 {
 		};
 	};
 
-	i2c2_pins_a: i2c2@0 {
+	i2c2_pins_a: i2c2 {
 		pins1 {
 			pinmux = <MT8516_PIN_60_SDA2__FUNC_SDA2_0>,
 				 <MT8516_PIN_61_SCL2__FUNC_SCL2_0>;
-- 
2.35.1



