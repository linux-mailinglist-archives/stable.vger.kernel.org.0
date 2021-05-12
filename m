Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 662F337B926
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 11:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbhELJ3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 05:29:33 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:45261 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230109AbhELJ3c (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 05:29:32 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id C1C3D194069D;
        Wed, 12 May 2021 05:28:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 12 May 2021 05:28:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=7sxU1T
        dFl6VPTEsDob6CNUgGWKZbMdREgMU1PUFApUA=; b=uSUeJlLB7I2PmV6mWkfzE9
        QM2/k54lL4Ojhdwa6QHuUFWdsYSdTuc91BUUjHSKk8t0a9vEVkcopayd0d3wWnMX
        skQbRIX6WdsHDXAm3Vqpl84f12OSgYMDL7rmRxxp7xO3GOVhf/tgjhMAhu+yPQ0Z
        vv1yFM5M33oPAhKosHha2XDH+m8VzcConGKxq6nQxM/xSpdWsEtgN2VXnXBr/3B1
        hwYhRJEoUkW7HZQ4cjghr8K18FPH1oTIYbA4TXpfpOV5CRuFiK7KK9N1SwFHKK+M
        PFtUYa/zVd7FOTGr6D5m/9Migh8HKPRWhp1Qqa8YsVlK0qmcyAnUXagPFcHPq6cw
        ==
X-ME-Sender: <xms:uJ-bYKvsB0yxSkTKLLgUDWm1X39fqwp0JPdM79zuFwySOU6LHwnGoA>
    <xme:uJ-bYPeCmz26IEpSFlFamERaDJEE85S_7kVQaZiL0hvXPKbElIfIUp5BexrPUJ51A
    vp-WmJ_y7WwAw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:uJ-bYFwF9dcaQ9GEaUq3p8-TLpeW0TKEInZnco29FRZ7WWXj2vweTg>
    <xmx:uJ-bYFNc1xNlAI9Su7gXnpE-VpSt29pkb2qj9K6tLmbkWtZUzK5Fjw>
    <xmx:uJ-bYK-lbEK5la_Ag4rUwQwgcRCdejj1RLuzjnG5BrZqdO7XjMceVg>
    <xmx:uJ-bYPO418VmdY2NSks0a4Dn9cY1A_GqxPLI7KMJ0VLEA___lOyh3w>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 05:28:24 -0400 (EDT)
Subject: FAILED: patch "[PATCH] net: xilinx: drivers need/depend on HAS_IOMEM" failed to apply to 5.11-stable tree
To:     rdunlap@infradead.org, andre.przywara@arm.com,
        daniel@iogearbox.net, davem@davemloft.net, gary@garyguo.net,
        kuba@kernel.org, lkp@intel.com, radhey.shyam.pandey@xilinx.com,
        zhangchangzhong@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 11:28:14 +0200
Message-ID: <162081169423614@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 46fd4471615c1bff9d87c411140807762c25667a Mon Sep 17 00:00:00 2001
From: Randy Dunlap <rdunlap@infradead.org>
Date: Fri, 16 Apr 2021 23:55:54 -0700
Subject: [PATCH] net: xilinx: drivers need/depend on HAS_IOMEM

kernel test robot reports build errors in 3 Xilinx ethernet drivers.
They all use ioremap functions that are only available when HAS_IOMEM
is set/enabled. If it is not enabled, they all have build errors,
so make these 3 drivers depend on HAS_IOMEM.

ld: drivers/net/ethernet/xilinx/xilinx_emaclite.o: in function `xemaclite_of_probe':
xilinx_emaclite.c:(.text+0x9fc): undefined reference to `devm_ioremap_resource'

ld: drivers/net/ethernet/xilinx/xilinx_axienet_main.o: in function `axienet_probe':
xilinx_axienet_main.c:(.text+0x942): undefined reference to `devm_ioremap_resource'

ld: drivers/net/ethernet/xilinx/ll_temac_main.o: in function `temac_probe':
ll_temac_main.c:(.text+0x1283): undefined reference to `devm_platform_ioremap_resource_byname'
ld: ll_temac_main.c:(.text+0x13ad): undefined reference to `devm_of_iomap'
ld: ll_temac_main.c:(.text+0x162e): undefined reference to `devm_platform_ioremap_resource'

Fixes: 8a3b7a252dca ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc: Gary Guo <gary@garyguo.net>
Cc: Zhang Changzhong <zhangchangzhong@huawei.com>
Cc: Andre Przywara <andre.przywara@arm.com>
Cc: stable@vger.kernel.org
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ethernet/xilinx/Kconfig b/drivers/net/ethernet/xilinx/Kconfig
index c6eb7f2368aa..911b5ef9e680 100644
--- a/drivers/net/ethernet/xilinx/Kconfig
+++ b/drivers/net/ethernet/xilinx/Kconfig
@@ -18,12 +18,14 @@ if NET_VENDOR_XILINX
 
 config XILINX_EMACLITE
 	tristate "Xilinx 10/100 Ethernet Lite support"
+	depends on HAS_IOMEM
 	select PHYLIB
 	help
 	  This driver supports the 10/100 Ethernet Lite from Xilinx.
 
 config XILINX_AXI_EMAC
 	tristate "Xilinx 10/100/1000 AXI Ethernet support"
+	depends on HAS_IOMEM
 	select PHYLINK
 	help
 	  This driver supports the 10/100/1000 Ethernet from Xilinx for the
@@ -31,6 +33,7 @@ config XILINX_AXI_EMAC
 
 config XILINX_LL_TEMAC
 	tristate "Xilinx LL TEMAC (LocalLink Tri-mode Ethernet MAC) driver"
+	depends on HAS_IOMEM
 	select PHYLIB
 	help
 	  This driver supports the Xilinx 10/100/1000 LocalLink TEMAC

