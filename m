Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B34B249F9E
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 15:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbgHSNXT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 09:23:19 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:57897 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728312AbgHSNSf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 09:18:35 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 745C6B44;
        Wed, 19 Aug 2020 09:18:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 09:18:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=LfxlBi
        xp1oE3e55um9hLV7sqtaMBQaCee6XdFj4YEKY=; b=eJjhV7JebzUaGwwZh+ow4Q
        ZxccXUcNGE3aY7ZmzuvUOJK2TvOsk1A2OstgimoCKOmm5s/LZvJnhS5zuupQf8qb
        JKGr/bdt7M668Im4d7YIGL63NiJEV3W3pTbxKjfdbjaBrWoRHG+QzpQEs6x+5WrO
        XXS5dAqPFs8SMp4f7zBu9N3KwADtCwsiDFDM4w3vZs9n7V4RFVkVHmwlAhTI6xno
        WQrae65N5K38Q1/yDDcWH129q8byfbyltVlsBOITMxZZAjTiADNvYTaA75uVqT99
        Q4OJErnxkl/V0fbiAAxfflVGBRY0XYaHB1azqXakuPz/TIAK4Coe8t62++gzNOGQ
        ==
X-ME-Sender: <xms:pyY9X3kkV9mhEkFcO5u4JuInQcW-47cJHoHsuoLNw45YsRDdwJU5Cw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:pyY9X61ZYaq0xjL1i8lDvwSEW5fXYb46QNAWkVSk_-jSGgmbMwYH7g>
    <xmx:pyY9X9r04KoN6TrBJO-GxkTsGJ1bMTNDNxLJEiJlWLiShGp6Woq1Sg>
    <xmx:pyY9X_mIn-flzKAqyhkC5jTnQfyhW6wnIRmveLOVLwEL1symVCrGdA>
    <xmx:qCY9Xyg1BEablox7M1Pnvp5JJ3vRBm5IIx83vY5qEHezaxPtOfaY8zM88OE>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 910763280060;
        Wed, 19 Aug 2020 09:18:31 -0400 (EDT)
Subject: FAILED: patch "[PATCH] dt-bindings: power: supply: bq25890: Document required" failed to apply to 4.4-stable tree
To:     krzk@kernel.org, sebastian.reichel@collabora.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 15:18:53 +0200
Message-ID: <1597843133227156@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

