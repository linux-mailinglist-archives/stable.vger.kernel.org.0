Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7E0145062
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387522AbgAVJm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:42:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:34308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387713AbgAVJm0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:42:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FDE624684;
        Wed, 22 Jan 2020 09:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686145;
        bh=NN3XaH1oGHRZjvkiDqVdyrqgwihZbowjQ5VmMe5uonE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qkx3GdpQh5tGZbvpLsyE5yDCjbh+VENAO3oM5/Iw7Kx2DeO+dULTcjnh2jSIIUv1F
         lCjeXkYbb6oPZq5mYBrYA4UXAvQIy5nRCQIhWDVnmkfqpeQCBDVFTwtpNe0bJMxb8z
         mwhL3OI223cQne5FRI2evNKbp/Ka2InVXwOVkuJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Mavrodiev <stefan@olimex.com>,
        Maxime Ripard <maxime@cerno.tech>
Subject: [PATCH 4.19 026/103] arm64: dts: allwinner: a64: olinuxino: Fix SDIO supply regulator
Date:   Wed, 22 Jan 2020 10:28:42 +0100
Message-Id: <20200122092807.742932532@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092803.587683021@linuxfoundation.org>
References: <20200122092803.587683021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Mavrodiev <stefan@olimex.com>

commit 3d615c2fc2d111b51d2e20516b920138d4ae29a2 upstream.

A64-OLinuXino uses DCDC1 (VCC-IO) for MMC1 supply. In commit 916b68cfe4b5
("arm64: dts: a64-olinuxino: Enable RTL8723BS WiFi") ALDO2 is set, which is
VCC-PL. Since DCDC1 is always present, the boards are working without a
problem.

This patch sets the correct regulator.

Fixes: 916b68cfe4b5 ("arm64: dts: a64-olinuxino: Enable RTL8723BS WiFi")
Cc: stable@vger.kernel.org # v4.16+
Signed-off-by: Stefan Mavrodiev <stefan@olimex.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/allwinner/sun50i-a64-olinuxino.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-olinuxino.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-olinuxino.dts
@@ -77,7 +77,7 @@
 &mmc1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&mmc1_pins>;
-	vmmc-supply = <&reg_aldo2>;
+	vmmc-supply = <&reg_dcdc1>;
 	vqmmc-supply = <&reg_dldo4>;
 	mmc-pwrseq = <&wifi_pwrseq>;
 	bus-width = <4>;


