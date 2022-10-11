Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF3B65FAF9F
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 11:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbiJKJsd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 05:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiJKJsc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 05:48:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6DB7539B
        for <stable@vger.kernel.org>; Tue, 11 Oct 2022 02:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665481711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nM1PM/6l4Tr8EGWaYPuCobqaUcrzd1NE2nJsT1FjZNI=;
        b=aVcAATRDmm9gza7mZpUeLLwod7AwMSoYEmGqM2XKKpsEAyYVGKdANebEIMqxhpa1zANGnz
        OMWETq7UL6zssxSS6x8zVKdD75qHsZ/ivzHehfPC8gH4vanTwQrfHjTidhkbagT45vYPmp
        UyShahNHZ53Kdndq2KfFf2yAWQL8wDA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-138-CNjBVHEWONqQzRAtyk6fIw-1; Tue, 11 Oct 2022 05:48:27 -0400
X-MC-Unique: CNjBVHEWONqQzRAtyk6fIw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E516F3C11EA1;
        Tue, 11 Oct 2022 09:48:26 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E003D414A809;
        Tue, 11 Oct 2022 09:48:26 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 29B9mQj5032256;
        Tue, 11 Oct 2022 05:48:26 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 29B9mQwW032252;
        Tue, 11 Oct 2022 05:48:26 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Tue, 11 Oct 2022 05:48:26 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Greg KH <gregkh@linuxfoundation.org>
cc:     stable@vger.kernel.org
Subject: Re: backport of patches 8238b4579866b7c1bb99883cfe102a43db5506ff
 and d6ffe6067a54972564552ea45d320fb98db1ac5e
In-Reply-To: <Y0Rtkk7hA4CBwp16@kroah.com>
Message-ID: <alpine.LRH.2.02.2210110531260.30193@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2209301128030.23900@file01.intranet.prod.int.rdu2.redhat.com> <YzflXQMdGLsjPb70@kroah.com> <alpine.LRH.2.02.2210030459050.10514@file01.intranet.prod.int.rdu2.redhat.com> <Yz21dn2vJPOVOffr@kroah.com> <Y0Rtkk7hA4CBwp16@kroah.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On Mon, 10 Oct 2022, Greg KH wrote:

> Nope, these cause loads of breakages.  See
> https://lore.kernel.org/r/09eca44e-4d91-a060-d48c-d0aa41ac5045@roeck-us.net
> for one such example, and I know kbuild sent you other build problems.
> I'll drop all of these from the stable trees now.  Please feel free to
> resend them when you have the build issues worked out.
> 
> thanks,
> 
> greg k-h

I don't have cross compilers for all the architectures that Linux 
supports. Is there some way how to have the patch compile-tested before I 
send it to you?

Or - would you accept this patch instead of the upstream patch? It fixes 
the same bug as the upstream patch, but it's noticeably smaller and it 
could be applied to the stable kernels 4.19 to 5.19.

Mikulas



From: Mikulas Patocka <mpatocka@redhat.com>

This fixes a bug that is fixed by the upstream patch 
8238b4579866b7c1bb99883cfe102a43db5506ff.

This patch differs from the upstream patch because backporting the 
upstream patch causes many build failures on various architectures.


Original commit message:

There are several places in the kernel where wait_on_bit is not followed
by a memory barrier (for example, in drivers/md/dm-bufio.c:new_read).

On architectures with weak memory ordering, it may happen that memory
accesses that follow wait_on_bit are reordered before wait_on_bit and
they may return invalid data.

Fix this class of bugs by introducing a new function "test_bit_acquire"
that works like test_bit, but has acquire memory ordering semantics.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Acked-by: Will Deacon <will@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>


---
 include/linux/wait_bit.h |   16 ++++++++++++----
 kernel/sched/wait_bit.c  |    2 ++
 2 files changed, 14 insertions(+), 4 deletions(-)

Index: linux-stable/include/linux/wait_bit.h
===================================================================
--- linux-stable.orig/include/linux/wait_bit.h	2022-10-11 11:23:12.000000000 +0200
+++ linux-stable/include/linux/wait_bit.h	2022-10-11 11:24:33.000000000 +0200
@@ -71,8 +71,10 @@ static inline int
 wait_on_bit(unsigned long *word, int bit, unsigned mode)
 {
 	might_sleep();
-	if (!test_bit(bit, word))
+	if (!test_bit(bit, word)) {
+		smp_rmb();
 		return 0;
+	}
 	return out_of_line_wait_on_bit(word, bit,
 				       bit_wait,
 				       mode);
@@ -96,8 +98,10 @@ static inline int
 wait_on_bit_io(unsigned long *word, int bit, unsigned mode)
 {
 	might_sleep();
-	if (!test_bit(bit, word))
+	if (!test_bit(bit, word)) {
+		smp_rmb();
 		return 0;
+	}
 	return out_of_line_wait_on_bit(word, bit,
 				       bit_wait_io,
 				       mode);
@@ -123,8 +127,10 @@ wait_on_bit_timeout(unsigned long *word,
 		    unsigned long timeout)
 {
 	might_sleep();
-	if (!test_bit(bit, word))
+	if (!test_bit(bit, word)) {
+		smp_rmb();
 		return 0;
+	}
 	return out_of_line_wait_on_bit_timeout(word, bit,
 					       bit_wait_timeout,
 					       mode, timeout);
@@ -151,8 +157,10 @@ wait_on_bit_action(unsigned long *word,
 		   unsigned mode)
 {
 	might_sleep();
-	if (!test_bit(bit, word))
+	if (!test_bit(bit, word)) {
+		smp_rmb();
 		return 0;
+	}
 	return out_of_line_wait_on_bit(word, bit, action, mode);
 }
 
Index: linux-stable/kernel/sched/wait_bit.c
===================================================================
--- linux-stable.orig/kernel/sched/wait_bit.c	2022-10-11 11:23:12.000000000 +0200
+++ linux-stable/kernel/sched/wait_bit.c	2022-10-11 11:25:22.000000000 +0200
@@ -51,6 +51,8 @@ __wait_on_bit(struct wait_queue_head *wq
 
 	finish_wait(wq_head, &wbq_entry->wq_entry);
 
+	smp_rmb();
+
 	return ret;
 }
 EXPORT_SYMBOL(__wait_on_bit);

