Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9455124642D
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 12:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgHQKN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 06:13:59 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:60363 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726151AbgHQKN6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 06:13:58 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 569721941AD8;
        Mon, 17 Aug 2020 06:13:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 17 Aug 2020 06:13:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=/b950o
        OCZEei+OyZkAgpiKw2iy5Hi6Pos96GngKVOY0=; b=PVPbwx6o1Rl6Idl0VgwUmv
        79/BLxoP6Ocq7lHJmiJ3IQJcQN4zQqX6CctkaHx+I8pyD2I83HaJvqcnqXhXdNtC
        1QhSIaM7D7leiOxQ/efyrFhZ5VeybPzgs3XnjsMfqFnzLxI+H+dsaCuHEreewJWw
        zG9k03IvJPS1XeJV2z7Y27ww8R5PyShdlOBUC6YYBZ5hi9ALDfN4T1uhROWks4rC
        MqutfaZ2S7PzHEeWXx4wsi+/4plg3NM7Clxq3TOMLDGYIq4wA3frnUxxthBmrGK1
        k74T7K1OODaudjprLfWy/NgtyR4g9JIxTt/P545d4ezZGTt+M3QWAbstPUJIm8lw
        ==
X-ME-Sender: <xms:ZVg6X_s8UjAj4g1N5phA9vM2_-Hu_2RFbOQZAfClA-43JBwO7Bcirw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtfedgvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:ZVg6XweVJ5_qy4M3EEqlRjS4WsRFlx5qjE4vzxPhd7-YU3J7oztMYg>
    <xmx:ZVg6XywWk7_AChrP0jHuPQ9ckP01lUm1zkPpHs7oGkOqDH9JpqKMfg>
    <xmx:ZVg6X-Nk_5RFm1bcZhhLMGnFvf_A2QyYTftJZFp0Tgq64WMuRYPSJw>
    <xmx:ZVg6X8FMZL27kRscw3k1rr_eHrLndeFqkwZSUxfGAyfS6diC8ime5w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id EAFC03060067;
        Mon, 17 Aug 2020 06:13:56 -0400 (EDT)
Subject: FAILED: patch "[PATCH] tpm: Unify the mismatching TPM space buffer sizes" failed to apply to 4.14-stable tree
To:     jarkko.sakkinen@linux.intel.com, jsnitsel@redhat.com,
        stefanb@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Aug 2020 12:14:09 +0200
Message-ID: <1597659249143217@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 6c4e79d99e6f42b79040f1a33cd4018f5425030b Mon Sep 17 00:00:00 2001
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Date: Fri, 3 Jul 2020 01:55:59 +0300
Subject: [PATCH] tpm: Unify the mismatching TPM space buffer sizes

The size of the buffers for storing context's and sessions can vary from
arch to arch as PAGE_SIZE can be anything between 4 kB and 256 kB (the
maximum for PPC64). Define a fixed buffer size set to 16 kB. This should be
enough for most use with three handles (that is how many we allow at the
moment). Parametrize the buffer size while doing this, so that it is easier
to revisit this later on if required.

Cc: stable@vger.kernel.org
Reported-by: Stefan Berger <stefanb@linux.ibm.com>
Fixes: 745b361e989a ("tpm: infrastructure for TPM spaces")
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Tested-by: Stefan Berger <stefanb@linux.ibm.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 8c77e88012e9..ddaeceb7e109 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -386,13 +386,8 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
 	chip->cdev.owner = THIS_MODULE;
 	chip->cdevs.owner = THIS_MODULE;
 
-	chip->work_space.context_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!chip->work_space.context_buf) {
-		rc = -ENOMEM;
-		goto out;
-	}
-	chip->work_space.session_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!chip->work_space.session_buf) {
+	rc = tpm2_init_space(&chip->work_space, TPM2_SPACE_BUFFER_SIZE);
+	if (rc) {
 		rc = -ENOMEM;
 		goto out;
 	}
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 0fbcede241ea..947d1db0a5cc 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -59,6 +59,9 @@ enum tpm_addr {
 
 #define TPM_TAG_RQU_COMMAND 193
 
+/* TPM2 specific constants. */
+#define TPM2_SPACE_BUFFER_SIZE		16384 /* 16 kB */
+
 struct	stclear_flags_t {
 	__be16	tag;
 	u8	deactivated;
@@ -228,7 +231,7 @@ unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal);
 int tpm2_probe(struct tpm_chip *chip);
 int tpm2_get_cc_attrs_tbl(struct tpm_chip *chip);
 int tpm2_find_cc(struct tpm_chip *chip, u32 cc);
-int tpm2_init_space(struct tpm_space *space);
+int tpm2_init_space(struct tpm_space *space, unsigned int buf_size);
 void tpm2_del_space(struct tpm_chip *chip, struct tpm_space *space);
 void tpm2_flush_space(struct tpm_chip *chip);
 int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space, u8 *cmd,
diff --git a/drivers/char/tpm/tpm2-space.c b/drivers/char/tpm/tpm2-space.c
index 982d341d8837..784b8b3cb903 100644
--- a/drivers/char/tpm/tpm2-space.c
+++ b/drivers/char/tpm/tpm2-space.c
@@ -38,18 +38,21 @@ static void tpm2_flush_sessions(struct tpm_chip *chip, struct tpm_space *space)
 	}
 }
 
-int tpm2_init_space(struct tpm_space *space)
+int tpm2_init_space(struct tpm_space *space, unsigned int buf_size)
 {
-	space->context_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	space->context_buf = kzalloc(buf_size, GFP_KERNEL);
 	if (!space->context_buf)
 		return -ENOMEM;
 
-	space->session_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	space->session_buf = kzalloc(buf_size, GFP_KERNEL);
 	if (space->session_buf == NULL) {
 		kfree(space->context_buf);
+		/* Prevent caller getting a dangling pointer. */
+		space->context_buf = NULL;
 		return -ENOMEM;
 	}
 
+	space->buf_size = buf_size;
 	return 0;
 }
 
@@ -311,8 +314,10 @@ int tpm2_prepare_space(struct tpm_chip *chip, struct tpm_space *space, u8 *cmd,
 	       sizeof(space->context_tbl));
 	memcpy(&chip->work_space.session_tbl, &space->session_tbl,
 	       sizeof(space->session_tbl));
-	memcpy(chip->work_space.context_buf, space->context_buf, PAGE_SIZE);
-	memcpy(chip->work_space.session_buf, space->session_buf, PAGE_SIZE);
+	memcpy(chip->work_space.context_buf, space->context_buf,
+	       space->buf_size);
+	memcpy(chip->work_space.session_buf, space->session_buf,
+	       space->buf_size);
 
 	rc = tpm2_load_space(chip);
 	if (rc) {
@@ -492,7 +497,7 @@ static int tpm2_save_space(struct tpm_chip *chip)
 			continue;
 
 		rc = tpm2_save_context(chip, space->context_tbl[i],
-				       space->context_buf, PAGE_SIZE,
+				       space->context_buf, space->buf_size,
 				       &offset);
 		if (rc == -ENOENT) {
 			space->context_tbl[i] = 0;
@@ -509,9 +514,8 @@ static int tpm2_save_space(struct tpm_chip *chip)
 			continue;
 
 		rc = tpm2_save_context(chip, space->session_tbl[i],
-				       space->session_buf, PAGE_SIZE,
+				       space->session_buf, space->buf_size,
 				       &offset);
-
 		if (rc == -ENOENT) {
 			/* handle error saving session, just forget it */
 			space->session_tbl[i] = 0;
@@ -557,8 +561,10 @@ int tpm2_commit_space(struct tpm_chip *chip, struct tpm_space *space,
 	       sizeof(space->context_tbl));
 	memcpy(&space->session_tbl, &chip->work_space.session_tbl,
 	       sizeof(space->session_tbl));
-	memcpy(space->context_buf, chip->work_space.context_buf, PAGE_SIZE);
-	memcpy(space->session_buf, chip->work_space.session_buf, PAGE_SIZE);
+	memcpy(space->context_buf, chip->work_space.context_buf,
+	       space->buf_size);
+	memcpy(space->session_buf, chip->work_space.session_buf,
+	       space->buf_size);
 
 	return 0;
 out:
diff --git a/drivers/char/tpm/tpmrm-dev.c b/drivers/char/tpm/tpmrm-dev.c
index 7a0a7051a06f..eef0fb06ea83 100644
--- a/drivers/char/tpm/tpmrm-dev.c
+++ b/drivers/char/tpm/tpmrm-dev.c
@@ -21,7 +21,7 @@ static int tpmrm_open(struct inode *inode, struct file *file)
 	if (priv == NULL)
 		return -ENOMEM;
 
-	rc = tpm2_init_space(&priv->space);
+	rc = tpm2_init_space(&priv->space, TPM2_SPACE_BUFFER_SIZE);
 	if (rc) {
 		kfree(priv);
 		return -ENOMEM;
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 03e9b184411b..8f4ff39f51e7 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -96,6 +96,7 @@ struct tpm_space {
 	u8 *context_buf;
 	u32 session_tbl[3];
 	u8 *session_buf;
+	u32 buf_size;
 };
 
 struct tpm_bios_log {

