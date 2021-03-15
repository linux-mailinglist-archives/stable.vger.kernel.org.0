Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A66833B0A2
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 12:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbhCOLHf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 07:07:35 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:47241 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229901AbhCOLHL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 07:07:11 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 3A7AD194094B;
        Mon, 15 Mar 2021 07:07:11 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 15 Mar 2021 07:07:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=1YpRMK
        BLT5bFvwy+tIvEUoxQCNzBTpaheGpz/XA0y/8=; b=tgjs1lgXPy4v374Wgz4LXS
        Qq776N5taVvLELmjghjlOsMrg0dlmkzQpPv2ql0eNPfIIbFV+UKignv3ozKz1L2c
        sz06qm2c234OyiOhvZeK4k+lYCmKyoWpb3J9dem0YaM27AStH3uWUyBS1rFx4HLJ
        bcz9BeOVTTMepNOvfq4hmebQBvjB7b1sntZsqsBaBVQQzwsDsnBcSCMFtu54JE73
        +EP11IM+szFOWLffha3i4WWniNgtmZF2pgHYYfV8Q5WqMUaeUc9TU6PBUhXC7F2z
        uCSHWp1F0t/9MbVATCH+19z6khaq7tzj9FsnWUFmvxWwZm+xnMjRZEljVULAqnbA
        ==
X-ME-Sender: <xms:3j9PYG10JRvtILNpiWksn4pe7mWodZVUF3NnFtyrUwuQVKy_8yNwvA>
    <xme:3j9PYLHrKoyo8JcAAp4mhK_toGyJYpy3548fyWrjLb29Tho1f_BCqSLqxLsc8-3nn
    Aua_PvMvTFiog>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvledgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:3j9PYIThqGu-KKX5T1hBwfGZHWsBdgTZ3vaQewI3CqydUnlZm1aN8A>
    <xmx:3j9PYKCSWZCvl6CtO83PRyH7TwgSXpp7S6aU_sCIy7MqxREjcwZKYQ>
    <xmx:3j9PYA0bCp1ngXNpvxi-9E3mmMCB-DowLwqczvKB9xAN0mp6vK0nfQ>
    <xmx:3z9PYFoI4J1W4mu3G5oICGUhEVQqCVbmwVJSU-tonZE1aspd_hmL8c7mTgE>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1C8DB1080054;
        Mon, 15 Mar 2021 07:07:10 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mm/madvise: replace ptrace attach requirement for" failed to apply to 5.10-stable tree
To:     surenb@google.com, akpm@linux-foundation.org, fweimer@redhat.com,
        jannh@google.com, jeffv@google.com, jmorris@namei.org,
        keescook@chromium.org, mhocko@suse.com, minchan@kernel.org,
        oleg@redhat.com, rientjes@google.com, shakeelb@google.com,
        stable@vger.kernel.org, timmurray@google.com,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Mar 2021 12:07:08 +0100
Message-ID: <1615806428159123@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 96cfe2c0fd23ea7c2368d14f769d287e7ae1082e Mon Sep 17 00:00:00 2001
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 12 Mar 2021 21:08:06 -0800
Subject: [PATCH] mm/madvise: replace ptrace attach requirement for
 process_madvise

process_madvise currently requires ptrace attach capability.
PTRACE_MODE_ATTACH gives one process complete control over another
process.  It effectively removes the security boundary between the two
processes (in one direction).  Granting ptrace attach capability even to a
system process is considered dangerous since it creates an attack surface.
This severely limits the usage of this API.

The operations process_madvise can perform do not affect the correctness
of the operation of the target process; they only affect where the data is
physically located (and therefore, how fast it can be accessed).  What we
want is the ability for one process to influence another process in order
to optimize performance across the entire system while leaving the
security boundary intact.

Replace PTRACE_MODE_ATTACH with a combination of PTRACE_MODE_READ and
CAP_SYS_NICE.  PTRACE_MODE_READ to prevent leaking ASLR metadata and
CAP_SYS_NICE for influencing process performance.

Link: https://lkml.kernel.org/r/20210303185807.2160264-1-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jeff Vander Stoep <jeffv@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tim Murray <timmurray@google.com>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: <stable@vger.kernel.org>	[5.10+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/madvise.c b/mm/madvise.c
index df692d2e35d4..01fef79ac761 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1198,12 +1198,22 @@ SYSCALL_DEFINE5(process_madvise, int, pidfd, const struct iovec __user *, vec,
 		goto release_task;
 	}
 
-	mm = mm_access(task, PTRACE_MODE_ATTACH_FSCREDS);
+	/* Require PTRACE_MODE_READ to avoid leaking ASLR metadata. */
+	mm = mm_access(task, PTRACE_MODE_READ_FSCREDS);
 	if (IS_ERR_OR_NULL(mm)) {
 		ret = IS_ERR(mm) ? PTR_ERR(mm) : -ESRCH;
 		goto release_task;
 	}
 
+	/*
+	 * Require CAP_SYS_NICE for influencing process performance. Note that
+	 * only non-destructive hints are currently supported.
+	 */
+	if (!capable(CAP_SYS_NICE)) {
+		ret = -EPERM;
+		goto release_mm;
+	}
+
 	total_len = iov_iter_count(&iter);
 
 	while (iov_iter_count(&iter)) {
@@ -1218,6 +1228,7 @@ SYSCALL_DEFINE5(process_madvise, int, pidfd, const struct iovec __user *, vec,
 	if (ret == 0)
 		ret = total_len - iov_iter_count(&iter);
 
+release_mm:
 	mmput(mm);
 release_task:
 	put_task_struct(task);

