Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 577E25B7249
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232971AbiIMOuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232492AbiIMOra (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:47:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CACC213FA4;
        Tue, 13 Sep 2022 07:24:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6530B80FAF;
        Tue, 13 Sep 2022 14:23:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301E0C433D6;
        Tue, 13 Sep 2022 14:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078982;
        bh=KF9Q6V5/2B3EEiSElY1fDQT4aPIUCka+ZzrUpzWsB40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nuGo0+xSdUbmMt+6A9Zc3H5GfQeAhv1FKCcYgHhTmnBU/BgsMOU5bZnOMO0x4lEEe
         ihpsrFFiViAet/3QVwIIZR1xkK/78++O60JAo3ilK39BpfoqpWKNAXGXrSAUoiZHyX
         FQJwgCr4sF2i4rpj+Z1fNddir9UihJ1RLv+7iYXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Felsch <m.felsch@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 37/79] ARM: dts: imx6qdl-kontron-samx6i: remove duplicated node
Date:   Tue, 13 Sep 2022 16:04:42 +0200
Message-Id: <20220913140352.084415433@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140350.291927556@linuxfoundation.org>
References: <20220913140350.291927556@linuxfoundation.org>
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

From: Marco Felsch <m.felsch@pengutronix.de>

[ Upstream commit 204f67d86f55dd4fa757ed04757d7273f71a169c ]

The regulator node 'regulator-3p3v-s0' was dupplicated. Remove it to
clean the DTS.

Fixes: 2a51f9dae13d ("ARM: dts: imx6qdl-kontron-samx6i: Add iMX6-based Kontron SMARC-sAMX6i module")
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
index 92f9977d14822..e9a4115124eb0 100644
--- a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
@@ -51,16 +51,6 @@
 		vin-supply = <&reg_3p3v_s5>;
 	};
 
-	reg_3p3v_s0: regulator-3p3v-s0 {
-		compatible = "regulator-fixed";
-		regulator-name = "V_3V3_S0";
-		regulator-min-microvolt = <3300000>;
-		regulator-max-microvolt = <3300000>;
-		regulator-always-on;
-		regulator-boot-on;
-		vin-supply = <&reg_3p3v_s5>;
-	};
-
 	reg_3p3v_s5: regulator-3p3v-s5 {
 		compatible = "regulator-fixed";
 		regulator-name = "V_3V3_S5";
-- 
2.35.1



