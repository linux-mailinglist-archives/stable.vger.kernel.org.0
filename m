Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69BCC1969F9
	for <lists+stable@lfdr.de>; Sun, 29 Mar 2020 00:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbgC1XID (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Mar 2020 19:08:03 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:41487 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727856AbgC1XID (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Mar 2020 19:08:03 -0400
Received: by mail-qt1-f193.google.com with SMTP id i3so11971708qtv.8
        for <stable@vger.kernel.org>; Sat, 28 Mar 2020 16:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ll5/yGQZRWchp8TDCZLz4Mu8TR2gdnKXC0ek/0PcC6s=;
        b=PRxrzlb0Wve/L9dD5bq3htIZlmqEDU9F7ufxGYc7pP/BjS+5KOylxKAwwIHMDMf1kK
         GAiNOm04VMgVUa3Supcf92GHzUywRFQX9LS+j1yZM2inMGJrkklncyHL47zpUWxiJFxD
         O0KXdR6lxe3K94eMF4vSmSgRVBZPOlclmZJzUwPUFieMfMIFqx9VB/L1KsAYQpVNzoT3
         Taky/Ug6yOt+8eY58C7ZUJKPjJ66FkhBSnlOpCqrSaWD+arNpe78PUBiSZFcxWGATwqb
         nM+gmuoFbKZCUlF7Fh1fbEu2DrYIZGbWgj64YoAVvRWg8gUWx9i1AZWznrb/ymk7cplj
         J6tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ll5/yGQZRWchp8TDCZLz4Mu8TR2gdnKXC0ek/0PcC6s=;
        b=jxVsuAhtOLjk0yQPA+QwB2f6eQqe9i2w5mD2sCuOGZLG7cpNpvmmX/iMsdIb68ZIEL
         siyoRqB1xh5JsRNzsJz2/EnjnlbX9bFZdqXVyXfwws5Fi+qP+5rzy57MRIso5JNAuuqF
         AyGjctWc2kilzJC4xQ6cso9TS1JPn0m8nqe0eiQJe0a/UWXBveR7MwYotM3RQTe6mFc4
         3HLByo6SURQMh6zTbK7O6WkHSRRhUmD8pCkYYtZc7amnZylz6flk3mmlcTHDkTx73UWB
         tDQQ+irfv8du+KqCaF147n94xKISmPAFIp/QYxbqg/MbsNr2DOr9zoKIVzCr44q3QZ4v
         L2jg==
X-Gm-Message-State: ANhLgQ2RQtw9PeE+ZHuXesBrbP7Rv+kYf8co97eM6Ho0AGnp8bEPM+ZL
        DmfEQHN7D5d9NnrFlZiCLEh49w==
X-Google-Smtp-Source: ADFU+vvA0LNIn6qdR1pCMkfY79ytftR4wg2Zm5m4Avobx1Rb43WaXRSlcWMRgHdIm+JTzaDT4ujOqQ==
X-Received: by 2002:ac8:7c92:: with SMTP id y18mr5780170qtv.189.1585436880818;
        Sat, 28 Mar 2020 16:08:00 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id x89sm7172921qtd.43.2020.03.28.16.08.00
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 28 Mar 2020 16:08:00 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jIKYZ-0000ov-QB; Sat, 28 Mar 2020 20:07:59 -0300
Date:   Sat, 28 Mar 2020 20:07:59 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Longpeng(Mike)" <longpeng2@huawei.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        kvm@vger.kernel.org, arei.gonglei@huawei.com,
        weidong.huang@huawei.com, weifuqiang@huawei.com,
        kirill.shutemov@linux.intel.com,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v4] mm/hugetlb: fix a addressing exception caused by
 huge_pte_offset
Message-ID: <20200328230759.GD20941@ziepe.ca>
References: <20200327234122.1985-1-longpeng2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327234122.1985-1-longpeng2@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 28, 2020 at 07:41:22AM +0800, Longpeng(Mike) wrote:
> From: Longpeng <longpeng2@huawei.com>
> 
> Our machine encountered a panic(addressing exception) after run
> for a long time and the calltrace is:
> RIP: 0010:[<ffffffff9dff0587>]  [<ffffffff9dff0587>] hugetlb_fault+0x307/0xbe0
> RSP: 0018:ffff9567fc27f808  EFLAGS: 00010286
> RAX: e800c03ff1258d48 RBX: ffffd3bb003b69c0 RCX: e800c03ff1258d48
> RDX: 17ff3fc00eda72b7 RSI: 00003ffffffff000 RDI: e800c03ff1258d48
> RBP: ffff9567fc27f8c8 R08: e800c03ff1258d48 R09: 0000000000000080
> R10: ffffaba0704c22a8 R11: 0000000000000001 R12: ffff95c87b4b60d8
> R13: 00005fff00000000 R14: 0000000000000000 R15: ffff9567face8074
> FS:  00007fe2d9ffb700(0000) GS:ffff956900e40000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffd3bb003b69c0 CR3: 000000be67374000 CR4: 00000000003627e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  [<ffffffff9df9b71b>] ? unlock_page+0x2b/0x30
>  [<ffffffff9dff04a2>] ? hugetlb_fault+0x222/0xbe0
>  [<ffffffff9dff1405>] follow_hugetlb_page+0x175/0x540
>  [<ffffffff9e15b825>] ? cpumask_next_and+0x35/0x50
>  [<ffffffff9dfc7230>] __get_user_pages+0x2a0/0x7e0
>  [<ffffffff9dfc648d>] __get_user_pages_unlocked+0x15d/0x210
>  [<ffffffffc068cfc5>] __gfn_to_pfn_memslot+0x3c5/0x460 [kvm]
>  [<ffffffffc06b28be>] try_async_pf+0x6e/0x2a0 [kvm]
>  [<ffffffffc06b4b41>] tdp_page_fault+0x151/0x2d0 [kvm]
>  ...
>  [<ffffffffc06a6f90>] kvm_arch_vcpu_ioctl_run+0x330/0x490 [kvm]
>  [<ffffffffc068d919>] kvm_vcpu_ioctl+0x309/0x6d0 [kvm]
>  [<ffffffff9deaa8c2>] ? dequeue_signal+0x32/0x180
>  [<ffffffff9deae34d>] ? do_sigtimedwait+0xcd/0x230
>  [<ffffffff9e03aed0>] do_vfs_ioctl+0x3f0/0x540
>  [<ffffffff9e03b0c1>] SyS_ioctl+0xa1/0xc0
>  [<ffffffff9e53879b>] system_call_fastpath+0x22/0x27

> Cc: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: stable@vger.kernel.org
> Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
> Signed-off-by: Longpeng <longpeng2@huawei.com>

Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>

Jason
