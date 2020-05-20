Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2231DBE09
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 21:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbgETTe4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 15:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726824AbgETTe4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 15:34:56 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EAE3C061A0E
        for <stable@vger.kernel.org>; Wed, 20 May 2020 12:34:55 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id 5so1828059pjd.0
        for <stable@vger.kernel.org>; Wed, 20 May 2020 12:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=5qOWagvNnemypqP27FvrDTTWHuO54ZbeOfezoDOkd2M=;
        b=ICeHxEa+9gwy0ABJd3/wQOXAKBXvvyo/OF3UARiVb/rNrskJkWP/6OmVSiPvMzeYeG
         48hJaSSnDDdFVbdP6jCjHUOO1F1x1J4YwZBK3MDByo2pdnfKJhGQ19JDmkyPil5n1Azj
         m8U5vvqdgG5pPgP+QfcklgU2+82Chsg574znmSEIsCVg6G9X8ui0T1W0Qb/spDJIGrvC
         ay2vWOyh2SObQOjb7YZ2Q9CdQZPIpzA3MIeXCZd+CQa2FmF2Q8dJfgIhYFtF4GtzcPld
         3om1XZUfPq9VAWCc+zL8j1MtGqs7tmpjyaDLUgBypUa4tuiuS0A9OkanLTMV91s90CUf
         O+gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=5qOWagvNnemypqP27FvrDTTWHuO54ZbeOfezoDOkd2M=;
        b=siYozCvMZxzE24t7tXwBJ8Vtfz+zPZlMSHDNJwm1zjPytnSBh6KvrT2dT2RpOqACkk
         J1I2oCY6Z0HBshX+9ivBWzSZ2Vc23SBhnh9Mm6mPfscnX01OIMr0POLB0vyvvwMMiJ1C
         sZHLX/2u9PoHo4OoHZtZ0eAdYm3mhe8Hfyb7IH/d2m0Pbt+2vRqjDIurTFrUuH6I5t65
         n68BUJirl4aUT/5E6X6d8deeieg3jogM2/InBN/4zlfmQwgFRx8b3Xl9bPrWHTdsnFKP
         ILwLcy6mZbuyqy8mAptzZaC1l1F3OpkDK6ZmHmGqXlEHUCdNgNI1zRb0PmObjeeHvmk0
         53Nw==
X-Gm-Message-State: AOAM532b/Naeup+kJe52IFsT5MX5sV+vfrQnxR3gypu1YoP196RxVG89
        vA5Idrm3QT9/newqVZUDibgEZIkWk9U=
X-Google-Smtp-Source: ABdhPJz7szB1DYQN0pp2N0/vdYDpgTzLIhWEpjSoPiD+xEHesEy4tPGvT/kCPkz/4XI/uTn9ouITHQ==
X-Received: by 2002:a17:90a:21cf:: with SMTP id q73mr7147672pjc.230.1590003294503;
        Wed, 20 May 2020 12:34:54 -0700 (PDT)
Received: from [2620:15c:17:3:3a5:23a7:5e32:4598] ([2620:15c:17:3:3a5:23a7:5e32:4598])
        by smtp.gmail.com with ESMTPSA id y18sm2763037pfr.100.2020.05.20.12.34.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 12:34:53 -0700 (PDT)
Date:   Wed, 20 May 2020 12:34:53 -0700 (PDT)
From:   David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     Christoph Hellwig <hch@lst.de>, Peter Gonda <pgonda@google.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>, stable@vger.kernel.org
Subject: Re: DMA API stable backports for AMD SEV
In-Reply-To: <20200520181645.GA339194@kroah.com>
Message-ID: <alpine.DEB.2.22.394.2005201233320.4412@chino.kir.corp.google.com>
References: <alpine.DEB.2.22.394.2005191708270.15133@chino.kir.corp.google.com> <20200520181645.GA339194@kroah.com>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 20 May 2020, Greg Kroah-Hartman wrote:

> On Tue, May 19, 2020 at 05:41:15PM -0700, David Rientjes wrote:
> > Hi Greg and everyone,
> > 
> > On all kernels, SEV enabled guests hit might_sleep() warnings when a 
> > driver (nvme in this case) allocates through the DMA API in a 
> > non-blockable context:
> > 
> > BUG: sleeping function called from invalid context at mm/vmalloc.c:1710
> > in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 3383, name: fio
> > 2 locks held by fio/3383:
> >  #0: ffff93b6a8568348 (&sb->s_type->i_mutex_key#16){+.+.}, at: ext4_file_write_iter+0xa2/0x5d0
> >  #1: ffffffffa52a61a0 (rcu_read_lock){....}, at: hctx_lock+0x1a/0xe0
> > CPU: 0 PID: 3383 Comm: fio Tainted: G        W         5.5.10 #14
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > Call Trace:
> >  dump_stack+0x98/0xd5
> >  ___might_sleep+0x175/0x260
> >  __might_sleep+0x4a/0x80
> >  _vm_unmap_aliases+0x45/0x250
> >  vm_unmap_aliases+0x19/0x20
> >  __set_memory_enc_dec+0xa4/0x130
> >  set_memory_decrypted+0x10/0x20
> >  dma_direct_alloc_pages+0x148/0x150
> >  dma_direct_alloc+0xe/0x10
> >  dma_alloc_attrs+0x86/0xc0
> >  dma_pool_alloc+0x16f/0x2b0
> >  nvme_queue_rq+0x878/0xc30 [nvme]
> >  __blk_mq_try_issue_directly+0x135/0x200
> >  blk_mq_request_issue_directly+0x4f/0x80
> >  blk_mq_try_issue_list_directly+0x46/0xb0
> >  blk_mq_sched_insert_requests+0x19b/0x2b0
> >  blk_mq_flush_plug_list+0x22f/0x3b0
> >  blk_flush_plug_list+0xd1/0x100
> >  blk_finish_plug+0x2c/0x40
> >  iomap_dio_rw+0x427/0x490
> >  ext4_file_write_iter+0x181/0x5d0
> >  aio_write+0x109/0x1b0
> >  io_submit_one+0x7d0/0xfa0
> >  __x64_sys_io_submit+0xa2/0x280
> >  do_syscall_64+0x5f/0x250
> >  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > 
> > There is a series of patches in Christoph's dma-mapping.git repo in the 
> > for-next branch on track for 5.8:
> > 
> > 1d659236fb43 dma-pool: scale the default DMA coherent pool size with memory capacity
> > 82fef0ad811f x86/mm: unencrypted non-blocking DMA allocations use coherent pools
> > 2edc5bb3c5cc dma-pool: add pool sizes to debugfs
> > 76a19940bd62 dma-direct: atomic allocations must come from atomic coherent pools
> > 54adadf9b085 dma-pool: dynamically expanding atomic pools
> > c84dc6e68a1d dma-pool: add additional coherent pools to map to gfp mask
> > e860c299ac0d dma-remap: separate DMA atomic pools from direct remap code
> > 
> > We'd like to prepare backports to LTS kernels so that our guest images are 
> > not modified by us and don't exhibit this issue.
> > 
> > They are bigger than we'd like:
> > 
> >  arch/x86/Kconfig            |   1 +
> >  drivers/iommu/dma-iommu.c   |   5 +-
> >  include/linux/dma-direct.h  |   2 +
> >  include/linux/dma-mapping.h |   6 +-
> >  kernel/dma/Kconfig          |   6 +-
> >  kernel/dma/Makefile         |   1 +
> >  kernel/dma/direct.c         |  56 ++++++--
> >  kernel/dma/pool.c           | 264 ++++++++++++++++++++++++++++++++++++
> >  kernel/dma/remap.c          | 121 +----------------
> >  9 files changed, 324 insertions(+), 138 deletions(-)
> >  create mode 100644 kernel/dma/pool.c
> > 
> > But they apply relatively cleanly to more modern kernels like 5.4.  We'd 
> > like to backport these all the way to 4.19, however, otherwise guests 
> > encounter these bugs.
> > 
> > The changes to kernel/dma/remap.c, for example, simply moves code to the 
> > new pool.c.  But that original code is actually in arch/arm64 in 4.19 and 
> > was moved in 5.0:
> > 
> > commit 0c3b3171ceccb8830c2bb5adff1b4e9b204c1450
> > Author: Christoph Hellwig <hch@lst.de>
> > Date:   Sun Nov 4 20:29:28 2018 +0100
> > 
> >     dma-mapping: move the arm64 noncoherent alloc/free support to common code
> > 
> > commit f0edfea8ef93ed6cc5f747c46c85c8e53e0798a0
> > Author: Christoph Hellwig <hch@lst.de>
> > Date:   Fri Aug 24 10:31:08 2018 +0200
> > 
> >     dma-mapping: move the remap helpers to a separate file
> > 
> > And there are most certainly more dependencies to get a cleanly applying 
> > series to 4.19.123.  So the backports could be quite extensive.
> > 
> > Peter Gonda <pgonda@google.com> is currently handling these and we're 
> > looking for advice: should we compile a full list of required backports 
> > that would be needed to get a series that would only consist of minor 
> > conflicts or is this going to be a non-starter?
> 
> A full series would be good.  Once these hit Linus's tree and show up in
> a -rc or two, feel free to send on the backports and we can look at them
> then.
> 

Thanks Greg.  I'll let Peter follow-up when he has the full list of 
commits that we'll need with minimal conflicts to apply this series 
cleanly as a kind of preview of what to expect the last week of June for 
4.19 LTS :)
