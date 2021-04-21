Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBE6367496
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 23:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238222AbhDUVF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 17:05:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42521 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243828AbhDUVF4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Apr 2021 17:05:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619039122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+NPvL4bnAQ0xyAmY/8IZQZjszIIYldcl5F0YQggfYA4=;
        b=WXlj+Uv+5YTRM1TdHDvaMLPdQEkl3oN246r24e+EtN2ZmTb7N+G7XfDJc5leHJ2hKV0+hb
        d3uDqW1c0lPrl20mxPmJKzt663IPxbRt+5k7k7sLwEkPm0Qg+udIaQYg3C87awcsKcCwCP
        EJhuyLtw56GbjHkXWZRxga4gnD7qSts=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-BIYEQ6yHPIy9aPXBg7nFyQ-1; Wed, 21 Apr 2021 17:05:20 -0400
X-MC-Unique: BIYEQ6yHPIy9aPXBg7nFyQ-1
Received: by mail-qk1-f197.google.com with SMTP id s143-20020a3745950000b029028274263008so10528670qka.9
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 14:05:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+NPvL4bnAQ0xyAmY/8IZQZjszIIYldcl5F0YQggfYA4=;
        b=jg06SjFBsYSQtw1vksraaOC9ChLBLIJehIbB6yfvF23IW/uyd+kJatlLlH7kNMs/p2
         hiKHVKKFHAy5mGrJcjS60E0N0GQ9qhbRH1KjKwUM4ndqBJUbx17nLFIu0XAYfdlsdfLX
         h/+Pgf+IVCuDnrMsBXi2C4mwFF3OW1kobdKMW1HaiVKlQGNtMIvjs5BARSVH+uTv0F4C
         aee81aXgDIe6XN+FtzHrKA/1aOHM+P+Bc8CV4GMLcrVYrZmU7T4tYyC4nMOY1j9B50zL
         5/3//LwOHDHL3r3E2nMPwgubDCjcF1li1MAItwKAcBBSFWKRDUI8gLJFE3Nu3nDMSiQx
         Tltg==
X-Gm-Message-State: AOAM533ixpxnUW4yefgpve8zTzbHlkB8YzeEoHjP8Lqhoos/K4qd6IlJ
        oTa66XP5zvrLL9HLmnbKLDHoATkyGmIB9iy7YHgrFwxNLbBJDlbTVjDr9dMGIq22HrGY8of5vgx
        eyuGRroNltb67WspV
X-Received: by 2002:a05:620a:2158:: with SMTP id m24mr137859qkm.306.1619039119806;
        Wed, 21 Apr 2021 14:05:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwxujGZeCbAvz4IXpRdnt1YImSNzwwC/WEtVZvG6EHSmVIC7ejMtWkWr+rWNvTx7EvGNOhIRQ==
X-Received: by 2002:a05:620a:2158:: with SMTP id m24mr137828qkm.306.1619039119514;
        Wed, 21 Apr 2021 14:05:19 -0700 (PDT)
Received: from xz-x1 (bras-base-toroon474qw-grc-77-184-145-104-227.dsl.bell.ca. [184.145.104.227])
        by smtp.gmail.com with ESMTPSA id v18sm589596qtq.38.2021.04.21.14.05.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 14:05:18 -0700 (PDT)
Date:   Wed, 21 Apr 2021 17:05:17 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Suren Baghdasaryan <surenb@google.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
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
Message-ID: <20210421210517.GA6404@xz-x1>
References: <20210401181741.168763-1-surenb@google.com>
 <CAHk-=wg8MDMLi8x+u-dee-ai0KiAavm6+JceV00gRXQRFG=Cgw@mail.gmail.com>
 <c7d580fe-e467-4f08-a11d-6b8ceaf41e8f@suse.cz>
 <CAHk-=wiQCrpxGL4o5piCSqJF0jahUUYW=9R=oGATiiPnkaGY0g@mail.gmail.com>
 <CAJuCfpFgHMMWZgch5gfjHj936gmpDztb8ZT-vJn6G0-r5BvceA@mail.gmail.com>
 <CAHk-=wj0JH6PnG7dW51Sr5ZqhomqSaSLTQV7z4Si2dLeSVcO_g@mail.gmail.com>
 <alpine.LRH.2.02.2104071432420.31819@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHk-=whUKYdWbKfFzXXnK8n04oCMwEgSnG8Y3tgE=YZUjiDvbA@mail.gmail.com>
 <CAJuCfpHa+eydE_voX38V-jtv5J_RnyT=eY12-VmcLbVG_u2dyA@mail.gmail.com>
 <CAJuCfpHJjtv_=jLULge8D4EK_AK2yGLMcWKcGSaknzuWm0DFtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJuCfpHJjtv_=jLULge8D4EK_AK2yGLMcWKcGSaknzuWm0DFtA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Suren,

On Wed, Apr 21, 2021 at 01:01:34PM -0700, Suren Baghdasaryan wrote:
> Peter, you mentioned https://lkml.org/lkml/2020/8/10/439 patch to
> distinguish real writes vs enforced COW read requests, however I also
> see that you had a later version of this patch here:
> https://lore.kernel.org/patchwork/patch/1286506/. Which one should I
> backport? Or is it not needed in the absence of uffd-wp support in the
> earlier kernels?

Sorry I have no ability to evaluate the rest... but according to Linus's
previous reply, my understanding is that it is not needed, not to mention it's
not upstreamed too.

Thanks,

-- 
Peter Xu

