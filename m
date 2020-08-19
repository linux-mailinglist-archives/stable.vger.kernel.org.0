Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41E9B249F75
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 15:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728530AbgHSNUe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 09:20:34 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:35911 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728285AbgHSNTx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 09:19:53 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 5B10BB64;
        Wed, 19 Aug 2020 09:18:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 09:18:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=64L3Th
        oIXscVW154ANYYaQU40PzvSJwuDV8DZlgbB6M=; b=sKdvKJGXNEdVIUGb1xllsc
        +4n5USow2CGXnUH4d4IpOGSQHDWZ/95LPI8Sg9VS32aPxzEp3q3MC/8sB5rvm8JP
        AUpaXR75ENKe8HpQ8R5MbeFu8F9Rp8LjDY4S8dNrdQ34TVNrFt0enNYBLuZ1fI9/
        HuwF/G7xpp7h9iXxHC4ve5ShNW0ZA+D7n4ODCnB2kQJ8/xO/glikM/jiOmH0PicF
        TMWmFvM9CJmTIudoab0hggarWxzu5pqX0nX1FRQBc0jsnJTagV529jz2BHfUgOPo
        B2ICKMGd/XCGLB5RuYqvIibxtPmSKAGLPMlS2R+XGVgkz77eDN1cBymm3yJEuB9g
        ==
X-ME-Sender: <xms:tSY9X2l5XOWbZ7C3r1Z2Bl1SMgliQx7mkrwTdNGY-QH9UdRwgrAOHw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:tSY9X90jNgASoM8iFRe1gx-ud8OHpFIKy_uMNQ01xXxJhuDtszBAiw>
    <xmx:tSY9X0orYmi_d2IkmE6vfOo-TxY1XbQCpvlidY8RDn9XEE_ej64qxg>
    <xmx:tSY9X6lWzP2A1hmJA0EyhWZ-2dB5_zAzCRMUaZc32yQ6R-GeLKJpxQ>
    <xmx:tiY9X1gV9ojQJYstauQfANfM2NDJy_QtCkym5fQarrHCBOCZrCT6kpp-vsM>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 96FAB3280059;
        Wed, 19 Aug 2020 09:18:45 -0400 (EDT)
Subject: FAILED: patch "[PATCH] dt-bindings: power: supply: bq25890: Document required" failed to apply to 5.4-stable tree
To:     krzk@kernel.org, sebastian.reichel@collabora.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 15:18:55 +0200
Message-ID: <15978431353692@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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

