Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59C592A450A
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 13:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728214AbgKCMZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 07:25:56 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:34397 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728168AbgKCMZ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 07:25:56 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id CD2BCC57;
        Tue,  3 Nov 2020 07:25:54 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 07:25:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=fNk2zb
        dtg2we3Y4qyeF7X3GsU5cV/4tQsDjDa26kjuE=; b=dNIMENX2U6VgIKd7EUYpxB
        h1AHgXz5OmLK/BO0t8Dm9n89IXeoY2/tNOPNGqKmnNilALtvfG36yesHXVhoz/Tk
        5NGcwpwmGQD30Ub6XkhjsudSzQf0q7uOjynyDOLZo3xVRmocvdcc+PzWt7U08v71
        Bos3Kce7O4/ZMwjUjUng/x/xoICDYJoTkjdmTwHLT6lxDFnBEj/EReBK5Lv/AzCN
        8aVEKohgMKrcGvXA9yLJsv/BJARhXi4F2mhoPAOr6wQvmRsdxlWcQnSTas799Lut
        sUSJA+iz1OLl3jRDR4BPGO7glz4jZuZI0JlX86W7RXqIHLx/neESwlYw+vQnoDPw
        ==
X-ME-Sender: <xms:UkyhXxvQPoKxmI1cI1WVtqKIHh_0_IdSKCw9NnkReNrC_jqK0igaUA>
    <xme:UkyhX6f5kG4V3roGk_QO58Xb8fZN3dHXWYL4tLGSBQ_v4QXq9pusrdVaoB6IBNKHG
    x-UmsOJx6R3dQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgfeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:UkyhX0yuWkOGl3l4xjopKr_zNes4-4KXOFdpYEDZtt4NGbXBPMOwGw>
    <xmx:UkyhX4PqJwHHG8jyE0wBNtnsqW0BZo4gRly3HsQScxY9tyLXpqNm9g>
    <xmx:UkyhXx9QuGFdQMAUhHppGfvznRQzMyxyiYAryaaK9AlrBkmLb0_Qfg>
    <xmx:UkyhX8YEhA87G018D48UQd330U0-8nr0WiAkAYrTMSEwj_zgbKhNT4YY0Ks>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A105D328005E;
        Tue,  3 Nov 2020 07:25:53 -0500 (EST)
Subject: FAILED: patch "[PATCH] fs/kernel_read_file: Remove FIRMWARE_PREALLOC_BUFFER enum" failed to apply to 4.19-stable tree
To:     keescook@chromium.org, gregkh@linuxfoundation.org,
        mcgrof@kernel.org, scott.branden@broadcom.com, zohar@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 13:26:40 +0100
Message-ID: <160440640045225@kroah.com>
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

From c307459b9d1fcb8bbf3ea5a4162979532322ef77 Mon Sep 17 00:00:00 2001
From: Kees Cook <keescook@chromium.org>
Date: Fri, 2 Oct 2020 10:38:13 -0700
Subject: [PATCH] fs/kernel_read_file: Remove FIRMWARE_PREALLOC_BUFFER enum

FIRMWARE_PREALLOC_BUFFER is a "how", not a "what", and confuses the LSMs
that are interested in filtering between types of things. The "how"
should be an internal detail made uninteresting to the LSMs.

Fixes: a098ecd2fa7d ("firmware: support loading into a pre-allocated buffer")
Fixes: fd90bc559bfb ("ima: based on policy verify firmware signatures (pre-allocated buffer)")
Fixes: 4f0496d8ffa3 ("ima: based on policy warn about loading firmware (pre-allocated buffer)")
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Acked-by: Scott Branden <scott.branden@broadcom.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201002173828.2099543-2-keescook@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/base/firmware_loader/main.c b/drivers/base/firmware_loader/main.c
index 63b9714a0154..b0ec2721f55d 100644
--- a/drivers/base/firmware_loader/main.c
+++ b/drivers/base/firmware_loader/main.c
@@ -470,14 +470,12 @@ fw_get_filesystem_firmware(struct device *device, struct fw_priv *fw_priv,
 	int i, len;
 	int rc = -ENOENT;
 	char *path;
-	enum kernel_read_file_id id = READING_FIRMWARE;
 	size_t msize = INT_MAX;
 	void *buffer = NULL;
 
 	/* Already populated data member means we're loading into a buffer */
 	if (!decompress && fw_priv->data) {
 		buffer = fw_priv->data;
-		id = READING_FIRMWARE_PREALLOC_BUFFER;
 		msize = fw_priv->allocated_size;
 	}
 
@@ -501,7 +499,8 @@ fw_get_filesystem_firmware(struct device *device, struct fw_priv *fw_priv,
 
 		/* load firmware files from the mount namespace of init */
 		rc = kernel_read_file_from_path_initns(path, &buffer,
-						       &size, msize, id);
+						       &size, msize,
+						       READING_FIRMWARE);
 		if (rc) {
 			if (rc != -ENOENT)
 				dev_warn(device, "loading %s failed with error %d\n",
diff --git a/fs/exec.c b/fs/exec.c
index a91003e28eaa..9233cd50dc4c 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -954,6 +954,7 @@ int kernel_read_file(struct file *file, void **buf, loff_t *size,
 {
 	loff_t i_size, pos;
 	ssize_t bytes = 0;
+	void *allocated = NULL;
 	int ret;
 
 	if (!S_ISREG(file_inode(file)->i_mode) || max_size < 0)
@@ -977,8 +978,8 @@ int kernel_read_file(struct file *file, void **buf, loff_t *size,
 		goto out;
 	}
 
-	if (id != READING_FIRMWARE_PREALLOC_BUFFER)
-		*buf = vmalloc(i_size);
+	if (!*buf)
+		*buf = allocated = vmalloc(i_size);
 	if (!*buf) {
 		ret = -ENOMEM;
 		goto out;
@@ -1007,7 +1008,7 @@ int kernel_read_file(struct file *file, void **buf, loff_t *size,
 
 out_free:
 	if (ret < 0) {
-		if (id != READING_FIRMWARE_PREALLOC_BUFFER) {
+		if (allocated) {
 			vfree(*buf);
 			*buf = NULL;
 		}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7519ae003a08..7336e22d0c5d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2858,10 +2858,10 @@ static inline void i_readcount_inc(struct inode *inode)
 #endif
 extern int do_pipe_flags(int *, int);
 
+/* This is a list of *what* is being read, not *how*. */
 #define __kernel_read_file_id(id) \
 	id(UNKNOWN, unknown)		\
 	id(FIRMWARE, firmware)		\
-	id(FIRMWARE_PREALLOC_BUFFER, firmware)	\
 	id(FIRMWARE_EFI_EMBEDDED, firmware)	\
 	id(MODULE, kernel-module)		\
 	id(KEXEC_IMAGE, kexec-image)		\
diff --git a/kernel/module.c b/kernel/module.c
index 1c5cff34d9f2..b2808acac46b 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -4035,7 +4035,7 @@ SYSCALL_DEFINE3(finit_module, int, fd, const char __user *, uargs, int, flags)
 {
 	struct load_info info = { };
 	loff_t size;
-	void *hdr;
+	void *hdr = NULL;
 	int err;
 
 	err = may_init_module();
diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
index e9cbadade74b..ac02b7632353 100644
--- a/security/integrity/digsig.c
+++ b/security/integrity/digsig.c
@@ -169,7 +169,7 @@ int __init integrity_add_key(const unsigned int id, const void *data,
 
 int __init integrity_load_x509(const unsigned int id, const char *path)
 {
-	void *data;
+	void *data = NULL;
 	loff_t size;
 	int rc;
 	key_perm_t perm;
diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index e3fcad871861..15a44c5022f7 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -272,7 +272,7 @@ static const struct file_operations ima_ascii_measurements_ops = {
 
 static ssize_t ima_read_policy(char *path)
 {
-	void *data;
+	void *data = NULL;
 	char *datap;
 	loff_t size;
 	int rc, pathlen = strlen(path);
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 8a91711ca79b..2f187784c5bc 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -611,19 +611,17 @@ void ima_post_path_mknod(struct dentry *dentry)
 int ima_read_file(struct file *file, enum kernel_read_file_id read_id)
 {
 	/*
-	 * READING_FIRMWARE_PREALLOC_BUFFER
-	 *
 	 * Do devices using pre-allocated memory run the risk of the
 	 * firmware being accessible to the device prior to the completion
 	 * of IMA's signature verification any more than when using two
-	 * buffers?
+	 * buffers? It may be desirable to include the buffer address
+	 * in this API and walk all the dma_map_single() mappings to check.
 	 */
 	return 0;
 }
 
 const int read_idmap[READING_MAX_ID] = {
 	[READING_FIRMWARE] = FIRMWARE_CHECK,
-	[READING_FIRMWARE_PREALLOC_BUFFER] = FIRMWARE_CHECK,
 	[READING_MODULE] = MODULE_CHECK,
 	[READING_KEXEC_IMAGE] = KEXEC_KERNEL_CHECK,
 	[READING_KEXEC_INITRAMFS] = KEXEC_INITRAMFS_CHECK,

