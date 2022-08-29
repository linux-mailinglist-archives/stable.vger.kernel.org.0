Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80A675A53CC
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 20:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbiH2SLW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 14:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiH2SLV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 14:11:21 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C602480369
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 11:11:19 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id y187so7271867iof.0
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 11:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=TbTCRboI273K6vdzVywMVDCK/xRKQxvsYXw9Bwpwxu0=;
        b=sDn1no/Jytsy85F8OBmJuZ/2eL28NhOQf8Kv9iYUzEenPSKOdrxF4ohRM0RoeOqGVB
         qvbOgFBLJmbcfoDFKzIpp6TTRxTbizUKpoa7whlcmCqPXPRTyNAManXC9tYspq/7VU++
         /49e+hLPBlfVjyqJpIdJe39W3jRnhfYcPWYhpl9JgV7HEqhhXvZQpHT6ZP8VEU6R7WZL
         Id3xezV4LEb0+gEg1dQJJS6VGUPRXwDu7/DYMAW5cOCVvYcGb7+oB7TqHtfS5iI/DfuG
         ztArPMZPHTxxNngD7Sc3EKjLqv4uvt4TKlosfq0/61LdXoQLDv+GOSJ9SxyXRqmaq83c
         k0PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=TbTCRboI273K6vdzVywMVDCK/xRKQxvsYXw9Bwpwxu0=;
        b=IWFbCGkTTJHegcl1rk98p8V6o3Y7NtigNpEAZvm++Bn8wjU0n7DQ8XQjk0YBQNxXz9
         nZELwz3iW4cMlyhaegqPXxZ+hQkE5LCdwqgPXh3n/hZTLoe7ntYzBIgkFXZ+F07bM0i9
         5E2iF81xWWfCBqDY0AsME5yvhKc+iScvTMoc8JbTUJ9SPHA+IxjXH6svpRCIVz4DYh5v
         aN/oY/CC+1p6m/aSf3mxh3Cf26nKCmnXeYKpgiO900l9T4RiMrB7l78h/LfspwHlWJJ6
         D07SPaqWusbFspZWcVrs682880CRaNV8FymK9prCW9m9sgbOqlpJsuSZPSbvOVQBgxur
         2PDQ==
X-Gm-Message-State: ACgBeo1YWhhoBVOG6hMUnxdHSD5nJM8Gt/ZL/o5Z/WZwkfCsvhKU8mb3
        IreKQ/l0NE1jyGAUboza6184iZVZE2it8gyrtcPzmuYhFAE=
X-Google-Smtp-Source: AA6agR5Hd3wDX3BIVEK62pbu5FKsXrTQgXEBt/8g9UfMd91TkEqH1qSiuoxfJmel2DduPY7m3UvFBDFLvzDgOnx7blY=
X-Received: by 2002:a5d:8b47:0:b0:689:a436:81d2 with SMTP id
 c7-20020a5d8b47000000b00689a43681d2mr9168228iot.138.1661796679055; Mon, 29
 Aug 2022 11:11:19 -0700 (PDT)
MIME-Version: 1.0
References: <166175868922875@kroah.com>
In-Reply-To: <166175868922875@kroah.com>
From:   Axel Rasmussen <axelrasmussen@google.com>
Date:   Mon, 29 Aug 2022 11:10:43 -0700
Message-ID: <CAJHvVcjuncHE_eG5aqxJTmtSeB0_z8DKssb34JzoSAgid0j2Fw@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] mm/hugetlb: avoid corrupting page->mapping
 in" failed to apply to 5.15-stable tree
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Miaohe Lin <linmiaohe@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Peter Xu <peterx@redhat.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 29, 2022 at 12:38 AM <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

I'm in favor of applying this to 5.15. I can send a backport, unless
someone else was already planning to do it (don't want to duplicate
effort)?

>
> thanks,
>
> greg k-h
>
> ------------------ original commit in Linus's tree ------------------
>
> From ab74ef708dc51df7cf2b8a890b9c6990fac5c0c6 Mon Sep 17 00:00:00 2001
> From: Miaohe Lin <linmiaohe@huawei.com>
> Date: Tue, 12 Jul 2022 21:05:42 +0800
> Subject: [PATCH] mm/hugetlb: avoid corrupting page->mapping in
>  hugetlb_mcopy_atomic_pte
>
> In MCOPY_ATOMIC_CONTINUE case with a non-shared VMA, pages in the page
> cache are installed in the ptes.  But hugepage_add_new_anon_rmap is called
> for them mistakenly because they're not vm_shared.  This will corrupt the
> page->mapping used by page cache code.
>
> Link: https://lkml.kernel.org/r/20220712130542.18836-1-linmiaohe@huawei.com
> Fixes: f619147104c8 ("userfaultfd: add UFFDIO_CONTINUE ioctl")
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: Axel Rasmussen <axelrasmussen@google.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 2480ba627aa5..e070b8593b37 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -6041,7 +6041,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
>         if (!huge_pte_none_mostly(huge_ptep_get(dst_pte)))
>                 goto out_release_unlock;
>
> -       if (vm_shared) {
> +       if (page_in_pagecache) {
>                 page_dup_file_rmap(page, true);
>         } else {
>                 ClearHPageRestoreReserve(page);
>
