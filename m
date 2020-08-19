Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEE54249F8D
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 15:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbgHSNXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 09:23:06 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:56925 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728236AbgHSNSy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 09:18:54 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id B1425B59;
        Wed, 19 Aug 2020 09:18:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 09:18:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=yOzPjd
        Otm2hkD17rwG93df1NrtY7wQJrUnA+GPgoaDg=; b=hYqd15s8w135sxAuVNXDSd
        4KJxygww2vMfpt8Q8fElvNBZw1Hd4PJg1FmCj3wfZ5e3bd1ie52O8MpIw8wGw1AY
        3rFWrEHfsnWhxZcQ7V9Dc0PTYvhCnE0s70nyE0L+/Ph0zHH9AyIyi+WF6FTeRwfk
        lDQOJgZwUR3h0cJ7xDAwIASSrdrFaCKUw7CMFWZKMIi8cxpV8ur2jWFwJLRA14RZ
        IAN4CTL6SuejYcTi+l2SDvjohIXB4sNdlVAtSgwf4kRxaQ3SFINjKCwvUBDoXUbN
        1DJygUp4cKVVte3tAzS8+THNIojCtREGsh20hzp/AjDzmCCitsq7rEuM5Sb8eMzQ
        ==
X-ME-Sender: <xms:tCY9X4wSElAAcmJW-RtRqaD8a5ZcEy85t4fRnQ0ZBRx6SCPMy1Ordg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:tCY9X8TJYR2i7elI3fV7wg07rZmPqaUdy0-mLi8cqiuKdXVl9mGaIg>
    <xmx:tCY9X6VY-U1CvkbjKa2mRq830xGjFoJ1LXKZV41YD4s57ohGcwlaQw>
    <xmx:tCY9X2hozksopXebCK9H8SbzWhM2qqMIGg1huehKjvCBrdWuHgFfmg>
    <xmx:tCY9Xx_xA9t8H2M-4EXRq-9EzpFLOBc92jtmjLGEaqlGooG7XV5pw3TE4ek>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D6C8030600A9;
        Wed, 19 Aug 2020 09:18:43 -0400 (EDT)
Subject: FAILED: patch "[PATCH] dt-bindings: power: supply: bq25890: Document required" failed to apply to 5.7-stable tree
To:     krzk@kernel.org, sebastian.reichel@collabora.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 15:18:55 +0200
Message-ID: <159784313521213@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.7-stable tree.
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

