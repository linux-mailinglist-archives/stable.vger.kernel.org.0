Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BCE260EAF5
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 23:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiJZVvo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 17:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233548AbiJZVvl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 17:51:41 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9230497EDA
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 14:51:38 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id g130so20533380oia.13
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 14:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EPlffG47xJTu/eCD1FI0MkLZITbqaPUGdqLyBsrHEsQ=;
        b=pQ3NtFajmDVuyFwcZCucRfU67xVNr9BztJT2DtYdIksFSYe4tA87UHPCfYmn76nQTa
         6Z0KMQUreGgCQVKDQLSgUC/FWku4QYzk2ivLlrRXT7EGUbbjwIBucQ4RTVvLD82QARHZ
         oxMjCgwB/lR69W+ma5Xuoq+mP3NN0oVqoUgLpkJID7xvAAlF+O3M+ypOaFQOyZs6wtdx
         4633ZPoltaxwMhCdbgRyWRYx4M2C9pVy8biqdYppAToF8P08gq8GfOSNxK0WfxXZY5W2
         y2pvHMO6/vukkbT+GVaoYVQSBHaTibplPq0kEQol9Cpqx/llivPk5SNy94rIM9EAcjZD
         4kjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EPlffG47xJTu/eCD1FI0MkLZITbqaPUGdqLyBsrHEsQ=;
        b=6VG1WbvioA3tnU6DPVZ0I5pgA+VpgHRB+xD1pai5ysu4UIUOTCxMJwCtBiNa7saPjO
         dYPbdJKjhVHILjrBPRlqORlaaG9dMWMlRKK6mrbwKuY0J5pX1yM1D/pIQeJzzsGhSYEg
         vtBid7eCanpMrja5tCU0vLM9rHk9hxpDjdPwk7snAEvvGPTh/xGToSF8WgIihUNv7vvj
         Nt7bT4mw28vnKe2H3TDQt3zUmO0tCUkMSJ4MOHSpWlBgwNmzUSMNnbsBQ7qt9ymAG9fm
         7c6rXw/alI6e+ypzYCixCxzWKcRAroh6dcQe22SxP99Trr5pCOEl8TgpPOOffeFyk/aW
         7xzw==
X-Gm-Message-State: ACrzQf0HdAqBVRC24vl9dsSnIZ2cjO35pYHuJCVjTKDwZ2VUEZ8bgrky
        UDopo3cc2B8gGMjGJLhaQwI+Uw==
X-Google-Smtp-Source: AMsMyM5kHy58Uc7tCzACZk/sYsLCjau2lYMY7FceCP3xGE+duN3aFlkIn1ckVQxeuiJFcDufNQ6qEw==
X-Received: by 2002:aca:1108:0:b0:359:aeef:505a with SMTP id 8-20020aca1108000000b00359aeef505amr2303122oir.288.1666821097743;
        Wed, 26 Oct 2022 14:51:37 -0700 (PDT)
Received: from ripple.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id n203-20020aca40d4000000b00354978180d8sm2499375oia.22.2022.10.26.14.51.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 14:51:36 -0700 (PDT)
Date:   Wed, 26 Oct 2022 14:51:16 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@ripple.attlocal.net
To:     Yuanzheng Song <songyuanzheng@huawei.com>
cc:     akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        peterx@redhat.com, david@redhat.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH STABLE 5.10] mm/memory: add non-anonymous page check in
 the copy_present_page()
In-Reply-To: <20221024094911.3054769-1-songyuanzheng@huawei.com>
Message-ID: <3823471f-6dda-256e-e082-718879c05449@google.com>
References: <20221024094911.3054769-1-songyuanzheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 Oct 2022, Yuanzheng Song wrote:

> The vma->anon_vma of the child process may be NULL because
> the entire vma does not contain anonymous pages. In this
> case, a BUG will occur when the copy_present_page() passes
> a copy of a non-anonymous page of that vma to the
> page_add_new_anon_rmap() to set up new anonymous rmap.
> 
> ------------[ cut here ]------------
> kernel BUG at mm/rmap.c:1044!
> Internal error: Oops - BUG: 0 [#1] SMP
> Modules linked in:
> CPU: 2 PID: 3617 Comm: test Not tainted 5.10.149 #1
> Hardware name: linux,dummy-virt (DT)
> pstate: 80000005 (Nzcv daif -PAN -UAO -TCO BTYPE=--)
> pc : __page_set_anon_rmap+0xbc/0xf8
> lr : __page_set_anon_rmap+0xbc/0xf8
> sp : ffff800014c1b870
> x29: ffff800014c1b870 x28: 0000000000000001
> x27: 0000000010100073 x26: ffff1d65c517baa8
> x25: ffff1d65cab0f000 x24: ffff1d65c416d800
> x23: ffff1d65cab5f248 x22: 0000000020000000
> x21: 0000000000000001 x20: 0000000000000000
> x19: fffffe75970023c0 x18: 0000000000000000
> x17: 0000000000000000 x16: 0000000000000000
> x15: 0000000000000000 x14: 0000000000000000
> x13: 0000000000000000 x12: 0000000000000000
> x11: 0000000000000000 x10: 0000000000000000
> x9 : ffffc3096d5fb858 x8 : 0000000000000000
> x7 : 0000000000000011 x6 : ffff5a5c9089c000
> x5 : 0000000000020000 x4 : ffff5a5c9089c000
> x3 : ffffc3096d200000 x2 : ffffc3096e8d0000
> x1 : ffff1d65ca3da740 x0 : 0000000000000000
> Call trace:
>  __page_set_anon_rmap+0xbc/0xf8
>  page_add_new_anon_rmap+0x1e0/0x390
>  copy_pte_range+0xd00/0x1248
>  copy_page_range+0x39c/0x620
>  dup_mmap+0x2e0/0x5a8
>  dup_mm+0x78/0x140
>  copy_process+0x918/0x1a20
>  kernel_clone+0xac/0x638
>  __do_sys_clone+0x78/0xb0
>  __arm64_sys_clone+0x30/0x40
>  el0_svc_common.constprop.0+0xb0/0x308
>  do_el0_svc+0x48/0xb8
>  el0_svc+0x24/0x38
>  el0_sync_handler+0x160/0x168
>  el0_sync+0x180/0x1c0
> Code: 97f8ff85 f9400294 17ffffeb 97f8ff82 (d4210000)
> ---[ end trace a972347688dc9bd4 ]---
> Kernel panic - not syncing: Oops - BUG: Fatal exception
> SMP: stopping secondary CPUs
> Kernel Offset: 0x43095d200000 from 0xffff800010000000
> PHYS_OFFSET: 0xffffe29a80000000
> CPU features: 0x08200022,61806082
> Memory Limit: none
> ---[ end Kernel panic - not syncing: Oops - BUG: Fatal exception ]---
> 
> This problem has been fixed by the fb3d824d1a46
> ("mm/rmap: split page_dup_rmap() into page_dup_file_rmap() and page_try_dup_anon_rmap()"),
> but still exists in the linux-5.10.y branch.
> 
> This patch is not applicable to this version because
> of the large version differences. Therefore, fix it by
> adding non-anonymous page check in the copy_present_page().
> 
> Fixes: 70e806e4e645 ("mm: Do early cow for pinned pages during fork() for ptes")
> Signed-off-by: Yuanzheng Song <songyuanzheng@huawei.com>

It's a good point, but this patch should not go into any stable release
without an explicit Ack from either Peter Xu or David Hildenbrand.

To my eye, it's simply avoiding the issue, rather than fixing
it properly; and even if the issue is so rare, and fixing properly
too difficult or inefficent (a cached anon_vma?), that a workaround
is good enough, it still looks like the wrong workaround (checking
dst_vma->anon_vma instead of PageAnon seems more to the point, and
less lenient).

But my eye on COW is very poor nowadays, and I may be plain wrong.

Hugh

> ---
>  mm/memory.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index cc50fa0f4590..45973fd97be8 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -823,6 +823,17 @@ copy_present_page(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma
>  	if (likely(!page_maybe_dma_pinned(page)))
>  		return 1;
>  
> +	/*
> +	 * The vma->anon_vma of the child process may be NULL
> +	 * because the entire vma does not contain anonymous pages.
> +	 * A BUG will occur when the copy_present_page() passes
> +	 * a copy of a non-anonymous page of that vma to the
> +	 * page_add_new_anon_rmap() to set up new anonymous rmap.
> +	 * Return 1 if the page is not an anonymous page.
> +	*/
> +	if (!PageAnon(page))
> +		return 1;
> +
>  	new_page = *prealloc;
>  	if (!new_page)
>  		return -EAGAIN;
> -- 
> 2.25.1
