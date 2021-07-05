Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9CE83BBDFB
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 16:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbhGEOIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 10:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbhGEOIm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 10:08:42 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26638C061574
        for <stable@vger.kernel.org>; Mon,  5 Jul 2021 07:06:04 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id t17so32787781lfq.0
        for <stable@vger.kernel.org>; Mon, 05 Jul 2021 07:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ORehuuFLRHngj4BfeJzGKp4s1pOaJxbH1Vm9Xu/XC1M=;
        b=Su+vopsmQhtsd2F1gNDaJSmu0WVcyTt0V1ibrc+uIbCRi+M/8PgO/A8D33Mz9mH7T0
         WQhn3iPeWexedTFUx+5vPk36vhAmp5v3wDJF/J3S/dc3CHjxh44cDT5PMhkWGoctey6V
         sJ0Z1qkOWM/b8ZNMowf/6Q/+q7xSEquYKtkOWoMAx22KY7uSValdpJz0S0D8EKYhTest
         k3VFZw8ZC+mxdmoa233hZg7Js72bSQ1+GbV/TWv17ILcGlY21TFoWJKsyI3Kn2j2Vzeo
         wQTmxIRqLsEjlKksrZpUEvKGSDumv4qWN7+nzlU2cNrmQMKiNgWCkecWcYnjzrw9DUUd
         rrIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ORehuuFLRHngj4BfeJzGKp4s1pOaJxbH1Vm9Xu/XC1M=;
        b=fGUxxTd7MNbKRvPR5RdUoWUraQdOtT236BV4QamRS+hm+Em+qQqQbmtRsB0LD15GIU
         h4XD9KW9t4G+AifnZ8YhC0nvqg+O/bvZsuy9ZPQxkvQUp0iatFQGqbZq6kUnlriLaLfs
         3Rxn3RlU6ZE08IPU0Q2yCETI5ZDvTMUOWoJQRJMr5emZrN5/LjtyUTBhUauxvwLs17AY
         q4bATYFV/f1FM3SO385+ySWZAki6Cq86EbiI3lcahkN1cOmp6WwFmrHvw0JWtoVyHl/2
         ulxSuv+cVqv/RJXQk4o+cct2UsQ6Y7nQHSnsZfvCQyOOCEGSXpxXvf58epUtNg0PMQtP
         JpLA==
X-Gm-Message-State: AOAM533O8qjO5S0wB3BqoYvYMbZkhuOY9uWkRUgJkATssvFUcoON4QBZ
        41NyLqtPaTWHgU+REoVvD+3ePwBjfbR0iTI0Os7tqw==
X-Google-Smtp-Source: ABdhPJxO3WGhVkYE+IFwo0w2hNQzHQTiWFMbNaD9/SY9x6NZGtxADqLJ23zQaYzEHXrl3SZ9Nzs6/lax2vxYqskyGYU=
X-Received: by 2002:a19:6803:: with SMTP id d3mr10752593lfc.235.1625493962095;
 Mon, 05 Jul 2021 07:06:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210630150234.1109496-1-glider@google.com> <20210630150234.1109496-2-glider@google.com>
In-Reply-To: <20210630150234.1109496-2-glider@google.com>
From:   Marco Elver <elver@google.com>
Date:   Mon, 5 Jul 2021 16:05:50 +0200
Message-ID: <CANpmjNNvBWER=zjie544Eq6o_ZSMD6rDYb7mqDcUFtYutDSpWw@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] kfence: skip all GFP_ZONEMASK allocations
To:     akpm@linux-foundation.org
Cc:     dvyukov@google.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org,
        gregkh@linuxfoundation.org, jrdr.linux@gmail.com,
        Alexander Potapenko <glider@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Andrew,

This series is ready to be picked up.

If possible, kindly consider including it in an upcoming batch of
mainline fixes.

Thank you!


On Wed, 30 Jun 2021 at 17:02, Alexander Potapenko <glider@google.com> wrote:
> Allocation requests outside ZONE_NORMAL (MOVABLE, HIGHMEM or DMA) cannot
> be fulfilled by KFENCE, because KFENCE memory pool is located in a
> zone different from the requested one.
>
> Because callers of kmem_cache_alloc() may actually rely on the
> allocation to reside in the requested zone (e.g. memory allocations done
> with __GFP_DMA must be DMAable), skip all allocations done with
> GFP_ZONEMASK and/or respective SLAB flags (SLAB_CACHE_DMA and
> SLAB_CACHE_DMA32).
>
> Fixes: 0ce20dd84089 ("mm: add Kernel Electric-Fence infrastructure")
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Marco Elver <elver@google.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Souptick Joarder <jrdr.linux@gmail.com>
> Cc: stable@vger.kernel.org # 5.12+
> Signed-off-by: Alexander Potapenko <glider@google.com>
> Reviewed-by: Marco Elver <elver@google.com>
>
> ---
>
> v2:
>  - added parentheses around the GFP clause, as requested by Marco
> v3:
>  - ignore GFP_ZONEMASK, which also covers __GFP_HIGHMEM and __GFP_MOVABLE
>  - move the flag check at the beginning of the function, as requested by
>    Souptick Joarder
> v4:
>  - minor fixes to description and comment formatting
> ---
>  mm/kfence/core.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/mm/kfence/core.c b/mm/kfence/core.c
> index 33bb20d91bf6a..1cbdb62e6d0fb 100644
> --- a/mm/kfence/core.c
> +++ b/mm/kfence/core.c
> @@ -740,6 +740,15 @@ void *__kfence_alloc(struct kmem_cache *s, size_t size, gfp_t flags)
>         if (size > PAGE_SIZE)
>                 return NULL;
>
> +       /*
> +        * Skip allocations from non-default zones, including DMA. We cannot
> +        * guarantee that pages in the KFENCE pool will have the requested
> +        * properties (e.g. reside in DMAable memory).
> +        */
> +       if ((flags & GFP_ZONEMASK) ||
> +           (s->flags & (SLAB_CACHE_DMA | SLAB_CACHE_DMA32)))
> +               return NULL;
> +
>         /*
>          * allocation_gate only needs to become non-zero, so it doesn't make
>          * sense to continue writing to it and pay the associated contention
> --
> 2.32.0.93.g670b81a890-goog
>
