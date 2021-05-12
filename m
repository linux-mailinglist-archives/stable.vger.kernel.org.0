Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 685FE37B922
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 11:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbhELJ30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 05:29:26 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:51805 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230109AbhELJ3Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 05:29:25 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id BA3D41940669;
        Wed, 12 May 2021 05:28:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 12 May 2021 05:28:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=l8VZdt
        8uoagOCDp8TRkbv7cQp0dg9yXnkLq6C/2d0Jg=; b=fZOU503UKrBh1v7iqohF+k
        DX5dato7N4bs7NvvlVTQrpbVboHHF3eH2Aq4bDs6DpM3uKUNb0EZa0c0Gr7gI+l+
        g9Z9JU7cxHtXdyVXucMp0Y1/JGB0IK2D1cnOLeB6h48xZv4gdScSGqj6wAKIatyV
        zmFx+hWsxmkRE5O66RKhEG65+tQ+sC9C+MfaUGScQXcvpssOFpRtu4EIkKjJlTTX
        pjDslUUToWR8b7KJsFe0vPmrhWuO8wEV4/j1JRGPHBLELTTO/bLlKRms2SK0SlKK
        UcubKiWaIySL8saeT6CgMvMsLTc5HW12s9e0ggaQRa2T8kzV5GAUMUn5baJ0rchA
        ==
X-ME-Sender: <xms:sZ-bYPfXvzL0vCPXYghmDty4ZqsOBd1CDbzoEO4wUyd8bZITjlykBw>
    <xme:sZ-bYFP6YImmT_wXNsUZd65rpbePGvgmjGWow9GRhMerVQhtFJukv-RGuSpYdn2mn
    DcnQ01IioRnGg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:sZ-bYIh_FVVAf1-zwTZV5SAZ0uK2u0BV2YiPpqcc-SHFE9BYjM6IcA>
    <xmx:sZ-bYA_p_lC7P57jN5LmugAPAwgupj7hqEnCidwuZwmiCEKoKk29aQ>
    <xmx:sZ-bYLt5BJqmMHtxPlFzrXPHwUvs4wgz6gM7jflUlsJhNA-smsYLpA>
    <xmx:sZ-bYE-_mSNYPQ9xbv-ZuMT5ugHGMjMtiMGcAVrt04DUxzJdZa8oFg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 05:28:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] net: xilinx: drivers need/depend on HAS_IOMEM" failed to apply to 4.14-stable tree
To:     rdunlap@infradead.org, andre.przywara@arm.com,
        daniel@iogearbox.net, davem@davemloft.net, gary@garyguo.net,
        kuba@kernel.org, lkp@intel.com, radhey.shyam.pandey@xilinx.com,
        zhangchangzhong@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 11:28:11 +0200
Message-ID: <162081169190239@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

