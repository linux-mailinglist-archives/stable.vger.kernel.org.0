Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3498E37B921
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 11:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbhELJ3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 05:29:24 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:47075 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230109AbhELJ3Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 05:29:24 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id 135FD1940649;
        Wed, 12 May 2021 05:28:16 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Wed, 12 May 2021 05:28:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=IM/0HO
        yb8fboMJX1zw+AURX8p8lPkl2SHs1PoLhpjAg=; b=sqCKdpnXgPsk/sfPbmBLuA
        ZvXI0PpKlDy41Xpwlo6q+BUBiRmeC6kduu20qXU6P9d7GnS13O751ki/8mYZlrPU
        lWWpETmClp8KWmLKEbaIihz3HzLq1U7ejqgeiwsXGYAxjndjP4YdhFQnIlnUXBCS
        tRwpDdTcEmzoAwdftxDIdnKQcPfqxRWAm90zNwR1pogaummLHci1DlMCBmYaexex
        GZUC6bkRsRT7f3r0Ng5QVFRGX5YKyngaOw/z+PocGc4X1K/XbBqJ8ju49DLvSoTt
        RxvAGo3Bw0s2U72kzdHx6UlYuqDrLNcVms6mCKCxKQvPwLI/vbWklvx0CStLqLNA
        ==
X-ME-Sender: <xms:r5-bYCp5fFWOhMdidF-PELrBeKuTAYIS7CKzIGrUSX2FmS4gYYwhlQ>
    <xme:r5-bYApviaGUse1GXoHNAoak2vZhx3KqwjjeFFmXCX-nAqtIiYdQbRF1GXe84eBgp
    4jeGNLUc8nR7w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:r5-bYHOb30H-jm2krrD-ciXlUuqWkKDRvPZFoOfFqLAgz-paRMx6Zw>
    <xmx:r5-bYB7uxT5LBfuapfRxRSqYmrZFdyOb9NvIQYVZ9m5A8z1XVNkr9w>
    <xmx:r5-bYB4bIVKRLaQr8UwT-BN505nIssStsxez2cMw2-wBEYUaolLs8w>
    <xmx:sJ-bYMbPtBm8UVhIAZLaxqjUXUUhLI-z9FFwhqRfAfCPHkfJNpo-fA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 05:28:15 -0400 (EDT)
Subject: FAILED: patch "[PATCH] net: xilinx: drivers need/depend on HAS_IOMEM" failed to apply to 4.9-stable tree
To:     rdunlap@infradead.org, andre.przywara@arm.com,
        daniel@iogearbox.net, davem@davemloft.net, gary@garyguo.net,
        kuba@kernel.org, lkp@intel.com, radhey.shyam.pandey@xilinx.com,
        zhangchangzhong@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 11:28:10 +0200
Message-ID: <162081169061155@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

