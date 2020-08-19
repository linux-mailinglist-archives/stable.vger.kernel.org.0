Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 360DD249F90
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 15:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbgHSNXH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 09:23:07 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:32979 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728529AbgHSNSw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 09:18:52 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 0BCABB90;
        Wed, 19 Aug 2020 09:18:42 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 09:18:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=sau1KX
        bLKjgq3GlYSxZUjs5ZCx3jYDJ5PxVGPyeHmec=; b=ua/1tEWe8e3bKGdIjRqqr5
        HsTywr+o/JyGXfZyr1U7fD3axe6XEBNL8RifXhFAZopNz+++mu1YtYaLOM3CErVZ
        yjKaKSRS9aM5M5wOSkGxw5+UraqZ3iKAxJ7e5WJsY+DgJ0wfs0wydLQCjaov0IaJ
        Y5O9/ldCj5G+3Uoykk3H+qWw/lv6lNk6FUmZW6kF+gGgWEHP/NEIWAc63Y3kgQ3v
        9BhjVyf5LqVrtImVakmPciV2FP1xyyMQ5lJJNVvMMsu0Lk9v+0ws1ZQYf2ljthrU
        Irz/+WSr+x1grewY7wK7vH7i/Ojho2RdoeHV4c/c14MjqNZIuNmLouhqUPvVor5Q
        ==
X-ME-Sender: <xms:siY9XxbeGIlTg5GTQzGyguuOBiLB0aBQatrSeXDRWOQnfxneE0RIZg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:siY9X4ZvXM9E7J14I1GQ_n0SZ3AQ00ramjVWayd9MOCAWvVdoi934g>
    <xmx:siY9Xz84dlH05caNRf-53p59qR6XKzT3fCZ_fNdwh1yaVf8nlhqhiQ>
    <xmx:siY9X_r41aYr3x2h9guj0tH97E6cQMNTYHmfN1kCJoX3tbUTxjGN1Q>
    <xmx:siY9XyHNUOx7Om0XOAm8p4Bo8BRY5Hed-HW34FiNzMR3lxuETxjKJPxUYjo>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3A80F30600A3;
        Wed, 19 Aug 2020 09:18:42 -0400 (EDT)
Subject: FAILED: patch "[PATCH] dt-bindings: power: supply: bq25890: Document required" failed to apply to 4.14-stable tree
To:     krzk@kernel.org, sebastian.reichel@collabora.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 15:18:54 +0200
Message-ID: <1597843134120174@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

