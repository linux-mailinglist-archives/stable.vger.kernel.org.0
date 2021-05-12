Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF25237B924
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 11:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhELJ33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 05:29:29 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:44251 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230109AbhELJ33 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 05:29:29 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 3BC361940DD5;
        Wed, 12 May 2021 05:28:21 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 12 May 2021 05:28:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=6uFk6j
        DYYJPBcjhJEa1moEOnNsX9yJgrZvklgxT6+Gs=; b=Zn1MxBf+Qwifsc/UxFzCbB
        +c2Pcr4mFv4jOye4VnQ7Zpis3+F9ThHeXcEseAzcgea2staLGZwiajQGulBRMIZh
        OXjAvxCdeo1pQDjwDi5vpThd+SixCNu1DzKiGU9N92su0cxi1AHsnjwgIIds1rv8
        DUOSJBC5I4WmLq1sNe3V024J22yZb5Ht9RZDF/TyVIXKFY/DzSP+KJ+3vbvXWNpl
        +U8eJ6SGFjmslaHpofOW60bvdv7iZhs5zmzcZbgQAx5vUS71nRDeMB+PEBDJU0Tv
        OhaHHgs1vT1sEfUV24iHE5yCxFmhgk2YEsUIEjEFMoMNy8kKaZcUL+7mlsHuVkBQ
        ==
X-ME-Sender: <xms:tZ-bYBnZNQS4-d11vUnXNfA5BpDwuY5EN-0IF0naojsYFvU4FM_0qg>
    <xme:tZ-bYM0B_ETqjGseYWeLDtBJKjWPakIlNgRYria9Bg11LO-_6KH4oL0YbKMKtD4sM
    ZP9YRk6AWVJAw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:tZ-bYHpKRy8_BdFLh1-WGsUeTN5W22Pgh8px9JQ4KZ7CYm9X1qr9SQ>
    <xmx:tZ-bYBm-n-e3J1EQlVTwRGhBQtelCxWaHZx0EN0p0wGXUQtSm5uNcA>
    <xmx:tZ-bYP0qHk1FnKbIbcKfVp-pxpMFl9K6uOYb89A1Hn3kDR1AUZ-GPQ>
    <xmx:tZ-bYEmZTR8ypir3qAJRbJep8eIYUzrM60NQWfbEEGdFoVpMxt2nPA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 05:28:20 -0400 (EDT)
Subject: FAILED: patch "[PATCH] net: xilinx: drivers need/depend on HAS_IOMEM" failed to apply to 4.19-stable tree
To:     rdunlap@infradead.org, andre.przywara@arm.com,
        daniel@iogearbox.net, davem@davemloft.net, gary@garyguo.net,
        kuba@kernel.org, lkp@intel.com, radhey.shyam.pandey@xilinx.com,
        zhangchangzhong@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 11:28:12 +0200
Message-ID: <162081169223251@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

