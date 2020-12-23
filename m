Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8322E1CEF
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 15:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbgLWOHD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 09:07:03 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:44937 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728251AbgLWOHD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 09:07:03 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 255AB275;
        Wed, 23 Dec 2020 09:05:57 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 23 Dec 2020 09:05:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=4Eo9Er
        PAfYPgN6ZeqjZwj9avlkicgEnAVIgO4uQmKuw=; b=mjWa/lmnKKd9i27oCeY6sw
        +FubXsz59eYCYw+UQf2ymkk92ECWGZ9lO4/pKQm4VW+UoLupfBLyNlmPZow64vex
        Lb0gd4GVc72yX6gyweQwpB7R4omzcQOZj7dyOHITyjb6uqir2zxVNaRgrCTsPjIb
        dVG+vKl6mYdtmqK1dqpEsavlX35wBn80sxXEtQvpwzVb9fZeQuKNC0VTY1FvbfyR
        bQv1TsgCmRLDLKrtySPAzu4fjKslfXACpJK5zcbpGrl5PoGDkv1+IssYsIJJUOLc
        rhWsSw7lSh8uMaCZb27UlZY34B213x5pft6WeuNV6go266P2Z3xRdvrVyC5Z9kNQ
        ==
X-ME-Sender: <xms:w07jXwmhuMX6D31oq2UrTIokH3IPBiBQjNq_T22Mvd-ikDuq5gH3kg>
    <xme:w07jX_3CjJptXz_ozpfQoc9gjniOzanTOvFQv6SsFmVF1LOfNNlLZ8NyOoPY38sRN
    INgdvCXQTTSuA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddtjedgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:w07jX-qrumO7ObS3F7LCp605kj-biEBNQORKbfpYkiFR6s5V0YWZcg>
    <xmx:w07jX8naitnSNbQxyDS2RL9nlAVyNASqm2XTUqCCZuVfpDDIPYyGQQ>
    <xmx:w07jX-2BP5xEZ4dB2R9j-x6NMY6jSbxzdz-HSf11yX10iZlFt4eX6A>
    <xmx:xE7jXz8WLdr-F8iURUKN0e78v2IlW1k9I4I49ur1p4E17zi6_SQRooHvZRk>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4A7BC108005C;
        Wed, 23 Dec 2020 09:05:55 -0500 (EST)
Subject: FAILED: patch "[PATCH] scsi: megaraid_sas: Check user-provided offsets" failed to apply to 4.4-stable tree
To:     arnd@arndb.de, hch@lst.de, martin.petersen@oracle.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 23 Dec 2020 15:07:07 +0100
Message-ID: <160873242770108@kroah.com>
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

From 381d34e376e3d9d27730fda8a0e870600e6c8196 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 30 Oct 2020 17:44:20 +0100
Subject: [PATCH] scsi: megaraid_sas: Check user-provided offsets

It sounds unwise to let user space pass an unchecked 32-bit offset into a
kernel structure in an ioctl. This is an unsigned variable, so checking the
upper bound for the size of the structure it points into is sufficient to
avoid data corruption, but as the pointer might also be unaligned, it has
to be written carefully as well.

While I stumbled over this problem by reading the code, I did not continue
checking the function for further problems like it.

Link: https://lore.kernel.org/r/20201030164450.1253641-2-arnd@kernel.org
Fixes: c4a3e0a529ab ("[SCSI] MegaRAID SAS RAID: new driver")
Cc: <stable@vger.kernel.org> # v2.6.15+
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 41cd66fc7d81..5e31bd364a5b 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -8134,7 +8134,7 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 	int error = 0, i;
 	void *sense = NULL;
 	dma_addr_t sense_handle;
-	unsigned long *sense_ptr;
+	void *sense_ptr;
 	u32 opcode = 0;
 	int ret = DCMD_SUCCESS;
 
@@ -8257,6 +8257,13 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 	}
 
 	if (ioc->sense_len) {
+		/* make sure the pointer is part of the frame */
+		if (ioc->sense_off >
+		    (sizeof(union megasas_frame) - sizeof(__le64))) {
+			error = -EINVAL;
+			goto out;
+		}
+
 		sense = dma_alloc_coherent(&instance->pdev->dev, ioc->sense_len,
 					     &sense_handle, GFP_KERNEL);
 		if (!sense) {
@@ -8264,12 +8271,11 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 			goto out;
 		}
 
-		sense_ptr =
-		(unsigned long *) ((unsigned long)cmd->frame + ioc->sense_off);
+		sense_ptr = (void *)cmd->frame + ioc->sense_off;
 		if (instance->consistent_mask_64bit)
-			*sense_ptr = cpu_to_le64(sense_handle);
+			put_unaligned_le64(sense_handle, sense_ptr);
 		else
-			*sense_ptr = cpu_to_le32(sense_handle);
+			put_unaligned_le32(sense_handle, sense_ptr);
 	}
 
 	/*

