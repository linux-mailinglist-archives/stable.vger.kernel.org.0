Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34FF75F494E
	for <lists+stable@lfdr.de>; Tue,  4 Oct 2022 20:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiJDSem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 14:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbiJDSel (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 14:34:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B4DBE1E;
        Tue,  4 Oct 2022 11:34:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F582B81BAD;
        Tue,  4 Oct 2022 18:34:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BF95C433D7;
        Tue,  4 Oct 2022 18:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664908477;
        bh=agXX+4U0DVERNNIuB6+6gikiu5DNE4D0C0fBvIlp8dg=;
        h=Date:To:From:Subject:From;
        b=sBa5BA5+7U9ceyIo+GwLdo8fk+WqoqsSvZyR0hRSBhCJCVpa4u7PwmgB3SP7C1aPO
         h41IDpXWg05N+H15DXQhXVL+KJR+aHwzUCK+RTVgvw2oz26BkN5toD5I8DjE7+RAyP
         O2XJDro6XjO5Xwh+LJQeSupp5DYC9hGg2XRcp2P8=
Date:   Tue, 04 Oct 2022 11:34:36 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, stable@vger.kernel.org,
        jannh@google.com, adobriyan@gmail.com, sethjenkins@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-proc-pid-smaps_rollup-fix-no-vmas-null-deref.patch added to mm-hotfixes-unstable branch
Message-Id: <20221004183437.3BF95C433D7@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: /proc/pid/smaps_rollup: fix no vma's null-deref
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-proc-pid-smaps_rollup-fix-no-vmas-null-deref.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-proc-pid-smaps_rollup-fix-no-vmas-null-deref.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Seth Jenkins <sethjenkins@google.com>
Subject: mm: /proc/pid/smaps_rollup: fix no vma's null-deref
Date: Mon, 3 Oct 2022 18:45:31 -0400

Commit 258f669e7e88 ("mm: /proc/pid/smaps_rollup: convert to single value
seq_file") introduced a null-deref if there are no vma's in the task in
show_smaps_rollup.

Link: https://lkml.kernel.org/r/20221003224531.1930646-1-sethjenkins@google.com
Fixes: 258f669e7e88 ("mm: /proc/pid/smaps_rollup: convert to single value seq_file")
Signed-off-by: Seth Jenkins <sethjenkins@google.com>
Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
Tested-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jann Horn <jannh@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c~mm-proc-pid-smaps_rollup-fix-no-vmas-null-deref
+++ a/fs/proc/task_mmu.c
@@ -969,7 +969,7 @@ static int show_smaps_rollup(struct seq_
 		vma = vma->vm_next;
 	}
 
-	show_vma_header_prefix(m, priv->mm->mmap->vm_start,
+	show_vma_header_prefix(m, priv->mm->mmap ? priv->mm->mmap->vm_start : 0,
 			       last_vma_end, 0, 0, 0, 0);
 	seq_pad(m, ' ');
 	seq_puts(m, "[rollup]\n");
_

Patches currently in -mm which might be from sethjenkins@google.com are

mm-proc-pid-smaps_rollup-fix-no-vmas-null-deref.patch

