Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01DF11A72F2
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 07:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405466AbgDNFYL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 01:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726552AbgDNFYK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 01:24:10 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 114D1C0A3BDC
        for <stable@vger.kernel.org>; Mon, 13 Apr 2020 22:24:09 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id k191so5500907pgc.13
        for <stable@vger.kernel.org>; Mon, 13 Apr 2020 22:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NbBcpNf0kcwgdYdDWjKBN5+E+CmUjuDQdss5nDQwNTs=;
        b=MBQu2b9wmdFW5zWz808EaWSexx+JTKTRg43I2TK6lNcuVScosTd5KoPsexxbzmSKf8
         J5n6YrgncN77ciAr/K6u9ybfsBSn3E/RJgX0Qg2Pj1gboxHJHWEhlIQ8YOj4TFMTMEJj
         rOGFY42cpnL2837hZB++kvoLT6hepHLJndiQw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NbBcpNf0kcwgdYdDWjKBN5+E+CmUjuDQdss5nDQwNTs=;
        b=rRMtyVkMWt7Dh1MTBZgru3ZaDfVDM3uDk7y8kFMj8fR3G3j6VxEORwT/fWPFiBtruR
         3zgvlwMU44XTxa+/XBWC9AIs09duWGeqS6Qlaj88Y2SNJ+x7Dx2p+fXvqNb40zK0R6Lq
         1Oj+4G6+WUMO/wQGdXc+Xmjs7wyB4zxjcg8YoIKdcaVi8pj/X8jI0rD/hq8Izj2kW0RE
         2GE/Je1BHp4sHc2meI4/A0tPSHfVjNwki7MGn+d+NAEVpubBiV6wGU3K4XfCK2ZGcRL1
         Wyba7HU6NnXVz8tbRn1iuq0p1TJSWkN9QwGrjmorcehB7UIZf2gIGVZrkbJ/NQnZW4R0
         9hXA==
X-Gm-Message-State: AGi0PuZKPIOPX0ldZDkGOk0B4/DZwUdktY1xANlsXNAUP5VXxA7y1sI1
        sTNwupLVeFpUOp5YTIaZJNUp2Q==
X-Google-Smtp-Source: APiQypK6r0BDULHSL0AtWQcPrK+F4gxJGou/7V3BKIDEKUe+/jpKi06QAKghsKyYau5gq+AW+PxIOg==
X-Received: by 2002:a62:6454:: with SMTP id y81mr20910395pfb.13.1586841848537;
        Mon, 13 Apr 2020 22:24:08 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id c125sm10045544pfa.142.2020.04.13.22.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 22:24:07 -0700 (PDT)
Date:   Mon, 13 Apr 2020 22:24:06 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org,
        rientjes@google.com, silvio.cesare@gmail.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: FAILED: patch "[PATCH] slub: improve bit diffusion for freelist
 ptr obfuscation" failed to apply to 4.19-stable tree
Message-ID: <202004132221.B4CC36F@keescook>
References: <1586506142226229@kroah.com>
 <20200414024025.GC1068@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414024025.GC1068@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 13, 2020 at 10:40:25PM -0400, Sasha Levin wrote:
> On Fri, Apr 10, 2020 at 10:09:02AM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > From 1ad53d9fa3f6168ebcf48a50e08b170432da2257 Mon Sep 17 00:00:00 2001
> > From: Kees Cook <keescook@chromium.org>
> > Date: Wed, 1 Apr 2020 21:04:23 -0700
> > Subject: [PATCH] slub: improve bit diffusion for freelist ptr obfuscation
> > 
> > Under CONFIG_SLAB_FREELIST_HARDENED=y, the obfuscation was relatively weak
> > in that the ptr and ptr address were usually so close that the first XOR
> > would result in an almost entirely 0-byte value[1], leaving most of the
> > "secret" number ultimately being stored after the third XOR.  A single
> > blind memory content exposure of the freelist was generally sufficient to
> > learn the secret.
> > 
> > Add a swab() call to mix bits a little more.  This is a cheap way (1
> > cycle) to make attacks need more than a single exposure to learn the
> > secret (or to know _where_ the exposure is in memory).
> > 
> > kmalloc-32 freelist walk, before:
> > 
> > ptr              ptr_addr            stored value      secret
> > ffff90c22e019020@ffff90c22e019000 is 86528eb656b3b5bd (86528eb656b3b59d)
> > ffff90c22e019040@ffff90c22e019020 is 86528eb656b3b5fd (86528eb656b3b59d)
> > ffff90c22e019060@ffff90c22e019040 is 86528eb656b3b5bd (86528eb656b3b59d)
> > ffff90c22e019080@ffff90c22e019060 is 86528eb656b3b57d (86528eb656b3b59d)
> > ffff90c22e0190a0@ffff90c22e019080 is 86528eb656b3b5bd (86528eb656b3b59d)
> > ...
> > 
> > after:
> > 
> > ptr              ptr_addr            stored value      secret
> > ffff9eed6e019020@ffff9eed6e019000 is 793d1135d52cda42 (86528eb656b3b59d)
> > ffff9eed6e019040@ffff9eed6e019020 is 593d1135d52cda22 (86528eb656b3b59d)
> > ffff9eed6e019060@ffff9eed6e019040 is 393d1135d52cda02 (86528eb656b3b59d)
> > ffff9eed6e019080@ffff9eed6e019060 is 193d1135d52cdae2 (86528eb656b3b59d)
> > ffff9eed6e0190a0@ffff9eed6e019080 is f93d1135d52cdac2 (86528eb656b3b59d)
> > 
> > [1] https://blog.infosectcbr.com.au/2020/03/weaknesses-in-linux-kernel-heap.html
> > 
> > Fixes: 2482ddec670f ("mm: add SLUB free list pointer obfuscation")
> > Reported-by: Silvio Cesare <silvio.cesare@gmail.com>
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Christoph Lameter <cl@linux.com>
> > Cc: Pekka Enberg <penberg@kernel.org>
> > Cc: David Rientjes <rientjes@google.com>
> > Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > Cc: <stable@vger.kernel.org>
> > Link: http://lkml.kernel.org/r/202003051623.AF4F8CB@keescook
> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> As previously promised, I've grabbed d5767057c9a7 ("uapi: rename
> ext2_swab() to swab() and share globally in swab.h") so that we'll have
> swab() on 4.19 and 4.14, but it wasn't enough.
> 
> There was another conflict with d36a63a943e3 ("kasan, slub: fix more
> conflicts with CONFIG_SLAB_FREELIST_HARDENED") which I've resolved by
> simply doing:
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 958a8f7a3c253..d2db6bc5e788b 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -248,7 +248,7 @@ static inline void *freelist_ptr(const struct kmem_cache *s, void *ptr,
>                                 unsigned long ptr_addr)
> {
> #ifdef CONFIG_SLAB_FREELIST_HARDENED
> -       return (void *)((unsigned long)ptr ^ s->random ^ ptr_addr);
> +       return (void *)swab((unsigned long)ptr ^ s->random ^ ptr_addr);

Eeek, no, no. The swab() must be on ptr_addr. I already sent a backport
for this to stable, see:
https://lore.kernel.org/stable/202004131001.20346EB0E7@keescook

Please use that instead.

-- 
Kees Cook
