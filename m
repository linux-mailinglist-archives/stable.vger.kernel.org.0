Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE6F2C026F
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 10:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgKWJnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 04:43:53 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:55737 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725275AbgKWJnx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 04:43:53 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 831D2FC7;
        Mon, 23 Nov 2020 04:43:52 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 23 Nov 2020 04:43:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=AX3p7G
        pqdo9dd5jzm6oBUh08kmhQYsn6lMGH8TikxN0=; b=HZNnWMNSUgw4mHaiPsDMm4
        FVbE6vpILFTtPxcgVJFj/EQFi2t0XCLpEOd2KnC6buekej4IBzro+xZKAYleKhig
        bCM/qf1n9ZD1uAXOB0Uas2exvLm5Q0Rok95Btw124fgrQOW7i9GcpobPK56A7Yq1
        SxEJqdwHe5FO43O9D+AVOpORfqy2tVS6WBwNGHSloywhZ4bELKLngNybpFQZctSH
        iLW8e/f2amfkvzLPh9YnadTKSYjmRYxN9eNEqaHyjvx0JgX0eI/BfKbyM3hMINFl
        0LRow4tCPMMVT496YsLZ2jH9uZN6pc2DyoOU8GpBMILZg1hJ4dmLHUESnPGJSb+A
        ==
X-ME-Sender: <xms:WIS7X4Bf-AML49ANZZOpljwaxHsAQzp1Q4nyx7FJ8JpCUj0LWtie9w>
    <xme:WIS7X6jFgyjVwoFMl4Vhd6xBnm9oTkciSz_Q0IeuYOnHz1K2rprQEi88JAXqiRzHP
    lbxWNVYU-5U4w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudegiedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkeejgffftefgveeggeehudfgleehkedthedtiefhie
    elieetveejvdfgvdeljeelnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:WIS7X7lw8IGhwGoqrzWsR0CJjSrN9HcYyLD0vg_GUgqoptD4Ak0soA>
    <xmx:WIS7X-ygFfZWoKf39A8vvui6afE5k5UUfxJbCcNbCci_rTFW5dvRWw>
    <xmx:WIS7X9RQnXNMwhE3mBzvJoRr7HaArczi9pV_3fb_nqelTplM1KUKHg>
    <xmx:WIS7X_fg9cTb-c5eyhd074Ugwx3onc6MkmwDfBiWT9wjhydE5ev6dtWaTTY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id BCF983064AA7;
        Mon, 23 Nov 2020 04:43:51 -0500 (EST)
Subject: FAILED: patch "[PATCH] seccomp: Set PF_SUPERPRIV when checking capability" failed to apply to 4.4-stable tree
To:     mic@linux.microsoft.com, jannh@google.com, keescook@chromium.org,
        tyhicks@linux.microsoft.com, wad@chromium.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Nov 2020 10:45:03 +0100
Message-ID: <160612470312048@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From fb14528e443646dd3fd02df4437fcf5265b66baa Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@linux.microsoft.com>
Date: Fri, 30 Oct 2020 13:38:49 +0100
Subject: [PATCH] seccomp: Set PF_SUPERPRIV when checking capability
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Replace the use of security_capable(current_cred(), ...) with
ns_capable_noaudit() which set PF_SUPERPRIV.

Since commit 98f368e9e263 ("kernel: Add noaudit variant of
ns_capable()"), a new ns_capable_noaudit() helper is available.  Let's
use it!

Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Tyler Hicks <tyhicks@linux.microsoft.com>
Cc: Will Drewry <wad@chromium.org>
Cc: stable@vger.kernel.org
Fixes: e2cfabdfd075 ("seccomp: add system call filtering using BPF")
Signed-off-by: Mickaël Salaün <mic@linux.microsoft.com>
Reviewed-by: Jann Horn <jannh@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20201030123849.770769-3-mic@digikod.net

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 8ad7a293255a..53a7d1512dd7 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -38,7 +38,7 @@
 #include <linux/filter.h>
 #include <linux/pid.h>
 #include <linux/ptrace.h>
-#include <linux/security.h>
+#include <linux/capability.h>
 #include <linux/tracehook.h>
 #include <linux/uaccess.h>
 #include <linux/anon_inodes.h>
@@ -558,8 +558,7 @@ static struct seccomp_filter *seccomp_prepare_filter(struct sock_fprog *fprog)
 	 * behavior of privileged children.
 	 */
 	if (!task_no_new_privs(current) &&
-	    security_capable(current_cred(), current_user_ns(),
-				     CAP_SYS_ADMIN, CAP_OPT_NOAUDIT) != 0)
+			!ns_capable_noaudit(current_user_ns(), CAP_SYS_ADMIN))
 		return ERR_PTR(-EACCES);
 
 	/* Allocate a new seccomp_filter */

