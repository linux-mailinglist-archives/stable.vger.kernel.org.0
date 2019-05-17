Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D987221816
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 14:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbfEQMU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 08:20:56 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:39503 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728073AbfEQMU4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 08:20:56 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 5196C423;
        Fri, 17 May 2019 08:20:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 17 May 2019 08:20:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=crx7ai
        AGAlAdCPojdnnj9KUR+KgxrN1yCB3YAC3Al/M=; b=SDAZ7gAkL+tdF2Ud7AkPDP
        0vZfZFNnsB6DVKiTuLmoupgZcPubh+wdDmNhApoJbXsbfbYf/TYBRqt2VDKmE/Ay
        wnuBElBtziT5Di/edtgCq9b+GoMsR2Yk21uVVBS0wSMNTB5t3pVhf3TDYGccXVQM
        pOwGZqpsi8i95kwBZ7oZ4TuC1p4MtXb4WkSRnRh+brmmJNL+9fFXgGHUwLIvJLow
        xh3vPVKz71sPuBipaSMhUU1MNGgQMPiWMjCfN8BOyrqeE422hImFSr0ZGd0ip3yz
        sYniL48B+P2MUvytY+sP+3IaNb04D3ZZbiB5oQKwxO2xQoyy4DuTPbC/kGBPoFRA
        ==
X-ME-Sender: <xms:JqfeXGzbu8S1bnRTuNzSzIz4nqhAcGdaxs5mMZHuDN8y7f6ZVuBc3g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtvddghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:JqfeXGgRqkjZLcEjVFYRwS2iBDKFzHfCzEnUOHOtcp7_OuuHMy-qWA>
    <xmx:JqfeXL7MPfoXgnRMpeADZ1-39puX_z1ymtkW5a-iGtmz9lhtKyHUcw>
    <xmx:JqfeXLrxlu2yP3tHNo0_fOXEyiB7ckwKEFTXmW1wl8QWqsUVbf3kDA>
    <xmx:JqfeXNrkJN0cQAbV69o7NLPljP37Maj-orSvMCQKzrlb0B9AOJu3tQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 43B898005B;
        Fri, 17 May 2019 08:20:54 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ARM: dts: exynos: Fix interrupt for shared EINTs on" failed to apply to 4.4-stable tree
To:     stuart.menefy@mathembedded.com, krzk@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 May 2019 14:20:44 +0200
Message-ID: <155809564421208@kroah.com>
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

From b7ed69d67ff0788d8463e599dd5dd1b45c701a7e Mon Sep 17 00:00:00 2001
From: Stuart Menefy <stuart.menefy@mathembedded.com>
Date: Tue, 19 Feb 2019 13:03:37 +0000
Subject: [PATCH] ARM: dts: exynos: Fix interrupt for shared EINTs on
 Exynos5260

Fix the interrupt information for the GPIO lines with a shared EINT
interrupt.

Fixes: 16d7ff2642e7 ("ARM: dts: add dts files for exynos5260 SoC")
Cc: stable@vger.kernel.org
Signed-off-by: Stuart Menefy <stuart.menefy@mathembedded.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

diff --git a/arch/arm/boot/dts/exynos5260.dtsi b/arch/arm/boot/dts/exynos5260.dtsi
index a8c7c6e589a0..3581b57fbbf7 100644
--- a/arch/arm/boot/dts/exynos5260.dtsi
+++ b/arch/arm/boot/dts/exynos5260.dtsi
@@ -227,7 +227,7 @@
 			wakeup-interrupt-controller {
 				compatible = "samsung,exynos4210-wakeup-eint";
 				interrupt-parent = <&gic>;
-				interrupts = <GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts = <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>;
 			};
 		};
 

