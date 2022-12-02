Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0887064091B
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 16:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbiLBPPP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 10:15:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232265AbiLBPPE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 10:15:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999546D7DD
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 07:14:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669994045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ahQ65RRmP8j5XsQcDv9WbM62Muh/lrt7zDJJlU3D5Bo=;
        b=OQJDM14UyuumSLciCuqDR8+QHz4Dm2T9XjTsTQpOaro4cvjWtZu1srHCQwWTSqZ4E+0iTr
        tjhrX2iOeUHiimXsN/t/a/4tYwYRTzBCx+bNgp+oVkQrChXGn1DmKlseMjcT++8/CIomoe
        eTen80q9Wlu9rJQriORHPt8SR6zbgXY=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-590-lchwHvgxOR6JskBs5OVq1Q-1; Fri, 02 Dec 2022 10:14:04 -0500
X-MC-Unique: lchwHvgxOR6JskBs5OVq1Q-1
Received: by mail-qt1-f199.google.com with SMTP id cj6-20020a05622a258600b003a519d02f59so17874429qtb.5
        for <stable@vger.kernel.org>; Fri, 02 Dec 2022 07:14:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ahQ65RRmP8j5XsQcDv9WbM62Muh/lrt7zDJJlU3D5Bo=;
        b=hdjDdiyChBWeUecv2xasu0F2fmJdKZP5eyjyCd97hxvlJJkUNqK/GJ7Iw4+Uapz7Bn
         QkeE5C7LnvVbHaKWzhvMK3EycLiMlFx8v/fgMqHOQdq6/t0EIENQxjDk3n+GCcCW/Nm8
         VIRsTNuz3Q1ePMtSWNMYqsHDrBU4MEWa/MlvhgK5WJEyvDpwCxLD2DE5HivOhLcO/1xx
         dw+VB9foW+lF9RJ9syNPokc15wPQIrC1DwITcBP3/qPNgMiO9PsuFraIrkx9P6MJdH4q
         R9zwvLIvk+44rIDQlU7iPHc1jVFy6/Pa3XNrHxMRwPzGCbP2dOoaWWcPFqNJ7dXDxHsa
         86+g==
X-Gm-Message-State: ANoB5pn3ZptwWCsjIyPKvzyp7IsQZE+e/d7CsNobwsER1XGxMIAL0pry
        aCPMZW3JdLSZQvg4CJ/oyCPbUJQUJ4OKZ9fpt1ZtgIPTF6ia7hRi74z73RpgJCo7rBiYPxcrvkf
        GJw8R2uo9qojITDuP
X-Received: by 2002:a05:620a:4eb:b0:6fa:4d19:2419 with SMTP id b11-20020a05620a04eb00b006fa4d192419mr50852257qkh.61.1669994044261;
        Fri, 02 Dec 2022 07:14:04 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5FF1pskZWE9dalQ9sJf17+xlWPRCU9XXWbrDM3qWCXQGYi6Kdf1YSkh3DemfGUs8F6PP+8wQ==
X-Received: by 2002:a05:620a:4eb:b0:6fa:4d19:2419 with SMTP id b11-20020a05620a04eb00b006fa4d192419mr50852226qkh.61.1669994043900;
        Fri, 02 Dec 2022 07:14:03 -0800 (PST)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id i13-20020ac84f4d000000b0039492d503cdsm4296805qtw.51.2022.12.02.07.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 07:14:03 -0800 (PST)
Date:   Fri, 2 Dec 2022 10:14:02 -0500
From:   Peter Xu <peterx@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Ives van Hoorne <ives@codesandbox.io>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Alistair Popple <apopple@nvidia.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] mm/migrate: Fix read-only page got writable when
 recover pte
Message-ID: <Y4oWOqgqmv1BFAFx@x1n>
References: <20221114000447.1681003-1-peterx@redhat.com>
 <20221114000447.1681003-2-peterx@redhat.com>
 <5ddf1310-b49f-6e66-a22a-6de361602558@redhat.com>
 <20221130142425.6a7fdfa3e5954f3c305a77ee@linux-foundation.org>
 <Y4jIHureiOd8XjDX@x1n>
 <a215fe2f-ef9b-1a15-f1c2-2f0bb5d5f490@redhat.com>
 <20221201143058.80296541cc6802d1e5990033@linux-foundation.org>
 <fc3e3497-053d-8e50-a504-764317b6a49a@redhat.com>
 <222fc0b2-6ec0-98e7-833f-ea868b248446@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <222fc0b2-6ec0-98e7-833f-ea868b248446@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 02, 2022 at 01:07:02PM +0100, David Hildenbrand wrote:
> On 02.12.22 12:03, David Hildenbrand wrote:
> > On 01.12.22 23:30, Andrew Morton wrote:
> > > On Thu, 1 Dec 2022 16:42:52 +0100 David Hildenbrand <david@redhat.com> wrote:
> > > 
> > > > On 01.12.22 16:28, Peter Xu wrote:
> > > > > 
> > > > > I didn't reply here because I have already replied with the question in
> > > > > previous version with a few attempts.  Quotting myself:
> > > > > 
> > > > > https://lore.kernel.org/all/Y3KgYeMTdTM0FN5W@x1n/
> > > > > 
> > > > >            The thing is recovering the pte into its original form is the
> > > > >            safest approach to me, so I think we need justification on why it's
> > > > >            always safe to set the write bit.
> > > > > 
> > > > > I've also got another longer email trying to explain why I think it's the
> > > > > other way round to be justfied, rather than justifying removal of the write
> > > > > bit for a read migration entry, here:
> > > > > 
> > > > 
> > > > And I disagree for this patch that is supposed to fix this hunk:
> > > > 
> > > > 
> > > > @@ -243,11 +243,15 @@ static bool remove_migration_pte(struct page *page, struct vm_area_struct *vma,
> > > >                    entry = pte_to_swp_entry(*pvmw.pte);
> > > >                    if (is_write_migration_entry(entry))
> > > >                            pte = maybe_mkwrite(pte, vma);
> > > > +               else if (pte_swp_uffd_wp(*pvmw.pte))
> > > > +                       pte = pte_mkuffd_wp(pte);
> > > >                    if (unlikely(is_zone_device_page(new))) {
> > > >                            if (is_device_private_page(new)) {
> > > >                                    entry = make_device_private_entry(new, pte_write(pte));
> > > >                                    pte = swp_entry_to_pte(entry);
> > > > +                               if (pte_swp_uffd_wp(*pvmw.pte))
> > > > +                                       pte = pte_mkuffd_wp(pte);
> > > >                            }
> > > >                    }
> > > 
> > > David, I'm unclear on what you mean by the above.  Can you please
> > > expand?
> > > 
> > > > 
> > > > There is really nothing to justify the other way around here.
> > > > If it's broken fix it independently and properly backport it independenty.
> > > > 
> > > > But we don't know about any such broken case.
> > > > 
> > > > I have no energy to spare to argue further ;)
> > > 
> > > This is a silent data loss bug, which is about as bad as it gets.
> > > Under obscure conditions, fortunately.  But please let's keep working
> > > it.  Let's aim for something minimal for backporting purposes.  We can
> > > revisit any cleanliness issues later.
> > 
> > Okay, you activated my energy reserves.
> > 
> > > 
> > > David, do you feel that the proposed fix will at least address the bug
> > > without adverse side-effects?
> > 
> > Usually, when I suspect something is dodgy I unconsciously push back
> > harder than I usually would.

Please consider using unconsciousness only for self guidance, figuring out
directions, or making decisions on one's own.

For discussions on the list which can get more than one person involved, we
do need consciousness and reasonings.

Thanks for the reproducer, that's definitely good reasonings.  Do you have
other reproducer that can trigger an issue without mprotect()?

As I probably mentioned before in other threads mprotect() is IMHO
conceptually against uffd-wp and I don't yet figured out how to use them
all right.  For example, we can uffd-wr-protect a pte in uffd-wp range,
then if we do "mprotect(RW)" it's hard to tell whether the user wants it
write or not.  E.g., using mprotect(RW) to resolve page faults should be
wrong because it'll not touch the uffd-wp bit at all.  I confess I never
thought more on how we should define the interactions between uffd-wp and
mprotect.

In short, it'll be great if you have other reproducers for any uffd-wp
issues other than mprotect().

I said that also because I just got another message from Ives privately
that there _seems_ to have yet another even harder to reproduce bug here
(Ives, feel free to fill in any more information if you got it).  So if you
can figure out what's missing and already write a reproducer, that'll be
perfect.

Thanks,

> > 
> > I just looked into the issue once again and realized that this patch
> > here (and also my alternative proposal) most likely tackles the
> > more-generic issue from the wrong direction. I found yet another such
> > bug (most probably two, just too lazy to write another reproducer).
> > Migration code does the right thing here -- IMHO -- and the issue should
> > be fixed differently.
> > 
> > I'm testing an alternative patch right now and will share it later
> > today, along with a reproducer.
> > 
> 
> mprotect() reproducer attached.
> 
> -- 
> Thanks,
> 
> David / dhildenb

> #define _GNU_SOURCE
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <fcntl.h>
> #include <unistd.h>
> #include <errno.h>
> #include <poll.h>
> #include <pthread.h>
> #include <sys/mman.h>
> #include <sys/syscall.h>
> #include <sys/ioctl.h>
> #include <linux/memfd.h>
> #include <linux/userfaultfd.h>
> 
> size_t pagesize;
> int uffd;
> 
> static void *uffd_thread_fn(void *arg)
> {
> 	static struct uffd_msg msg;
> 	ssize_t nread;
> 
> 	while (1) {
> 		struct pollfd pollfd;
> 		int nready;
> 
> 		pollfd.fd = uffd;
> 		pollfd.events = POLLIN;
> 		nready = poll(&pollfd, 1, -1);
> 		if (nready == -1) {
> 			fprintf(stderr, "poll() failed: %d\n", errno);
> 			exit(1);
> 		}
> 
> 		nread = read(uffd, &msg, sizeof(msg));
> 		if (nread <= 0)
> 			continue;
> 
> 		if (msg.event != UFFD_EVENT_PAGEFAULT ||
> 		    !(msg.arg.pagefault.flags & UFFD_PAGEFAULT_FLAG_WP)) {
> 			printf("FAIL: wrong uffd-wp event fired\n");
> 			exit(1);
> 		}
> 
> 		printf("PASS: uffd-wp fired\n");
> 		exit(0);
> 	}
> }
> 
> static int setup_uffd(char *map)
> {
> 	struct uffdio_api uffdio_api;
> 	struct uffdio_register uffdio_register;
> 	struct uffdio_range uffd_range;
> 	pthread_t thread;
> 
> 	uffd = syscall(__NR_userfaultfd,
> 		       O_CLOEXEC | O_NONBLOCK | UFFD_USER_MODE_ONLY);
> 	if (uffd < 0) {
> 		fprintf(stderr, "syscall() failed: %d\n", errno);
> 		return -errno;
> 	}
> 
> 	uffdio_api.api = UFFD_API;
> 	uffdio_api.features = UFFD_FEATURE_PAGEFAULT_FLAG_WP;
> 	if (ioctl(uffd, UFFDIO_API, &uffdio_api) < 0) {
> 		fprintf(stderr, "UFFDIO_API failed: %d\n", errno);
> 		return -errno;
> 	}
> 
> 	if (!(uffdio_api.features & UFFD_FEATURE_PAGEFAULT_FLAG_WP)) {
> 		fprintf(stderr, "UFFD_FEATURE_WRITEPROTECT missing\n");
> 		return -ENOSYS;
> 	}
> 
> 	uffdio_register.range.start = (unsigned long) map;
> 	uffdio_register.range.len = pagesize;
> 	uffdio_register.mode = UFFDIO_REGISTER_MODE_WP;
> 	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register) < 0) {
> 		fprintf(stderr, "UFFDIO_REGISTER failed: %d\n", errno);
> 		return -errno;
> 	}
> 
> 	pthread_create(&thread, NULL, uffd_thread_fn, NULL);
> 
> 	return 0;
> }
> 
> int main(int argc, char **argv)
> {
> 	struct uffdio_writeprotect uffd_writeprotect;
> 	char *map;
> 	int fd;
> 
> 	pagesize = getpagesize();
> 	fd = memfd_create("test", 0);
> 	if (fd < 0) {
> 		fprintf(stderr, "memfd_create() failed\n");
> 		return -errno;
> 	}
> 	if (ftruncate(fd, pagesize)) {
> 		fprintf(stderr, "ftruncate() failed\n");
> 		return -errno;
> 	}
> 
> 	/* Start out without write protection. */
> 	map = mmap(NULL, pagesize, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
> 	if (map == MAP_FAILED) {
> 		fprintf(stderr, "mmap() failed\n");
> 		return -errno;
> 	}
> 
> 	if (setup_uffd(map))
> 		return 1;
> 
> 	/* Populate a page ... */
> 	memset(map, 0, pagesize);
> 
> 	/* ... and write-protect it using uffd-wp. */
> 	uffd_writeprotect.range.start = (unsigned long) map;
> 	uffd_writeprotect.range.len = pagesize;
> 	uffd_writeprotect.mode = UFFDIO_WRITEPROTECT_MODE_WP;
> 	if (ioctl(uffd, UFFDIO_WRITEPROTECT, &uffd_writeprotect)) {
> 		fprintf(stderr, "UFFDIO_WRITEPROTECT failed: %d\n", errno);
> 		return -errno;
> 	}
> 
> 	/* Write-protect the whole mapping temporarily. */
> 	mprotect(map, pagesize, PROT_READ);
> 	mprotect(map, pagesize, PROT_READ|PROT_WRITE);
> 
> 	/* Test if uffd-wp fires. */
> 	memset(map, 1, pagesize);
> 
> 	printf("FAIL: uffd-wp did not fire\n");
> 	return 1;
> }


-- 
Peter Xu

