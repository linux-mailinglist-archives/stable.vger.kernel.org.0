Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB68200A32
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731687AbgFSNcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:32:00 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:38321 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726124AbgFSNb7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:31:59 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 53C3B194424D;
        Fri, 19 Jun 2020 09:31:58 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 09:31:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=n91Hyy
        w8MXuU6nfb0yiiES9uAw2dzirnUPxUn9hHwDg=; b=TC0m/vaQ7lqgdiIHbG7+7p
        fSCKl7gJWxKhuKQqFNbbLv7h42EQ0ql1LzLgr6bUT5jCEi6sAo51904XLfqndqNl
        fDcvVh8VP0YL/1Bw6hVZPyMkB6ij3V7De/nSmlp7E5d7W4eel5JAv68SU82UrvoK
        SR88B97ngWxLJPj6V5pWisqo2zzhtviAmS15R4Et9Zo/y1pVGGM2aZr8SCn8NQjF
        tGfhJlZs3VVJleAnTotnuNxMu6GO1jlrYcPftIUp4IjdgcrfpH6OOhQstimY+ZEb
        bB0ca5//D3AWCMTSy1lNuiKkfZm0A3rgYr86++F130DzuVleVexwAu36M7MxOdzg
        ==
X-ME-Sender: <xms:Tr7sXmRuLvzK2FVfv2GpQui37QDsPyHlr4F9hMQQp8mKg7jihSJBtw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgieehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:Tr7sXrz0GNv4LNRo7_VL3QVRPCRHsCZMQyOMD_XKd5YJLw_QEw1DgQ>
    <xmx:Tr7sXj10MVIwWt1oFEu8eRdWSeC3FvA7n4JUfBQtxygZTvO11Dqfzg>
    <xmx:Tr7sXiC4nMC7RTN85Q2wUgn59zQQoJSq0FtVmE0g9l-6Kq7MKz_b4w>
    <xmx:Tr7sXqvBUPWNFRHbERi0RPjujk_MIw8i_G0Y_jPg7q9b8_3FS5uzfA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B928F3280063;
        Fri, 19 Jun 2020 09:31:57 -0400 (EDT)
Subject: FAILED: patch "[PATCH] sparc64: fix misuses of access_process_vm() in" failed to apply to 4.4-stable tree
To:     viro@zeniv.linux.org.uk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 15:31:53 +0200
Message-ID: <159257351314396@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 142cd25293f6a7ecbdff4fb0af17de6438d46433 Mon Sep 17 00:00:00 2001
From: Al Viro <viro@zeniv.linux.org.uk>
Date: Sun, 17 May 2020 15:37:50 -0400
Subject: [PATCH] sparc64: fix misuses of access_process_vm() in
 genregs32_[sg]et()

We do need access_process_vm() to access the target's reg_window.
However, access to caller's memory (storing the result in
genregs32_get(), fetching the new values in case of genregs32_set())
should be done by normal uaccess primitives.

Fixes: ad4f95764040 ([SPARC64]: Fix user accesses in regset code.)
Cc: stable@kernel.org
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

diff --git a/arch/sparc/kernel/ptrace_64.c b/arch/sparc/kernel/ptrace_64.c
index c9d41a96468f..3f5930bfab06 100644
--- a/arch/sparc/kernel/ptrace_64.c
+++ b/arch/sparc/kernel/ptrace_64.c
@@ -572,19 +572,13 @@ static int genregs32_get(struct task_struct *target,
 			for (; count > 0 && pos < 32; count--) {
 				if (access_process_vm(target,
 						      (unsigned long)
-						      &reg_window[pos],
+						      &reg_window[pos++],
 						      &reg, sizeof(reg),
 						      FOLL_FORCE)
 				    != sizeof(reg))
 					return -EFAULT;
-				if (access_process_vm(target,
-						      (unsigned long) u,
-						      &reg, sizeof(reg),
-						      FOLL_FORCE | FOLL_WRITE)
-				    != sizeof(reg))
+				if (put_user(reg, u++))
 					return -EFAULT;
-				pos++;
-				u++;
 			}
 		}
 	}
@@ -684,12 +678,7 @@ static int genregs32_set(struct task_struct *target,
 			}
 		} else {
 			for (; count > 0 && pos < 32; count--) {
-				if (access_process_vm(target,
-						      (unsigned long)
-						      u,
-						      &reg, sizeof(reg),
-						      FOLL_FORCE)
-				    != sizeof(reg))
+				if (get_user(reg, u++))
 					return -EFAULT;
 				if (access_process_vm(target,
 						      (unsigned long)

