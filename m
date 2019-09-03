Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD40A7317
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 21:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbfICTEu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 15:04:50 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:49475 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726005AbfICTEu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 15:04:50 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 3BE9521F82;
        Tue,  3 Sep 2019 15:04:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 03 Sep 2019 15:04:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=cgwaFt
        JoEcwGJkbVC2BQwbLBo5b3r5VJWS4XUacxyoY=; b=PCnJQ1LZeg1FcGsNeZPD9Z
        4XoLGR4Gvynpsas1NUDd96ySt3tIzJDotmC4SdJnh6UIoyrNV5IsYwYOZowOuEjw
        OjK/mJQsPczGi0WVv7BJYdNZSBOpZHkRbueH3v15jUGxXCUgq5XQdYgrm6IwzCeB
        CIFeKFZK/01SfOzZnVIJ//QiShfSlHduJm/siom2ADEe+zpibB8PIqNLhwQIcYb8
        mMJB9mrqp2hU82Vy768kl85HrMZhHwvuu2fzJAaxbAiSie+qnrbnUlyGG7r0y6Xg
        JcN/3pUhHw6xnJPX9xbtZgbdepRKHzY33wqkCi0zO4Io9NUjYndsZVyyjq5zC0Yg
        ==
X-ME-Sender: <xms:UbluXbY-61u4GdhD94MYzGZdIs72hEEFRpDuF0kij8eekQ_7sLxpGQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudejfedguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:UbluXXhNvis2JxFQDJmdHV0LGCN0ThBXgLk5WTvQ8L3A6mF5TyjBoA>
    <xmx:UbluXeazsbLDYHKevVHzOeoHFJ3OEDwieXbVg5VKz0vHWa64u_b4ow>
    <xmx:UbluXSq-K6VANIuXhqjUCobUEbevMxZhFjbWIc0u9l-qsoO6qixnyQ>
    <xmx:UbluXQGF5K2n24G-AdIgMVoAqS-sLJb5awZp2BahNPkBK8QYaDg7Qw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id BCE0CD60063;
        Tue,  3 Sep 2019 15:04:48 -0400 (EDT)
Subject: FAILED: patch "[PATCH] i2c: piix4: Fix port selection for AMD Family 16h Model 30h" failed to apply to 4.9-stable tree
To:     andrew.cooks@opengear.com, jdelvare@suse.de, wsa@the-dreams.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Sep 2019 21:04:39 +0200
Message-ID: <15675374794253@kroah.com>
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

From c7c06a1532f3fe106687ac82a13492c6a619ff1c Mon Sep 17 00:00:00 2001
From: Andrew Cooks <andrew.cooks@opengear.com>
Date: Fri, 2 Aug 2019 14:52:46 +0200
Subject: [PATCH] i2c: piix4: Fix port selection for AMD Family 16h Model 30h

Family 16h Model 30h SMBus controller needs the same port selection fix
as described and fixed in commit 0fe16195f891 ("i2c: piix4: Fix SMBus port
selection for AMD Family 17h chips")

commit 6befa3fde65f ("i2c: piix4: Support alternative port selection
register") also fixed the port selection for Hudson2, but unfortunately
this is not the exact same device and the AMD naming and PCI Device IDs
aren't particularly helpful here.

The SMBus port selection register is common to the following Families
and models, as documented in AMD's publicly available BIOS and Kernel
Developer Guides:

 50742 - Family 15h Model 60h-6Fh (PCI_DEVICE_ID_AMD_KERNCZ_SMBUS)
 55072 - Family 15h Model 70h-7Fh (PCI_DEVICE_ID_AMD_KERNCZ_SMBUS)
 52740 - Family 16h Model 30h-3Fh (PCI_DEVICE_ID_AMD_HUDSON2_SMBUS)

The Hudson2 PCI Device ID (PCI_DEVICE_ID_AMD_HUDSON2_SMBUS) is shared
between Bolton FCH and Family 16h Model 30h, but the location of the
SmBus0Sel port selection bits are different:

 51192 - Bolton Register Reference Guide

We distinguish between Bolton and Family 16h Model 30h using the PCI
Revision ID:

  Bolton is device 0x780b, revision 0x15
  Family 16h Model 30h is device 0x780b, revision 0x1F
  Family 15h Model 60h and 70h are both device 0x790b, revision 0x4A.

The following additional public AMD BKDG documents were checked and do
not share the same port selection register:

 42301 - Family 15h Model 00h-0Fh doesn't mention any
 42300 - Family 15h Model 10h-1Fh doesn't mention any
 49125 - Family 15h Model 30h-3Fh doesn't mention any

 48751 - Family 16h Model 00h-0Fh uses the previously supported
         index register SB800_PIIX4_PORT_IDX_ALT at 0x2e

Signed-off-by: Andrew Cooks <andrew.cooks@opengear.com>
Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: stable@vger.kernel.org [v4.6+]
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

diff --git a/drivers/i2c/busses/i2c-piix4.c b/drivers/i2c/busses/i2c-piix4.c
index c46c4bddc7ca..cba325eb852f 100644
--- a/drivers/i2c/busses/i2c-piix4.c
+++ b/drivers/i2c/busses/i2c-piix4.c
@@ -91,7 +91,7 @@
 #define SB800_PIIX4_PORT_IDX_MASK	0x06
 #define SB800_PIIX4_PORT_IDX_SHIFT	1
 
-/* On kerncz, SmBus0Sel is at bit 20:19 of PMx00 DecodeEn */
+/* On kerncz and Hudson2, SmBus0Sel is at bit 20:19 of PMx00 DecodeEn */
 #define SB800_PIIX4_PORT_IDX_KERNCZ		0x02
 #define SB800_PIIX4_PORT_IDX_MASK_KERNCZ	0x18
 #define SB800_PIIX4_PORT_IDX_SHIFT_KERNCZ	3
@@ -358,18 +358,16 @@ static int piix4_setup_sb800(struct pci_dev *PIIX4_dev,
 	/* Find which register is used for port selection */
 	if (PIIX4_dev->vendor == PCI_VENDOR_ID_AMD ||
 	    PIIX4_dev->vendor == PCI_VENDOR_ID_HYGON) {
-		switch (PIIX4_dev->device) {
-		case PCI_DEVICE_ID_AMD_KERNCZ_SMBUS:
+		if (PIIX4_dev->device == PCI_DEVICE_ID_AMD_KERNCZ_SMBUS ||
+		    (PIIX4_dev->device == PCI_DEVICE_ID_AMD_HUDSON2_SMBUS &&
+		     PIIX4_dev->revision >= 0x1F)) {
 			piix4_port_sel_sb800 = SB800_PIIX4_PORT_IDX_KERNCZ;
 			piix4_port_mask_sb800 = SB800_PIIX4_PORT_IDX_MASK_KERNCZ;
 			piix4_port_shift_sb800 = SB800_PIIX4_PORT_IDX_SHIFT_KERNCZ;
-			break;
-		case PCI_DEVICE_ID_AMD_HUDSON2_SMBUS:
-		default:
+		} else {
 			piix4_port_sel_sb800 = SB800_PIIX4_PORT_IDX_ALT;
 			piix4_port_mask_sb800 = SB800_PIIX4_PORT_IDX_MASK;
 			piix4_port_shift_sb800 = SB800_PIIX4_PORT_IDX_SHIFT;
-			break;
 		}
 	} else {
 		if (!request_muxed_region(SB800_PIIX4_SMB_IDX, 2,

