Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F53F1A99E9
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 12:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896153AbgDOKHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 06:07:30 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:58047 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2896155AbgDOKH2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 06:07:28 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id BC9B45C01E2;
        Wed, 15 Apr 2020 06:07:27 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 15 Apr 2020 06:07:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=SbgNjH
        TFyuqJuqZ2C7rI/BJOQ7BsktTqR9NiLACMW5w=; b=k1TQ52esv+UcaJ8lPuClSo
        nVaZfFcmckh9xf2hlwwZzklX+fh4Y0FLbtafngJl2tEvMm3w9fpLo3FNbEG6j2IL
        3RC8X67iI8Y9SjufNWS0aTeuioMJ2vPE8+oE27Yzu3vcWo8U2/QiQQf8VSEtStSf
        6j45bJ3pQ/ZjHEK183CPeIJB4fodZSKWbxe0aHcE75YYNROoYzL/ROA+AKlTNthm
        9M2r8YAIDD4pYzj8gttc0Bd1NQ5D1X4BZiUyL9C+OomyCBTpuZBf0QKA/+Y1EPlq
        J7tpxxPABsSb717ArdG6o4MFnKlFtMLr/j1dxJTc5pAnLtoiHQwMzsHWnuXurJFQ
        ==
X-ME-Sender: <xms:39yWXkAVwWKjtQW3Fz94Uopnuv0AzZBcrYVJcAQk4qvRNfNJzTTsuQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeefgdduudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:39yWXs3PC3HJlCj5rAfzkb1-Mox6jJxxZaEKuZq5Wms43IXMgDRQ2Q>
    <xmx:39yWXkT_7SswxUN87iv9fPric2uEgJgZ0zUe7AQvtv7sne96RFpQ8w>
    <xmx:39yWXpZAFMo3BrBiO5QGm6sTXUPS34gS0fqI6w-VxUSn6YElx2J-jw>
    <xmx:39yWXnMhOxwUVa6uTr7oef015g1bwUusXJ3UHNIKCVODazS4iJfIHQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 70FAD3060067;
        Wed, 15 Apr 2020 06:07:27 -0400 (EDT)
Subject: FAILED: patch "[PATCH] scsi: mpt3sas: Fix kernel panic observed on soft HBA unplug" failed to apply to 4.14.y-stable tree
To:     sreekanth.reddy@broadcom.com, martin.petersen@oracle.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Apr 2020 12:07:24 +0200
Message-ID: <158694524496146@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14.y-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cc41f11a21a51d6869d71e525a7264c748d7c0d7 Mon Sep 17 00:00:00 2001
From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Date: Fri, 27 Mar 2020 05:52:43 -0400
Subject: [PATCH] scsi: mpt3sas: Fix kernel panic observed on soft HBA unplug

Generic protection fault type kernel panic is observed when user performs
soft (ordered) HBA unplug operation while IOs are running on drives
connected to HBA.

When user performs ordered HBA removal operation, the kernel calls PCI
device's .remove() call back function where driver is flushing out all the
outstanding SCSI IO commands with DID_NO_CONNECT host byte and also unmaps
sg buffers allocated for these IO commands.

However, in the ordered HBA removal case (unlike of real HBA hot removal),
HBA device is still alive and hence HBA hardware is performing the DMA
operations to those buffers on the system memory which are already unmapped
while flushing out the outstanding SCSI IO commands and this leads to
kernel panic.

Don't flush out the outstanding IOs from .remove() path in case of ordered
removal since HBA will be still alive in this case and it can complete the
outstanding IOs. Flush out the outstanding IOs only in case of 'physical
HBA hot unplug' where there won't be any communication with the HBA.

During shutdown also it is possible that HBA hardware can perform DMA
operations on those outstanding IO buffers which are completed with
DID_NO_CONNECT by the driver from .shutdown(). So same above fix is applied
in shutdown path as well.

It is safe to drop the outstanding commands when HBA is inaccessible such
as when permanent PCI failure happens, when HBA is in non-operational
state, or when someone does a real HBA hot unplug operation. Since driver
knows that HBA is inaccessible during these cases, it is safe to drop the
outstanding commands instead of waiting for SCSI error recovery to kick in
and clear these outstanding commands.

Link: https://lore.kernel.org/r/1585302763-23007-1-git-send-email-sreekanth.reddy@broadcom.com
Fixes: c666d3be99c0 ("scsi: mpt3sas: wait for and flush running commands on shutdown/unload")
Cc: stable@vger.kernel.org #v4.14.174+
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 778d5e6ce385..04a40afe60e3 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -9908,8 +9908,8 @@ static void scsih_remove(struct pci_dev *pdev)
 
 	ioc->remove_host = 1;
 
-	mpt3sas_wait_for_commands_to_complete(ioc);
-	_scsih_flush_running_cmds(ioc);
+	if (!pci_device_is_present(pdev))
+		_scsih_flush_running_cmds(ioc);
 
 	_scsih_fw_event_cleanup_queue(ioc);
 
@@ -9992,8 +9992,8 @@ scsih_shutdown(struct pci_dev *pdev)
 
 	ioc->remove_host = 1;
 
-	mpt3sas_wait_for_commands_to_complete(ioc);
-	_scsih_flush_running_cmds(ioc);
+	if (!pci_device_is_present(pdev))
+		_scsih_flush_running_cmds(ioc);
 
 	_scsih_fw_event_cleanup_queue(ioc);
 

