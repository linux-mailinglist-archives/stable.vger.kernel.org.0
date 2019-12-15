Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEF5611F808
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 14:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbfLONdm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 08:33:42 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:49405 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726103AbfLONdm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Dec 2019 08:33:42 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id E812F22233;
        Sun, 15 Dec 2019 08:33:40 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 15 Dec 2019 08:33:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=1K5i2r
        7mas/LcyTdkJtkBH3Ozh0boOlTUJregKUZGsk=; b=fRmAm9LN3x2APdkebqFbQJ
        TjFYVFpyQVTrf8k6g2pF22UWLzoE3aqHc921lkGPVEPqwDqATvldp8I/d2vm5iNP
        WR/ujOaoSP9DAj9UPZZpkp+6TtCNmja+O2qaPc8u3H8BABIf+OmXXnU90rqEvkct
        hIh0XnO8J0jpZ+xxxdrlWMZHtXLTmyCEJV5WL1c4QXwLJI2LoZTTagCjfZ6uQ90n
        P4bNgAF0dOHc+HUZtb9fpMn4xa2LEbsD5avib33mFsBCb2bem3j0233sLCD00ydT
        6T6y65BJ+NEAryyT5zEdnYa2cqPer49uXipgrai7UVI2xtM89+PwNl/zq+Zcz26A
        ==
X-ME-Sender: <xms:NDb2XenIxis0AXYfVgDWc7lQkAebC9Qv5-n_JjZ1Ppo-ssMHcKV0RA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtfedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepie
X-ME-Proxy: <xmx:NDb2XWOoT8uNRiPxU82t0-VouJY84csmotf6D2gaWvYbSmJ6-X_baQ>
    <xmx:NDb2XUhqaDb-ZxuWXgHFwC0m2Q5sitSvIvRPEIDTQkIEfhjA2IQ_Rg>
    <xmx:NDb2XQTRPpkHZ47cXgaXM1YQVuKF3fhmWkDVFUMpXa04xpEBF314SQ>
    <xmx:NDb2XSRBWfhRmrlxFIUOZGh44m_Lj9ZO8AigvDcVYjqIAChDUVc8xQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 89E3130600AB;
        Sun, 15 Dec 2019 08:33:40 -0500 (EST)
Subject: FAILED: patch "[PATCH] ARM: dts: omap3-tao3530: Fix incorrect MMC card detection" failed to apply to 4.9-stable tree
To:     jarkko.nikula@bitmer.com, stable@vger.kernel.org, tony@atomide.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Dec 2019 14:33:31 +0100
Message-ID: <157641681111754@kroah.com>
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
 

