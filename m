Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB35E37B883
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 10:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbhELIux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 04:50:53 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:53029 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230037AbhELIuw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 04:50:52 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id 1D18913AC;
        Wed, 12 May 2021 04:49:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 12 May 2021 04:49:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=I9r4hs
        2R43CoSEipJ/xjS3Y9kMHCwdtPpfFYLHE/IpA=; b=Z2DoQZ+/8CHY4oNcg5xHzj
        9y3F+ckX01STAo7SQLB5whRIHOY/hqhaY6LieJ8Yq0KoOA5MMC4wjxC1BAYVxX81
        dDSjjWeMlJ9sWbQjFeMPNXCWofusFBTMyCUEJBWEPamM5NFmcoN5v8SteoNHUKII
        uk0hwP2GMC3Yy4Di6MSIHlA6j1R97MnRoNhgq1xkcjRmeB+0Z/zXMEhPZ6AC8nYc
        KGcNAhWkUVTSBV2zz2nyZbaN1jzwUCxJf2YfSlgVubZADjAT2N9rkOiXXQRLsePg
        GVNGtuLAHeKcvOQzkFwDvFsc+b9EudOvI1nGf0xDxV6DElmPLyZ0iEKy+4jGY7Sw
        ==
X-ME-Sender: <xms:p5abYLiz--YxpceA1iYZ1p8aRFtqyAlbtEwAwcBmbUOkTVqC9RoTMQ>
    <xme:p5abYIDxOALmIiryRJXZKxLxHlJHU1jBJdJEKLqyE51FkbVfrIbsDzXvdVtPsolCS
    3GTMxrDmT13Qw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:p5abYLErmLSZWOagcRDF94swqtjOcm7_EElK45AL8xlPqOM7xJ-otA>
    <xmx:p5abYIQMG6bAt4vNn3pEjaNDaMToA1oSPEHL-BPBT4ua8t-nRm8Z6Q>
    <xmx:p5abYIywtkS8UkqgRaLUyDm5q2ihtDf7kKLFTQJdOk62KZqJ7X4swA>
    <xmx:p5abYOatojLrwnXKCKYgD-AisIk69SsE8AnFLT8EMkE5JAJSt1kJfNimR7A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 04:49:43 -0400 (EDT)
Subject: FAILED: patch "[PATCH] PCI: Allow VPD access for QLogic ISP2722" failed to apply to 4.4-stable tree
To:     aeasi@marvell.com, bhelgaas@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 10:49:41 +0200
Message-ID: <162080938139105@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From e00dc69b5f17c444a38cd9745a0f76bc989b3af4 Mon Sep 17 00:00:00 2001
From: Arun Easi <aeasi@marvell.com>
Date: Fri, 9 Apr 2021 14:51:53 -0700
Subject: [PATCH] PCI: Allow VPD access for QLogic ISP2722

0d5370d1d852 ("PCI: Prevent VPD access for QLogic ISP2722") disabled access
to VPD of the ISP2722-based 16/32Gb Fibre Channel to PCIe Adapter because
reading past the end of the VPD caused NMIs.

104daa71b396 ("PCI: Determine actual VPD size on first access") limits
reads to the actual size of VPD, which should prevent these NMIs.

104daa71b396 was merged *before* 0d5370d1d852, but we think the testing
that prompted 0d5370d1d852 ("PCI: Prevent VPD access for QLogic ISP2722")
was done with a kernel that lacked 104daa71b396.  See [1, 2].

Remove the quirk added by 0d5370d1d852 ("PCI: Prevent VPD access for QLogic
ISP2722") so customers can read the HBA VPD.

[1] https://lore.kernel.org/linux-pci/alpine.LRH.2.21.9999.2012161641230.28924@irv1user01.caveonetworks.com/
[2] https://lore.kernel.org/linux-pci/alpine.LRH.2.21.9999.2104071535110.13940@irv1user01.caveonetworks.com/
[bhelgaas: commit log]
Link: https://lore.kernel.org/r/20210409215153.16569-2-aeasi@marvell.com
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org      # v4.6+

diff --git a/drivers/pci/vpd.c b/drivers/pci/vpd.c
index c6aad87dd0f9..8af31c5eec2d 100644
--- a/drivers/pci/vpd.c
+++ b/drivers/pci/vpd.c
@@ -500,7 +500,6 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_LSI_LOGIC, 0x005d, quirk_blacklist_vpd);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_LSI_LOGIC, 0x005f, quirk_blacklist_vpd);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATTANSIC, PCI_ANY_ID,
 		quirk_blacklist_vpd);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_QLOGIC, 0x2261, quirk_blacklist_vpd);
 /*
  * The Amazon Annapurna Labs 0x0031 device id is reused for other non Root Port
  * device types, so the quirk is registered for the PCI_CLASS_BRIDGE_PCI class.

