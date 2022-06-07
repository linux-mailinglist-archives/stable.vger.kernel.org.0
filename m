Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5036540C24
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351826AbiFGSeC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353023AbiFGSbg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:31:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F079917CE67;
        Tue,  7 Jun 2022 10:56:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27CC1B81F38;
        Tue,  7 Jun 2022 17:56:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D6BC385A5;
        Tue,  7 Jun 2022 17:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624601;
        bh=wpfaxEUSQSSnqw0C1UmU0qcePChoKtwxbyOBltqsojw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LAmbJ0g/oNkTq6VUtkk6+xQcAfzfR2odnjBz5aU7k9grbuyiOPTA2gWvStoFzOzt2
         3S2cu9GEeb4tn3ZEWewbJJ3OxW25sgYICRvelZOUf41Ex77+yFOxVaVmhoDb4I2kTw
         skEQgd3TDjFwugziYkDp7I+hRWf1wetPEQSYt7M0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 385/667] ARM: dts: BCM5301X: update CRU block description
Date:   Tue,  7 Jun 2022 19:00:50 +0200
Message-Id: <20220607164946.295076841@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 31fd9b79dc580301c53a001482755ba7e88c2809 ]

This describes CRU in a way matching documentation and fixes:

arch/arm/boot/dts/bcm4708-asus-rt-ac56u.dt.yaml: cru@100: $nodename:0: 'cru@100' does not match '^([a-z][a-z0-9\\-]+-bus|bus|soc|axi|ahb|apb)(@[0-9a-f]+)?$'
        From schema: /lib/python3.6/site-packages/dtschema/schemas/simple-bus.yaml

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm5301x.dtsi | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/bcm5301x.dtsi b/arch/arm/boot/dts/bcm5301x.dtsi
index f69d2af3c1fa..db8c3f684786 100644
--- a/arch/arm/boot/dts/bcm5301x.dtsi
+++ b/arch/arm/boot/dts/bcm5301x.dtsi
@@ -423,14 +423,14 @@
 		#address-cells = <1>;
 		#size-cells = <1>;
 
-		cru@100 {
-			compatible = "simple-bus";
+		cru-bus@100 {
+			compatible = "brcm,ns-cru", "simple-mfd";
 			reg = <0x100 0x1a4>;
 			ranges;
 			#address-cells = <1>;
 			#size-cells = <1>;
 
-			lcpll0: lcpll0@100 {
+			lcpll0: clock-controller@100 {
 				#clock-cells = <1>;
 				compatible = "brcm,nsp-lcpll0";
 				reg = <0x100 0x14>;
@@ -439,7 +439,7 @@
 						     "sdio", "ddr_phy";
 			};
 
-			genpll: genpll@140 {
+			genpll: clock-controller@140 {
 				#clock-cells = <1>;
 				compatible = "brcm,nsp-genpll";
 				reg = <0x140 0x24>;
@@ -450,6 +450,11 @@
 						     "sata1", "sata2";
 			};
 
+			syscon@180 {
+				compatible = "brcm,cru-clkset", "syscon";
+				reg = <0x180 0x4>;
+			};
+
 			pinctrl: pin-controller@1c0 {
 				compatible = "brcm,bcm4708-pinmux";
 				reg = <0x1c0 0x24>;
-- 
2.35.1



