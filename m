Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 403D46200C9
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 22:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232258AbiKGVPI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 16:15:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233490AbiKGVOV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 16:14:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 446142E9F1
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 13:10:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667855434;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SzHKQ14nNjsViFBZiKyyfTIyPTT6hamOAKSnybTM1Zw=;
        b=hByG6/KMyHiHtd9MWM+xKwJljVmmZu2yIsMSl2hrkKwufLLf6bSqkudHiZspoBTHaudyZ0
        ggd7L8lgrp/r+BnJWKyS6M/3Uv/8Vy8nbnKqbzgJPwseRFJjGV2EYbi1ujT3HLTDJAEdY8
        xULO40Vx4kL2IQnVGsf+aDBtLM4H5JM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-ae7_CcN2MzCInPJVtmyiNA-1; Mon, 07 Nov 2022 16:10:31 -0500
X-MC-Unique: ae7_CcN2MzCInPJVtmyiNA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D1270101A5AD;
        Mon,  7 Nov 2022 21:10:30 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CC5ED2027063;
        Mon,  7 Nov 2022 21:10:30 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 2A7LAUnq004909;
        Mon, 7 Nov 2022 16:10:30 -0500
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 2A7LAUQG004905;
        Mon, 7 Nov 2022 16:10:30 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Mon, 7 Nov 2022 16:10:30 -0500 (EST)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Greg KH <gregkh@linuxfoundation.org>
cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.15 2/2] provide arch_test_bit_acquire for architectures
 that define test_bit
In-Reply-To: <Y2kiGNpHW8pYBVk6@kroah.com>
Message-ID: <alpine.LRH.2.21.2211071541450.2058@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.21.2210270841040.22202@file01.intranet.prod.int.rdu2.redhat.com> <Y2kiGNpHW8pYBVk6@kroah.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On Mon, 7 Nov 2022, Greg KH wrote:

> On Thu, Oct 27, 2022 at 08:41:45AM -0400, Mikulas Patocka wrote:
> > commit d6ffe6067a54972564552ea45d320fb98db1ac5e upstream.
> > 
> > Some architectures define their own arch_test_bit and they also need
> > arch_test_bit_acquire, otherwise they won't compile.  We also clean up
> > the code by using the generic test_bit if that is equivalent to the
> > arch-specific version.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > Cc: stable@vger.kernel.org
> > Fixes: 8238b4579866 ("wait_on_bit: add an acquire memory barrier")
> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > 
> > ---
> >  arch/alpha/include/asm/bitops.h   |    7 +++++++
> >  arch/h8300/include/asm/bitops.h   |    3 ++-
> >  arch/hexagon/include/asm/bitops.h |   15 +++++++++++++++
> >  arch/ia64/include/asm/bitops.h    |    7 +++++++
> >  arch/m68k/include/asm/bitops.h    |    6 ++++++
> >  arch/s390/include/asm/bitops.h    |    7 +++++++
> >  arch/sh/include/asm/bitops-op32.h |    7 +++++++
> >  7 files changed, 51 insertions(+), 1 deletion(-)
> 
> This is _very_ different from the upstream change that you are trying to
> backport here.
> 
> Are you sure it is correct?

I compile-tested it with all the cross-compilers downloaded from 
https://mirrors.edge.kernel.org/pub/tools/crosstool/ (I tried to compile 
the file kernel/sched/build_utility.o that includes wait_bit.c)

> You are adding real functions for these
> arches, while the original backport was _REMOVING_ them and having the
> arch code call the generic functions.

The kernels 5.19 and older don't contain the function generic_test_bit - 
and they don't contain the file 
"include/asm-generic/bitops/generic-non-atomic.h" where this function is 
defined. The test_bit code was refactored in 6.0 - see the commits

21bb8af513d35c005c401706030f4eb469538d1d
0e862838f290147ea9c16db852d8d494b552d38d
bb7379bfa680bd48b468e856475778db2ad866c1
e69eb9c460f128b71c6b995d75a05244e4b6cc3e
b03fc1173c0c2bb8fad61902a862985cecdc4b1b

So, the upstream patch doesn't apply to the older kernels.

> So why is this the same?

Functionally, it is equivalent if you define a function test_bit_acquire 
or refer to an existing generic_test_bit_acquire that has the same 
content.

Mikulas

> confused,
> 
> greg k-h
> 

