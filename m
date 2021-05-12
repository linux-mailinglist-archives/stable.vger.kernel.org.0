Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB82D37B923
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 11:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhELJ31 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 05:29:27 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:57097 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230109AbhELJ31 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 05:29:27 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 7AE9A1940CE7;
        Wed, 12 May 2021 05:28:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 12 May 2021 05:28:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=cIcvqR
        w4N6q7CDBYv0Kju5OsJTy4la3TSIQ7UOlleLs=; b=Cinkd9bH/iD0740cOJvx/u
        AHeUzZURvQ9YOdagqSC84RGA7jjJrHwF82qoTobIS9liNW7Dlrqkz5+wrH6ec0+4
        a4YYuwDgW3OfZnSYyXdBw9gCCRodcVsjIRPHvhn390fiEw/+kGKbPiTrq8rC7O8z
        /12NPf0as1ki49N84VTZklKKyyXHmJoRFT9EgvZg1fAd1ICx8CoURHYZT9F3ZHXk
        8m1z6oFV/4VFvdEJ3vSxlhg/EBID6fejB7F6FCyq2y0I4rOqsHwlteL+L7dmUgcg
        ylkYTdEpTe7FaBqTB0oAmRTRyIcFK45lP24NRbF06wwSAa5Ku/VDAaJ2mrHxnvEQ
        ==
X-ME-Sender: <xms:s5-bYFjPyOj8Tusq2QbTMvHeCFKOLpBmR5t9EMOOC7rDs4V3wzBZig>
    <xme:s5-bYKB030QGhTLs3X0f57pTCdvgzGJ_nu28wyn2ErMkoYDVRIf9rDzuZHMEI0zdx
    ffy3ImzuRB9qg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:s5-bYFHAzFCyvmYLJ_G_T6HnFlc0pykDRj44Bpan8rAVxJpZheAh7Q>
    <xmx:s5-bYKQUhikxQmUj1i8raD8w00jGWhp39N6mPYKgZ8SUDnfPAGYTSg>
    <xmx:s5-bYCzmFaBPhqx-6Y2lOh52PQDHaZkVkNPKLvn38T3NJBxRowIl5g>
    <xmx:s5-bYNxmjwZSgndWFQaj_BBX_KmDwdfq3CedSJb1m3674pMpRZlEnQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 05:28:18 -0400 (EDT)
Subject: FAILED: patch "[PATCH] net: xilinx: drivers need/depend on HAS_IOMEM" failed to apply to 5.4-stable tree
To:     rdunlap@infradead.org, andre.przywara@arm.com,
        daniel@iogearbox.net, davem@davemloft.net, gary@garyguo.net,
        kuba@kernel.org, lkp@intel.com, radhey.shyam.pandey@xilinx.com,
        zhangchangzhong@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 11:28:12 +0200
Message-ID: <162081169233122@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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

