Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9822634187E
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 10:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbhCSJgP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 05:36:15 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:54267 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229618AbhCSJfx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 05:35:53 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 75B3D15B3;
        Fri, 19 Mar 2021 05:35:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 19 Mar 2021 05:35:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=RCfuueNAjMgqPIWlOXQoNKx2Gwo
        Tp8S7Mwap+HYgGFk=; b=OcOPM1QWm2flpFI1DefepVAYFAZokBOEdeuYaE6uqm6
        SP2jM6eEypRk0b95seXl+QeHNa8RZXh8PckZ03l/YFAsL1Q845vtpG47BeeANOYO
        xjwdvX0QF5lv2vKOAhnSDfKQF2fyVzu8qXiJgQCYxxTryXEmlhflImGXCvH6Okjz
        BBNYL1tbaYyU1fLuj7I8ovw4oo/BFvZrDVl0ATPa+I1OSua0gDseb1AF864yWa6r
        6y9bE69CFW3ZPxnTWV5q6w4u7D56C62S9GqFQHdeS2q4NqdG+1JexNPOwC8SOvvJ
        HMbPXZe/WPLOJqj+hkJ0EZAA2YIWQ3RaSwS0yBoan1A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=RCfuue
        NAjMgqPIWlOXQoNKx2GwoTp8S7Mwap+HYgGFk=; b=Ic2lRIeUJAWuNnVkIJ/vKR
        G4gHqUHl6G78jOkUy0qjXji+P42OpcafTWKblyPXO+oalTI5kefx4SdjsqFrXHlz
        XOENrTz+qf/mYSAAnHtccXOD031tcRZ1utzMTfW6aMMF5rrX32L4WYojMFtgPKWh
        pLx/gk2xpXqkyX7bzWe8IdnCdM/sIyh00vJpbRWcOrZvM3jCpVL+cRKOTVQSIUL6
        mGl+4mx2Y1UW4TaAq2NRPifXT4qZEncLS859laWudbioUduTadZXJSyVRAwnJN46
        8OGOXspXDLFGSLaAAoa60AygsqksMt9pXHZbkEyxqTU7aQU1Axo1CuZVDWYY4xHg
        ==
X-ME-Sender: <xms:d3BUYLYfEeWKrcZr0LDXa8C6pfvGXcyOdp_t21kZSOlS90HIIWQg7g>
    <xme:d3BUYKYghkLgP9xlk8d1nnwdDE9hcdguztJr2X3N2Mc3NUGeRxdIrjguT9gBVZxCE
    RG3qodxH-zpCA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefkedgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhm
X-ME-Proxy: <xmx:d3BUYN9i2dhed42bJFJzX63ZX9i3FxtzgHDAH3TJJYPYDQwj2WfjyQ>
    <xmx:d3BUYBrf2m9QE00xjInwtU9K7Kn8y-N9oC0eaxatCzR_jwNXy58vYg>
    <xmx:d3BUYGoe3rgdTSpD5nW2s9wByEZ2p-Mbuy75BS06uIW_bIC6kFeFkA>
    <xmx:eHBUYN3OosG7fV6Ca0XLx41IBJVr4RUouy8ej0xSYCgv3psK2Ya0Ew>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 94E9F24005B;
        Fri, 19 Mar 2021 05:35:51 -0400 (EDT)
Date:   Fri, 19 Mar 2021 10:35:49 +0100
From:   Greg KH <greg@kroah.com>
To:     David Sterba <dsterba@suse.com>
Cc:     stable@vger.kernel.org, fdmanana@suse.com,
        linux-btrfs@vger.kernel.org, wqu@suse.com
Subject: Re: [PATCH 5.4] btrfs: scrub: Don't check free space before marking
 a block group RO
Message-ID: <YFRwdX42UDBdIaDh@kroah.com>
References: <20210317095151.19777-1-dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210317095151.19777-1-dsterba@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 17, 2021 at 10:51:51AM +0100, David Sterba wrote:
> From: Qu Wenruo <wqu@suse.com>
> 
> [ Upstream commit b12de52896c0e8213f70e3a168fde9e6eee95909 ]
> 
> [BUG]
> When running btrfs/072 with only one online CPU, it has a pretty high
> chance to fail:
> 
>   btrfs/072 12s ... _check_dmesg: something found in dmesg (see xfstests-dev/results//btrfs/072.dmesg)
>   - output mismatch (see xfstests-dev/results//btrfs/072.out.bad)
>       --- tests/btrfs/072.out     2019-10-22 15:18:14.008965340 +0800
>       +++ /xfstests-dev/results//btrfs/072.out.bad      2019-11-14 15:56:45.877152240 +0800
>       @@ -1,2 +1,3 @@
>        QA output created by 072
>        Silence is golden
>       +Scrub find errors in "-m dup -d single" test
>       ...
> 
> And with the following call trace:
> 
>   BTRFS info (device dm-5): scrub: started on devid 1
>   ------------[ cut here ]------------
>   BTRFS: Transaction aborted (error -27)
>   WARNING: CPU: 0 PID: 55087 at fs/btrfs/block-group.c:1890 btrfs_create_pending_block_groups+0x3e6/0x470 [btrfs]
>   CPU: 0 PID: 55087 Comm: btrfs Tainted: G        W  O      5.4.0-rc1-custom+ #13
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
>   RIP: 0010:btrfs_create_pending_block_groups+0x3e6/0x470 [btrfs]
>   Call Trace:
>    __btrfs_end_transaction+0xdb/0x310 [btrfs]
>    btrfs_end_transaction+0x10/0x20 [btrfs]
>    btrfs_inc_block_group_ro+0x1c9/0x210 [btrfs]
>    scrub_enumerate_chunks+0x264/0x940 [btrfs]
>    btrfs_scrub_dev+0x45c/0x8f0 [btrfs]
>    btrfs_ioctl+0x31a1/0x3fb0 [btrfs]
>    do_vfs_ioctl+0x636/0xaa0
>    ksys_ioctl+0x67/0x90
>    __x64_sys_ioctl+0x43/0x50
>    do_syscall_64+0x79/0xe0
>    entry_SYSCALL_64_after_hwframe+0x49/0xbe
>   ---[ end trace 166c865cec7688e7 ]---
> 
> [CAUSE]
> The error number -27 is -EFBIG, returned from the following call chain:
> btrfs_end_transaction()
> |- __btrfs_end_transaction()
>    |- btrfs_create_pending_block_groups()
>       |- btrfs_finish_chunk_alloc()
>          |- btrfs_add_system_chunk()
> 
> This happens because we have used up all space of
> btrfs_super_block::sys_chunk_array.
> 
> The root cause is, we have the following bad loop of creating tons of
> system chunks:
> 
> 1. The only SYSTEM chunk is being scrubbed
>    It's very common to have only one SYSTEM chunk.
> 2. New SYSTEM bg will be allocated
>    As btrfs_inc_block_group_ro() will check if we have enough space
>    after marking current bg RO. If not, then allocate a new chunk.
> 3. New SYSTEM bg is still empty, will be reclaimed
>    During the reclaim, we will mark it RO again.
> 4. That newly allocated empty SYSTEM bg get scrubbed
>    We go back to step 2, as the bg is already mark RO but still not
>    cleaned up yet.
> 
> If the cleaner kthread doesn't get executed fast enough (e.g. only one
> CPU), then we will get more and more empty SYSTEM chunks, using up all
> the space of btrfs_super_block::sys_chunk_array.
> 
> [FIX]
> Since scrub/dev-replace doesn't always need to allocate new extent,
> especially chunk tree extent, so we don't really need to do chunk
> pre-allocation.
> 
> To break above spiral, here we introduce a new parameter to
> btrfs_inc_block_group(), @do_chunk_alloc, which indicates whether we
> need extra chunk pre-allocation.
> 
> For relocation, we pass @do_chunk_alloc=true, while for scrub, we pass
> @do_chunk_alloc=false.
> This should keep unnecessary empty chunks from popping up for scrub.
> 
> Also, since there are two parameters for btrfs_inc_block_group_ro(),
> add more comment for it.
> 
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
> 
> There's a report for 5.4 and the patch applies with a minor fixup
> without dependencies.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=210447

Thanks, now queued up.

greg k-h
