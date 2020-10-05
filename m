Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B86E528363D
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 15:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725891AbgJENGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 09:06:46 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:50389 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725982AbgJENGp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Oct 2020 09:06:45 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 779405C0053;
        Mon,  5 Oct 2020 09:06:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 05 Oct 2020 09:06:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=NE0NuWZKbqQk35aCYw1MZf/w7Lt
        huqRDYVuX2l+Lgeo=; b=OMLRelkpHVty8r8xMWBiDzPXOSF14IVzWl6+65yUo9g
        MYuTmndBitIS3mDKn3SPKrToWHwG19eDLUg8HzWVBprll/0I0QGLuxb3dUJ2dx7E
        WOrqbA43/GmCRaln4dPHyy6sUCrS7YRqda4KG6wYS7kiEbyGt97BKQQidVlyFULZ
        IPU0VH2T8c7OKgbQ4ovRvRstW/lhc4MOE8exT9WYcPsLUFmtwD/WY8QAZqcflxp/
        BOtsn4vygsd2h14fWF1ZTvx9LYNe+sl/0TdUH8plJV83Pe6oI0p+GLbIqTHmpIXV
        kXNFeUVvG8MDvCRVh97L0FZmqo5tg/1HdQkfcK+a5/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=NE0NuW
        ZKbqQk35aCYw1MZf/w7LthuqRDYVuX2l+Lgeo=; b=DyG1VZ7Qly/OrGtDA7Ypjc
        9k10eM8KLdr4L4bCGKG/CrsO+l0JfI7Vb9rbFe4Dg1SVOYhG6N/sTT4wpNE1c9Iu
        5fDTYNf+JpUXcD+fzBSLwpyqIC7Nh6bgeICphZTwkXB2l2pugyeWQgp2YlRBc6oI
        IzACzlfNX/+/UsDSTjP9qiPMybGIFwlHgmseg3tCwsCbqYSLm1MEsQyud93PrCCp
        jDQCqZKBPLvwhPZWQEZXeFkdkKR5HF+0HLGrYWtmjYoeLkk+eqUAlSRPzSJwxgtL
        r1ffiI/Lv05JbcOmtn9SnC8pGX6q112kteqjw6ipAGIr8i3VNanc4Zi2Wkj1XBig
        ==
X-ME-Sender: <xms:Yxp7XyM8bvgmH2By73M0YHRQ2f9NPKqfXzAJRYtqsodSDKNVHFkm8Q>
    <xme:Yxp7Xw8pMeNb1WkWK3rpak2lMV7fc4BDQvnD01jUBXF6uNYpM-sPHWcs1GqvFDwdo
    Zm-19GV5_xfKA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrgedvgdeivdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Yxp7X5RNBroCbsjCiarGrB5Hovj-bm79-1tkI4arCANaReqJGeg-ug>
    <xmx:Yxp7Xytstf8uMGgH3qcs4fKCnfQS_CxAEt-YwzuwaocnryPtQl4BkA>
    <xmx:Yxp7X6d0VR00dMGvkh12Z029ZrqY_nNSZ3fqiGcF3jHCaT4IWCbxmg>
    <xmx:Yxp7X8rOxYEJwpbBmUVuhnI3TsB8C2eiHAhVCjWZ5JsrlTCJ7W30zA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id EE12B3280064;
        Mon,  5 Oct 2020 09:06:42 -0400 (EDT)
Date:   Mon, 5 Oct 2020 15:07:29 +0200
From:   Greg KH <greg@kroah.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 00/30 for 5.4] Backport unencrypted non-blocking DMA
 allocations
Message-ID: <20201005130729.GD827657@kroah.com>
References: <20200925161916.204667-1-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925161916.204667-1-pgonda@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 25, 2020 at 09:18:46AM -0700, Peter Gonda wrote:
> Currently SEV enabled guests hit might_sleep() warnings when a driver (nvme in
> this case) allocates through the DMA API in a non-blockable context. Making
> these unencrypted non-blocking DMA allocations come from the coherent pools
> prevents this BUG.
> 
> BUG: sleeping function called from invalid context at mm/vmalloc.c:1710
> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 3383, name: fio
> 2 locks held by fio/3383:
>  #0: ffff93b6a8568348 (&sb->s_type->i_mutex_key#16){+.+.}, at: ext4_file_write_iter+0xa2/0x5d0
>  #1: ffffffffa52a61a0 (rcu_read_lock){....}, at: hctx_lock+0x1a/0xe0
> CPU: 0 PID: 3383 Comm: fio Tainted: G        W         5.5.10 #14
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  dump_stack+0x98/0xd5
>  ___might_sleep+0x175/0x260
>  __might_sleep+0x4a/0x80
>  _vm_unmap_aliases+0x45/0x250
>  vm_unmap_aliases+0x19/0x20
>  __set_memory_enc_dec+0xa4/0x130
>  set_memory_decrypted+0x10/0x20
>  dma_direct_alloc_pages+0x148/0x150
>  dma_direct_alloc+0xe/0x10
>  dma_alloc_attrs+0x86/0xc0
>  dma_pool_alloc+0x16f/0x2b0
>  nvme_queue_rq+0x878/0xc30 [nvme]
>  __blk_mq_try_issue_directly+0x135/0x200
>  blk_mq_request_issue_directly+0x4f/0x80
>  blk_mq_try_issue_list_directly+0x46/0xb0
>  blk_mq_sched_insert_requests+0x19b/0x2b0
>  blk_mq_flush_plug_list+0x22f/0x3b0
>  blk_flush_plug_list+0xd1/0x100
>  blk_finish_plug+0x2c/0x40
>  iomap_dio_rw+0x427/0x490
>  ext4_file_write_iter+0x181/0x5d0
>  aio_write+0x109/0x1b0
>  io_submit_one+0x7d0/0xfa0
>  __x64_sys_io_submit+0xa2/0x280
>  do_syscall_64+0x5f/0x250
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> Christoph Hellwig (9):
>   dma-direct: remove __dma_direct_free_pages
>   dma-direct: remove the dma_handle argument to __dma_direct_alloc_pages
>   dma-direct: provide mmap and get_sgtable method overrides
>   dma-mapping: merge the generic remapping helpers into dma-direct
>   dma-direct: consolidate the error handling in dma_direct_alloc_pages
>   xtensa: use the generic uncached segment support
>   dma-direct: make uncached_kernel_address more general
>   dma-mapping: DMA_COHERENT_POOL should select GENERIC_ALLOCATOR
>   dma-pool: fix coherent pool allocations for IOMMU mappings
> 
> David Rientjes (13):
>   dma-remap: separate DMA atomic pools from direct remap code
>   dma-pool: add additional coherent pools to map to gfp mask
>   dma-pool: dynamically expanding atomic pools
>   dma-direct: atomic allocations must come from atomic coherent pools
>   dma-pool: add pool sizes to debugfs
>   x86/mm: unencrypted non-blocking DMA allocations use coherent pools
>   dma-pool: scale the default DMA coherent pool size with memory
>     capacity
>   dma-pool: decouple DMA_REMAP from DMA_COHERENT_POOL
>   dma-direct: always align allocation size in dma_direct_alloc_pages()
>   dma-direct: re-encrypt memory if dma_direct_alloc_pages() fails
>   dma-direct: check return value when encrypting or decrypting memory
>   dma-direct: add missing set_memory_decrypted() for coherent mapping
>   dma-mapping: warn when coherent pool is depleted
> 
> Geert Uytterhoeven (1):
>   dma-pool: fix too large DMA pools on medium memory size systems
> 
> Huang Shijie (1):
>   lib/genalloc.c: rename addr_in_gen_pool to gen_pool_has_addr
> 
> Nicolas Saenz Julienne (6):
>   dma-direct: provide function to check physical memory area validity
>   dma-pool: get rid of dma_in_atomic_pool()
>   dma-pool: introduce dma_guess_pool()
>   dma-pool: make sure atomic pool suits device
>   dma-pool: do not allocate pool memory from CMA
>   dma/direct: turn ARCH_ZONE_DMA_BITS into a variable
> 
>  Documentation/core-api/genalloc.rst    |   2 +-
>  arch/Kconfig                           |   8 +-
>  arch/arc/Kconfig                       |   1 -
>  arch/arm/Kconfig                       |   1 -
>  arch/arm/mm/dma-mapping.c              |   8 +-
>  arch/arm64/Kconfig                     |   1 -
>  arch/arm64/mm/init.c                   |   9 +-
>  arch/ia64/Kconfig                      |   2 +-
>  arch/ia64/kernel/dma-mapping.c         |   6 -
>  arch/microblaze/Kconfig                |   3 +-
>  arch/microblaze/mm/consistent.c        |   2 +-
>  arch/mips/Kconfig                      |   7 +-
>  arch/mips/mm/dma-noncoherent.c         |   8 +-
>  arch/nios2/Kconfig                     |   3 +-
>  arch/nios2/mm/dma-mapping.c            |   2 +-
>  arch/powerpc/include/asm/page.h        |   9 -
>  arch/powerpc/mm/mem.c                  |  20 +-
>  arch/powerpc/platforms/Kconfig.cputype |   1 -
>  arch/s390/include/asm/page.h           |   2 -
>  arch/s390/mm/init.c                    |   1 +
>  arch/x86/Kconfig                       |   1 +
>  arch/xtensa/Kconfig                    |   6 +-
>  arch/xtensa/include/asm/platform.h     |  27 ---
>  arch/xtensa/kernel/Makefile            |   3 +-
>  arch/xtensa/kernel/pci-dma.c           | 121 ++---------
>  drivers/iommu/dma-iommu.c              |   5 +-
>  drivers/misc/sram-exec.c               |   2 +-
>  include/linux/dma-direct.h             |  12 +-
>  include/linux/dma-mapping.h            |   7 +-
>  include/linux/dma-noncoherent.h        |   4 +-
>  include/linux/genalloc.h               |   2 +-
>  kernel/dma/Kconfig                     |  20 +-
>  kernel/dma/Makefile                    |   1 +
>  kernel/dma/direct.c                    | 224 ++++++++++++++++----
>  kernel/dma/mapping.c                   |  45 +----
>  kernel/dma/pool.c                      | 270 +++++++++++++++++++++++++
>  kernel/dma/remap.c                     | 176 +---------------
>  lib/genalloc.c                         |   5 +-
>  38 files changed, 564 insertions(+), 463 deletions(-)
>  create mode 100644 kernel/dma/pool.c

This is a pretty big set of changes for a stable tree.  Can I get some
acks/reviews/whatever by the developers involved here that this really
is a good idea to take into the 5.4.y tree?

thanks,

greg k-h
