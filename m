Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF912F9026
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 03:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbhAQCML (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Jan 2021 21:12:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:41710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727888AbhAQCML (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Jan 2021 21:12:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62D0022D5A;
        Sun, 17 Jan 2021 02:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610849466;
        bh=WqSNkc457cUzVFmSvSDLfcpcisjUoMEl0tJwGfQzTy4=;
        h=Date:From:To:Subject:From;
        b=jWSPF4dXb8XaR0DpNkfTeb8++DACNjJmqo12iIL6LEijUMx0ZQbUoGz+ipJvJNYau
         ponFq2F7BwlrZHmYGvS4FzbwJyCCI1tYfbMWYPYvW6VuWWakt0f2hiQgvaBj9kE8hw
         TwQvqCbLTHnMn/0qqD09oM+zfbOUKpm+rDC0D+ik=
Date:   Sat, 16 Jan 2021 18:11:06 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, axboe@kernel.dk, hch@lst.de,
        me@kylehuey.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, viro@zeniv.linux.org.uk
Subject:  [merged] mm-process_vm_accessc-include-compath.patch
 removed from -mm tree
Message-ID: <20210117021106.BfaXbX7b2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/process_vm_access.c: include compat.h
has been removed from the -mm tree.  Its filename was
     mm-process_vm_accessc-include-compath.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/process_vm_access.c: include compat.h

mm/process_vm_access.c:277:5: error: implicit declaration of function 'in_compat_syscall'; did you mean 'in_ia32_syscall'? [-Werror=implicit-function-declaration]

Fixes: 38dc5079da7081e "Fix compat regression in process_vm_rw()"
Reported-by: syzbot+5b0d0de84d6c65b8dd2b@syzkaller.appspotmail.com
Cc: Kyle Huey <me@kylehuey.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/process_vm_access.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/process_vm_access.c~mm-process_vm_accessc-include-compath
+++ a/mm/process_vm_access.c
@@ -9,6 +9,7 @@
 #include <linux/mm.h>
 #include <linux/uio.h>
 #include <linux/sched.h>
+#include <linux/compat.h>
 #include <linux/sched/mm.h>
 #include <linux/highmem.h>
 #include <linux/ptrace.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account-fix.patch
mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fixes.patch
mm-memcg-add-swapcache-stat-for-memcg-v2-fix.patch
kasan-fix-bug-detection-via-ksize-for-hw_tags-mode-fix.patch
mm-compaction-return-proper-state-in-should_proactive_compact_node-fix.patch
mm-cma-allocate-cma-areas-bottom-up-fix-3-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

