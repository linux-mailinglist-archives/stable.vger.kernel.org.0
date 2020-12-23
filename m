Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55CFF2E1CF0
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 15:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728650AbgLWOGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 09:06:50 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:45073 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728251AbgLWOGu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 09:06:50 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 90E2B3B3;
        Wed, 23 Dec 2020 09:06:04 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 23 Dec 2020 09:06:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=IT36s/
        ulOqINlhxQgMZpIzg+Y1guLezOk9ekk0ABMQA=; b=UvprE5rhXtTYRAXsp5e6vt
        SQjWvKoDiuAJqLew3YF6jp4765+/jQSkNB0pYAw6cpqr48zEDSZXC5T3cX/Vbph8
        ZvBAIHChNO63TDrLjgkzpYmtWJH28OUhqV83MOoQPYl175eCN9tgs6/tKW0WtyDN
        xXWjfCM62DtSvXuiCoTUcsDVYKIzXAgWqml80epBDezF0J/uTYEsnrQvbe/2gHSi
        m/lpkgvbzzkoBquuzeC/fRnZiS2edfZ05A8lzeO7eTpkkgMcKi9GNL0fYO5aVuTq
        tcXYt0AS8o7Jtqc1J+6mp2HzUx4qI6X6MhAucUZUPE/iauHtN9rFob+TcFIQh5uA
        ==
X-ME-Sender: <xms:zE7jX2E6hXWvdUgc-OcXVvn6V_SHmMKtt1jkpLhyTVa7SdyvfJjl0Q>
    <xme:zE7jX3Udj_PkBtc06z7Y5JzYkm4CdSfkeopKMPhnD7VPjYzvDuM1Z69XQXa2LYcnQ
    AlLPXWxUFcmew>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddtjedgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:zE7jXwIBo93qL7RIsOPyqCrU8RlcUrA_fS_Dfnua6men248lnLMRug>
    <xmx:zE7jXwGmCsBQkU5xZtMls7v2HcZgKlqCcz8WFKzmdbMGM-BOuaFyjQ>
    <xmx:zE7jX8VY3Xj7j4tZK7xP8_hwtR0GdVKGdQlElBiTP-apnAKegyyzNg>
    <xmx:zE7jX3cQ9hY2OJN_QHGUm1t3y27S8wfreLKlfLNibRA81uqH3ERLePj-XLI>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id D7D70240057;
        Wed, 23 Dec 2020 09:06:03 -0500 (EST)
Subject: FAILED: patch "[PATCH] scsi: megaraid_sas: Check user-provided offsets" failed to apply to 4.9-stable tree
To:     arnd@arndb.de, hch@lst.de, martin.petersen@oracle.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 23 Dec 2020 15:07:07 +0100
Message-ID: <160873242799150@kroah.com>
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

