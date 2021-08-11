Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE74A3E9A42
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 23:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbhHKVL3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 17:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbhHKVL3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Aug 2021 17:11:29 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039E3C061765
        for <stable@vger.kernel.org>; Wed, 11 Aug 2021 14:11:05 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id f5so4899987wrm.13
        for <stable@vger.kernel.org>; Wed, 11 Aug 2021 14:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=D1l2ENsahB1VYyvr/bIHfV6Vd3t0SbpdzH9H+1htIDM=;
        b=lmPjkyY/Qg8X8zZoDoxPqJjyWZZd1QmR1I5VR3WcDFvlYO0egY0mhXxeqN6t4zH1NB
         7lZusvy347ygWZdclUuBsbVJfyPWOTctY7TFzn7EWgc8pxUcIEgmMGBcWdFtdMQV9uSd
         Ep2i87PuQzJZKe9BxExt/EUNqrnDS+P+tZpyF6QioTICh9Skr7wa5X0RZA8jaon38tDY
         nC5EbqWjRqPYcNB+rgJ+bhsE16vUlY7mbh/zPTophZeYqTZ34rb7liNzZpSEKfeRYk3z
         ODiqW6XlA8vxkZD5xZlwHY0y8cOlYsn+OPaLBFpzEqRaY6xH6fNusLIUkOBmmLyp1dI0
         WKHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=D1l2ENsahB1VYyvr/bIHfV6Vd3t0SbpdzH9H+1htIDM=;
        b=A93Ns7bAGMdCjqG1VImhvp4de/MvUlmNVT9rnnCBQz1DjULGtuEPg1FvJ0KrlPu8Mt
         rQl1sIaKOHHQ862VVgx60OfjEj/w1n7MXt9YPz8FbyvxkMf69anHmKvG/WaCGLMrJdlD
         OkIvQ91LtzbZ97ozxEFbdc7kbhfB8zEF+mHZ5Nd1O40ZZd43QhrMEH+d2EnhkcqyEM9v
         0HxmLzP5BChZZCMzzWXwF8Y1vGDreY6uFqQGhLSqy0F346SwSAfwwFZCYR3io1+tl+qZ
         uy1QZIaE9BWElqMF6hRJhhebml4NKpUoLYa3+U4UzAgg34wBOxi+Ww6MZ1aokbd3FYZd
         ndLA==
X-Gm-Message-State: AOAM531qRLyFCqGGYlruuZmd177dq2OBmLYPcSCRHte6ZKEM+VNA/G7W
        2XGpH2jQxWPmTqpiNBct/rA=
X-Google-Smtp-Source: ABdhPJxY1jJ3pNTYYZ4ISEbzf3dXPXaGAt6H4KcinSbavGg5oi64kWAqO+UV9HbZ/SS9/iSu3xM1Gg==
X-Received: by 2002:a5d:634a:: with SMTP id b10mr378315wrw.305.1628716263584;
        Wed, 11 Aug 2021 14:11:03 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id p4sm536494wrq.81.2021.08.11.14.11.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 14:11:03 -0700 (PDT)
Date:   Wed, 11 Aug 2021 22:11:01 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     hdegoede@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] vboxsf: Make vboxsf_dir_create() return
 the handle for the" failed to apply to 5.10-stable tree
Message-ID: <YRQ85QyVc7Sb/Hm/@debian>
References: <1626967913218159@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="suOL+kFwe0IUFHcY"
Content-Disposition: inline
In-Reply-To: <1626967913218159@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--suOL+kFwe0IUFHcY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Thu, Jul 22, 2021 at 05:31:53PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport along with cc3ddee97cff ("vboxsf: Honor excl flag
to the dir-inode create op") which was also in another failed mail.

--
Regards
Sudip

--suOL+kFwe0IUFHcY
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-vboxsf-Honor-excl-flag-to-the-dir-inode-create-op.patch"

From 3233e395a642f599315f928ebe12af6bbf079520 Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Thu, 21 Jan 2021 10:08:59 +0100
Subject: [PATCH 1/2] vboxsf: Honor excl flag to the dir-inode create op

commit cc3ddee97cff034cea4d095de4a484c92a219bf5 upstream

Honor the excl flag to the dir-inode create op, instead of behaving
as if it is always set.

Note the old behavior still worked most of the time since a non-exclusive
open only calls the create op, if there is a race and the file is created
between the dentry lookup and the calling of the create call.

While at it change the type of the is_dir parameter to the
vboxsf_dir_create() helper from an int to a bool, to be consistent with
the use of bool for the excl parameter.

Fixes: 0fd169576648 ("fs: Add VirtualBox guest shared folder (vboxsf) support")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 fs/vboxsf/dir.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/vboxsf/dir.c b/fs/vboxsf/dir.c
index 4d569f14a8d8..c3e68ad6c0f4 100644
--- a/fs/vboxsf/dir.c
+++ b/fs/vboxsf/dir.c
@@ -253,7 +253,7 @@ static int vboxsf_dir_instantiate(struct inode *parent, struct dentry *dentry,
 }
 
 static int vboxsf_dir_create(struct inode *parent, struct dentry *dentry,
-			     umode_t mode, int is_dir)
+			     umode_t mode, bool is_dir, bool excl)
 {
 	struct vboxsf_inode *sf_parent_i = VBOXSF_I(parent);
 	struct vboxsf_sbi *sbi = VBOXSF_SBI(parent->i_sb);
@@ -261,10 +261,12 @@ static int vboxsf_dir_create(struct inode *parent, struct dentry *dentry,
 	int err;
 
 	params.handle = SHFL_HANDLE_NIL;
-	params.create_flags = SHFL_CF_ACT_CREATE_IF_NEW |
-			      SHFL_CF_ACT_FAIL_IF_EXISTS |
-			      SHFL_CF_ACCESS_READWRITE |
-			      (is_dir ? SHFL_CF_DIRECTORY : 0);
+	params.create_flags = SHFL_CF_ACT_CREATE_IF_NEW | SHFL_CF_ACCESS_READWRITE;
+	if (is_dir)
+		params.create_flags |= SHFL_CF_DIRECTORY;
+	if (excl)
+		params.create_flags |= SHFL_CF_ACT_FAIL_IF_EXISTS;
+
 	params.info.attr.mode = (mode & 0777) |
 				(is_dir ? SHFL_TYPE_DIRECTORY : SHFL_TYPE_FILE);
 	params.info.attr.additional = SHFLFSOBJATTRADD_NOTHING;
@@ -291,13 +293,13 @@ static int vboxsf_dir_create(struct inode *parent, struct dentry *dentry,
 static int vboxsf_dir_mkfile(struct inode *parent, struct dentry *dentry,
 			     umode_t mode, bool excl)
 {
-	return vboxsf_dir_create(parent, dentry, mode, 0);
+	return vboxsf_dir_create(parent, dentry, mode, false, excl);
 }
 
 static int vboxsf_dir_mkdir(struct inode *parent, struct dentry *dentry,
 			    umode_t mode)
 {
-	return vboxsf_dir_create(parent, dentry, mode, 1);
+	return vboxsf_dir_create(parent, dentry, mode, true, true);
 }
 
 static int vboxsf_dir_unlink(struct inode *parent, struct dentry *dentry)
-- 
2.30.2


--suOL+kFwe0IUFHcY
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-vboxsf-Make-vboxsf_dir_create-return-the-handle-for-.patch"

From ee92acd5243cec7687d73f60cdcb239756de9e2a Mon Sep 17 00:00:00 2001
From: Hans de Goede <hdegoede@redhat.com>
Date: Thu, 21 Jan 2021 10:22:27 +0100
Subject: [PATCH 2/2] vboxsf: Make vboxsf_dir_create() return the handle for
 the created file

commit ab0c29687bc7a890d1a86ac376b0b0fd78b2d9b6 upstream

Make vboxsf_dir_create() optionally return the vboxsf-handle for
the created file. This is a preparation patch for adding atomic_open
support.

Fixes: 0fd169576648 ("fs: Add VirtualBox guest shared folder (vboxsf) support")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 fs/vboxsf/dir.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/vboxsf/dir.c b/fs/vboxsf/dir.c
index c3e68ad6c0f4..0664787f2b74 100644
--- a/fs/vboxsf/dir.c
+++ b/fs/vboxsf/dir.c
@@ -253,7 +253,7 @@ static int vboxsf_dir_instantiate(struct inode *parent, struct dentry *dentry,
 }
 
 static int vboxsf_dir_create(struct inode *parent, struct dentry *dentry,
-			     umode_t mode, bool is_dir, bool excl)
+			     umode_t mode, bool is_dir, bool excl, u64 *handle_ret)
 {
 	struct vboxsf_inode *sf_parent_i = VBOXSF_I(parent);
 	struct vboxsf_sbi *sbi = VBOXSF_SBI(parent->i_sb);
@@ -278,28 +278,32 @@ static int vboxsf_dir_create(struct inode *parent, struct dentry *dentry,
 	if (params.result != SHFL_FILE_CREATED)
 		return -EPERM;
 
-	vboxsf_close(sbi->root, params.handle);
-
 	err = vboxsf_dir_instantiate(parent, dentry, &params.info);
 	if (err)
-		return err;
+		goto out;
 
 	/* parent directory access/change time changed */
 	sf_parent_i->force_restat = 1;
 
-	return 0;
+out:
+	if (err == 0 && handle_ret)
+		*handle_ret = params.handle;
+	else
+		vboxsf_close(sbi->root, params.handle);
+
+	return err;
 }
 
 static int vboxsf_dir_mkfile(struct inode *parent, struct dentry *dentry,
 			     umode_t mode, bool excl)
 {
-	return vboxsf_dir_create(parent, dentry, mode, false, excl);
+	return vboxsf_dir_create(parent, dentry, mode, false, excl, NULL);
 }
 
 static int vboxsf_dir_mkdir(struct inode *parent, struct dentry *dentry,
 			    umode_t mode)
 {
-	return vboxsf_dir_create(parent, dentry, mode, true, true);
+	return vboxsf_dir_create(parent, dentry, mode, true, true, NULL);
 }
 
 static int vboxsf_dir_unlink(struct inode *parent, struct dentry *dentry)
-- 
2.30.2


--suOL+kFwe0IUFHcY--
