Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACF1E478A30
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 12:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235574AbhLQLi6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 06:38:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235575AbhLQLi6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 06:38:58 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A21C061574;
        Fri, 17 Dec 2021 03:38:57 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id 200so1840914pgg.3;
        Fri, 17 Dec 2021 03:38:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Mul3ZRNFflTWXV4x8BSchYuRZDr6/Zs4AviyHDR6Mbs=;
        b=N72GbVk1j2sTQmOoAz6wPf7Xl+fFMpDg6FcOzAKqdWrwCxCiisp1Z5RZC4ue0Vf1v4
         jerBHr3qfyIwjpTcwoy2aINXfiIv9toma5YuCaGZxVCB1PVoEv4WSJCfgwikGMe/68aN
         oXhdgbcMKGf84GwKJWD7ydQcF2o2cOa8F67bJqeV8Tbk+yiMcpWvlPHhU6ASD5wHp21R
         ArmgN1ndqfxsgG1ZDGzoYK5xurGxX2iWr00lzNVcwH4K2Ssg8cWfpe9XMua2hvi4RFQN
         Gsj4NwCsSUE9t4skP6aA91q3W813wKHxsfeXl6tZg84eH9Ld4GmAMxKw9FAGAoQ4meDt
         TEIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Mul3ZRNFflTWXV4x8BSchYuRZDr6/Zs4AviyHDR6Mbs=;
        b=TXjsjEjn2jxJ8xfcDEs3KsxmIeAFb6smCIiaFVdCQafDr92IvJBLrQ1++NLGtEN5s0
         CYS7cn7DDvuwflqF3iuww4zxvhe6l2LN+wEfj6bKpPKwQLClUx0Ky0BYTOjzmlNrHANF
         fraRDQdhsd8EPUTLONwkqepnmTxZcz4EsuhAnlALygREqIgLgl3KBQl2vpwQ+GzI5RNZ
         EpXF0Gxdeh5iDSFdNOzk5VKvyAgBzBvv5fchuOnbIpSfBo1/UiduIFHBwLLUA2Z+Hpud
         vViS1PWDLQ1O/yMnMiGN9H1dgXxODalaMWgPOCHDd4Ur6fD78hALog3hhMh5A9D7jIpv
         6zjw==
X-Gm-Message-State: AOAM531BjxML1UCId7P31+VbGygRDITG3t0Pv/LeFwwQnyCc0HQ/XAbh
        8Z6iAR+jOR6qC19AJrvzg5Q=
X-Google-Smtp-Source: ABdhPJz0Lqy/grEZdHR3OmyTYAVpGmR4r88Bqsau2CdVvZCbJ7jRDqcOJ7/LTvXWZkORmPlBVf5Fww==
X-Received: by 2002:a63:d907:: with SMTP id r7mr2533764pgg.406.1639741137165;
        Fri, 17 Dec 2021 03:38:57 -0800 (PST)
Received: from ip-172-31-30-232.ap-northeast-1.compute.internal (ec2-18-181-137-102.ap-northeast-1.compute.amazonaws.com. [18.181.137.102])
        by smtp.gmail.com with ESMTPSA id e15sm1702548pga.53.2021.12.17.03.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 03:38:56 -0800 (PST)
Date:   Fri, 17 Dec 2021 11:38:52 +0000
From:   Hyeonggon Yoo <42.hyeyoo@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Vlastimil Babka <vbabka@suse.cz>, Baoquan He <bhe@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, cl@linux.com,
        John.p.donnelly@oracle.com, kexec@lists.infradead.org,
        stable@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v3 5/5] mm/slub: do not create dma-kmalloc if no managed
 pages in DMA zone
Message-ID: <Ybx2zGCvWGTmm2Ed@ip-172-31-30-232.ap-northeast-1.compute.internal>
References: <20211213122712.23805-1-bhe@redhat.com>
 <20211213122712.23805-6-bhe@redhat.com>
 <20211213134319.GA997240@odroid>
 <20211214053253.GB2216@MiWiFi-R3L-srv>
 <f5ff82eb-73b6-55b5-53d7-04ab73ce5035@suse.cz>
 <20211215044818.GB1097530@odroid>
 <20211215070335.GA1165926@odroid>
 <20211215072710.GA3010@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215072710.GA3010@lst.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 15, 2021 at 08:27:10AM +0100, Christoph Hellwig wrote:
> On Wed, Dec 15, 2021 at 07:03:35AM +0000, Hyeonggon Yoo wrote:
> > I'm not sure that allocating from ZONE_DMA32 instead of ZONE_DMA
> > for kdump kernel is nice way to solve this problem.
> 
> What is the problem with zones in kdump kernels?
> 
> > Devices that requires ZONE_DMA memory is rare but we still support them.
> 
> Indeed.
> 
> > >     1) Do not call warn_alloc in page allocator if will always fail
> > >     to allocate ZONE_DMA pages.
> > > 
> > > 
> > >     2) let's check all callers of kmalloc with GFP_DMA
> > >     if they really need GFP_DMA flag and replace those by DMA API or
> > >     just remove GFP_DMA from kmalloc()
> > > 
> > >     3) Drop support for allocating DMA memory from slab allocator
> > >     (as Christoph Hellwig said) and convert them to use DMA32
> > 
> > 	(as Christoph Hellwig said) and convert them to use *DMA API*
> > 
> > >     and see what happens
> 
> This is the right thing to do, but it will take a while.  In fact
> I dont think we really need the warning in step 1,

Hmm I think step 1) will be needed if someone is allocating pages from
DMA zone not using kmalloc or DMA API. (for example directly allocating
from buddy allocator) is there such cases?

> a simple grep
> already allows to go over them.  I just looked at the uses of GFP_DMA
> in drivers/scsi for example, and all but one look bogus.
>

That's good. this cleanup will also remove unnecessary limitations.

> > > > > Yeah, I have the same guess too for get_capabilities(), not sure about other
> > > > > callers. Or, as ChristophL and ChristophH said(Sorry, not sure if this is
> > > > > the right way to call people when the first name is the same. Correct me if
> > > > > it's wrong), any buffer requested from kmalloc can be used by device driver.
> > > > > Means device enforces getting memory inside addressing limit for those
> > > > > DMA transferring buffer which is usually large, Megabytes level with
> > > > > vmalloc() or alloc_pages(), but doesn't care about this kind of small
> > > > > piece buffer memory allocated with kmalloc()? Just a guess, please tell
> > > > > a counter example if anyone happens to know, it could be
> > > > > easy.
> 
> The way this works is that the dma_map* calls will bounce buffer memory
> that does to fall into the addressing limitations.  This is a performance
> overhead, but allows drivers to address all memory in a system.  If the
> driver controls memory allocation it should use one of the dma_alloc_*
> APIs that allocate addressable memory from the start.  The allocator
> will dip into ZONE_DMA and ZONE_DMA32 when needed.
