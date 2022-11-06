Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAE0161E1B7
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 11:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiKFKqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 05:46:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbiKFKqW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 05:46:22 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE7F65D5;
        Sun,  6 Nov 2022 02:46:22 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id f5-20020a17090a4a8500b002131bb59d61so10558444pjh.1;
        Sun, 06 Nov 2022 02:46:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=d/7LW7lwY8oZ4ACHiAH4Aswn0e1LYPuf1ESlWFt5AVg=;
        b=nGhCIFW56DbH4ofS1cJb2PSk6GRFIeO3+Dhzi7S7NMo9WOgBAaEeYy11wNWusqx4/l
         xTOfj+ervuzKxBafkF/oN71uqUlyWrrfHOtmI0TeIuWfCaS38HCyBxXdx4drjJrqWt7G
         vgW2kUcjSdW2M84phs8EebVg5DmLpoXgCmGxXGCWJcSHsJBB0/wc/QP65kuDDkBxYmPI
         Ho4A0vgbfiSbLqa/9GGeJJ7xfwTz1ybvlqSnmv9tohjZrdTRm2+VYbDBXRPz22Yk4bE4
         cL8JzsGXvou28PTOXMFQjAFwgZl3PfMjicMhJwUarlPxxfo87L2JmOhVZlhKpylgOb/Z
         EYOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d/7LW7lwY8oZ4ACHiAH4Aswn0e1LYPuf1ESlWFt5AVg=;
        b=2vuJ7+pQ2tYXxITwz+EZDNvtuwuG8+kg1OQaagEWFS2wTmU8Fr7IB9ZeVgJiIoWGUQ
         Rp5RhiDWJhKE7tLJkNxdQU+0XNyLhtCLs0xdCTDIkIAKV+vrtBDlPQBDS0zfdIDxTgdw
         +WMX/htJITbWNgRkBDr31aWGWEThONV86Q5h+U6nyhD3H5y2/fQQ7XT2PT3RiqI3uoMX
         g41G+4VapmGKsUNnqj3cycwqyyHQ9mP703HN37P1CjkGI5LbtXRK+e001lS8mslAj1EJ
         O0ptxcOFqjh5oIQczRDY/jDID1c1MEUON46UKEzPO/Lb6Eyb+sGCdBkJk7GY06BgKTFj
         Rwag==
X-Gm-Message-State: ACrzQf1Qzaepx+8joT2dXgZlTrGc0LKRyzqDNHr5c+ySmiJt4UiU4Er4
        6of4I0PbMBx0bmbrSxShGWA=
X-Google-Smtp-Source: AMsMyM5Yzht930J/wG332Tukvnu/nP8d7xQg+MZzY26K16CEpClMjkoRJ9jmRJsG2OQpPQ1gTKln0A==
X-Received: by 2002:a17:902:7897:b0:178:9292:57b9 with SMTP id q23-20020a170902789700b00178929257b9mr45547569pll.102.1667731581663;
        Sun, 06 Nov 2022 02:46:21 -0800 (PST)
Received: from hyeyoo ([114.29.91.56])
        by smtp.gmail.com with ESMTPSA id a11-20020a170902eccb00b00186b7443082sm2923018plh.195.2022.11.06.02.46.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Nov 2022 02:46:20 -0800 (PST)
Date:   Sun, 6 Nov 2022 19:46:15 +0900
From:   Hyeonggon Yoo <42.hyeyoo@gmail.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] mm/slab_common: Restore passing "caller" for tracing
Message-ID: <Y2eQd365DU6Zi9wr@hyeyoo>
References: <20221105063529.never.818-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221105063529.never.818-kees@kernel.org>
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 04, 2022 at 11:35:34PM -0700, Kees Cook wrote:
> The "caller" argument was accidentally being ignored in a few places
> that were recently refactored. Restore these "caller" arguments, instead
> of _RET_IP_.
> 
> Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>

Acked-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>

> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: linux-mm@kvack.org
> Fixes: 11e9734bcb6a ("mm/slab_common: unify NUMA and UMA version of tracepoints")
> Cc: stable@vger.kernel.org


BTW I think it can be just sent to next release candidate.
The referred commit was merged in this development cycle.

> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  mm/slab_common.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 33b1886b06eb..0e614f9e7ed7 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -941,7 +941,7 @@ void *__do_kmalloc_node(size_t size, gfp_t flags, int node, unsigned long caller
>  
>  	if (unlikely(size > KMALLOC_MAX_CACHE_SIZE)) {
>  		ret = __kmalloc_large_node(size, flags, node);
> -		trace_kmalloc(_RET_IP_, ret, size,
> +		trace_kmalloc(caller, ret, size,
>  			      PAGE_SIZE << get_order(size), flags, node);
>  		return ret;
>  	}
> @@ -953,7 +953,7 @@ void *__do_kmalloc_node(size_t size, gfp_t flags, int node, unsigned long caller
>  
>  	ret = __kmem_cache_alloc_node(s, flags, node, size, caller);
>  	ret = kasan_kmalloc(s, ret, size, flags);
> -	trace_kmalloc(_RET_IP_, ret, size, s->size, flags, node);
> +	trace_kmalloc(caller, ret, size, s->size, flags, node);
>  	return ret;
>  }
>  
> -- 
> 2.34.1


Thanks for catching this!

-- 
Thanks,
Hyeonggon
