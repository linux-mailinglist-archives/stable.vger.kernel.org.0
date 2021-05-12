Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A526637B939
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 11:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbhELJb2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 05:31:28 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:60599 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230433AbhELJbR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 05:31:17 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.west.internal (Postfix) with ESMTP id 8FE071404;
        Wed, 12 May 2021 05:30:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 12 May 2021 05:30:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=CH6l8c
        RWVCMnePccqQ851I88ts2rX6BQ4jUK3FOIwCo=; b=cYy4YPJ7lMdMP4QuLRTJe2
        MJ73ky89ycgHy4I3acmlj6LLM0mKAnHfFtbNMDb2Wpnvrqz1JPng6OKTbIWbUjBW
        WP4nhrJSnqNlStq+qbSfzeN10gKDnE25H0aJwGipth9LNHu9oR+11/L+sDRWAJKa
        q5moS1b990Bhxco6NgM5RWhkJqokcYmDQbnewuVLHXaKgcEEYLO8wKURA428NHml
        UySa1XVzU6WL+DIvgxGMpKk1Dd4AYKbjDcU4X4y5OolkWI0z5mIXHxwFMmZSDX7K
        rsUfl/7BQwG8hU4jE8Ptk1l7fRLrWS5Lqnz3c/K7RErL337t0Jl3wfB1BJvBHq8A
        ==
X-ME-Sender: <xms:H6CbYL4eXCGcMb9kQxdv0OX0IuWj5ia3_vQyhBC7LL2uvzDqP6jPSg>
    <xme:H6CbYA7n9VovqKCLDOYmrhF8bccGseh3c-APrP9HyGXchU1m_5miT26djthR_gTIV
    rXzyXOvgIV78g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:H6CbYCdNksRVWEoyFrcFcxe368QbOF7SdAWf5HrypOi0pv7V5qJGIQ>
    <xmx:H6CbYMJPc1oCdqNnjfFffPFLcc6qFykkzk3VR1GXPqElq4oD113BWA>
    <xmx:H6CbYPIF3Rsb4Q1W_qqRjDvd7SzWMZ0dh29yulBu-H26YG0ZOs4Wrw>
    <xmx:H6CbYBxIt7xNSHJI4_vCVZIAVxbr3YM4HnlATpBSgovbxcMrNKP-a8loEXU>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 05:30:06 -0400 (EDT)
Subject: FAILED: patch "[PATCH] FDDI: defxx: Make MMIO the configuration default except for" failed to apply to 4.19-stable tree
To:     macro@orcam.me.uk, davem@davemloft.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 11:29:59 +0200
Message-ID: <1620811799137224@kroah.com>
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
 

