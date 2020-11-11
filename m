Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBEB22AF412
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 15:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgKKOwq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Nov 2020 09:52:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgKKOwq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Nov 2020 09:52:46 -0500
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F567C0613D1;
        Wed, 11 Nov 2020 06:52:45 -0800 (PST)
Received: by mail-lj1-x242.google.com with SMTP id x9so2388462ljc.7;
        Wed, 11 Nov 2020 06:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iqXzG4nSzYlFe8ERET+8xQRhF1wCxB96YJaw1rg7Nak=;
        b=GFqiS60DyrCfM1v2COjz1L8aPOKbkFCZMxXXwNmGs56gUSPDHLYHHVxCG1WOcOA0r/
         zJ67aEtqoGmaNU8183/2qa2hft+O6C9tJRgq4idjTDzKPAsKerSkA8Lfc+xiRpZKV4IM
         5FoPU9NIceR+zbrHauVmDhemtQyDJRbXh/26ffgNANVvLFgCbF1bMm5xIsyzNYXGvuz1
         Az0bZzh0IfppnuDQo27Sui6kXfskC179909Vlpf36CqfI6spQ1F9megy1EihZwEd89Ze
         c/BO2w/VQcWj44skVBFQ16U8Z+CB0+S8vsjBlPIbZBaIXPJC4IjzKP5yUBTQV7fISN+V
         +pPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iqXzG4nSzYlFe8ERET+8xQRhF1wCxB96YJaw1rg7Nak=;
        b=qMTVGsUb+0G10vL7Rm5CsWpJpmEkJp2TYdkIuBUQx0MRHXEHvo/em7eGyICvtKpoP/
         g2J4449aAPy68ZvgGCzvWmDnRbnYvmL8aU4ZF8VfQ4LSixJ+PeXZHREVpcbElSi97w2e
         o1VRjRukfQNNUmhFOC5P0wpeQwTobjCqGwPUVZ4iJNof1dkK4B6AJfVEKhGdx0p0r3yt
         qancldqZV68tlOyuL0gGOTH9YeNMj6Is971TsxeryouuyE5v/v7QvKmdUZqXly4F7+Jz
         KqbXeW3AXMSRHSi16VfM1bK+PSyuXlKS+CPjNqQXBWolarxATDrrnPYxpmps5NU1YeyS
         oRSw==
X-Gm-Message-State: AOAM532DC2iqrPmUsHstFcGFVX9keTt1oRHNNsu/qIoAWml1xLHt0TE7
        FX4xVqvzppM4X40Wx5HmNKM=
X-Google-Smtp-Source: ABdhPJz7uS4/+RqawyJ4T9Xx5mM/wUT99cm10QHAEiN6poWT/wUAcN5U8iRqye6ZakFOdBzTtYei1Q==
X-Received: by 2002:a05:651c:95:: with SMTP id 21mr9979022ljq.307.1605106363632;
        Wed, 11 Nov 2020 06:52:43 -0800 (PST)
Received: from mobilestation ([95.79.141.114])
        by smtp.gmail.com with ESMTPSA id k3sm238958lfd.245.2020.11.11.06.52.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 06:52:43 -0800 (PST)
Date:   Wed, 11 Nov 2020 17:52:40 +0300
From:   Serge Semin <fancer.lancer@gmail.com>
To:     Alexander Sverdlin <alexander.sverdlin@nokia.com>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        linux-mips@vger.kernel.org, Paul Burton <paulburton@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] MIPS: reserve the memblock right after the kernel
Message-ID: <20201111145240.lok3q5g3pgcvknqr@mobilestation>
References: <20201106141001.57637-1-alexander.sverdlin@nokia.com>
 <20201107094028.GA4918@alpha.franken.de>
 <1d6a424e-944e-7f21-1f30-989fb61018a8@nokia.com>
 <20201110095503.GA10357@alpha.franken.de>
 <c435b3df-4e82-7c10-366a-5a3d1543c73f@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c435b3df-4e82-7c10-366a-5a3d1543c73f@nokia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Alexander

On Tue, Nov 10, 2020 at 11:29:50AM +0100, Alexander Sverdlin wrote:
> Hello Thomas,
> 
> On 10/11/2020 10:55, Thomas Bogendoerfer wrote:
> >>>> Linux doesn't own the memory immediately after the kernel image. On Octeon
> >>>> bootloader places a shared structure right close after the kernel _end,
> >>>> refer to "struct cvmx_bootinfo *octeon_bootinfo" in cavium-octeon/setup.c.
> >>>>
> >>>> If check_kernel_sections_mem() rounds the PFNs up, first memblock_alloc()
> >>>> inside early_init_dt_alloc_memory_arch() <= device_tree_init() returns
> >>>> memory block overlapping with the above octeon_bootinfo structure, which
> >>>> is being overwritten afterwards.
> >>> as this special for Octeon how about added the memblock_reserve
> >>> in octen specific code ?
> >> while the shared structure which is being corrupted is indeed Octeon-specific,
> >> the wrong assumption that the memory right after the kernel can be allocated by memblock
> >> allocator and re-used somewhere in Linux is in MIPS-generic check_kernel_sections_mem().
> > ok, I see your point. IMHO this whole check_kernel_sections_mem() should
> > be removed. IMHO memory adding should only be done my memory detection code.
> > 
> > Could you send a patch, which removes check_kernel_section_mem completly ?
> 

> this will expose one issue:
> platforms usually do it in a sane way, like it was done last 15 years, namely
> add kernel image without non-complete pages on the boundaries.
> This will lead to the situation, that request_resource() will fail at least
> for .bss section of the kernel and it will not be properly displayed under
> /proc/iomem (and probably same problem will appear, which initially motivated
> the creation of check_kernel_section_mem()).

Are you saying that some old platforms rely on the
check_kernel_section_mem() method adding the memory occupied by the
kernel to the system? If so, do you have an example of such?

Personally I also had my hand itching to remove that method years ago,
but I didn't dare to do so for the same reason in mind... On the other
hand if we detected all the platforms that needed that method, we could
have moved it to their prom_init() or something and got rid of that
atavism for good.

> 
> As I understood, the issue is that memblock API operates internally on the
> page granularity (at least there are many ROUND_DOWN() inside for the size
> or upper boundary),

Hm, I don't think so. Memblock doesn't work with the pages granularity,
but with memory ranges. round_down()/round_up() are used to find a memory
range with proper alignment. (See __memblock_find_range_top_{up,down}()
method implementation.)

Memblock allocates a memory region with exact size and alignment as
requested. That's the beauty of that allocator and one of the reasons
why the kernel platforms have been painfully converted to using it instead
of the old bootmem allocator. BTW the later one has indeed operated
with page granularity.

Getting back to the memblock allocator. It works with pages only when
the kernel comes to starting the buddy allocator. So the kernel
invokes memblock_free_all(), which eventually gets to calling
free_low_memory_core_early()->__free_memory_core(). The later method indeed
sets the memory pages free, but as you can see it's done with correct
aligning PFN_UP(phys_start)/PFN_DOWN(end).

> so for request_resource() to success one has to claim
> the rest of the .bss last page. And with current memblock API
> memblock_reserve() must appear somewhere, being this ARCH or platform code.

After a short glance at the request_resource() code I didn't manage to
find a reason why the method would fail to request a page-unaligned
region. AFAICS it will fail only if the memory occupied by the kernel
hasn't been registered as system memory. The later case may happen
only for the systems which rely on the check_kernel_section_mem()
method being called in the generic arch_mem_init(). Of course we
shouldn't blindly have it removed, but instead move it to the
platforms, which have been unfortunate enough not to add the kernel
memory to the system memory pool.

So IMHO what could be the best conclusion in the framework of this patch:
1) As Thomas said any platform-specific reservation should be done in the
platform-specific code. That means if octeon needs some memory behind
the kernel being reserved, then it should be done for example in
prom_init().
2) The check_kernel_sections_mem() method can be removed. But it
should be done carefully. We at least need to try to find all the
platforms, which rely on its functionality.

-Sergey

> 
> -- 
> Best regards,
> Alexander Sverdlin.
