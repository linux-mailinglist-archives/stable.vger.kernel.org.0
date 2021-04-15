Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206CF360B99
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 16:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233247AbhDOOPR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbhDOOPR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 10:15:17 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD50AC061574;
        Thu, 15 Apr 2021 07:14:53 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id t11so9675639qtr.8;
        Thu, 15 Apr 2021 07:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PcMlPklfCvlm1Cok3Oiv8mr5HJURs6hqGUuWf6zfFdU=;
        b=rRmTL4IW87YHajh31Ayidt359X7o7Wt4BL3NeZedUHouii/pMjqAOflYQLX7Uaphj1
         bfKhvKNFFnZ8eB6dOKTJjZ0CyOPI89IBJsSyoXDIqgxnooqC6EIF9LMV+7YUSNNS5AEK
         4gYZeK1TJEkSGCkyVVuq++U7dm+UJ+JzkhFyka6XvaIopYWCMCvtjxPlZuTCH4kCcbyX
         Uyt10LzDHeRxciZiIaH0YjQ1l3lt0dYAw3arVF4xj/JMOznk8pW3U8k9IKrfbwF1eh7V
         j6AJTFjjdMLiV0bPs/mchHciMxI20+1j3amM3/0eMz5NjjYgXkw7pG5LsMHtk05nF2J2
         gr0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PcMlPklfCvlm1Cok3Oiv8mr5HJURs6hqGUuWf6zfFdU=;
        b=OHsFE24YIRer8fUoFHWAcfJQ2yacdTuOoP/TfjYvbkykPYhqJHiqETg119nyCFDh/l
         ch0gqjgCxNM8hZ3uznyIqojmiEFFhyDwza5BvVuyOPWDh2SWSVTdZZeTKlwxBh0HnaRh
         Ia5XSoX47shexCoMxkief2uch3ysB1nHxeGmB6nDQcj+kplFcoA+6DFVeseK/oCEgD5A
         8pXn9Mv56lkluCmk6qn3XyoWE3NF71CYK4cR0aNx2xXsZhki3RWNpAkBZrALpvcIhTVi
         J4ikoqYP/RRq5OIN8P0Mv/PvTq+knBuKrej1kRRKNLPm790tSnwLCIDn7wXZABODD/xL
         dzxg==
X-Gm-Message-State: AOAM531QsmPpIDFz4Dw8gToyLetqDjuQdCmAZSX0A1pdmGm1kf9U4hW1
        UWXB24da8iIENdkJ/ZZacuiP2xLKSMM=
X-Google-Smtp-Source: ABdhPJzeS8ODMoVcB2Td1qmFvzli4Qu6qiuqsm8yD/MVv9hQxKPCm02OK7atVsv3hVZ3kWH8oFEqog==
X-Received: by 2002:a05:622a:170e:: with SMTP id h14mr3129505qtk.287.1618496092890;
        Thu, 15 Apr 2021 07:14:52 -0700 (PDT)
Received: from localhost.localdomain (c-73-60-226-25.hsd1.nh.comcast.net. [73.60.226.25])
        by smtp.gmail.com with ESMTPSA id q198sm2076083qke.3.2021.04.15.07.14.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 07:14:52 -0700 (PDT)
Date:   Thu, 15 Apr 2021 10:14:50 -0400
From:   Eric Whitney <enwlinux@gmail.com>
To:     Jan Kara <jack@suse.cz>
Cc:     Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Eric Whitney <enwlinux@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] ext4: Fix occasional generic/418 failure
Message-ID: <20210415141450.GA12301@localhost.localdomain>
References: <20210414131453.4945-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414131453.4945-1-jack@suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Jan Kara <jack@suse.cz>:
> Eric has noticed that after pagecache read rework, generic/418 is
> occasionally failing for ext4 when blocksize < pagesize. In fact, the
> pagecache rework just made hard to hit race in ext4 more likely. The
> problem is that since ext4 conversion of direct IO writes to iomap
> framework (commit 378f32bab371), we update inode size after direct IO
> write only after invalidating page cache. Thus if buffered read sneaks
> at unfortunate moment like:
> 
> CPU1 - write at offset 1k                       CPU2 - read from offset 0
> iomap_dio_rw(..., IOMAP_DIO_FORCE_WAIT);
>                                                 ext4_readpage();
> ext4_handle_inode_extension()
> 
> the read will zero out tail of the page as it still sees smaller inode
> size and thus page cache becomes inconsistent with on-disk contents with
> all the consequences.
> 
> Fix the problem by moving inode size update into end_io handler which
> gets called before the page cache is invalidated.
> 
> Reported-by: Eric Whitney <enwlinux@gmail.com>
> Fixes: 378f32bab371 ("ext4: introduce direct I/O write using iomap infrastructure")
> CC: stable@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/file.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
> 
> Eric, can you please try whether this patch fixes the failures you are
> occasionally seeing?
> 

I applied this patch to 5.12-rc7 and ran tests on two different sets of
hardware using kvm-xfstests.

5000 runs of generic/418 passed on the 1k test configuration without
incident.  On an unmodified -rc7 kernel, I'm typically getting 100-200 failures
for that many runs.  So, that looks good.

After running through all the appliance's test configurations with the
patched kernel, I did see one unexpected failure of generic/068 on
data=journal due to a burst of kernel warnings.  Unexpected means I haven't
seen this failure in recent memory on upstream -rc* regression runs.  A
10 run attempt to reproduce the failure failed to do so.  An instance of the
warning follows.

Thanks,
Eric

[35456.178585] WARNING: CPU: 1 PID: 22225 at fs/ext4/ext4_jbd2.c:75 ext4_journal_check_start+0x4c/0x90
[35456.180802] Modules linked in:
[35456.181554] CPU: 1 PID: 22225 Comm: kworker/u4:0 Not tainted 5.12.0-rc7+ #2
[35456.183169] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
[35456.185030] Workqueue: writeback wb_workfn (flush-254:32)
[35456.186290] RIP: 0010:ext4_journal_check_start+0x4c/0x90
[35456.187540] Code: e1 02 75 24 f6 43 50 01 75 54 83 bb 20 03 00 00 04 74 17 48 8b 92 70 03 00 00 31 c0 48 85 d2 74 07 8b 02 83 e0 02 75 06 5b c3 <0f> 0b eb e5 44 8b 42 08 68 11 23 0f 82 48 89 df 45 31 c9 b9 01 00
[35456.190939] RSP: 0018:ffffc90004167850 EFLAGS: 00010246
[35456.191845] RAX: 00000000fffffffb RBX: ffff888009f76000 RCX: 0000000000000000
[35456.193668] RDX: ffff888009f73000 RSI: ffffffff8235dd60 RDI: ffff888009f76000
[35456.195461] RBP: 0000000000000009 R08: 0000000000000000 R09: ffffffff813c9fd8
[35456.197365] R10: 0000000000000000 R11: 000000000002f6b8 R12: 0000000000000000
[35456.199276] R13: 0000000000000008 R14: 0000000000000002 R15: 0000000000000771
[35456.201080] FS:  0000000000000000(0000) GS:ffff88807dd00000(0000) knlGS:0000000000000000
[35456.202513] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[35456.203521] CR2: 00007f30cf413000 CR3: 0000000001c04006 CR4: 0000000000370ee0
[35456.205554] Call Trace:
[35456.206275]  __ext4_journal_start_sb+0x118/0x180
[35456.207568]  ext4_writepage+0x368/0x740
[35456.209077]  ? _raw_spin_unlock_irqrestore+0x30/0x40
[35456.210638]  ? page_mkclean+0x6e/0xc0
[35456.211899]  ? lock_is_held_type+0x99/0x100
[35456.213341]  __writepage+0x19/0x70
[35456.214614]  write_cache_pages+0x1a6/0x470
[35456.216026]  ? __wb_calc_thresh+0xd0/0xd0
[35456.217617]  generic_writepages+0x59/0x90
[35456.219119]  ? lock_is_held_type+0x99/0x100
[35456.220673]  ? do_writepages+0x41/0xd0
[35456.222038]  ? do_writepages+0x41/0xd0
[35456.223341]  ext4_writepages+0xc40/0x1080
[35456.224750]  ? __lock_acquire+0x3d5/0x2380
[35456.226175]  ? __lock_acquire+0x3d5/0x2380
[35456.227586]  ? do_writepages+0x41/0xd0
[35456.228563]  ? __ext4_mark_inode_dirty+0x280/0x280
[35456.230308]  do_writepages+0x41/0xd0
[35456.231540]  ? lock_is_held_type+0x99/0x100
[35456.233032]  __writeback_single_inode+0x58/0x530
[35456.234542]  writeback_sb_inodes+0x204/0x4d0
[35456.235995]  wb_writeback+0x107/0x430
[35456.237489]  wb_workfn+0xb5/0x5f0
[35456.238645]  ? lock_acquire+0xb5/0x380
[35456.240026]  ? process_one_work+0x223/0x5d0
[35456.241522]  ? lock_is_held_type+0x99/0x100
[35456.243139]  process_one_work+0x2a5/0x5d0
[35456.244615]  ? process_one_work+0x5d0/0x5d0
[35456.246108]  worker_thread+0x2d/0x3c0
[35456.247429]  ? process_one_work+0x5d0/0x5d0
[35456.248926]  kthread+0x127/0x140
[35456.250090]  ? kthread_park+0x80/0x80
[35456.251379]  ret_from_fork+0x22/0x30
[35456.252559] irq event stamp: 4858465
[35456.253785] hardirqs last  enabled at (4858473): [<ffffffff8115ddee>] console_unlock+0x36e/0x550
[35456.256235] hardirqs last disabled at (4858482): [<ffffffff8115de77>] console_unlock+0x3f7/0x550
[35456.259117] softirqs last  enabled at (4858496): [<ffffffff81c00303>] __do_softirq+0x303/0x41a
[35456.261485] softirqs last disabled at (4858491): [<ffffffff810ecade>] irq_exit_rcu+0xae/0xb0
[35456.263742] ---[ end trace ea82423dcfaf8730 ]---


> Changes since v1:
> * Rewritten the fix to avoid the need for separate transaction handle for
>   orphan list update
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 194f5d00fa32..be1e80af61be 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -371,15 +371,27 @@ static ssize_t ext4_handle_inode_extension(struct inode *inode, loff_t offset,
>  static int ext4_dio_write_end_io(struct kiocb *iocb, ssize_t size,
>  				 int error, unsigned int flags)
>  {
> -	loff_t offset = iocb->ki_pos;
> +	loff_t pos = iocb->ki_pos;
>  	struct inode *inode = file_inode(iocb->ki_filp);
>  
>  	if (error)
>  		return error;
>  
> -	if (size && flags & IOMAP_DIO_UNWRITTEN)
> -		return ext4_convert_unwritten_extents(NULL, inode,
> -						      offset, size);
> +	if (size && flags & IOMAP_DIO_UNWRITTEN) {
> +		error = ext4_convert_unwritten_extents(NULL, inode, pos, size);
> +		if (error < 0)
> +			return error;
> +	}
> +	/*
> +	 * If we are extending the file, we have to update i_size here before
> +	 * page cache gets invalidated in iomap_dio_rw(). Otherwise racing
> +	 * buffered reads could zero out too much from page cache pages. Update
> +	 * of on-disk size will happen later in ext4_dio_write_iter() where
> +	 * we have enough information to also perform orphan list handling etc.
> +	 */
> +	pos += size;
> +	if (pos > i_size_read(inode))
> +		i_size_write(inode, pos);
>  
>  	return 0;
>  }
> -- 
> 2.26.2
> 
