Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2DD28515F
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 20:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgJFSKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Oct 2020 14:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbgJFSKp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Oct 2020 14:10:45 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59EAAC061755
        for <stable@vger.kernel.org>; Tue,  6 Oct 2020 11:10:44 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id c6so1603440plr.9
        for <stable@vger.kernel.org>; Tue, 06 Oct 2020 11:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=LW6eADktBhT0zG7NUjkahqpsAFEQu+5dOoVUbndCYL0=;
        b=B84wE1p5Db7uoe+qtNxGSLmWPYJLmsoN4snvy40DdU8tDWhpEpgV1LMGUKnihz5UEX
         ictV1wFIux5Zs82+sEGwE4ACeRwX1ibNkBHmE6cQJanj1wSM3dDUF9oUNlyFjfsLXjMS
         7g/UG2pa3MjUijDCf8bN5vYN0YbidY71AS19fC3UmQqBcSD6lMGokL36Az/WV+d5pq4J
         BCtv7OsvciupAhh1IZEif9cfnJY102XzX4c2pJfUZHgBK2d9fjlGM03lbgDK1Rpz8e8J
         Klaplgei+kGel1EUAwX4Pf2AJNlxWn4Khv+k85sEvXFzWte0r0Ns1hjaJzx7+m7N3mje
         /g4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=LW6eADktBhT0zG7NUjkahqpsAFEQu+5dOoVUbndCYL0=;
        b=ExYlbONZfsbfA7/AoimorYdZahWZ2xLavIxguV7oQ3EQ64HCNJOTnOVR1KECtep0Tj
         6HPR0KhZHTCSqqD32hXS1rwSnYe/g+//oNI7AS9WDiXd+9UxX1Kh+1SMc6f5VZf8BTB0
         xIx9UMQdAdTjpotHCltPelUiMOQcNKtFFnFFin5jJlw/DKYbpbIqcnhdFxc52dlUAkAL
         5q7/n33qekgcVJFDWMKBhbSOsdN5FJikhrM/mKHdURy/SY46/EmNwN3pnuEwjbMd0h7k
         eg/xCql3P2TXSiwtsA11K0Jczk/wno3iq36YnxIsUxy3BPwFZZ59Kud3JH0oedD8Qk96
         dbQg==
X-Gm-Message-State: AOAM533pHQ72y6PNeqr4zuvzGHvTjklDTMI1m6YghVD45SfEL4viSpFx
        LgOorrNl7B1eLb6WN4XVj11R1Q==
X-Google-Smtp-Source: ABdhPJyr438vfz78H5278jmBm6vwWyvs9YL63/6zAhOj4zru9Z1KVp0ubItEizLC//MAzzMy0NNwuw==
X-Received: by 2002:a17:90b:1649:: with SMTP id il9mr5256255pjb.94.1602007843570;
        Tue, 06 Oct 2020 11:10:43 -0700 (PDT)
Received: from [2620:15c:17:3:4a0f:cfff:fe51:6667] ([2620:15c:17:3:4a0f:cfff:fe51:6667])
        by smtp.gmail.com with ESMTPSA id q4sm3862919pjl.28.2020.10.06.11.10.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 11:10:42 -0700 (PDT)
Date:   Tue, 6 Oct 2020 11:10:41 -0700 (PDT)
From:   David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To:     Peter Gonda <pgonda@google.com>
cc:     Greg KH <greg@kroah.com>, stable@vger.kernel.org,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Christoph Hellwig <hch@lst.de>, nsaenzjulienne@suse.de,
        geert@linux-m68k.org, sjhuang@iluvatar.ai
Subject: Re: [PATCH 00/30 for 5.4] Backport unencrypted non-blocking DMA
 allocations
In-Reply-To: <CAMkAt6qgbO4CqQVxLKU_Tf6bN3numdJHdkc-rck26V68+Y1j9Q@mail.gmail.com>
Message-ID: <alpine.DEB.2.23.453.2010061100120.51232@chino.kir.corp.google.com>
References: <20200925161916.204667-1-pgonda@google.com> <20201005130729.GD827657@kroah.com> <CAMkAt6qgbO4CqQVxLKU_Tf6bN3numdJHdkc-rck26V68+Y1j9Q@mail.gmail.com>
User-Agent: Alpine 2.23 (DEB 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks Peter.

The series of commits certainly expanded from my initial set that I asked 
about in a thread with the subject "DMA API stable backports for AMD SEV" 
on May 19.  Turns out that switching how DMA memory is allocated based on 
various characteristics of the allocation and device is trickier than 
originally thought :)  There were a number of fixes that were needed for 
subtleties and cornercases that folks ran into, but were addressed and 
have been merged by Linus.  I believe it's stable in upstream and that 
we've been thorough in compiling a full set of changes that are required 
for 5.4.

Note that without this series, all SEV-enabled guests will run into the 
"sleeping function called from invalid context" issue in the vmalloc layer 
that Peter cites when using certain drivers.  For such configurations, 
there is no way to avoid the "BUG" messages in the guest kernel when using 
AMD SEV unless this series is merged into an LTS kernel that the distros 
will then pick up.

For my 13 patches in the 30 patch series, I fully stand by Peter's 
backports and rationale for merge into 5.4 LTS.


On Tue, 6 Oct 2020, Peter Gonda wrote:

> We realize this is a large set of changes but it's the only way for us
> to remove that customer facing BUG for SEV guests. When David asked
> back in May a full series was preferred, is there another way forward?
> I've CCd the authors of the changes.
> 
> On Mon, Oct 5, 2020 at 7:06 AM Greg KH <greg@kroah.com> wrote:
> >
> > On Fri, Sep 25, 2020 at 09:18:46AM -0700, Peter Gonda wrote:
> > > Currently SEV enabled guests hit might_sleep() warnings when a driver (nvme in
> > > this case) allocates through the DMA API in a non-blockable context. Making
> > > these unencrypted non-blocking DMA allocations come from the coherent pools
> > > prevents this BUG.
> > >
> > > BUG: sleeping function called from invalid context at mm/vmalloc.c:1710
> > > in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 3383, name: fio
> > > 2 locks held by fio/3383:
> > >  #0: ffff93b6a8568348 (&sb->s_type->i_mutex_key#16){+.+.}, at: ext4_file_write_iter+0xa2/0x5d0
> > >  #1: ffffffffa52a61a0 (rcu_read_lock){....}, at: hctx_lock+0x1a/0xe0
> > > CPU: 0 PID: 3383 Comm: fio Tainted: G        W         5.5.10 #14
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > > Call Trace:
> > >  dump_stack+0x98/0xd5
> > >  ___might_sleep+0x175/0x260
> > >  __might_sleep+0x4a/0x80
> > >  _vm_unmap_aliases+0x45/0x250
> > >  vm_unmap_aliases+0x19/0x20
> > >  __set_memory_enc_dec+0xa4/0x130
> > >  set_memory_decrypted+0x10/0x20
> > >  dma_direct_alloc_pages+0x148/0x150
> > >  dma_direct_alloc+0xe/0x10
> > >  dma_alloc_attrs+0x86/0xc0
> > >  dma_pool_alloc+0x16f/0x2b0
> > >  nvme_queue_rq+0x878/0xc30 [nvme]
> > >  __blk_mq_try_issue_directly+0x135/0x200
> > >  blk_mq_request_issue_directly+0x4f/0x80
> > >  blk_mq_try_issue_list_directly+0x46/0xb0
> > >  blk_mq_sched_insert_requests+0x19b/0x2b0
> > >  blk_mq_flush_plug_list+0x22f/0x3b0
> > >  blk_flush_plug_list+0xd1/0x100
> > >  blk_finish_plug+0x2c/0x40
> > >  iomap_dio_rw+0x427/0x490
> > >  ext4_file_write_iter+0x181/0x5d0
> > >  aio_write+0x109/0x1b0
> > >  io_submit_one+0x7d0/0xfa0
> > >  __x64_sys_io_submit+0xa2/0x280
> > >  do_syscall_64+0x5f/0x250
> > >  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > >
> > > Christoph Hellwig (9):
> > >   dma-direct: remove __dma_direct_free_pages
> > >   dma-direct: remove the dma_handle argument to __dma_direct_alloc_pages
> > >   dma-direct: provide mmap and get_sgtable method overrides
> > >   dma-mapping: merge the generic remapping helpers into dma-direct
> > >   dma-direct: consolidate the error handling in dma_direct_alloc_pages
> > >   xtensa: use the generic uncached segment support
> > >   dma-direct: make uncached_kernel_address more general
> > >   dma-mapping: DMA_COHERENT_POOL should select GENERIC_ALLOCATOR
> > >   dma-pool: fix coherent pool allocations for IOMMU mappings
> > >
> > > David Rientjes (13):
> > >   dma-remap: separate DMA atomic pools from direct remap code
> > >   dma-pool: add additional coherent pools to map to gfp mask
> > >   dma-pool: dynamically expanding atomic pools
> > >   dma-direct: atomic allocations must come from atomic coherent pools
> > >   dma-pool: add pool sizes to debugfs
> > >   x86/mm: unencrypted non-blocking DMA allocations use coherent pools
> > >   dma-pool: scale the default DMA coherent pool size with memory
> > >     capacity
> > >   dma-pool: decouple DMA_REMAP from DMA_COHERENT_POOL
> > >   dma-direct: always align allocation size in dma_direct_alloc_pages()
> > >   dma-direct: re-encrypt memory if dma_direct_alloc_pages() fails
> > >   dma-direct: check return value when encrypting or decrypting memory
> > >   dma-direct: add missing set_memory_decrypted() for coherent mapping
> > >   dma-mapping: warn when coherent pool is depleted
> > >
> > > Geert Uytterhoeven (1):
> > >   dma-pool: fix too large DMA pools on medium memory size systems
> > >
> > > Huang Shijie (1):
> > >   lib/genalloc.c: rename addr_in_gen_pool to gen_pool_has_addr
> > >
> > > Nicolas Saenz Julienne (6):
> > >   dma-direct: provide function to check physical memory area validity
> > >   dma-pool: get rid of dma_in_atomic_pool()
> > >   dma-pool: introduce dma_guess_pool()
> > >   dma-pool: make sure atomic pool suits device
> > >   dma-pool: do not allocate pool memory from CMA
> > >   dma/direct: turn ARCH_ZONE_DMA_BITS into a variable
> > >
> > >  Documentation/core-api/genalloc.rst    |   2 +-
> > >  arch/Kconfig                           |   8 +-
> > >  arch/arc/Kconfig                       |   1 -
> > >  arch/arm/Kconfig                       |   1 -
> > >  arch/arm/mm/dma-mapping.c              |   8 +-
> > >  arch/arm64/Kconfig                     |   1 -
> > >  arch/arm64/mm/init.c                   |   9 +-
> > >  arch/ia64/Kconfig                      |   2 +-
> > >  arch/ia64/kernel/dma-mapping.c         |   6 -
> > >  arch/microblaze/Kconfig                |   3 +-
> > >  arch/microblaze/mm/consistent.c        |   2 +-
> > >  arch/mips/Kconfig                      |   7 +-
> > >  arch/mips/mm/dma-noncoherent.c         |   8 +-
> > >  arch/nios2/Kconfig                     |   3 +-
> > >  arch/nios2/mm/dma-mapping.c            |   2 +-
> > >  arch/powerpc/include/asm/page.h        |   9 -
> > >  arch/powerpc/mm/mem.c                  |  20 +-
> > >  arch/powerpc/platforms/Kconfig.cputype |   1 -
> > >  arch/s390/include/asm/page.h           |   2 -
> > >  arch/s390/mm/init.c                    |   1 +
> > >  arch/x86/Kconfig                       |   1 +
> > >  arch/xtensa/Kconfig                    |   6 +-
> > >  arch/xtensa/include/asm/platform.h     |  27 ---
> > >  arch/xtensa/kernel/Makefile            |   3 +-
> > >  arch/xtensa/kernel/pci-dma.c           | 121 ++---------
> > >  drivers/iommu/dma-iommu.c              |   5 +-
> > >  drivers/misc/sram-exec.c               |   2 +-
> > >  include/linux/dma-direct.h             |  12 +-
> > >  include/linux/dma-mapping.h            |   7 +-
> > >  include/linux/dma-noncoherent.h        |   4 +-
> > >  include/linux/genalloc.h               |   2 +-
> > >  kernel/dma/Kconfig                     |  20 +-
> > >  kernel/dma/Makefile                    |   1 +
> > >  kernel/dma/direct.c                    | 224 ++++++++++++++++----
> > >  kernel/dma/mapping.c                   |  45 +----
> > >  kernel/dma/pool.c                      | 270 +++++++++++++++++++++++++
> > >  kernel/dma/remap.c                     | 176 +---------------
> > >  lib/genalloc.c                         |   5 +-
> > >  38 files changed, 564 insertions(+), 463 deletions(-)
> > >  create mode 100644 kernel/dma/pool.c
> >
> > This is a pretty big set of changes for a stable tree.  Can I get some
> > acks/reviews/whatever by the developers involved here that this really
> > is a good idea to take into the 5.4.y tree?
> >
> > thanks,
> >
> > greg k-h
> 
