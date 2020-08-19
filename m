Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5059E249F86
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 15:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbgHSNWh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 09:22:37 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:38889 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727872AbgHSNTt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 09:19:49 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id A00F2BBE;
        Wed, 19 Aug 2020 09:18:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 09:18:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=lqMBXd
        MtrPD8GTxuddcc0LnJtDPrSxBDGE9vXb6RW+A=; b=eY0ieFbeXLjav4ubrd3qGk
        /DNGAgiEF+SR6y6fOKlpmB6wvXnlp46/t0t5SpIa0zI6j7oHD9mKp2umMBPM52E/
        0lOpH8ELJd6jCBAeqGtaTMR+Fs9xPfxvoIlxf2trV7Zcot+9ZRYm1tmhYj9yhjSK
        Ssy13/a2C+1Z3uQlnKE3cY8Fzf9i+RXOoodkNUOrwcvDVpvk2R6E32+tfYuYT+kF
        jYvkr4Cis59JLDnUG6NsJTvWDaOB/tJ3jK6Pwaa1Yb+96r7I7Vez5s69LlAuWruE
        toTysjJlD50cC4jxNF98s+yXJP4pLlFiL6zN3oLT3zgkFjbNjD8LbFNxaDkL0hRw
        ==
X-ME-Sender: <xms:uCY9X_7gBj3V5P3tYY7T7E3baCur6ZOiBBiZShE9N6Xn1PzdDe1qrw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpeeinecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:uCY9X04cMCBR3RefjcRUghwY7b9-qhqpoHPtMj64-SquY5SnpLNb6w>
    <xmx:uCY9X2d5MqFanmeHxIJf4vLJ3BeISIgeW6GHL1lLthiqjPmXX5EECg>
    <xmx:uCY9XwKnZ31pCTGGGd03XnpF-0wXFI56rgw3NfKc9mVs8YDiwFvqLQ>
    <xmx:uCY9X-lK0gAoTSBbk_YbPSFLZSuz6B6TFDoEtW7_ul3gR0hyAp6zyjllYPo>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id DECDA328005A;
        Wed, 19 Aug 2020 09:18:47 -0400 (EDT)
Subject: FAILED: patch "[PATCH] dt-bindings: power: supply: bq25890: Document required" failed to apply to 5.8-stable tree
To:     krzk@kernel.org, sebastian.reichel@collabora.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 15:18:56 +0200
Message-ID: <1597843136236@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.8-stable tree.
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

