Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D2A2D6422
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 18:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392935AbgLJRy3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 12:54:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392178AbgLJRyZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 12:54:25 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64BC6C0613CF
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 09:53:45 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id q22so4798256pfk.12
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 09:53:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=G4hUloSQ1uQEQVeNiYcMiD6uCkefrUn6s2yR1vrm4IA=;
        b=KFa74gTQMPUdpakVO9A2B2hGnYzp+hXxTrHtYe94CVkOwC4T0gmeZYB4fh2sqFv5cz
         YWb17tIXVdnG9mgYyTjW8Tgru9PxmFBJFtIIslm65MvOSHAMfH2BKRQUYmYat9UWMAgF
         Akwj1wVUmZMzJYEj+s1x8IcUvXdb3UcJsoYrCefAENvO6Bmp6P7COsHb+pz28CVyYnPR
         cZmeDkUCc/5t3dqYLCszMXjKQZbWbFM1BbvN9BSpJuZYjMmMoE2zYkmBrhDh/lNL14Uf
         rZPbJ1LLRpTgnUbr3saTa0hTzTniZcBeJDjsrE6soR/fNMpt7xLqBMumi+R5JcvAyLYi
         D6Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=G4hUloSQ1uQEQVeNiYcMiD6uCkefrUn6s2yR1vrm4IA=;
        b=U+UuNIWnJAGDns9xVBc565WaW44WLrUQUvRE3GL7MCfnczHxA5vx9oESQJLexQVnYv
         6Lx72rOdo0pjCFiEy6fRPHvHHVLkqC/dSlwyLJrt9wUkmCg4yO3QvCjpAmjN6c88sZmD
         ok5SgVw25mvXjCeHHrzdxOGisDg0p94MLGdCYQsC4jKBdamMVGOTLecpQEpuyR8MV7NW
         bySnkaNISHZRWpH/AF+KSkJzxTY/JUHvO5knUWEOfjCPYLgSS0B1fAYVAByxUBXt+X9q
         oZ/dSJZQzka2rGsWTE4VoO1jAh9An+oEm9yG4BhqyfVrfMLrfLrXvEuT/r1S9D2qEuBz
         Emsg==
X-Gm-Message-State: AOAM533i/AeRAmCbCv2dlU4+LZWXg40V3VSNukjb75k3+NLk6uCkvqFG
        bMyPYWAvvtSSAiMkCge9rQTBOz/6880=
X-Google-Smtp-Source: ABdhPJw2PF3ijuQODLvCWMGgOSYZUGCgg7Noqn6XxaybthIIabaSokloTV6DGuMentaB/uJe1U9HMg==
X-Received: by 2002:a17:90a:730b:: with SMTP id m11mr4480422pjk.76.1607622824942;
        Thu, 10 Dec 2020 09:53:44 -0800 (PST)
Received: from google.com ([2620:15c:211:201:7220:84ff:fe09:5e58])
        by smtp.gmail.com with ESMTPSA id b11sm7105138pjl.41.2020.12.10.09.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 09:53:44 -0800 (PST)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date:   Thu, 10 Dec 2020 09:53:42 -0800
From:   Minchan Kim <minchan@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     akpm@linux-foundation.org, harish@linux.ibm.com, hch@infradead.org,
        sergey.senozhatsky@gmail.com, stable@vger.kernel.org,
        tony@atomide.com, torvalds@linux-foundation.org, urezki@gmail.com
Subject: Re: FAILED: patch "[PATCH] mm/zsmalloc.c: drop
 ZSMALLOC_PGTABLE_MAPPING" failed to apply to 5.4-stable tree
Message-ID: <X9JgpjCx9CDIt8ye@google.com>
References: <160750482424034@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160750482424034@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 09, 2020 at 10:07:04AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From e91d8d78237de8d7120c320b3645b7100848f24d Mon Sep 17 00:00:00 2001
> From: Minchan Kim <minchan@kernel.org>
> Date: Sat, 5 Dec 2020 22:14:51 -0800
> Subject: [PATCH] mm/zsmalloc.c: drop ZSMALLOC_PGTABLE_MAPPING
> 
> While I was doing zram testing, I found sometimes decompression failed
> since the compression buffer was corrupted.  With investigation, I found
> below commit calls cond_resched unconditionally so it could make a
> problem in atomic context if the task is reschedule.
> 
>   BUG: sleeping function called from invalid context at mm/vmalloc.c:108
>   in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 946, name: memhog
>   3 locks held by memhog/946:
>    #0: ffff9d01d4b193e8 (&mm->mmap_lock#2){++++}-{4:4}, at: __mm_populate+0x103/0x160
>    #1: ffffffffa3d53de0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0xa98/0x1160
>    #2: ffff9d01d56b8110 (&zspage->lock){.+.+}-{3:3}, at: zs_map_object+0x8e/0x1f0
>   CPU: 0 PID: 946 Comm: memhog Not tainted 5.9.3-00011-gc5bfc0287345-dirty #316
>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1 04/01/2014
>   Call Trace:
>     unmap_kernel_range_noflush+0x2eb/0x350
>     unmap_kernel_range+0x14/0x30
>     zs_unmap_object+0xd5/0xe0
>     zram_bvec_rw.isra.0+0x38c/0x8e0
>     zram_rw_page+0x90/0x101
>     bdev_write_page+0x92/0xe0
>     __swap_writepage+0x94/0x4a0
>     pageout+0xe3/0x3a0
>     shrink_page_list+0xb94/0xd60
>     shrink_inactive_list+0x158/0x460
> 
> We can fix this by removing the ZSMALLOC_PGTABLE_MAPPING feature (which
> contains the offending calling code) from zsmalloc.
> 
> Even though this option showed some amount improvement(e.g., 30%) in
> some arm32 platforms, it has been headache to maintain since it have
> abused APIs[1](e.g., unmap_kernel_range in atomic context).
> 
> Since we are approaching to deprecate 32bit machines and already made
> the config option available for only builtin build since v5.8, lastly it
> has been not default option in zsmalloc, it's time to drop the option
> for better maintenance.
> 
> [1] http://lore.kernel.org/linux-mm/20201105170249.387069-1-minchan@kernel.org
> 
> Fixes: e47110e90584 ("mm/vunmap: add cond_resched() in vunmap_pmd_range")

This patch fixex e47110e90584 which merged at v5.9 so we could drop it
for v5.4.

Thanks.
