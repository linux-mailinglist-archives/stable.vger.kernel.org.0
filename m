Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9DD3676F42
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbjAVPT1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:19:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbjAVPT1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:19:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 905442004D
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:19:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C2E760BC5
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:19:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C59BC433D2;
        Sun, 22 Jan 2023 15:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400765;
        bh=9Eh7jreooWqXler4iR5FnNwOnKMo5hSZwr7G08/7rZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Be02GGCUUDUSU/AqEJXJZlTFV+VYO/UW3Q6b0nSpKqKJWFuguSWPOiZ9D7Kx1c95G
         lZp4KzyyR7E3Zten9w4/FjoMF+/MynPIqLzbzoihGjExa0qhZD6bW3LxhGQwKgDpT+
         Ttqo0Rbsk6Y2Kbs1VBrnKaIDJcsVNYx5x6lik10o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
Subject: [PATCH 5.15 071/117] staging: mt7621-dts: change some node hex addresses to lower case
Date:   Sun, 22 Jan 2023 16:04:21 +0100
Message-Id: <20230122150235.741216922@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
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

From: Sergio Paracuellos <sergio.paracuellos@gmail.com>

commit ce835dbd04d7b24f9fd50d9a9c59be46304aaa8a upstream.

Hexadecimal addresses in device tree must be defined using lower case.
There are some of them that are still in upper case. Change them all.

Signed-off-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Link: https://lore.kernel.org/r/20211017070656.12654-2-sergio.paracuellos@gmail.com
Cc: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/mt7621-dts/mt7621.dtsi |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/staging/mt7621-dts/mt7621.dtsi
+++ b/drivers/staging/mt7621-dts/mt7621.dtsi
@@ -47,10 +47,10 @@
 		regulator-always-on;
 	};
 
-	palmbus: palmbus@1E000000 {
+	palmbus: palmbus@1e000000 {
 		compatible = "palmbus";
-		reg = <0x1E000000 0x100000>;
-		ranges = <0x0 0x1E000000 0x0FFFFF>;
+		reg = <0x1e000000 0x100000>;
+		ranges = <0x0 0x1e000000 0x0fffff>;
 
 		#address-cells = <1>;
 		#size-cells = <1>;
@@ -301,11 +301,11 @@
 		#reset-cells = <1>;
 	};
 
-	sdhci: sdhci@1E130000 {
+	sdhci: sdhci@1e130000 {
 		status = "disabled";
 
 		compatible = "mediatek,mt7620-mmc";
-		reg = <0x1E130000 0x4000>;
+		reg = <0x1e130000 0x4000>;
 
 		bus-width = <4>;
 		max-frequency = <48000000>;
@@ -327,7 +327,7 @@
 		interrupts = <GIC_SHARED 20 IRQ_TYPE_LEVEL_HIGH>;
 	};
 
-	xhci: xhci@1E1C0000 {
+	xhci: xhci@1e1c0000 {
 		status = "okay";
 
 		compatible = "mediatek,mt8173-xhci";


