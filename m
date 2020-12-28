Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6492E3576
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 10:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgL1J2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 04:28:08 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:43145 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726509AbgL1J2H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 04:28:07 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id F09B16F4;
        Mon, 28 Dec 2020 04:27:01 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 04:27:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=4Zf1xN
        P0/iUx8xd8YKWrhC48SOU7Rtl/8eEtKesFsVM=; b=iOQ2ScjojxMkH4B/FT4NWS
        ++l6BeX+ESeubzrJiEE1LMWqQZfrUVbavjhosiEeNsnDzB3cvb8gXMWmr95+Hdrn
        K2obg6JBRbGRA1dNW9kNPDKkyF21Ay2VryHH+4B68J19D8DgyLVLT2BcJkuuoiH0
        UiGrm3PgLuuea8WmJTFs2TPbUqfrtwkQgLxsmNBDLH/FG+k3HZGe0H3Cbr0kcOK3
        rVP/Hm1N1RMbxEaSgA++YDNW/hDRwWLoHdhAq1Y9RkOi1WDLkXddrCDMAi950wk4
        Z6A4h6BxF5xTF6sjJTgrqakJGbtMS5NZ80nLn+cj7B/6NZjYIHGu4dthe1cw6D+Q
        ==
X-ME-Sender: <xms:5KTpX6KoxdKf6XjCPmjN2t0xpmbBBLWgwP-d84Cl2B024YmzdAdHIw>
    <xme:5KTpXyJ1-IxSVsWRTFvukT75fJhme9-vI0Wp_UChnvtL1dZCGfhw27K8hS6E1PulU
    -dyj2F9DlFVtg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:5aTpX6vDvq1U2sQ7WhdsJfGjVigo_tkZzVW2BBnEiaHXB1IjxvZAwg>
    <xmx:5aTpX_ZdjE6H56ss2SyZdkWfmuHnhTF_lkPJ4qSx2e8EtCfrDME6Nw>
    <xmx:5aTpXxbKOr0w5GytcpIFw1yUAFX8AbbM3L6DQjoAaG5on0g8aJFGiQ>
    <xmx:5aTpXwzyWMhIixRuICpxHzVPSzJy4LPtnl8B9O2fIiLn8ov6_0smMvavSjU>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9E71924005C;
        Mon, 28 Dec 2020 04:27:00 -0500 (EST)
Subject: FAILED: patch "[PATCH] ima: Don't modify file descriptor mode on the fly" failed to apply to 4.4-stable tree
To:     roberto.sassu@huawei.com, hch@lst.de, stable@vger.kernel.org,
        zohar@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 10:28:24 +0100
Message-ID: <1609147704129219@kroah.com>
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

From 207cdd565dfc95a0a5185263a567817b7ebf5467 Mon Sep 17 00:00:00 2001
From: Roberto Sassu <roberto.sassu@huawei.com>
Date: Thu, 26 Nov 2020 11:34:56 +0100
Subject: [PATCH] ima: Don't modify file descriptor mode on the fly

Commit a408e4a86b36b ("ima: open a new file instance if no read
permissions") already introduced a second open to measure a file when the
original file descriptor does not allow it. However, it didn't remove the
existing method of changing the mode of the original file descriptor, which
is still necessary if the current process does not have enough privileges
to open a new one.

Changing the mode isn't really an option, as the filesystem might need to
do preliminary steps to make the read possible. Thus, this patch removes
the code and keeps the second open as the only option to measure a file
when it is unreadable with the original file descriptor.

Cc: <stable@vger.kernel.org> # 4.20.x: 0014cc04e8ec0 ima: Set file->f_mode
Fixes: 2fe5d6def1672 ("ima: integrity appraisal extension")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>

diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index 21989fa0c107..f6a7e9643b54 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -537,7 +537,7 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
 	loff_t i_size;
 	int rc;
 	struct file *f = file;
-	bool new_file_instance = false, modified_mode = false;
+	bool new_file_instance = false;
 
 	/*
 	 * For consistency, fail file's opened with the O_DIRECT flag on
@@ -555,18 +555,10 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
 				O_TRUNC | O_CREAT | O_NOCTTY | O_EXCL);
 		flags |= O_RDONLY;
 		f = dentry_open(&file->f_path, flags, file->f_cred);
-		if (IS_ERR(f)) {
-			/*
-			 * Cannot open the file again, lets modify f_mode
-			 * of original and continue
-			 */
-			pr_info_ratelimited("Unable to reopen file for reading.\n");
-			f = file;
-			f->f_mode |= FMODE_READ;
-			modified_mode = true;
-		} else {
-			new_file_instance = true;
-		}
+		if (IS_ERR(f))
+			return PTR_ERR(f);
+
+		new_file_instance = true;
 	}
 
 	i_size = i_size_read(file_inode(f));
@@ -581,8 +573,6 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
 out:
 	if (new_file_instance)
 		fput(f);
-	else if (modified_mode)
-		f->f_mode &= ~FMODE_READ;
 	return rc;
 }
 

