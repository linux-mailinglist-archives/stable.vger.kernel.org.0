Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB3913FD09
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387533AbgAPXVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:21:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:48238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389910AbgAPXVN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:21:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1ED3E2072B;
        Thu, 16 Jan 2020 23:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216872;
        bh=2kKG/27VuOVK4lQ4VGSOkWD7HQ57Q6d5cJDxLBh9vbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=inBZddWSC84YgxejRSaF/xm5sT8yjlQaAwjuhZ1R4GHfdMsfwXbLOK7tITemQPVm2
         DjC+By6dQuusW0AJtE8HYjDdL1FZaNag6J4yXuO0h9VvMr56uDfIMueyPfdbqgz0p2
         uOg5SwPp9R93/fVwJvSpHca6y/EMx5YECCzzqbDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.4 038/203] cifs: Adjust indentation in smb2_open_file
Date:   Fri, 17 Jan 2020 00:15:55 +0100
Message-Id: <20200116231747.421371600@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
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
 		/* default timeout is 0, servers pick default (120 seconds) */
 		nr_ioctl_req.Timeout =
 			cpu_to_le32(oparms->tcon->handle_timeout);


