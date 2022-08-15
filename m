Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE6B593D25
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243716AbiHOU1J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347881AbiHOU0q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:26:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D9D9E2C0;
        Mon, 15 Aug 2022 12:03:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0484C612AB;
        Mon, 15 Aug 2022 19:03:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D56FC433C1;
        Mon, 15 Aug 2022 19:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590216;
        bh=XZ1fEXbihwMvZmm867y5/Z2A0UapQQWEVOY0NEtU6jA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z/E6z0CWyTesZ4bFOer7BlB2VJ3CqhL9KJMdc/c/J0QCTXxqAA1U5U06X8AELDfWn
         SM8SDaaYwiZ87lONNtUoBP0gBmCx1RcX4sLQY3H/iB4A9OGvAgEca/cVaDKwzXco+s
         qe6TfZ59DQMpnoQV19f+tHGWjTEYaALVY4QDcNjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0189/1095] arm64: dts: renesas: beacon: Fix regulator node names
Date:   Mon, 15 Aug 2022 19:53:08 +0200
Message-Id: <20220815180437.453022770@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index 5ad6cd1864c1..c289d2bb5122 100644
--- a/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi
+++ b/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi
@@ -146,7 +146,7 @@ rgb_panel: endpoint {
 		};
 	};
 
-	reg_audio: regulator_audio {
+	reg_audio: regulator-audio {
 		compatible = "regulator-fixed";
 		regulator-name = "audio-1.8V";
 		regulator-min-microvolt = <1800000>;
@@ -174,7 +174,7 @@ reg_lcd_reset: regulator-lcd-reset {
 		vin-supply = <&reg_lcd>;
 	};
 
-	reg_cam0: regulator_camera {
+	reg_cam0: regulator-cam0 {
 		compatible = "regulator-fixed";
 		regulator-name = "reg_cam0";
 		regulator-min-microvolt = <1800000>;
@@ -183,7 +183,7 @@ reg_cam0: regulator_camera {
 		enable-active-high;
 	};
 
-	reg_cam1: regulator_camera {
+	reg_cam1: regulator-cam1 {
 		compatible = "regulator-fixed";
 		regulator-name = "reg_cam1";
 		regulator-min-microvolt = <1800000>;
-- 
2.35.1



