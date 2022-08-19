Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF9BD59A000
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350699AbiHSP45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350966AbiHSP4H (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:56:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886FC1CFD8;
        Fri, 19 Aug 2022 08:51:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81B47615E7;
        Fri, 19 Aug 2022 15:51:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87061C433C1;
        Fri, 19 Aug 2022 15:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924262;
        bh=JmNy9SOqsoECasqAIXzyjV4CCn1OElcxYFq12UPQwfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mEUpi6b6Wj4oia+4AXsibQQ5NX3+5X/3OVaBBH4hbCPm3ja+fgxH7Yv2+r5Zm7mJ0
         EwCZ/CdlZbWOkFtvk09A2Imw6jsWztFpNXHZ7W4cA+xilUihTomvq6/tdTDEqgnASf
         nD7WxGQz7qx53EMV1dv4Y2rJruvDjYPr6t3o+hcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 110/545] arm64: dts: renesas: beacon: Fix regulator node names
Date:   Fri, 19 Aug 2022 17:38:00 +0200
Message-Id: <20220819153834.211620489@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 7512af9f78dedea7e04225f665dad6750df7d095 ]

Currently there are two nodes named "regulator_camera".  This causes the
former to be overwritten by the latter.

Fix this by renaming them to unique names, using the preferred hyphen
instead of an underscore.

While at it, update the name of the audio regulator (which was added in
the same commit) to use a hyphen.

Fixes: a1d8a344f1ca0709 ("arm64: dts: renesas: Introduce r8a774a1-beacon-rzg2m-kit")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/a9ac82bdf108162487289d091c53a9b3de393f13.1652263918.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi b/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi
index bc4bb5dd8bae..53e1d43cbecf 100644
--- a/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi
+++ b/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi
@@ -145,7 +145,7 @@ rgb_panel: endpoint {
 		};
 	};
 
-	reg_audio: regulator_audio {
+	reg_audio: regulator-audio {
 		compatible = "regulator-fixed";
 		regulator-name = "audio-1.8V";
 		regulator-min-microvolt = <1800000>;
@@ -173,7 +173,7 @@ reg_lcd_reset: regulator-lcd-reset {
 		vin-supply = <&reg_lcd>;
 	};
 
-	reg_cam0: regulator_camera {
+	reg_cam0: regulator-cam0 {
 		compatible = "regulator-fixed";
 		regulator-name = "reg_cam0";
 		regulator-min-microvolt = <1800000>;
@@ -182,7 +182,7 @@ reg_cam0: regulator_camera {
 		enable-active-high;
 	};
 
-	reg_cam1: regulator_camera {
+	reg_cam1: regulator-cam1 {
 		compatible = "regulator-fixed";
 		regulator-name = "reg_cam1";
 		regulator-min-microvolt = <1800000>;
-- 
2.35.1



