Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D528C50F832
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344705AbiDZJHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347691AbiDZJGD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:06:03 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A361015CEF0;
        Tue, 26 Apr 2022 01:45:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1FBE5CE1BDD;
        Tue, 26 Apr 2022 08:45:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1355CC385AC;
        Tue, 26 Apr 2022 08:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962721;
        bh=f78a7N9udEO6WWX9YD5+pQYN4AKP3qbQWx0V0kl2zAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qy1m4J1HSHF/LlDtOwf2zkHenCBU5tcV0u0ow2UsozBV5DohWUCXFbT/PWL6iKV6Y
         FNSahZNZ8hVNsn3yLi7HP00xdHS0YQfrPdUYFkfHrn+WIUaC5Dq4Aib4jTLHlNvePJ
         oy7f0uYqbTe3zuP4VqfiV0GI6aheLDDS7PXj7avE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 068/146] arm64: dts: imx: Fix imx8*-var-som touchscreen property sizes
Date:   Tue, 26 Apr 2022 10:21:03 +0200
Message-Id: <20220426081751.975523867@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

[ Upstream commit 1bc12d301594eafde0a8529d28d459af81053b3a ]

The common touchscreen properties are all 32-bit, not 16-bit. These
properties must not be too important as they are all ignored in case of an
error reading them.

Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/Yk3moe6Hz8ELM0iS@robh.at.kernel.org'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-var-som.dtsi | 8 ++++----
 arch/arm64/boot/dts/freescale/imx8mn-var-som.dtsi | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-var-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-var-som.dtsi
index 1dc9d187601c..a0bd540f27d3 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-var-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-var-som.dtsi
@@ -89,12 +89,12 @@
 		pendown-gpio = <&gpio1 3 GPIO_ACTIVE_LOW>;
 
 		ti,x-min = /bits/ 16 <125>;
-		touchscreen-size-x = /bits/ 16 <4008>;
+		touchscreen-size-x = <4008>;
 		ti,y-min = /bits/ 16 <282>;
-		touchscreen-size-y = /bits/ 16 <3864>;
+		touchscreen-size-y = <3864>;
 		ti,x-plate-ohms = /bits/ 16 <180>;
-		touchscreen-max-pressure = /bits/ 16 <255>;
-		touchscreen-average-samples = /bits/ 16 <10>;
+		touchscreen-max-pressure = <255>;
+		touchscreen-average-samples = <10>;
 		ti,debounce-tol = /bits/ 16 <3>;
 		ti,debounce-rep = /bits/ 16 <1>;
 		ti,settle-delay-usec = /bits/ 16 <150>;
diff --git a/arch/arm64/boot/dts/freescale/imx8mn-var-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mn-var-som.dtsi
index b16c7caf34c1..87b5e23c766f 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn-var-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn-var-som.dtsi
@@ -70,12 +70,12 @@
 		pendown-gpio = <&gpio1 3 GPIO_ACTIVE_LOW>;
 
 		ti,x-min = /bits/ 16 <125>;
-		touchscreen-size-x = /bits/ 16 <4008>;
+		touchscreen-size-x = <4008>;
 		ti,y-min = /bits/ 16 <282>;
-		touchscreen-size-y = /bits/ 16 <3864>;
+		touchscreen-size-y = <3864>;
 		ti,x-plate-ohms = /bits/ 16 <180>;
-		touchscreen-max-pressure = /bits/ 16 <255>;
-		touchscreen-average-samples = /bits/ 16 <10>;
+		touchscreen-max-pressure = <255>;
+		touchscreen-average-samples = <10>;
 		ti,debounce-tol = /bits/ 16 <3>;
 		ti,debounce-rep = /bits/ 16 <1>;
 		ti,settle-delay-usec = /bits/ 16 <150>;
-- 
2.35.1



