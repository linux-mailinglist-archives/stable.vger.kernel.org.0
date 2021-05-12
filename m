Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C553B37B935
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 11:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbhELJbV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 05:31:21 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:33969 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230366AbhELJbK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 05:31:10 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id B1E55140C;
        Wed, 12 May 2021 05:30:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 12 May 2021 05:30:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=9SxQGD
        pO6Pvj2thLBvJNBhipq0P+iZPVrJpnKjPNJcY=; b=YR+2Hx2EOdOyLsHM66fprB
        SMUZIRZTinMJ5quJuGRAcUilZooN0aaO/ALV2mVCPvPIUJQUnzn1/ZdAAZNjYW6g
        vxZMGFz1t+Kv45SZIX1c6stpZ0FeVB8XrUnGe9eO7PxelHu0pWe3FSHwBIUynnX5
        p0PbWy3KDfX0rx0vS03h10dJYfECYrAgghUHDCEda3dGPiZNUB+CFOs0bktDsaLd
        3EohGkSw9vx/6X4ihi/R9aozhAV6ZB998j58SNa+ic8fPXfRW9DFO08nmHMk0eUv
        N/zGYQ1FsLsXLzYdvytt57UTcV3P6jTuMrsvqLp2rT47oNjPuTtAIN/mZz4QtXwQ
        ==
X-ME-Sender: <xms:GaCbYCWMjjCEx6nznvhynC4f6m38x8Cq6aukAzrblc_iIzn_aJGNWw>
    <xme:GaCbYOkFrU7xy74ThDS8ZkUvoCDXBKkBq9DSYOOVh2hYehYUBTY7h3UFENkwg9D_u
    dqXyZzYEhjM8g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:GaCbYGYyJ2uX8qEX3Q4982Uq4m0zaXl8Qapiv2XWzWC0w_yQ7eCiMA>
    <xmx:GaCbYJWF4wWB76zyW2H_2gb2muM1Ld-AsocqzZ92HVyqpfgkIfsUXg>
    <xmx:GaCbYMmCg4N9tI65JQ5PXHRAwHPOk0lxTAGGhLsMBnfKdeAtrIqiTw>
    <xmx:GaCbYDv2ZfMRcm2dZGMV8XrX66ExHMBWEjlNCbVVeNaIg0sp_SJLHj5Yi4M>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 05:30:00 -0400 (EDT)
Subject: FAILED: patch "[PATCH] FDDI: defxx: Make MMIO the configuration default except for" failed to apply to 4.9-stable tree
To:     macro@orcam.me.uk, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 11:29:57 +0200
Message-ID: <16208117979059@kroah.com>
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

From 193ced4a79599352d63cb8c9e2f0c6043106eb6a Mon Sep 17 00:00:00 2001
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
Date: Wed, 10 Mar 2021 13:03:14 +0100
Subject: [PATCH] FDDI: defxx: Make MMIO the configuration default except for
 EISA

Recent versions of the PCI Express specification have deprecated support
for I/O transactions and actually some PCIe host bridges, such as Power
Systems Host Bridge 4 (PHB4), do not implement them.

The default kernel configuration choice for the defxx driver is the use
of I/O ports rather than MMIO for PCI and EISA systems.  It may have
made sense as a conservative backwards compatible choice back when MMIO
operation support was added to the driver as a part of TURBOchannel bus
support.  However nowadays this configuration choice makes the driver
unusable with systems that do not implement I/O transactions for PCIe.

Make DEFXX_MMIO the configuration default then, except where configured
for EISA.  This exception is because an EISA adapter can have its MMIO
decoding disabled with ECU (EISA Configuration Utility) and therefore
not available with the resource allocation infrastructure we implement,
while port I/O is always readily available as it uses slot-specific
addressing, directly mapped to the slot an option card has been placed
in and handled with our EISA bus support core.  Conversely a kernel that
supports modern systems which may not have I/O transactions implemented
for PCIe will usually not be expected to handle legacy EISA systems.

The change of the default will make it easier for people, including but
not limited to distribution packagers, to make a working choice for the
driver.

Update the option description accordingly and while at it replace the
potentially ambiguous PIO acronym with IOP for "port I/O" vs "I/O ports"
according to our nomenclature used elsewhere.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Fixes: e89a2cfb7d7b ("[TC] defxx: TURBOchannel support")
Cc: stable@vger.kernel.org # v2.6.21+
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/fddi/Kconfig b/drivers/net/fddi/Kconfig
index f722079dfb6a..f99c1048c97e 100644
--- a/drivers/net/fddi/Kconfig
+++ b/drivers/net/fddi/Kconfig
@@ -40,17 +40,20 @@ config DEFXX
 
 config DEFXX_MMIO
 	bool
-	prompt "Use MMIO instead of PIO" if PCI || EISA
+	prompt "Use MMIO instead of IOP" if PCI || EISA
 	depends on DEFXX
-	default n if PCI || EISA
+	default n if EISA
 	default y
 	help
 	  This instructs the driver to use EISA or PCI memory-mapped I/O
-	  (MMIO) as appropriate instead of programmed I/O ports (PIO).
+	  (MMIO) as appropriate instead of programmed I/O ports (IOP).
 	  Enabling this gives an improvement in processing time in parts
-	  of the driver, but it may cause problems with EISA (DEFEA)
-	  adapters.  TURBOchannel does not have the concept of I/O ports,
-	  so MMIO is always used for these (DEFTA) adapters.
+	  of the driver, but it requires a memory window to be configured
+	  for EISA (DEFEA) adapters that may not always be available.
+	  Conversely some PCIe host bridges do not support IOP, so MMIO
+	  may be required to access PCI (DEFPA) adapters on downstream PCI
+	  buses with some systems.  TURBOchannel does not have the concept
+	  of I/O ports, so MMIO is always used for these (DEFTA) adapters.
 
 	  If unsure, say N.
 

