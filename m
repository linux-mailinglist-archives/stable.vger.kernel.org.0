Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A2A249F95
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 15:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbgHSNXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 09:23:18 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:53397 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728481AbgHSNSn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 09:18:43 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 89221A79;
        Wed, 19 Aug 2020 09:18:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 09:18:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=lZ2kuu
        ZbPbhxCOlWMu2LBnK1myUbnyrlh25+MRGfpXY=; b=cpDyKlf7Og8XnfsSZvqXRr
        DsaDcCY6xCUjoNfnAxMqM1vEJHVsWQTDYqlrNSXTSBTHrd2Fkze7GqWRQs8AvsqN
        DfuBidHGAjIwWg3blYp+iIeHlVNzBpg1hJndaRX31yNw6HGJMX1MGEKKp2ii3QCs
        zxKbY4jqKyaY2/RojYdYbH3BUW26EUx66nbM5Y+hMrg3am6P6p98Pvk5FPSuGrP5
        LNgGlIqUUr/xGuxlOXVIAvB0OD6Z8EG2kzB5XAl3RiKBxXdbjLfbqy/vtS2DNrQD
        F2Kx3Y48bUXjfO190u3WuuQO2ur1j/+yhq0ZMpscgqw77mZP9qf3A3KpNC7YMA0Q
        ==
X-ME-Sender: <xms:sSY9X6s8vfG3OR3mXuWNp7xWmmWTcD9Dhw-kZk92z5FC4OsgIHNRqQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:sSY9X_eSrnHN064FEfg40k9XeMuTTRLZabzgcBFcM8PzNWWy9WeFvA>
    <xmx:sSY9X1zVcuSLXAKqxx2zex1TOYFu-cYz7B39fs5EBAnSqChLRcE3LQ>
    <xmx:sSY9X1PsSC4Wwg31g-btjwDeNRMIL9ABTtS4zQXv2vo6Y-hhul2VXA>
    <xmx:sSY9X7KNPyu3nTNUAsiQE2EkCxtRQlB7xC-9WaQLxoH1ypBoyHX10jtXuUI>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C481530600A3;
        Wed, 19 Aug 2020 09:18:40 -0400 (EDT)
Subject: FAILED: patch "[PATCH] dt-bindings: power: supply: bq25890: Document required" failed to apply to 4.19-stable tree
To:     krzk@kernel.org, sebastian.reichel@collabora.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 15:18:54 +0200
Message-ID: <1597843134108215@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0768e6e4934e239f1a7f8ba83150a7c46765bb3e Mon Sep 17 00:00:00 2001
From: Krzysztof Kozlowski <krzk@kernel.org>
Date: Wed, 17 Jun 2020 12:23:05 +0200
Subject: [PATCH] dt-bindings: power: supply: bq25890: Document required
 interrupt

The driver requires interrupts (fails probe if it is not provided) so
document this requirement in bindings.

Fixes: 4aeae9cb0dad ("power_supply: Add support for TI BQ25890 charger chip")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>

diff --git a/Documentation/devicetree/bindings/power/supply/bq25890.txt b/Documentation/devicetree/bindings/power/supply/bq25890.txt
index 51ecc756521f..3b4c69a7fa70 100644
--- a/Documentation/devicetree/bindings/power/supply/bq25890.txt
+++ b/Documentation/devicetree/bindings/power/supply/bq25890.txt
@@ -10,6 +10,7 @@ Required properties:
     * "ti,bq25895"
     * "ti,bq25896"
 - reg: integer, i2c address of the device.
+- interrupts: interrupt line;
 - ti,battery-regulation-voltage: integer, maximum charging voltage (in uV);
 - ti,charge-current: integer, maximum charging current (in uA);
 - ti,termination-current: integer, charge will be terminated when current in
@@ -39,6 +40,9 @@ bq25890 {
 	compatible = "ti,bq25890";
 	reg = <0x6a>;
 
+	interrupt-parent = <&gpio1>;
+	interrupts = <16 IRQ_TYPE_EDGE_FALLING>;
+
 	ti,battery-regulation-voltage = <4200000>;
 	ti,charge-current = <1000000>;
 	ti,termination-current = <50000>;

