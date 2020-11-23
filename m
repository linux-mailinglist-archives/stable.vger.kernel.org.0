Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 176C42C0270
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 10:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728057AbgKWJoC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 04:44:02 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:54915 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725275AbgKWJoC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 04:44:02 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 50EAAF95;
        Mon, 23 Nov 2020 04:44:01 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 23 Nov 2020 04:44:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=DIt9Nw
        ftW4Q0g/P7AzfOQepzUTgsDLZIKXCgno7qCdg=; b=lbG/VMmtIjmryZgbDNoVfh
        efMSA6Y5TvIcu0U0IviqGxvTxx5ZMwiU83GRE81wTyfVrHybuLi2xGdpO6H/93cJ
        2OqtGsXp6om3rUuNdlAPTf3x5Tb9jK8mKVwVBTF/euHvWUyLYnOYXg/uSUrF9AUD
        jqH0JmG+jDGG2ul9csPZnSz/G/CfoEUhpYweDNRGk0ty3Kw2b1EklqHgHdH1qYUv
        qTI6stDqQNKZcFDDuTakJ6ItIl/uJXWetNqh1tFXe7u2UW9SUi020fs5o7ibMise
        9d9mYnThb2WNRKwIz7R06ApeIEqriM+rsG3DG0nNfzmepAJQkf7NtINCvqwkFpFg
        ==
X-ME-Sender: <xms:YIS7X85iUyg-McDNtYCIquPmSXLnGjDYyoIrBv3SEINkZST6oB5F3A>
    <xme:YIS7X95BJBgpyaNVZ6MMqjOvcTHtCcJKKW5lqOJmpr2BCFHNhEoEV9Ax-ecwfhQ6G
    EteOo1UbMyjfw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudegiedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkeejgffftefgveeggeehudfgleehkedthedtiefhie
    elieetveejvdfgvdeljeelnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:YIS7X7fXpQ7PskJwe6PZbiZsSljBt9f7uqZOkz6rlL3MQtsCDROMRQ>
    <xmx:YIS7XxKvAhCRqOgFxg7T5emEeY7vqlcZX24ZWft5f2oVhgkjj2BHiQ>
    <xmx:YIS7XwJ7SneNMw3Op7NvFc-WME8tlCq6tBnfo_6yJwL3zS7V_miODQ>
    <xmx:YIS7X02HaQPfuxSljYl4LCJSyMQ74kv2mBbRGnxpUoniqd1O28kWf0JX1RY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 76F6E3280059;
        Mon, 23 Nov 2020 04:44:00 -0500 (EST)
Subject: FAILED: patch "[PATCH] seccomp: Set PF_SUPERPRIV when checking capability" failed to apply to 4.9-stable tree
To:     mic@linux.microsoft.com, jannh@google.com, keescook@chromium.org,
        tyhicks@linux.microsoft.com, wad@chromium.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Nov 2020 10:45:03 +0100
Message-ID: <160612470318636@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

