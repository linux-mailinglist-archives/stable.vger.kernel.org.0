Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA676AF315
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbjCGTAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:00:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233576AbjCGS7u (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:59:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC561CDA37
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:46:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66CFB61535
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:46:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D449C433EF;
        Tue,  7 Mar 2023 18:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214766;
        bh=+rws6bpR+C+r6X1Nh5EPieRoYEXi11Jx82BT558iZSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ckebioMI2cIAdmSg9+yqPtH8vYdhk5N8Ng0mGt2wx/fwlG6kcIsmznSBZR4+2IhlI
         blEBsSCKYcZhdG+91wXOxAOSBJJSjcAzF+6xm59zazqhLgxArvHtpmLIQl3Sjngh2v
         AADEunraYENwpraVd1EBp6kjmrHto/0HWNFjnRmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 042/567] arm64: dts: amlogic: meson-sm1-bananapi-m5: fix adc keys node names
Date:   Tue,  7 Mar 2023 17:56:18 +0100
Message-Id: <20230307165907.758234544@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit d519a73332b6c3d14e15f8fd20d7c6f29ed13d41 ]

Fixes:
adc_keys: 'key' does not match any of the regexes: '^button-', 'pinctrl-[0-9]+'

Also fix the invalid "adc_keys" node name.

Link: https://lore.kernel.org/r/20230124-b4-amlogic-bindings-fixups-v1-11-44351528957e@linaro.org
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-sm1-bananapi-m5.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-sm1-bananapi-m5.dts b/arch/arm64/boot/dts/amlogic/meson-sm1-bananapi-m5.dts
index cadba194b149b..6d0db667581fa 100644
--- a/arch/arm64/boot/dts/amlogic/meson-sm1-bananapi-m5.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-sm1-bananapi-m5.dts
@@ -17,13 +17,13 @@ / {
 	compatible = "bananapi,bpi-m5", "amlogic,sm1";
 	model = "Banana Pi BPI-M5";
 
-	adc_keys {
+	adc-keys {
 		compatible = "adc-keys";
 		io-channels = <&saradc 2>;
 		io-channel-names = "buttons";
 		keyup-threshold-microvolt = <1800000>;
 
-		key {
+		button-sw3 {
 			label = "SW3";
 			linux,code = <BTN_3>;
 			press-threshold-microvolt = <1700000>;
-- 
2.39.2



