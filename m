Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 865163B7969
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 22:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234700AbhF2UgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 16:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235165AbhF2Uf6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 16:35:58 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A373C061760
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 13:33:30 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id v5-20020a0568301bc5b029045c06b14f83so75650ota.13
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 13:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=u4TayqLw9Ab8ZNZudCgXF+JcfRv6nZ7ESeD+imDOgI0=;
        b=hRnT5JnmqK0Js1gJbi/VZrOf/qnGmrmggPyEsLJgvFTcZYvqayEWSHk/vf7AtAfU4R
         LMhM9s0Z33lAZ3RUOuVWroIWvktB3SjcTNxMZz7e876A2jny0E1+H1IfTypqVruxsBiL
         WN/MUpmX83AyFxJ5SfjGtZZQ/1rvSEgkuYEuW3tfaqBaQV7CzaZlM9bb9JQVzXh5WLbs
         xik6Q2DWHy1uZgbpxmm4SK6FPNXcKZ/tTDmZIPZQZlo6UPYOLccxqYOhUHIVJ+2lz5gO
         kDcbVLBL2XW0c2gBwOAMV0kzeMflcPnatWkyIAsztT8cI/S1yjX8KfWdYhdU8Rq/96nf
         B2Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=u4TayqLw9Ab8ZNZudCgXF+JcfRv6nZ7ESeD+imDOgI0=;
        b=PLQB1C2iCtgU/EznyXYxgBjwsM2FP7DS+/7+PBX6zjdpi4dpTckrdx2GH0LrZM7df6
         Y0Djf0ls2re9Tw45CtLGrh+QpBSBUmcWBT2pJmxm84IvRmVGq9g85kXFdWVuy35RGIhn
         fuTYWjPoHXI2QgTVo9mz25M52/Efa2RRPAJQEmZPjZU922EOyYcVzkZntsJ7wfIEo5x/
         qMATx5nNZsF90JEk4IF7VwR86QqYy/jmK2RKLe3DsYqqNs2JLP3DZ1xQsixgSqPtuc9Z
         YFFhknIjzNwl808Zyu1W+2Rx/u1p1XCWHLtKDI/A/WPEjLQsthUZw/XFmFsfb6NFM6QH
         Tb9w==
X-Gm-Message-State: AOAM532ILJ812J+QKjIa6Jxf9G7kMoxzAwOhM2z/ZhY5nSPJrXwcKrfH
        TB9x3/iaeNNh6xUJB/lYH4ZIZQ==
X-Google-Smtp-Source: ABdhPJxXAKy/Aajc2eGDGTBRnIYskO73VMTc5iUB30PJ2Q84AmKRYzHOs3hFLUcEuwXW6OtFdxk+vQ==
X-Received: by 2002:a05:6830:17d5:: with SMTP id p21mr6151414ota.104.1624998809385;
        Tue, 29 Jun 2021 13:33:29 -0700 (PDT)
Received: from ripple.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id x17sm2361159otp.48.2021.06.29.13.33.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 13:33:28 -0700 (PDT)
Date:   Tue, 29 Jun 2021 13:33:14 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@ripple.anvils
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     Nick Hu <nickhu@andestech.com>, Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        iLifetruth <yixiaonn@gmail.com>, Michal Hocko <mhocko@suse.com>,
        Hugh Dickins <hughd@google.com>,
        Qiang Liu <cyruscyliu@gmail.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] nds32: fix up stack guard gap
In-Reply-To: <20210629104024.2293615-1-gregkh@linuxfoundation.org>
Message-ID: <382e353f-7489-d8c8-5711-a2d99b0b7f0@google.com>
References: <20210629104024.2293615-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 29 Jun 2021, Greg Kroah-Hartman wrote:

> Commit 1be7107fbe18 ("mm: larger stack guard gap, between vmas") fixed
> up almost all architectures to deal with the stack guard gap, but forgit
> nds32.
> 
> Resolve this by properly fixing up the nsd32's version of
> arch_get_unmapped_area()
> 
> Reported-by: iLifetruth <yixiaonn@gmail.com>
> Cc: Nick Hu <nickhu@andestech.com>
> Cc: Greentime Hu <green.hu@gmail.com>
> Cc: Vincent Chen <deanbo422@gmail.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Qiang Liu <cyruscyliu@gmail.com>
> Cc: stable <stable@vger.kernel.org>
> Fixes: 1be7107fbe18 ("mm: larger stack guard gap, between vmas")
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Hugh Dickins <hughd@google.com>

but it's a bit unfair to say that commit forgot nds32:
nds32 came into the tree nearly a year later.

> ---
>  arch/nds32/mm/mmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/nds32/mm/mmap.c b/arch/nds32/mm/mmap.c
> index c206b31ce07a..1bdf5e7d1b43 100644
> --- a/arch/nds32/mm/mmap.c
> +++ b/arch/nds32/mm/mmap.c
> @@ -59,7 +59,7 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
>  
>  		vma = find_vma(mm, addr);
>  		if (TASK_SIZE - len >= addr &&
> -		    (!vma || addr + len <= vma->vm_start))
> +		    (!vma || addr + len <= vm_start_gap(vma)))
>  			return addr;
>  	}
>  
> -- 
> 2.32.0
> 
> 
