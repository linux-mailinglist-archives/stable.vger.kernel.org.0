Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4D664F83
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 02:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbfGKAVJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jul 2019 20:21:09 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:34993 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727325AbfGKAVJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jul 2019 20:21:09 -0400
Received: by mail-yw1-f67.google.com with SMTP id g19so803959ywe.2
        for <stable@vger.kernel.org>; Wed, 10 Jul 2019 17:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7/B9CYpQdz+GAWAoUzOIHz5UY1aCmsCJS0D/uyoxcic=;
        b=QkDKDShfH/cjp6e6ikhHG8pwznCt0ta4Fm2m/9b7VSRNALP0TyVX5ETQFmvujLEkeM
         wW2bKau0ZJNzdp6Xx7OpKgofXEAEaki9haC+CH44em2dACeXnn+7sci9CJgTVz/bDSyp
         9G+7m8sn00aDKPOnHyIZ11zeqzUwkOHNW1HOuu+aufKx0PAmPug1NIoVaeskNDP6JDtm
         IRG9f7ZTMtxpA3VJhPvZw5RBjzVixMI6UCcnrhhOXiSIkH4kmnEHB4SZzDZsSkHx634a
         fiiVFuM9PqC4PkJLI/a4uKM5KgqHh0eRifSNfShHFy1akk+101NGcGl4M2mixax+fjrf
         Jtxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7/B9CYpQdz+GAWAoUzOIHz5UY1aCmsCJS0D/uyoxcic=;
        b=H2I5hbKgeGog4Pig7Pjq0CxxknCE4RREzsX0yOnpCuZ9by3fJ2XR+ZB0kFIrfPtrTf
         qy1n4PfTDpxvrVYE8wsF9M91VYPwy9eSp1aRerzgeLBw0OWb+hmpEbVEZgiGKEt2MPQD
         Ih/NTsQd/VqIQgpW8qcey1nQxgew5hN+UVuhWQk9kP3wz7LtySfQEUn0tmJ2PpzcrNEy
         nhs/hbeoP8lAxXhAj4mSsdrb+FX0NPn17KBgTpwTmp6jXOxH7pofkw+6XsKQcDTfLGh4
         Z0QEsg9OjL9TXPDqMez5duZCj5hocDXtaZxS53iKuz7YcMTI3USj4BDY7yxp/qBS2sJb
         KkIQ==
X-Gm-Message-State: APjAAAWd0t1VnSVCU2FWWx/SwJOPTEbNnUi7ZGRhafrSpfDcoiXS/4/S
        MeaoEY2D0PyRYoTEZ0iqUIz9PtbqkmYCFqYSCzFm3Q==
X-Google-Smtp-Source: APXvYqwCi1okFSDcpD98yKE8jcclXxmFpZckgytqSraEskPV/cXxeNAsHwf8PXoVC6QrSycC30s0nH2cCOPg1zreKcw=
X-Received: by 2002:a81:19c6:: with SMTP id 189mr310339ywz.296.1562804467732;
 Wed, 10 Jul 2019 17:21:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190704210640._1tth6_R-%akpm@linux-foundation.org>
In-Reply-To: <20190704210640._1tth6_R-%akpm@linux-foundation.org>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Wed, 10 Jul 2019 17:20:56 -0700
Message-ID: <CALvZod5H0DzzVJanoB0HV3M7g-7c9-nLUyv0S1USKU-VF_GS2Q@mail.gmail.com>
Subject: Re: + mm-z3foldc-lock-z3fold-page-before-__setpagemovable.patch added
 to -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Henry Burns <henryburns@google.com>,
        Jonathan Adams <jwadams@google.com>,
        mm-commits@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable@vger.kernel.org, Vitaly Vul <vitaly.vul@sony.com>,
        Vitaly Wool <vitalywool@gmail.com>,
        Xidong Wang <wangxidong_97@163.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 4, 2019 at 2:06 PM <akpm@linux-foundation.org> wrote:
>
>
> The patch titled
>      Subject: mm/z3fold.c: lock z3fold page before  __SetPageMovable()
> has been added to the -mm tree.  Its filename is
>      mm-z3foldc-lock-z3fold-page-before-__setpagemovable.patch
>
> This patch should soon appear at
>     http://ozlabs.org/~akpm/mmots/broken-out/mm-z3foldc-lock-z3fold-page-before-__setpagemovable.patch
> and later at
>     http://ozlabs.org/~akpm/mmotm/broken-out/mm-z3foldc-lock-z3fold-page-before-__setpagemovable.patch
>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
>
> ------------------------------------------------------
> From: Henry Burns <henryburns@google.com>
> Subject: mm/z3fold.c: lock z3fold page before  __SetPageMovable()
>
> Following zsmalloc.c's example we call trylock_page() and unlock_page().
> Also make z3fold_page_migrate() assert that newpage is passed in locked,
> as per the documentation.
>
> Link: http://lkml.kernel.org/r/20190702005122.41036-1-henryburns@google.com
> Link: http://lkml.kernel.org/r/20190702233538.52793-1-henryburns@google.com
> Signed-off-by: Henry Burns <henryburns@google.com>
> Suggested-by: Vitaly Wool <vitalywool@gmail.com>
> Acked-by: Vitaly Wool <vitalywool@gmail.com>
> Acked-by: David Rientjes <rientjes@google.com>
> Cc: Shakeel Butt <shakeelb@google.com>
> Cc: Vitaly Vul <vitaly.vul@sony.com>
> Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
> Cc: Xidong Wang <wangxidong_97@163.com>
> Cc: Jonathan Adams <jwadams@google.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  mm/z3fold.c |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>
> --- a/mm/z3fold.c~mm-z3foldc-lock-z3fold-page-before-__setpagemovable
> +++ a/mm/z3fold.c
> @@ -924,7 +924,16 @@ retry:
>                 set_bit(PAGE_HEADLESS, &page->private);
>                 goto headless;
>         }
> -       __SetPageMovable(page, pool->inode->i_mapping);
> +       if (can_sleep) {
> +               lock_page(page);
> +               __SetPageMovable(page, pool->inode->i_mapping);
> +               unlock_page(page);
> +       } else {
> +               if (!trylock_page(page)) {

Oops, the above should be just trylock_page() without the '!'. Andrew,
can you please fix this in-place or do you want a new version to be
posted.

> +                       __SetPageMovable(page, pool->inode->i_mapping);
> +                       unlock_page(page);
> +               }
> +       }
>         z3fold_page_lock(zhdr);
>
>  found:
> @@ -1331,6 +1340,7 @@ static int z3fold_page_migrate(struct ad
>
>         VM_BUG_ON_PAGE(!PageMovable(page), page);
>         VM_BUG_ON_PAGE(!PageIsolated(page), page);
> +       VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);
>
>         zhdr = page_address(page);
>         pool = zhdr_to_pool(zhdr);
> _
>
> Patches currently in -mm which might be from henryburns@google.com are
>
> mm-z3foldc-lock-z3fold-page-before-__setpagemovable.patch
> mm-z3fold-fix-z3fold_buddy_slots-use-after-free.patch
>
