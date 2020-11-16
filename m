Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD602B4E94
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 18:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388174AbgKPRx1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 12:53:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732758AbgKPRx0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 12:53:26 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D913FC0613CF;
        Mon, 16 Nov 2020 09:53:26 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id w6so14883861pfu.1;
        Mon, 16 Nov 2020 09:53:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GbPGYJN0fMY0z7n6XRrmAYO8MuLCIdhGDwcy5dtKtqQ=;
        b=Nw8G/i8GfhKmDS8JU6LlrD6htHjtzPQdSwefD+Rp1qLWqjp3I23WSTOwRQFgpAihBa
         FnvytZ64iTcHp+siXu+euGIp1v3joocTQVqBcR5J9iIOibjy4UO5rV0SwqLtBWUbcHpg
         8VhMABte6rNiT000T1cYXb5YWPuVZKVbof+RR5w8uHMPVmAESDw8M+wDGA5bZFcMruX4
         C0BEt5wxKcyrWf1cnFdZY6dWmwR/0PP7jGDHQEdoIezLZ1IbF2+t3cZSyYfz7qzpWuwW
         kBubCvdMn91K0Rdt+fXwF+7KvoyOr0C/xPdn2qCwru6ciGxpF+tx2+pGCdSdfmT+Ihh0
         B9Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=GbPGYJN0fMY0z7n6XRrmAYO8MuLCIdhGDwcy5dtKtqQ=;
        b=sPaSkcWEpHnJ4RM/i7WqwG4HO7v1q6R1IzGT6zIotJS7Vb6gdPS7UP8C9FSvUnY8If
         FAT7aInW+cqQo3/HyAv5NCwuTQ7Drf7HD7z7iBHxqI/eVgqBXGzyu7QMYS3Pi81PfGrc
         G/bSgwty2Fj5+JAjIb4wmqBAIgKfQmFwwPJLYmCTgUH4Sk3OM4r+UYRFkquSPszTXY08
         uIs/LZlCHtGwROqjvDzPIbFq5tyAYcLNNklJgFdFxCY7RoxhRd35+yYRxuyoK2mnyg18
         ea9SACb5tGugWAj44NPrkmZ5M3Qc0ue0CKqtsC7E6EW6bmVg/pfX1JhyJZJtsrrUdX+h
         dlxQ==
X-Gm-Message-State: AOAM532TatF48hQLnmfNoP6vg8AyIkINVVwHvLCbEYs/gZP5VLv6m+aE
        xz0W13bumJd4kLppCAPORJoUcZoIOr0=
X-Google-Smtp-Source: ABdhPJxGigBheTwqLlRs6rH6tGYgv4T9xx3E1AOLB9Uef+pN/BHK93BDZbU3ZxFInGKEiGzWp8ywxg==
X-Received: by 2002:a17:90a:df93:: with SMTP id p19mr68876pjv.170.1605549206339;
        Mon, 16 Nov 2020 09:53:26 -0800 (PST)
Received: from google.com ([2620:15c:211:201:7220:84ff:fe09:5e58])
        by smtp.gmail.com with ESMTPSA id u197sm19260345pfc.127.2020.11.16.09.53.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 09:53:25 -0800 (PST)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date:   Mon, 16 Nov 2020 09:53:23 -0800
From:   Minchan Kim <minchan@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Harish Sriram <harish@linux.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH] Revert "mm/vunmap: add cond_resched() in
 vunmap_pmd_range"
Message-ID: <20201116175323.GB3805951@google.com>
References: <20201105170249.387069-1-minchan@kernel.org>
 <20201106175933.90e4c8851010c9ce4dd732b6@linux-foundation.org>
 <20201107083939.GA1633068@google.com>
 <20201112200101.GC123036@google.com>
 <20201112144919.5f6b36876f4e59ebb4a99d6d@linux-foundation.org>
 <20201113162529.GA2378542@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113162529.GA2378542@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 13, 2020 at 08:25:29AM -0800, Minchan Kim wrote:
> On Thu, Nov 12, 2020 at 02:49:19PM -0800, Andrew Morton wrote:
> > On Thu, 12 Nov 2020 12:01:01 -0800 Minchan Kim <minchan@kernel.org> wrote:
> > 
> > > 
> > > On Sat, Nov 07, 2020 at 12:39:39AM -0800, Minchan Kim wrote:
> > > > Hi Andrew,
> > > > 
> > > > On Fri, Nov 06, 2020 at 05:59:33PM -0800, Andrew Morton wrote:
> > > > > On Thu,  5 Nov 2020 09:02:49 -0800 Minchan Kim <minchan@kernel.org> wrote:
> > > > > 
> > > > > > This reverts commit e47110e90584a22e9980510b00d0dfad3a83354e.
> > > > > > 
> > > > > > While I was doing zram testing, I found sometimes decompression failed
> > > > > > since the compression buffer was corrupted. With investigation,
> > > > > > I found below commit calls cond_resched unconditionally so it could
> > > > > > make a problem in atomic context if the task is reschedule.
> > > > > > 
> > > > > > Revert the original commit for now.
> > >
> > > How should we proceed this problem?
> > >
> > 
> > (top-posting repaired - please don't).
> > 
> > Well, we don't want to reintroduce the softlockup reports which
> > e47110e90584a2 fixed, and we certainly don't want to do that on behalf
> > of code which is using the unmap_kernel_range() interface incorrectly.
> > 
> > So I suggest either
> > 
> > a) make zs_unmap_object() stop doing the unmapping from atomic context or
> 
> It's not easy since the path already hold several spin_locks as well as
> per-cpu context. I could pursuit the direction but it takes several
> steps to change entire locking scheme in the zsmalloc, which will
> take time(we couldn't leave zsmalloc broken until then) and hard to
> land on stable tree.
> 
> > 
> > b) figure out whether the vmalloc unmap code is *truly* unsafe from
> >    atomic context - perhaps it is only unsafe from interrupt context,
> >    in which case we can rework the vmalloc.c checks to reflect this, or
> 
> I don't get the point. I assume your suggestion would be "let's make the
> vunmap code atomic context safe" but how could it solve this problem?
>      
> The point from e47110e90584a2 was softlockup could be triggered if
> vunamp deal with large mapping so need *explict reschedule* point
> for CONFIG_PREEMPT_VOLUNTARY. However, CONFIG_PREEMPT_VOLUNTARY
> doesn't consider peempt count so even though we could make vunamp
> atomic safe to make a call under spin_lock:
> 
> spin_lock(&A);
> vunmap
>   vunmap_pmd_range
>     cond_resched <- bang
>  
> Below options would have same problem, too.
> Let me know if I misunderstand something.
> 
> > 
> > c) make the vfree code callable from all contexts.  Which is by far
> >    the preferred solution, but may be tough.
> > 
> > 
> > Or maybe not so tough - if the only problem in the vmalloc code is the
> > use of mutex_trylock() from irqs then it may be as simple as switching
> > to old-style semaphores and using down_trylock(), which I think is
> > irq-safe.
> > 
> > However old-style semaphores are deprecated.  A hackyish approach might
> > be to use an rwsem always in down_write mode and use
> > down_write_trylock(), which I think is also callable from interrrupt
> > context.
> > 
> > But I have a feeling that there are other reasons why vfree shouldn't
> > be called from atomic context, apart from the mutex_trylock-in-irq
> > issue.

How about this?

From 0733bc468d0072147c2ecf998d7cc3af2234bc87 Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan@kernel.org>
Date: Mon, 16 Nov 2020 09:38:40 -0800
Subject: [PATCH] mm: unmap_kernel_range_atomic

unmap_kernel_range had been atomic operation and zsmalloc has used
it in atomic context in zs_unmap_object.
However, ("e47110e90584, mm/vunmap: add cond_resched() in vunmap_pmd_range")
changed it into non-atomic operation via adding cond_resched.
It causes zram decompresion failure by corrupting compressed buffer
in atomic context.

This patch introduces unmap_kernel_range_atomic which works for
only range less than PMD_SIZE to prevent cond_resched call.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 include/linux/vmalloc.h |  2 ++
 mm/vmalloc.c            | 23 +++++++++++++++++++++--
 mm/zsmalloc.c           |  2 +-
 3 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 938eaf9517e2..36b1ecc2d014 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -180,6 +180,7 @@ int map_kernel_range(unsigned long start, unsigned long size, pgprot_t prot,
 		struct page **pages);
 extern void unmap_kernel_range_noflush(unsigned long addr, unsigned long size);
 extern void unmap_kernel_range(unsigned long addr, unsigned long size);
+extern void unmap_kernel_range_atomic(unsigned long addr, unsigned long size);
 static inline void set_vm_flush_reset_perms(void *addr)
 {
 	struct vm_struct *vm = find_vm_area(addr);
@@ -200,6 +201,7 @@ unmap_kernel_range_noflush(unsigned long addr, unsigned long size)
 {
 }
 #define unmap_kernel_range unmap_kernel_range_noflush
+#define unmap_kernel_range_atomic unmap_kernel_range_noflush
 static inline void set_vm_flush_reset_perms(void *addr)
 {
 }
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index d7075ad340aa..714e5425dc45 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -88,6 +88,7 @@ static void vunmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
 	pmd_t *pmd;
 	unsigned long next;
 	int cleared;
+	bool check_resched = (end - addr) > PMD_SIZE;
 
 	pmd = pmd_offset(pud, addr);
 	do {
@@ -102,8 +103,8 @@ static void vunmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
 		if (pmd_none_or_clear_bad(pmd))
 			continue;
 		vunmap_pte_range(pmd, addr, next, mask);
-
-		cond_resched();
+		if (check_resched)
+			cond_resched();
 	} while (pmd++, addr = next, addr != end);
 }
 
@@ -2024,6 +2025,24 @@ void unmap_kernel_range(unsigned long addr, unsigned long size)
 	flush_tlb_kernel_range(addr, end);
 }
 
+/**
+ * unmap_kernel_range_atomic - unmap kernel VM area and flush cache and TLB
+ * @addr: start of the VM area to unmap
+ * @size: size of the VM area to unmap
+ *
+ * Similar to unmap_kernel_range_noflush() but it's atomic. @size should be
+ * less than PMD_SIZE.
+ */
+void unmap_kernel_range_atomic(unsigned long addr, unsigned long size)
+{
+	unsigned long end = addr + size;
+
+	flush_cache_vunmap(addr, end);
+	WARN_ON(size > PMD_SIZE);
+	unmap_kernel_range_noflush(addr, size);
+	flush_tlb_kernel_range(addr, end);
+}
+
 static inline void setup_vmalloc_vm_locked(struct vm_struct *vm,
 	struct vmap_area *va, unsigned long flags, const void *caller)
 {
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 662ee420706f..9decc7634852 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1154,7 +1154,7 @@ static inline void __zs_unmap_object(struct mapping_area *area,
 {
 	unsigned long addr = (unsigned long)area->vm_addr;
 
-	unmap_kernel_range(addr, PAGE_SIZE * 2);
+	unmap_kernel_range_atomic(addr, PAGE_SIZE * 2);
 }
 
 #else /* CONFIG_ZSMALLOC_PGTABLE_MAPPING */
-- 
2.29.2.299.gdc1121823c-goog

