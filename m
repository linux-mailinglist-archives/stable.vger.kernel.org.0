Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83043672E3F
	for <lists+stable@lfdr.de>; Thu, 19 Jan 2023 02:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjASBeP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 20:34:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbjASBdn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 20:33:43 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8199C689C0;
        Wed, 18 Jan 2023 17:32:00 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id b6so343101pgi.7;
        Wed, 18 Jan 2023 17:32:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sXNsw7EeTEsvtWUuitnNdNylxzIxfcpGMOt+sXRhn9E=;
        b=XO5hWB8BKRMjJG9wedfW/7N0DVE/FekLVn+dMBNz4FPVa8bJzTkVEbK16AAldqY7ZP
         dLwU27QWyEvjxLusnsfaDv7f4TiWB+1avDxCO9Z4mVGCFwpQFzEuuJ3H9v+WyputLooR
         c0S9zrxG6nLwgHEKldUjynRUe3tJvvFhLlogV3NYyalCy0YWZ2ZvBdTtO+MSBNICVCdJ
         iLDOgSfZe2tWYZtbUk6oXMPZOZvhsDzG3e6R2zO4xBzniW5TaKIH3tqr68jVgjej2q1F
         3eQxFe495GvkSZo9Ol3O6Alp5E8iMhG9LK/dxb9tmaCV1xC3W4FmkGNr3DmPqEq1c3Rx
         yDEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sXNsw7EeTEsvtWUuitnNdNylxzIxfcpGMOt+sXRhn9E=;
        b=ULNT2t5072vmBWaHqGFq39usPbU0mIbkplPHhJzqEhfoTXIhef/Iz+ApsL2TYh+BBH
         tbfX4zhBoj3t5NtYX2ZCnDdwfe19Z0B8vvPU+muQg9GT3nHa8/t86byDmBdtOEA46T0u
         PM/xd5qOhw09ilfZHHSCG87MeV92vFuGFua7KHkLhaTVuTlxaExgEiddQ55bZrle7kYt
         M7b0oSiih1NcjjOZpG0gC9V5fBPa2fFq5X9359h7pGayroIG8OrBg8/i2KPmDxGIWjo4
         CtRW2lHSFIjiLghWByzJm350qHSiu5iwcKOtjLHJyvOUPfR5sDyOtdo9KrDzVe8RjkWb
         sNCg==
X-Gm-Message-State: AFqh2kqbCDCECucKSQ4U2tbluYg/jzBXqp1oLrrMfxQ52y9Asin6b2x8
        k0sTfL9Ub2SSmY/JosbrOg31HyVb4K+qj3wXm1Q=
X-Google-Smtp-Source: AMrXdXuMdPNNO7dhqyig++OSTSGJkZYkOTTr1H/oqemcMwYH6XtQmnhXS/8C2aTKsZIGBam+9OoU1jkT17oV8KUBisg=
X-Received: by 2002:a62:144a:0:b0:582:e939:183d with SMTP id
 71-20020a62144a000000b00582e939183dmr996720pfu.63.1674091919974; Wed, 18 Jan
 2023 17:31:59 -0800 (PST)
MIME-Version: 1.0
References: <20230119011537.87567C433D2@smtp.kernel.org>
In-Reply-To: <20230119011537.87567C433D2@smtp.kernel.org>
From:   Yang Shi <shy828301@gmail.com>
Date:   Wed, 18 Jan 2023 17:31:48 -0800
Message-ID: <CAHbLzkoCskH-etPT0Dbd-dxOGQUXBY8HXTF_r3oWsaHh24DpNA@mail.gmail.com>
Subject: Re: [merged mm-stable] mm-thp-check-and-bail-out-if-page-in-deferred-queue-already.patch
 removed from -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, zhengjun.xing@linux.intel.com,
        ying.huang@intel.com, willy@infradead.org, stable@vger.kernel.org,
        rientjes@google.com, riel@surriel.com, nathan@kernel.org,
        feng.tang@intel.com, fengwei.yin@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 18, 2023 at 5:15 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
>
> The quilt patch titled
>      Subject: mm/thp: check and bail out if page in deferred queue already
> has been removed from the -mm tree.  Its filename was
>      mm-thp-check-and-bail-out-if-page-in-deferred-queue-already.patch
>
> This patch was dropped because it was merged into the mm-stable branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> ------------------------------------------------------
> From: Yin Fengwei <fengwei.yin@intel.com>
> Subject: mm/thp: check and bail out if page in deferred queue already
> Date: Fri, 23 Dec 2022 21:52:07 +0800
>
> Kernel build regression with LLVM was reported here:
> https://lore.kernel.org/all/Y1GCYXGtEVZbcv%2F5@dev-arch.thelio-3990X/ with
> commit f35b5d7d676e ("mm: align larger anonymous mappings on THP
> boundaries").  And the commit f35b5d7d676e was reverted.
>
> It turned out the regression is related with madvise(MADV_DONTNEED)
> was used by ld.lld. But with none PMD_SIZE aligned parameter len.
> trace-bpfcc captured:
> 531607  531732  ld.lld          do_madvise.part.0 start: 0x7feca9000000, len: 0x7fb000, behavior: 0x4
> 531607  531793  ld.lld          do_madvise.part.0 start: 0x7fec86a00000, len: 0x7fb000, behavior: 0x4

This just reminds me that we should reinstantiate Rik's commit?

>
> If the underneath physical page is THP, the madvise(MADV_DONTNEED) can
> trigger split_queue_lock contention raised significantly. perf showed
> following data:
>     14.85%     0.00%  ld.lld           [kernel.kallsyms]           [k]
>        entry_SYSCALL_64_after_hwframe
>            11.52%
>                 entry_SYSCALL_64_after_hwframe
>                 do_syscall_64
>                 __x64_sys_madvise
>                 do_madvise.part.0
>                 zap_page_range
>                 unmap_single_vma
>                 unmap_page_range
>                 page_remove_rmap
>                 deferred_split_huge_page
>                 __lock_text_start
>                 native_queued_spin_lock_slowpath
>
> If THP can't be removed from rmap as whole THP, partial THP will be
> removed from rmap by removing sub-pages from rmap.  Even the THP head page
> is added to deferred queue already, the split_queue_lock will be acquired
> and check whether the THP head page is in the queue already.  Thus, the
> contention of split_queue_lock is raised.
>
> Before acquire split_queue_lock, check and bail out early if the THP
> head page is in the queue already. The checking without holding
> split_queue_lock could race with deferred_split_scan, but it doesn't
> impact the correctness here.
>
> Test result of building kernel with ld.lld:
> commit 7b5a0b664ebe (parent commit of f35b5d7d676e):
> time -f "\t%E real,\t%U user,\t%S sys" make LD=ld.lld -skj96 allmodconfig all
>         6:07.99 real,   26367.77 user,  5063.35 sys
>
> commit f35b5d7d676e:
> time -f "\t%E real,\t%U user,\t%S sys" make LD=ld.lld -skj96 allmodconfig all
>         7:22.15 real,   26235.03 user,  12504.55 sys
>
> commit f35b5d7d676e with the fixing patch:
> time -f "\t%E real,\t%U user,\t%S sys" make LD=ld.lld -skj96 allmodconfig all
>         6:08.49 real,   26520.15 user,  5047.91 sys
>
> Link: https://lkml.kernel.org/r/20221223135207.2275317-1-fengwei.yin@intel.com
> Signed-off-by: Yin Fengwei <fengwei.yin@intel.com>
> Tested-by: Nathan Chancellor <nathan@kernel.org>
> Acked-by: David Rientjes <rientjes@google.com>
> Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
> Cc: Feng Tang <feng.tang@intel.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Rik van Riel <riel@surriel.com>
> Cc: Xing Zhengjun <zhengjun.xing@linux.intel.com>
> Cc: Yang Shi <shy828301@gmail.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  mm/huge_memory.c |    3 +++
>  1 file changed, 3 insertions(+)
>
> --- a/mm/huge_memory.c~mm-thp-check-and-bail-out-if-page-in-deferred-queue-already
> +++ a/mm/huge_memory.c
> @@ -2835,6 +2835,9 @@ void deferred_split_huge_page(struct pag
>         if (PageSwapCache(page))
>                 return;
>
> +       if (!list_empty(page_deferred_list(page)))
> +               return;
> +
>         spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
>         if (list_empty(page_deferred_list(page))) {
>                 count_vm_event(THP_DEFERRED_SPLIT_PAGE);
> _
>
> Patches currently in -mm which might be from fengwei.yin@intel.com are
>
>
