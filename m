Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5F3128EA2A
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 03:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732268AbgJOBeh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 21:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbgJOBeh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Oct 2020 21:34:37 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F32C0F26CF;
        Wed, 14 Oct 2020 17:15:07 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id p15so1274675ljj.8;
        Wed, 14 Oct 2020 17:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=d48UUfGdXFaIA+KwvnkR9fUosyR7sfTD+FB5b41Fqbw=;
        b=ecBFiapZdn0gMgcXdIvjxSN6UPMihyoQBabVKiek3SiuGHvx5S+OBSh+51WrhnMCd5
         dLzESU9uJstwusIMIA0mnTaRayQ5srG+PxIM4ABmclteScQsZ5cI3MrE4wpN2t1niEVJ
         wr89JpuFz0UexHbejrkZki/AMorBpG/nNb3dPxP7QC26/XHtzX2UxDYU4IDYmlP19GTk
         er8AmOZNcls9fI6d6vuCUTKYqfQ/zCnmPn6uuAjY4wJFuFW+a3p2BC0CoGSf2dFIuhqh
         pSj+n5vK06e6RrpuUyFI3Qzoc6FfUrqU5Gi7oRtS4mMlDn6dj1MXaLn4Ru6PJ/F7SRRT
         6mQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=d48UUfGdXFaIA+KwvnkR9fUosyR7sfTD+FB5b41Fqbw=;
        b=Fs75luQbm0gk3Ah78QJ4r3+HIKOYnqZ1UENXeE6zu7fZqelaaylF+P/kPQuwuWkG4r
         cTvNLjUmOexAdkXFls8exH7DjVhTn6BOnjKFkOjxWCwsSY1bfPvGXC5WaAhSXNKrL0cw
         ylvk5jPB5rnhu5pkh9q6HcD/iuZWrqJG9NIF82PDsoAAtd3ik/3TFtpwaYHgs+ksg/Z3
         Z/R2OyBo29JQPu/d1Mz6OCkT6lzNUfH9Vo44C/JqJXrzhUB8s59MiLHhxq2jDWspNafA
         fH4o0rjEiEi5RVZ+isT7r4aDFxTDAytYThB2UBC13wWUT18vYKCXJKS3ViT1JzoQ4Yr/
         w3CA==
X-Gm-Message-State: AOAM531J+CBOYoCLXgevezo/YdQNAJJv76973iXUdMriSOvwHZ45K+0L
        W/rEUKg81qno4x6P06O+KwbeSlgKSDo=
X-Google-Smtp-Source: ABdhPJxDyJM7FpN/RfQSfRa3LDIst+Ox6hSijWBeV3YpHvsmcZX9WgTcUiJIs4WvBb+WTBjydwtsvw==
X-Received: by 2002:a2e:b70d:: with SMTP id j13mr212949ljo.400.1602720905974;
        Wed, 14 Oct 2020 17:15:05 -0700 (PDT)
Received: from mobilestation ([95.79.141.114])
        by smtp.gmail.com with ESMTPSA id r10sm520707ljm.14.2020.10.14.17.15.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 17:15:05 -0700 (PDT)
Date:   Thu, 15 Oct 2020 03:15:03 +0300
From:   Serge Semin <fancer.lancer@gmail.com>
To:     "Maciej W. Rozycki" <macro@linux-mips.org>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] MIPS: DEC: Restore bootmem reservation for firmware
 working memory area
Message-ID: <20201015001503.gouirlzmfourkuw2@mobilestation>
References: <alpine.LFD.2.21.2010142230090.866917@eddie.linux-mips.org>
 <20201014223654.rntqmnrxldxovf3u@mobilestation>
 <alpine.LFD.2.21.2010150008460.866917@eddie.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.21.2010150008460.866917@eddie.linux-mips.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 15, 2020 at 01:03:10AM +0100, Maciej W. Rozycki wrote:
> On Thu, 15 Oct 2020, Serge Semin wrote:
> 
> > > Table 2-2  REX Memory Regions
> > > -------------------------------------------------------------------------
> > >         Starting        Ending
> > > Region  Address         Address         Use
> > > -------------------------------------------------------------------------
> > > 0       0xa0000000      0xa000ffff      Restart block, exception vectors,
> > >                                         REX stack and bss
> > > 1       0xa0010000      0xa0017fff      Keyboard or tty drivers
> > > 
> > > 2       0xa0018000      0xa001f3ff 1)   CRT driver
> > > 
> > > 3       0xa0020000      0xa002ffff      boot, cnfg, init and t objects
> > > 
> > > 4       0xa0020000      0xa002ffff      64KB scratch space
> > > -------------------------------------------------------------------------
> > > 1) Note that the last 3 Kbytes of region 2 are reserved for backward
> > > compatibility with previous system software.
> > > -------------------------------------------------------------------------
> > > 
> > 
> > ...
> > 
> > > @@ -146,6 +150,9 @@ void __init plat_mem_setup(void)
> > >  
> > >  	ioport_resource.start = ~0UL;
> > >  	ioport_resource.end = 0UL;
> > 
> > > +
> > > +	/* Stay away from the firmware working memory area for now. */
> > > +	memblock_reserve(PHYS_OFFSET, __pa_symbol(&_text) - PHYS_OFFSET);
> > 
> > I am just wondering...
> > Here we reserve a region within [PHYS_OFFSET, __pa_symbol(&_text)]. But then in
> > the prom_free_prom_memory() method we'll get to free a region as either
> > [PAGE_SIZE, __pa_symbol(&_text)] or [PAGE_SIZE, __pa_symbol(&_text) - 0x00020000].
> > 
> > First of all the start address of the being freed region is PAGE_SIZE, which doesn't
> > take the PHYS_OFFSET into account. I assume it won't cause problems because
> > PHYS_OFFSET is set to 0 for DEC. If so then we either shouldn't use PHYS_OFFSET
> > here or should take PHYS_OFFSET into account there on freeing or should just forget
> > about that since other than confusion it won't cause any problem.)
> > (I should have posted this question to v1 of this patch instead of pointing out
> > on the confusing size argument of the memblock_reserve() method. Sorry about
> > that.)
> 
>  Technically, yes, we could use PHYS_OFFSET here, though as a separate 
> change, as it's not related to the regression addressed.
> 
>  Please mind that this is very old code, which long predates the existence 
> of PHYS_OFFSET, introduced with commit 6f284a2ce7b8 ("[MIPS] FLATMEM: 
> introduce PHYS_OFFSET.") back in 2007 only.  While `prom_free_prom_memory' 
> code dates back to commit b5766e7e6177 ("o bootmem fixes for DECstations") 
> (no proper change heading here; this is from CVS repo days) from 2000, and 
> I fiddled with it myself not so long afterwards with commit e25ac8bd2505 
> ("DECstation fixes from Maciej") in 2001 (both in the old LMO GIT repo).  
> So if anytime it should have been updated in the course of a code audit 
> that was surely due across all platforms with the introduction of 
> PHYS_OFFSET.
> 
>  Of course it doesn't mean it must not or cannot be fixed now, but it has 
> been functionally correct even if semantically broken, so no one saw the 
> urge to change it (let alone notice the problem in the first place -- you 
> are the first one).
> 
> > Secondly why is PAGE_SIZE selected as the start address? It belongs to the
> > Region 1 in accordance with "Table 2-2 REX Memory Regions" cited above. Thus we
> > get to keep reserved just a part of the Region 1. Most likely it's the restart
> > block and the exception vectors. Even assuming that the DEC developers knew what
> > they were doing, I am wondering can we be sure that a single page is enough for
> > all that data?..
> 
>  Again this is so old as to predate the existence of synthesised exception 
> handlers we currently use (which has been a blessing BTW), which I reckon 
> take a little less space than the preassembled handlers we previously had 
> used to, and stay well within even the smallest supported page size of 
> 4KiB.  Anything else we can just overwrite as we do not mean to call into 
> the firmware at this point anymore; we couldn't trust it to do the right 
> thing anyway once we have booted (e.g. not to keep interrupts masked for 
> too long, etc.).
> 
>  I've been occasionally thinking about a better solution in place of the 
> LANCE hack here, needed because the chip has only its low 16 out of 24 
> address lines wired, due to a limitation of the IOASIC DMA controller (it 
> also drives one half of the IOASIC's 16-bit data bus only, communicating 
> with every other byte of system memory only and hence the requirement for 
> a 128KiB allocation, with every other byte wasted, rather than a 64KiB 
> one).
> 
>  Had all 24 lines been used, we could use dynamic ZONE_DMA buffers as with 
> PC ISA DMA, as the LANCE implements proper DMA rings, but with low 16 only 
> it would not really play.  I have not come up with any solution however 
> that would be significantly better than what we have, and the current one 
> works, so I have left it as it is.
> 

>  Do these explanations address your concerns?

Yep, completely. Thanks for the very detailed response.

-Sergey

> 
>   Maciej
