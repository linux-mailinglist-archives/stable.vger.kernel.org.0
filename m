Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D58728EB04
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 04:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729168AbgJOCOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 22:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbgJOCOh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Oct 2020 22:14:37 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813AAC05BD1A;
        Wed, 14 Oct 2020 15:36:58 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id r127so1212313lff.12;
        Wed, 14 Oct 2020 15:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BAhqLujKs3qvyU8mzyTrRxpaREp3Hw9vVWDBSKjqLnY=;
        b=BUGxB1YA65cmz4OJ8kyPkuDCA+/Ycreilwo3cOCS4XMMcq6n+qcAHHm1nkgzJoV8kI
         yxX6QTeZaUR+Kx7wqY2c30nPWaIV2Kov4qwGa4+p3V+X5ac9NuPgHOxlXHoOJxZDIsBl
         yXUZpvZMtszcu5IWa4C+OfWnMQ354z9wlZ50kUZRh0H9JPLjATjcIoRTIadynuMj5enM
         ABX49FKBmhAws+/g+5SphWYG7J69jz8A6BK23XKQhTdAwjpb5C6Bx69fORFnHqzoj0ZQ
         WM3Gbu/IqKWl8gnX829aiUeSewYwyt3rB+aIZ8jTAIn7KdJLfnwjoVvCxcQLgBnWf3hC
         /14Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BAhqLujKs3qvyU8mzyTrRxpaREp3Hw9vVWDBSKjqLnY=;
        b=VpQCEGBzTTPJCknqQygHvnGHQ2QdoeIvAyEaT7GzHRNTu7Jo4/tem1/sNIERtB8UOG
         l5QhuI0LFIzVhuGMlqBc+naW1t//EHMjmqbCCq4/XH4uNOVPC6Q7LL5PlvgMUQpPh7HO
         yricARks8mptS7IzaG7mkqbytvqMJBM8v9DFMeuDUBUL0Dl3WJKwKQiQrYmlwtOKa2Ot
         JHqUtDu8oX1oWw07EVrhJQL9PvUcJF9nJ+l1ZJvM/Vq4vJDyP0d4mXyYLy/rdpsThflQ
         tDY+xQKhUb+mDOZpeEl2iYsitymc8/CwTtK95SNYeGM2nioQ7xRdSIvsNNCb/RtPs/q4
         zYdQ==
X-Gm-Message-State: AOAM5330cdUjkTuUd/Q/deJl91SJ4z5rMPcfmPzKlBu8qBwl5V6QpscP
        K7qK91HdBw6vDkyjolcD2wRB8GLA5U0=
X-Google-Smtp-Source: ABdhPJxZisFbSGvURTBfOCD9EDQlBYtk/KEGQrFQGMEtiQdtgCqp/S/vrha8NPgrelxcV8hOJ2zN3g==
X-Received: by 2002:a19:84d5:: with SMTP id g204mr78148lfd.194.1602715016908;
        Wed, 14 Oct 2020 15:36:56 -0700 (PDT)
Received: from mobilestation ([95.79.141.114])
        by smtp.gmail.com with ESMTPSA id e73sm245572lfd.199.2020.10.14.15.36.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 15:36:56 -0700 (PDT)
Date:   Thu, 15 Oct 2020 01:36:54 +0300
From:   Serge Semin <fancer.lancer@gmail.com>
To:     "Maciej W. Rozycki" <macro@linux-mips.org>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] MIPS: DEC: Restore bootmem reservation for firmware
 working memory area
Message-ID: <20201014223654.rntqmnrxldxovf3u@mobilestation>
References: <alpine.LFD.2.21.2010142230090.866917@eddie.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.21.2010142230090.866917@eddie.linux-mips.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Maciej,
Regardless of a comment below feel free to add:
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>

On Wed, Oct 14, 2020 at 10:34:56PM +0100, Maciej W. Rozycki wrote:
> Fix a crash on DEC platforms starting with:
> 
> VFS: Mounted root (nfs filesystem) on device 0:11.
> Freeing unused PROM memory: 124k freed
> BUG: Bad page state in process swapper  pfn:00001
> page:(ptrval) refcount:0 mapcount:-128 mapping:00000000 index:0x1 pfn:0x1
> flags: 0x0()
> raw: 00000000 00000100 00000122 00000000 00000001 00000000 ffffff7f 00000000
> page dumped because: nonzero mapcount
> Modules linked in:
> CPU: 0 PID: 1 Comm: swapper Not tainted 5.9.0-00858-g865c50e1d279 #1
> Stack : 8065dc48 0000000b 8065d2b8 9bc27dcc 80645bfc 9bc259a4 806a1b97 80703124
>         80710000 8064a900 00000001 80099574 806b116c 1000ec00 9bc27d88 806a6f30
>         00000000 00000000 80645bfc 00000000 31232039 80706ba4 2e392e35 8039f348
>         2d383538 00000070 0000000a 35363867 00000000 806c2830 80710000 806b0000
>         80710000 8064a900 00000001 81000000 00000000 00000000 8035af2c 80700000
>         ...
> Call Trace:
> [<8004bc5c>] show_stack+0x34/0x104
> [<8015675c>] bad_page+0xfc/0x128
> [<80157714>] free_pcppages_bulk+0x1f4/0x5dc
> [<801591cc>] free_unref_page+0xc0/0x130
> [<8015cb04>] free_reserved_area+0x144/0x1d8
> [<805abd78>] kernel_init+0x20/0x100
> [<80046070>] ret_from_kernel_thread+0x14/0x1c
> Disabling lock debugging due to kernel taint
> 
> caused by an attempt to free bootmem space that as from commit 
> b93ddc4f9156 ("mips: Reserve memory for the kernel image resources") has 
> not been anymore reserved due to the removal of generic MIPS arch code 
> that used to reserve all the memory from the beginning of RAM up to the 
> kernel load address.
> 
> This memory does need to be reserved on DEC platforms however as it is 
> used by REX firmware as working area, as per the TURBOchannel firmware 
> specification[1]:
> 
> Table 2-2  REX Memory Regions
> -------------------------------------------------------------------------
>         Starting        Ending
> Region  Address         Address         Use
> -------------------------------------------------------------------------
> 0       0xa0000000      0xa000ffff      Restart block, exception vectors,
>                                         REX stack and bss
> 1       0xa0010000      0xa0017fff      Keyboard or tty drivers
> 
> 2       0xa0018000      0xa001f3ff 1)   CRT driver
> 
> 3       0xa0020000      0xa002ffff      boot, cnfg, init and t objects
> 
> 4       0xa0020000      0xa002ffff      64KB scratch space
> -------------------------------------------------------------------------
> 1) Note that the last 3 Kbytes of region 2 are reserved for backward
> compatibility with previous system software.
> -------------------------------------------------------------------------
> 

...

> @@ -146,6 +150,9 @@ void __init plat_mem_setup(void)
>  
>  	ioport_resource.start = ~0UL;
>  	ioport_resource.end = 0UL;

> +
> +	/* Stay away from the firmware working memory area for now. */
> +	memblock_reserve(PHYS_OFFSET, __pa_symbol(&_text) - PHYS_OFFSET);

I am just wondering...
Here we reserve a region within [PHYS_OFFSET, __pa_symbol(&_text)]. But then in
the prom_free_prom_memory() method we'll get to free a region as either
[PAGE_SIZE, __pa_symbol(&_text)] or [PAGE_SIZE, __pa_symbol(&_text) - 0x00020000].

First of all the start address of the being freed region is PAGE_SIZE, which doesn't
take the PHYS_OFFSET into account. I assume it won't cause problems because
PHYS_OFFSET is set to 0 for DEC. If so then we either shouldn't use PHYS_OFFSET
here or should take PHYS_OFFSET into account there on freeing or should just forget
about that since other than confusion it won't cause any problem.)
(I should have posted this question to v1 of this patch instead of pointing out
on the confusing size argument of the memblock_reserve() method. Sorry about
that.)

Secondly why is PAGE_SIZE selected as the start address? It belongs to the
Region 1 in accordance with "Table 2-2 REX Memory Regions" cited above. Thus we
get to keep reserved just a part of the Region 1. Most likely it's the restart
block and the exception vectors. Even assuming that the DEC developers knew what
they were doing, I am wondering can we be sure that a single page is enough for
all that data?..

-Sergey

>  }
>  
>  /*
