Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC50A11F807
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 14:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbfLONde (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 08:33:34 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:42309 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726103AbfLONdd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Dec 2019 08:33:33 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id A5E5922139;
        Sun, 15 Dec 2019 08:33:32 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 15 Dec 2019 08:33:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=eQFurq
        v0IKvM+hneXd4SHWnkJURmCAI2GDepmVDF8F0=; b=JV6r5GZTrfb+/0PnZ2UHMB
        ch3XBT4h26OtBH2EQr7TzBTwDMHc9/Kfy+A5q7jS4Z6RLpAVMKTtizYABOMPvA3q
        AhaT3lV+lejCHzvKsVn2wyLeJx67fLogotEU+ZRoHiCRPK1GsfGPopGte4YkBu+o
        paBCJzNMLymguDtrXAWcNllOKfepyrn0j/knaK49zSHBRTf5hF3D9JqZ4Iv9xUwh
        vLJbn9n1g35yLjIvONZhNF1gRh3j0Kr3uj+FBoWr6xNHt4OL49PBdRPzmBtK/Dua
        00xl0sRm3GjaUYdk/n6i6D22cNVDRHlIV6jt0XEtP4SgbLxANdGyDUm5Vb/7484A
        ==
X-ME-Sender: <xms:LDb2XRlWQk1-K4NWztFNrTJNvNu_TyJI22l0vAlGOS4JvuPclDGb0Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtfedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgephe
X-ME-Proxy: <xmx:LDb2Xap7EZA8HHd1dwyUyGcY23pZgwY5-aOQlVckCD_WTCmQMHDxCg>
    <xmx:LDb2XYjiJpp8OF2zDIkJsHgj5kE8pWprTCCOgVvGYK7kwNXUCn89EQ>
    <xmx:LDb2XciqTK5byvPgS8923xUu1JEFQRp5CLNYTSWPNauPU99suwiwlA>
    <xmx:LDb2XcTx2o7MdAyly2Cpn_C0CHF84b2ly8WnZDJ_crnyo0NuodRAWA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0B7DA30600DC;
        Sun, 15 Dec 2019 08:33:31 -0500 (EST)
Subject: FAILED: patch "[PATCH] ARM: dts: omap3-tao3530: Fix incorrect MMC card detection" failed to apply to 4.4-stable tree
To:     jarkko.nikula@bitmer.com, stable@vger.kernel.org, tony@atomide.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Dec 2019 14:33:30 +0100
Message-ID: <1576416810187118@kroah.com>
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

From 287897f9aaa2ad1c923d9875914f57c4dc9159c8 Mon Sep 17 00:00:00 2001
From: Jarkko Nikula <jarkko.nikula@bitmer.com>
Date: Sat, 16 Nov 2019 17:16:51 +0200
Subject: [PATCH] ARM: dts: omap3-tao3530: Fix incorrect MMC card detection
 GPIO polarity

The MMC card detection GPIO polarity is active low on TAO3530, like in many
other similar boards. Now the card is not detected and it is unable to
mount rootfs from an SD card.

Fix this by using the correct polarity.

This incorrect polarity was defined already in the commit 30d95c6d7092
("ARM: dts: omap3: Add Technexion TAO3530 SOM omap3-tao3530.dtsi") in v3.18
kernel and later changed to use defined GPIO constants in v4.4 kernel by
the commit 3a637e008e54 ("ARM: dts: Use defined GPIO constants in flags
cell for OMAP2+ boards").

While the latter commit did not introduce the issue I'm marking it with
Fixes tag due the v4.4 kernels still being maintained.

Fixes: 3a637e008e54 ("ARM: dts: Use defined GPIO constants in flags cell for OMAP2+ boards")
Cc: linux-stable <stable@vger.kernel.org> # 4.4+
Signed-off-by: Jarkko Nikula <jarkko.nikula@bitmer.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>

diff --git a/arch/arm/boot/dts/omap3-tao3530.dtsi b/arch/arm/boot/dts/omap3-tao3530.dtsi
index a7a04d78deeb..f24e2326cfa7 100644
--- a/arch/arm/boot/dts/omap3-tao3530.dtsi
+++ b/arch/arm/boot/dts/omap3-tao3530.dtsi
@@ -222,7 +222,7 @@ &mmc1 {
 	pinctrl-0 = <&mmc1_pins>;
 	vmmc-supply = <&vmmc1>;
 	vqmmc-supply = <&vsim>;
-	cd-gpios = <&twl_gpio 0 GPIO_ACTIVE_HIGH>;
+	cd-gpios = <&twl_gpio 0 GPIO_ACTIVE_LOW>;
 	bus-width = <8>;
 };
 

