Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1772234CD27
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 11:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhC2JgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 05:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231142AbhC2Jfu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 05:35:50 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC9AC061756
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 02:35:49 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id b7so18407690ejv.1
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 02:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ofP8ZrkKdrb2jW02UKASuGexUcGhv2J0NvhfsNoA2rw=;
        b=LWhxFew4ersP1bNrrS/NlQ7W5Wfn+B7qayH3xpRbTUpQ8/ZFI7VhGpZAoHTlpbSI9x
         4p7LvtBL4kSOJXZ+Cd9e5O04DN1347CpU8/Qggx18/vHhrxLyOJvWanTfiJo3wK0pXQe
         jXhhNPuPbJISHvJjCT3Pgu7yGZdO1Ma+27xw6nUshbKcIZEXE5GcOiuTGdXti7t2MKB0
         tUM68KaL/IUiIauovo+qemQLHynrPpjlrmalMOBwb5XCnRH2Pxd3q/a3tonUcKTW+BMN
         0HBi6osGVojmYTfxrlfjJU40cq62HaXJ7RAPPgpBN4BEbiLYElPZdM6JvTaMhcozOd9x
         sNjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ofP8ZrkKdrb2jW02UKASuGexUcGhv2J0NvhfsNoA2rw=;
        b=TpYor5euxu9I6DGWeXcY86P5S+y6CzRuDzmjgxdCFrbH12ujhtMhKGGU8geyFgZGHt
         pFCLElPcpsMZqqnFhs67x28QhVoYUcZZv1AZeAX3OMQnwRP1+7CARRB6W6WmgoUw0rCy
         y+8iFx9gyIGHYd4zoQfto0sJ5k4Os+KeZHRJZcgoCKB1vVYDBiRQQqVsOS1465ACbmi9
         lyelprLO2/SitWbJGtPeQxoj3mfYa98dczlonHGYDxVsrMRigJDDpn7kEFqvVll7D0LM
         WV8UbGfrTk37LSUavZCXv49I9mtAEzjIbqM/v2qFvGysX8M2rXb9M3GNhkozXefZ3dpS
         hRRw==
X-Gm-Message-State: AOAM531NQSmFJEkjsMObRRb/EgvJxgjS0/cwcnX4nqOTcrRwfUlIeAQg
        Wzh+RkI6pLAMVtqyrbovMLHGMi3TvFNoZlVx3L8DVERiAYxAwZ3M
X-Google-Smtp-Source: ABdhPJzeKGOpzQe8OSdOFHA+TWaSykrMP4h6yj9CHmlZ7q7eF7+gw/6ai54C/CvIxbfcszi3ibuCpUW50QCMakOQAqA=
X-Received: by 2002:a17:907:720a:: with SMTP id dr10mr27144667ejc.375.1617010537417;
 Mon, 29 Mar 2021 02:35:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210329075633.135869143@linuxfoundation.org> <20210329075640.480623043@linuxfoundation.org>
In-Reply-To: <20210329075640.480623043@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 29 Mar 2021 15:05:25 +0530
Message-ID: <CA+G9fYvHsa0TAqPBvHwPhhe_0qt8syEWkGV_GPjOyEOAO9q5Sw@mail.gmail.com>
Subject: Re: [PATCH 5.11 225/254] arm64/mm: define arch_get_mappable_range()
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Jason Wang <jasowang@redhat.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Michal Hocko <mhocko@kernel.org>,
        Oscar Salvador <osalvador@suse.de>,
        Pankaj Gupta <pankaj.gupta@cloud.ionos.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        teawater <teawaterz@linux.alibaba.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Wei Yang <richard.weiyang@linux.alibaba.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 29 Mar 2021 at 14:10, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Anshuman Khandual <anshuman.khandual@arm.com>
>
> [ Upstream commit 03aaf83fba6e5af08b5dd174c72edee9b7d9ed9b ]
>
> This overrides arch_get_mappable_range() on arm64 platform which will be
> used with recently added generic framework.  It drops
> inside_linear_region() and subsequent check in arch_add_memory() which are
> no longer required.  It also adds a VM_BUG_ON() check that would ensure
> that mhp_range_allowed() has already been called.
>
> Link: https://lkml.kernel.org/r/1612149902-7867-3-git-send-email-anshuman.khandual@arm.com
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
> Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
> Cc: teawater <teawaterz@linux.alibaba.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/arm64/mm/mmu.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 6f0648777d34..92b3be127796 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -1443,16 +1443,19 @@ static void __remove_pgd_mapping(pgd_t *pgdir, unsigned long start, u64 size)
>         free_empty_tables(start, end, PAGE_OFFSET, PAGE_END);
>  }
>
> -static bool inside_linear_region(u64 start, u64 size)
> +struct range arch_get_mappable_range(void)
>  {
> +       struct range mhp_range;
> +
>         /*
>          * Linear mapping region is the range [PAGE_OFFSET..(PAGE_END - 1)]
>          * accommodating both its ends but excluding PAGE_END. Max physical
>          * range which can be mapped inside this linear mapping range, must
>          * also be derived from its end points.
>          */
> -       return start >= __pa(_PAGE_OFFSET(vabits_actual)) &&
> -              (start + size - 1) <= __pa(PAGE_END - 1);
> +       mhp_range.start = __pa(_PAGE_OFFSET(vabits_actual));
> +       mhp_range.end =  __pa(PAGE_END - 1);
> +       return mhp_range;
>  }
>
>  int arch_add_memory(int nid, u64 start, u64 size,
> @@ -1460,11 +1463,7 @@ int arch_add_memory(int nid, u64 start, u64 size,
>  {
>         int ret, flags = 0;
>
> -       if (!inside_linear_region(start, size)) {
> -               pr_err("[%llx %llx] is outside linear mapping region\n", start, start + size);
> -               return -EINVAL;
> -       }
> -
> +       VM_BUG_ON(!mhp_range_allowed(start, size, true));
>         if (rodata_full || debug_pagealloc_enabled())
>                 flags = NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;

The stable rc 5.10 and 5.11 builds failed for arm64 architecture
due to below warnings / errors,

> Anshuman Khandual <anshuman.khandual@arm.com>
>     arm64/mm: define arch_get_mappable_range()


  arch/arm64/mm/mmu.c: In function 'arch_add_memory':
  arch/arm64/mm/mmu.c:1483:13: error: implicit declaration of function
'mhp_range_allowed'; did you mean 'cpu_map_prog_allowed'?
[-Werror=implicit-function-declaration]
    VM_BUG_ON(!mhp_range_allowed(start, size, true));
               ^
  include/linux/build_bug.h:30:63: note: in definition of macro
'BUILD_BUG_ON_INVALID'
   #define BUILD_BUG_ON_INVALID(e) ((void)(sizeof((__force long)(e))))
                                                                 ^
  arch/arm64/mm/mmu.c:1483:2: note: in expansion of macro 'VM_BUG_ON'
    VM_BUG_ON(!mhp_range_allowed(start, size, true));
    ^~~~~~~~~

Build link,
https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5.11/DISTRO=lkft,MACHINE=juno,label=docker-buster-lkft/41/consoleText
https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5.10/DISTRO=lkft,MACHINE=dragonboard-410c,label=docker-buster-lkft/120/consoleFull

--
Linaro LKFT
https://lkft.linaro.org
