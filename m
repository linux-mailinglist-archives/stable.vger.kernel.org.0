Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88B9B2C026B
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 10:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727927AbgKWJnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 04:43:21 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:34019 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725275AbgKWJnU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 04:43:20 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 7CD36EAC;
        Mon, 23 Nov 2020 04:43:19 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 23 Nov 2020 04:43:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=5n9UYK
        iLDTyN3dlBdy454qpwj3lMjeMyboxysHJBIpk=; b=KCxWtmG9XUOxx+y+Unwt/z
        dfTR+VQoReoZTJj9jogiD9XYrcQ0qGpwU4ZM+8IUWeRy6ELvzoufK0u6UUiRY7eM
        QhyiNqCZ1vUvSVDTAhlYl4ba5AGDD5WGFKf1HZ1cblqi+WMuflOZYrqTfHnl2RbC
        WPM+e4zXfZYEojOqjm6tQt8EDDrNuOZOAd9aQgKyhO70hesB/cp4P6y2wQhTq4mI
        is7HjGe446Uby8ibpZFvZc3wdcwnxomu42zoBqT7tzJQuFdylCwBNMl4DqU1Cj9X
        /JTV7LgXFG+5PoU7wBIie4mXHzBD+PWnPHVd0plXgVMH9clnTUK0UAUzBZXdaXdw
        ==
X-ME-Sender: <xms:NoS7XwCRlnius5UQg4gaJKjRk15Z-7h84wFh2i-zS400MMzmx6kL3g>
    <xme:NoS7XyjZV5LMFt3H9OzIUp9ovn9i4M6_R7wTkPZ7pTOulVnw3KPM2W1BTlA0af16O
    cCtW3oCsbFiKg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudegiedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkeejgffftefgveeggeehudfgleehkedthedtiefhie
    elieetveejvdfgvdeljeelnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:NoS7Xzm-wRSbwzG4SNODHcG2HhecU7lPQERdJ_JsAa_DXwCi1BTd3Q>
    <xmx:NoS7X2yg1PbRpRLxCftHoKEPO5_J0__ciWYMZZqkLN8h6iwZV1qZew>
    <xmx:NoS7X1Qafej1QfyOOrW7E6lyeLl9vW9wbQEJXieOycstDVX4s_573A>
    <xmx:N4S7X0E2yioHHGNZ8qjlzPzm1fpzBaz9kchMIaR1ub5hgmfHzhGMqseg1Yo>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 620CA328005E;
        Mon, 23 Nov 2020 04:43:18 -0500 (EST)
Subject: FAILED: patch "[PATCH] ptrace: Set PF_SUPERPRIV when checking capability" failed to apply to 4.14-stable tree
To:     mic@linux.microsoft.com, christian.brauner@ubuntu.com,
        eparis@redhat.com, jannh@google.com, keescook@chromium.org,
        oleg@redhat.com, serge@hallyn.com, tyhicks@linux.microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Nov 2020 10:44:29 +0100
Message-ID: <1606124669198129@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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

From cf23705244c947151179f929774fabf71e239eee Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@linux.microsoft.com>
Date: Fri, 30 Oct 2020 13:38:48 +0100
Subject: [PATCH] ptrace: Set PF_SUPERPRIV when checking capability
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Commit 69f594a38967 ("ptrace: do not audit capability check when outputing
/proc/pid/stat") replaced the use of ns_capable() with
has_ns_capability{,_noaudit}() which doesn't set PF_SUPERPRIV.

Commit 6b3ad6649a4c ("ptrace: reintroduce usage of subjective credentials in
ptrace_has_cap()") replaced has_ns_capability{,_noaudit}() with
security_capable(), which doesn't set PF_SUPERPRIV neither.

Since commit 98f368e9e263 ("kernel: Add noaudit variant of ns_capable()"), a
new ns_capable_noaudit() helper is available.  Let's use it!

As a result, the signature of ptrace_has_cap() is restored to its original one.

Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Serge E. Hallyn <serge@hallyn.com>
Cc: Tyler Hicks <tyhicks@linux.microsoft.com>
Cc: stable@vger.kernel.org
Fixes: 6b3ad6649a4c ("ptrace: reintroduce usage of subjective credentials in ptrace_has_cap()")
Fixes: 69f594a38967 ("ptrace: do not audit capability check when outputing /proc/pid/stat")
Signed-off-by: Mickaël Salaün <mic@linux.microsoft.com>
Reviewed-by: Jann Horn <jannh@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20201030123849.770769-2-mic@digikod.net

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 43d6179508d6..79de1294f8eb 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -264,17 +264,11 @@ static int ptrace_check_attach(struct task_struct *child, bool ignore_state)
 	return ret;
 }
 
-static bool ptrace_has_cap(const struct cred *cred, struct user_namespace *ns,
-			   unsigned int mode)
+static bool ptrace_has_cap(struct user_namespace *ns, unsigned int mode)
 {
-	int ret;
-
 	if (mode & PTRACE_MODE_NOAUDIT)
-		ret = security_capable(cred, ns, CAP_SYS_PTRACE, CAP_OPT_NOAUDIT);
-	else
-		ret = security_capable(cred, ns, CAP_SYS_PTRACE, CAP_OPT_NONE);
-
-	return ret == 0;
+		return ns_capable_noaudit(ns, CAP_SYS_PTRACE);
+	return ns_capable(ns, CAP_SYS_PTRACE);
 }
 
 /* Returns 0 on success, -errno on denial. */
@@ -326,7 +320,7 @@ static int __ptrace_may_access(struct task_struct *task, unsigned int mode)
 	    gid_eq(caller_gid, tcred->sgid) &&
 	    gid_eq(caller_gid, tcred->gid))
 		goto ok;
-	if (ptrace_has_cap(cred, tcred->user_ns, mode))
+	if (ptrace_has_cap(tcred->user_ns, mode))
 		goto ok;
 	rcu_read_unlock();
 	return -EPERM;
@@ -345,7 +339,7 @@ static int __ptrace_may_access(struct task_struct *task, unsigned int mode)
 	mm = task->mm;
 	if (mm &&
 	    ((get_dumpable(mm) != SUID_DUMP_USER) &&
-	     !ptrace_has_cap(cred, mm->user_ns, mode)))
+	     !ptrace_has_cap(mm->user_ns, mode)))
 	    return -EPERM;
 
 	return security_ptrace_access_check(task, mode);

