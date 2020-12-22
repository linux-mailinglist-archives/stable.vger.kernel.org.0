Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C582D2E0E3C
	for <lists+stable@lfdr.de>; Tue, 22 Dec 2020 19:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgLVSbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 13:31:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgLVSbX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Dec 2020 13:31:23 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E91C0613D6
        for <stable@vger.kernel.org>; Tue, 22 Dec 2020 10:30:42 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id 75so12785108ilv.13
        for <stable@vger.kernel.org>; Tue, 22 Dec 2020 10:30:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=2/91dbxcc8vjfFczLbnffexa0oogy+Nlat6FcAAxiKE=;
        b=k8+J1Xh03Vy0Zpqimx3ivXxIaRfuw00eKPTDw1vF0sVhuKz13AepLp4Ns4vA44mCCW
         g77cyTV7YoHCr61qWC7vcaHtOwHtJlNlLRFQSqoFaAjhgVyQK6L6FD8cTn1eBQDLovzn
         WW9DFcJ16vywwncwlaCEJWg1kTECRDNbVYUCLPWPwq71Zy2dQejspHyJB7JfPz6fAhGl
         kG6Di9Q2K8If7+3pKVLhYFRzjd9D6GqfgCHv4sF/uy+ZA4ms+3oR9dPEUUeyma1jFzc1
         2Zexq7UdNM0kMYmNaQ2kaZY4VZKcO3OIU2J1we/48pJh50E3A8G5BhgXrufMLytRQw2F
         NmvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=2/91dbxcc8vjfFczLbnffexa0oogy+Nlat6FcAAxiKE=;
        b=qhSsf+oyZXHtwDdI1sXkj29Hzx7VhjDQqK1HsWkbihutrMu3vi43E7fS6BDTZxDGeJ
         FzIqNGw7WwQgwxD6SwzWCZ1u4mSv6/9OrPUK3Jdz6WDkwNCiaZZuRanpElGCzdpVxUye
         mH/ntt+qjzUs527V4l/uhqD1Svv/wPOZLqFI9qBFiyAzeELmQ8wseCcmPkxIsoKaU+pp
         Y0AW8fJ78MCUtpMkuI7zv9d9+Wv6FzqXMNQkiorFFrcednPyaPdN6qmOv4REe1zVglZ/
         VRLW/Sl4jUF25wxDxl/EEoSqXdO3XZONIcZGJe/Or9lkhR/8HB4D+oxIUJNsx4cgwTZx
         MwsQ==
X-Gm-Message-State: AOAM530lbjQctuiFIf8MSzhZ2jnIsQL+mo5+NlEvan4OyA50C33xh8n+
        /9/sEaKq7RU+MCIIR2+5JKb5Mw==
X-Google-Smtp-Source: ABdhPJz2iQ/q85zYmOOvFgtHRoG8/tOM89MswWR+0F+w4sHO+r2ZNQ873gc1H6TgLrU4X7omsXjP9g==
X-Received: by 2002:a05:6e02:152f:: with SMTP id i15mr21837403ilu.104.1608661842045;
        Tue, 22 Dec 2020 10:30:42 -0800 (PST)
Received: from google.com ([2620:15c:183:200:7220:84ff:fe09:2d90])
        by smtp.gmail.com with ESMTPSA id t22sm16453414ill.35.2020.12.22.10.30.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 10:30:41 -0800 (PST)
Date:   Tue, 22 Dec 2020 11:30:37 -0700
From:   Yu Zhao <yuzhao@google.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Minchan Kim <minchan@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Message-ID: <X+I7TcwMsiS1Bhy/@google.com>
References: <X97pprdcRXusLGnq@google.com>
 <DDA15360-D6D4-46A8-95A4-5EE34107A407@gmail.com>
 <20201221172711.GE6640@xz-x1>
 <76B4F49B-ED61-47EA-9BE4-7F17A26B610D@gmail.com>
 <X+D0hTZCrWS3P5Pi@google.com>
 <CAHk-=wg_UBuo7ro1fpEGkMyFKA1+PxrE85f9J_AhUfr-nJPpLQ@mail.gmail.com>
 <9E301C7C-882A-4E0F-8D6D-1170E792065A@gmail.com>
 <CAHk-=wg-Y+svNy3CDkJjj0X_CJkSbpERLg64-Vqwq5u7SC4z0g@mail.gmail.com>
 <X+ESkna2z3WjjniN@google.com>
 <D4916F41-DE4A-42C6-8702-944382631A02@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <D4916F41-DE4A-42C6-8702-944382631A02@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 22, 2020 at 04:40:32AM -0800, Nadav Amit wrote:
> > On Dec 21, 2020, at 1:24 PM, Yu Zhao <yuzhao@google.com> wrote:
> > 
> > On Mon, Dec 21, 2020 at 12:26:22PM -0800, Linus Torvalds wrote:
> >> On Mon, Dec 21, 2020 at 12:23 PM Nadav Amit <nadav.amit@gmail.com> wrote:
> >>> Using mmap_write_lock() was my initial fix and there was a strong pushback
> >>> on this approach due to its potential impact on performance.
> >> 
> >> From whom?
> >> 
> >> Somebody who doesn't understand that correctness is more important
> >> than performance? And that userfaultfd is not the most important part
> >> of the system?
> >> 
> >> The fact is, userfaultfd is CLEARLY BUGGY.
> >> 
> >>          Linus
> > 
> > Fair enough.
> > 
> > Nadav, for your patch (you might want to update the commit message).
> > 
> > Reviewed-by: Yu Zhao <yuzhao@google.com>
> > 
> > While we are all here, there is also clear_soft_dirty() that could
> > use a similar fix…
> 
> Just an update as for why I have still not sent v2: I fixed
> clear_soft_dirty(), created a reproducer, and the reproducer kept failing.
> 
> So after some debugging, it appears that clear_refs_write() does not flush
> the TLB. It indeed calls tlb_finish_mmu() but since 0758cd830494
> ("asm-generic/tlb: avoid potential double flush”), tlb_finish_mmu() does not
> flush the TLB since there is clear_refs_write() does not call to
> __tlb_adjust_range() (unless there are nested TLBs are pending).

Sorry Nadav, I assumed you knew this existing problem fixed by:
https://patchwork.kernel.org/project/linux-mm/cover/20201210121110.10094-1-will@kernel.org/

> So I have a patch for this issue too: arguably the tlb_gather interface is
> not the right one for clear_refs_write() that does not clear PTEs but
> changes them.
> 
> Yet, sadly, my reproducer keeps falling (less frequently, but still). So I
> will keep debugging to see what goes wrong. I will send v2 once I figure out
> what the heck is wrong in the code or my reproducer.
> 
> For the reference, here is my reproducer:

Thanks. This would be helpful in case any other breakages happen in the
future.

> -- >8 --
> 
> #define _GNU_SOURCE
> #include <sys/types.h>
> #include <sys/stat.h>
> #include <sys/mman.h>
> #include <unistd.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <assert.h>
> #include <fcntl.h>
> #include <string.h>
> #include <threads.h>
> #include <stdatomic.h>
> 
> #define PAGE_SIZE	(4096)
> #define TLB_SIZE	(2000)
> #define N_PAGES		(300000)
> #define ITERATIONS	(100)
> #define N_THREADS	(2)
> 
> static int stop;
> static char *m;
> 
> static int writer(void *argp)
> {
> 	unsigned long t_idx = (unsigned long)argp;
> 	int i, cnt = 0;
> 
> 	while (!atomic_load(&stop)) {
> 		cnt++;
> 		atomic_fetch_add((atomic_int *)m, 1);
> 
> 		/*
> 		 * First thread only accesses the page to have it cached in the
> 		 * TLB.
> 		 */
> 		if (t_idx == 0)
> 			continue;
> 
> 		/*
> 		 * Other threads access enough entries to cause eviction from
> 		 * the TLB and trigger #PF upon the next access (before the TLB
> 		 * flush of clear_ref actually takes place).
> 		 */
> 		for (i = 1; i < TLB_SIZE; i++) {
> 			if (atomic_load((atomic_int *)(m + PAGE_SIZE * i))) {
> 				fprintf(stderr, "unexpected error\n");
> 				exit(1);
> 			}
> 		}
> 	}
> 	return cnt;
> }
> 
> /*
>  * Runs mlock/munlock in the background to raise the page-count of the page and
>  * force copying instead of reusing the page.
>  */
> static int do_mlock(void *argp)
> {
> 	while (!atomic_load(&stop)) {
> 		if (mlock(m, PAGE_SIZE) || munlock(m, PAGE_SIZE)) {
> 			perror("mlock/munlock");
> 			exit(1);
> 		}
> 	}
> 	return 0;
> }
> 
> int main(void)
> {
> 	int r, cnt, fd, total = 0;
> 	long i;
> 	thrd_t thr[N_THREADS];
> 	thrd_t mlock_thr[N_THREADS];
> 
> 	fd = open("/proc/self/clear_refs", O_WRONLY, 0666);
> 	if (fd < 0) {
> 		perror("open");
> 		exit(1);
> 	}
> 
> 	/*
> 	 * Have large memory for clear_ref, so there would be some time between
> 	 * the unmap and the actual deferred flush.
> 	 */
> 	m = mmap(NULL, PAGE_SIZE * N_PAGES, PROT_READ|PROT_WRITE,
> 			MAP_PRIVATE|MAP_ANONYMOUS|MAP_POPULATE, -1, 0);
> 	if (m == MAP_FAILED) {
> 		perror("mmap");
> 		exit(1);
> 	}
> 
> 	for (i = 0; i < N_THREADS; i++) {
> 		r = thrd_create(&thr[i], writer, (void *)i);
> 		assert(r == thrd_success);
> 	}
> 
> 	for (i = 0; i < N_THREADS; i++) {
> 		r = thrd_create(&mlock_thr[i], do_mlock, (void *)i);
> 		assert(r == thrd_success);
> 	}
> 
> 	for (i = 0; i < ITERATIONS; i++) {
> 		for (i = 0; i < ITERATIONS; i++) {
> 			r = pwrite(fd, "4", 1, 0);
> 			if (r < 0) {
> 				perror("pwrite");
> 				exit(1);
> 			}
> 		}
> 	}
> 
> 	atomic_store(&stop, 1);
> 
> 	for (i = 0; i < N_THREADS; i++) {
> 		r = thrd_join(mlock_thr[i], NULL);
> 		assert(r == thrd_success);
> 	}
> 
> 	for (i = 0; i < N_THREADS; i++) {
> 		r = thrd_join(thr[i], &cnt);
> 		assert(r == thrd_success);
> 		total += cnt;
> 	}
> 
> 	r = atomic_load((atomic_int *)(m));
> 	if (r != total) {
> 		fprintf(stderr, "failed - expected=%d actual=%d\n", total, r);
> 		exit(-1);
> 	}
> 
> 	fprintf(stderr, "ok\n");
> 	return 0;
> }
