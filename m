Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88B2C13FEDA
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391238AbgAPX3N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:29:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:34666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389191AbgAPX3M (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:29:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A02142072E;
        Thu, 16 Jan 2020 23:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217352;
        bh=AYrrjajashVILVcw4LRRvqc3zeVs4tG/2WfuTQkxp74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RVr50ibTXadI7DbHWd2A4HsX9iWlE9YiLs8LZIVNkLbz0+rrKwS6aikUuhqsCdmPe
         mi0tAp0aihK3jkiePaVwHNj6dDieEvOZba2PRt9iBOGNS5x1aF6/J7ti7jvnbkvu5F
         47xSRmHHK8Xyt+9IuFK6BCtBXwDTKJTKok4mQsZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 4.19 30/84] cifs: Adjust indentation in smb2_open_file
Date:   Fri, 17 Jan 2020 00:18:04 +0100
Message-Id: <20200116231717.245025122@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231713.087649517@linuxfoundation.org>
References: <20200116231713.087649517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

commit 7935799e041ae10d380d04ea23868240f082bd11 upstream.

Clang warns:

../fs/cifs/smb2file.c:70:3: warning: misleading indentation; statement
is not part of the previous 'if' [-Wmisleading-indentation]
         if (oparms->tcon->use_resilient) {
         ^
../fs/cifs/smb2file.c:66:2: note: previous statement is here
        if (rc)
        ^
1 warning generated.

This warning occurs because there is a space after the tab on this line.
Remove it so that the indentation is consistent with the Linux kernel
coding style and clang no longer warns.

Fixes: 592fafe644bf ("Add resilienthandles mount parm")
Link: https://github.com/ClangBuiltLinux/linux/issues/826
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -67,7 +67,7 @@ smb2_open_file(const unsigned int xid, s
 		goto out;
 
 
-	 if (oparms->tcon->use_resilient) {
+	if (oparms->tcon->use_resilient) {
 		nr_ioctl_req.Timeout = 0; /* use server default (120 seconds) */
 		nr_ioctl_req.Reserved = 0;
 		rc = SMB2_ioctl(xid, oparms->tcon, fid->persistent_fid,


