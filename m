Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3299421815
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 14:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728628AbfEQMUs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 08:20:48 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:58025 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728073AbfEQMUs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 08:20:48 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 1807744E;
        Fri, 17 May 2019 08:20:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 17 May 2019 08:20:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=p6tl6A
        +AfAoWnh3G2NoEFkCrmsforGByqvt3zg/vfnE=; b=are/zj+kBt04FekXLhhb05
        rjqfaJXkHxgVr5wA67Wu6iVHix7Fbp7eqfBvVLQjLkXgoomcqIzswYzz4l6wJy9N
        KGCCqqRM9NvdMqeSC04CmOQUVGw69hXClafx7Zdi0wW9qaAykJ3iG6RmL9HYaOwR
        2CVMkLxGNuATOhrlPKBy1ccK1NT9p1YSocgoee8SotG/DIob+t99m7h7SN78G0PY
        wV3Px+OfpOD8Kvu8lu9+sYElxtW+NOUQ/PSEW0gy6gxsgroblrQ3DD+CA6/zZj45
        Kq3xb3dbTqirYhcSAtoSfFElmeGOa/Qp61MTV4clEN7G+rxi1sERESM3ANghllVg
        ==
X-ME-Sender: <xms:HqfeXGW5amh1AfzU7Mc5fXfSfardZ9dq3ITpURRiKceKoCjPQ95VCw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtvddghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:HqfeXI7x26vC5VtrNV-R-RyOkLVQnuhwiXGxAVSrjJv3Af2w019vYg>
    <xmx:HqfeXHHEy7CeQh51yA_1kYjEs3g8zsYRFm-2d5g2R3Ym-J7ENpwyjQ>
    <xmx:HqfeXL-iI2ejMeG7qBV7KFk6elx5b_9Yj76pgO5dvyYowdXm9bsmdQ>
    <xmx:HqfeXFRa67VUQUBrzoqytNgYmBxldRnff3WYHNmnJfAbtvnRyMuUqw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id EA0FF103D7;
        Fri, 17 May 2019 08:20:45 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ARM: dts: exynos: Fix interrupt for shared EINTs on" failed to apply to 4.9-stable tree
To:     stuart.menefy@mathembedded.com, krzk@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 May 2019 14:20:44 +0200
Message-ID: <155809564479208@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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
 

