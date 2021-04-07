Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69DBD356EA2
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 16:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348476AbhDGOaS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 10:30:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45192 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229772AbhDGOaR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Apr 2021 10:30:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617805807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GDYJOulx7zxHZLZyk25KIXd/enfCBPJHhg/Sw/V6QOU=;
        b=ZGxJqhJX3iXWBvhzeFdukfD/jEqS2I4dkEyhLzfnuityooZnZ/Wxef0qw7yfSsRjnYUz6w
        dbgHyU+VPxvRGpsKFvSs8/c50VgLxu0yzZ/8L/6nKpR1kiq7u5zaPeGtH+uYIwnUdsZsxq
        1eQl89QRjf28aaEFkKwJuw1c0Ztw9yg=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-aZhsMMt8Oj-Q5ygx9vUifA-1; Wed, 07 Apr 2021 10:30:04 -0400
X-MC-Unique: aZhsMMt8Oj-Q5ygx9vUifA-1
Received: by mail-qt1-f199.google.com with SMTP id w8so5448776qtn.17
        for <stable@vger.kernel.org>; Wed, 07 Apr 2021 07:30:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GDYJOulx7zxHZLZyk25KIXd/enfCBPJHhg/Sw/V6QOU=;
        b=Q13kBTTD+subCeJx3RfkWkC6YHO1wLuJxiisoRdxhMiqqZgs9Tc8GNCSsC+uEPC3/h
         88G5QzWhdsM97LjVM7DD3ix7Ax3NXKBZxaUxVnxY9FxD5u0yLs1fIa64+NeCgnyTYQUv
         nVTb0fyk3lYVFweMz/HySVIDIU6IcbBvnGa8PMb1l+3jmrU/1fUwlMko3ZNVtbhQH87A
         V9TBxZyGBVJeqvhzsUPN0sUEvW4LQoOiZHlnraM+Ikl7ypZkzk8W1Vc0n6Di89RRaFg7
         UYUFtTQ61T/W4aHY+ce9kK9WlM+97m1M+07itRyNRlBQLG2VKaOaELkWTaEYZ32xMURg
         AL0A==
X-Gm-Message-State: AOAM532No/3ivDtsmpzESVjNNxAWyxOls7FXy925lS7DeoYk9CYjJAvg
        ZR/sCIJ3xkle8fAP+4dbYrJFRDP65y/6Abpwq5Is4FIfOFZXI6PaQSt58h+ByXJSRKRoEsp9Lp2
        lwICjqlfheC34fH7D
X-Received: by 2002:a05:620a:1133:: with SMTP id p19mr3546202qkk.340.1617805804152;
        Wed, 07 Apr 2021 07:30:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzemfyJsndiR794toQll/jxXTqquK1TrMQGdy5V/MEjR03W49+XHL7o/gI5hUEjYjU3jO2W+g==
X-Received: by 2002:a05:620a:1133:: with SMTP id p19mr3546159qkk.340.1617805803851;
        Wed, 07 Apr 2021 07:30:03 -0700 (PDT)
Received: from xz-x1 (bras-base-toroon474qw-grc-82-174-91-135-175.dsl.bell.ca. [174.91.135.175])
        by smtp.gmail.com with ESMTPSA id u12sm18037837qkk.129.2021.04.07.07.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 07:30:03 -0700 (PDT)
Date:   Wed, 7 Apr 2021 10:30:01 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Suren Baghdasaryan <surenb@google.com>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jann Horn <jannh@google.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>, Shaohua Li <shli@fb.com>,
        Nadav Amit <namit@vmware.com>, Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 0/5] 4.14 backports of fixes for "CoW after fork() issue"
Message-ID: <20210407143001.GP628002@xz-x1>
References: <20210401181741.168763-1-surenb@google.com>
 <CAHk-=wg8MDMLi8x+u-dee-ai0KiAavm6+JceV00gRXQRFG=Cgw@mail.gmail.com>
 <c7d580fe-e467-4f08-a11d-6b8ceaf41e8f@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c7d580fe-e467-4f08-a11d-6b8ceaf41e8f@suse.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 07, 2021 at 03:21:55PM +0200, Vlastimil Babka wrote:
> 2) For backports go with the original approach of 17839856fd58 ("gup: document
> and work around "COW can break either way" issue"), thus break COW during the
> GUP. But only for vmplice() so that nothing else gets broken. I think 5.4 stable
> (another LTS) actually backported only 17839856fd58 out of everything else, so
> it should have even the THP case covered, but its userfaultfd() is now probably
> broken...

Since you mentioned this approach - AFAIU userfaultfd was only broken because
with that approach the kernel pretends some read accesses as writes, while
userfaultfd needs that accurate resolution.  Adding something like
FOLL_BREAK_COW [1] upon 17839856fd58 should keep both the vmsplice issue fixed
but also uffd working since that'll keep the read/write operation separate.

Meanwhile, I know Andrea was actively working on a complete solution [2] that's
a few steps further.  E.g., FOLL_BREAK_COW is done with FOLL_UNSHARE [3], speed
up in COW path [4] with similar idea of what we do right now with latest
upstream in 09854ba94c6aad7, allow write-protect with pinned pages (which is
right now forbidden), and something more.  However that's definitely a huge
branch, even discussing upstream (or maybe stopped discussing for quite some
days already?).

Neither of above are within upstream, so I don't really know whether these
information could be anything useful, just raise it up.  If Android could drop
userfaultfd, then I think solution 2) above is indeed the most efficient.  Note
that I think only uffd-wp was affected by 17839856fd58 but not the "missing
mode", so if Android is only using missing mode it still looks fine to only
have 17839856fd58.  It's just that I remembered there's another report besides
uffd-wp on 17839856fd58, but I can't remember the details of the other report.

Thanks,

[1] https://lkml.org/lkml/2020/8/10/439
[2] https://git.kernel.org/pub/scm/linux/kernel/git/andrea/aa.git/log/?h=mapcount_deshare
[3] https://git.kernel.org/pub/scm/linux/kernel/git/andrea/aa.git/commit/?h=mapcount_deshare&id=7c3a31caa34ac6ac4a4ec0559b1307b5edfc0821
[4] https://git.kernel.org/pub/scm/linux/kernel/git/andrea/aa.git/commit/?h=mapcount_deshare&id=599aa62474f51a470408b28fd4365320a5357aca

-- 
Peter Xu

