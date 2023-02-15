Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87B2A6985D8
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 21:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjBOUqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 15:46:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjBOUqB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 15:46:01 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732B138654;
        Wed, 15 Feb 2023 12:46:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 60A0BCE26DA;
        Wed, 15 Feb 2023 20:45:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24757C433EF;
        Wed, 15 Feb 2023 20:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676493956;
        bh=Cs+M07axfazicUtMljub5Y2DDqCfcNlViF85M3SkxYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lZix+C/JCvxLWp5WrpHivRydRyw7ww+YcHkWVAsf5dj0qG43RIsbqC2a5DcXSk2P7
         /b1T+w6RQxd3UAhXNvqN6kN3ZTgMhr7Cs0DQDYwEU+83c86/Z8vEhHshIjUejVbCfQ
         oSlJN+9u/gSoMqHLPf0IxDbDWq/22/TEuccqxC34UbVhjmtattqeadGBep2+qM/JXv
         63GBNf3EwP1dA7Pj1Fpi3wQlqSem0RHweiidIIB9KsA4XiH3ZsaSqhUv0q2PqD8ngN
         fsJSmovdwTGirOLTA4HQnlpy1ok+/mS0O/DWADyQd1hbVu8EIh+7pxrncknWFmseXR
         0cUOqDX3D13Vg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jarrah Gosbell <kernel@undef.tools>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, tom@tom-fitzhenry.me.uk,
        megi@xff.cz, kc@postmarketos.org, martijn@brixit.nl,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 6.1 02/24] arm64: dts: rockchip: reduce thermal limits on rk3399-pinephone-pro
Date:   Wed, 15 Feb 2023 15:45:25 -0500
Message-Id: <20230215204547.2760761-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230215204547.2760761-1-sashal@kernel.org>
References: <20230215204547.2760761-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarrah Gosbell <kernel@undef.tools>

[ Upstream commit 33e24f0738b922b6f5f4118dbdc26cac8400d7b9 ]

While this device uses the rk3399 it is also enclosed in a tight package
and cooled through the screen and back case. The default rk3399 thermal
limits can result in a burnt screen.

These lower limits have resulted in the existing burn not expanding and
will hopefully result in future devices not experiencing the issue.

Signed-off-by: Jarrah Gosbell <kernel@undef.tools>
Link: https://lore.kernel.org/r/20221207113212.8216-1-kernel@undef.tools
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-pinephone-pro.dts | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-pinephone-pro.dts b/arch/arm64/boot/dts/rockchip/rk3399-pinephone-pro.dts
index 2e058c3150256..fccc2b2f327df 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-pinephone-pro.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-pinephone-pro.dts
@@ -83,6 +83,13 @@ vcc1v8_codec: vcc1v8-codec-regulator {
 	};
 };
 
+&cpu_alert0 {
+	temperature = <65000>;
+};
+&cpu_alert1 {
+	temperature = <68000>;
+};
+
 &cpu_l0 {
 	cpu-supply = <&vdd_cpu_l>;
 };
-- 
2.39.0

