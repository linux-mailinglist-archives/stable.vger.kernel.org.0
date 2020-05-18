Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4ED1D81B0
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730596AbgERRuD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:50:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:51918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730618AbgERRuD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:50:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 335C220671;
        Mon, 18 May 2020 17:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824202;
        bh=AIDuqpFwK4loOrrBPfN4kswXj1atAMquNwmhwqFlyYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mANI1i9bDryIa3w/8Zn1wrN18mif/yZaErsgEagv7q9jsHebiCNIY4DfRGr8ZBF35
         Q7IC9h6o7wIWGfS1NHgPWAP3CmDsXz1W8AiIR2zZYP4i0KMrqy5pWYYOlGHbDocfiU
         d0VxywmwX/wmqmIzXrTYebrTgbhuxS2VKXrEx4YI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 4.14 111/114] ARM: dts: r8a73a4: Add missing CMT1 interrupts
Date:   Mon, 18 May 2020 19:37:23 +0200
Message-Id: <20200518173520.976032946@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173503.033975649@linuxfoundation.org>
References: <20200518173503.033975649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 0f739fdfe9e5ce668bd6d3210f310df282321837 upstream.

The R-Mobile APE6 Compare Match Timer 1 generates 8 interrupts, one for
each channel, but currently only 1 is described.
Fix this by adding the missing interrupts.

Fixes: f7b65230019b9dac ("ARM: shmobile: r8a73a4: Add CMT1 node")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20200408090926.25201-1-geert+renesas@glider.be
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/r8a73a4.dtsi |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/arch/arm/boot/dts/r8a73a4.dtsi
+++ b/arch/arm/boot/dts/r8a73a4.dtsi
@@ -133,7 +133,14 @@
 	cmt1: timer@e6130000 {
 		compatible = "renesas,cmt-48-r8a73a4", "renesas,cmt-48-gen2";
 		reg = <0 0xe6130000 0 0x1004>;
-		interrupts = <GIC_SPI 120 IRQ_TYPE_LEVEL_HIGH>;
+		interrupts = <GIC_SPI 120 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 121 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 122 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 123 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 124 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 125 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 126 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 127 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp3_clks R8A73A4_CLK_CMT1>;
 		clock-names = "fck";
 		power-domains = <&pd_c5>;


