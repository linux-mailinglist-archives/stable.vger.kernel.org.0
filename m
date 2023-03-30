Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55BBD6D039E
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 13:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbjC3Ln6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 07:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbjC3Lnk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 07:43:40 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D1BAF15
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 04:43:19 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id cn12so75276805edb.4
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 04:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680176550;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JieTrdgd7KjSCTz0uvG3ksT4LnCNnOH7vY9tsofvCls=;
        b=rXeHbNc+KtyOXSo/wFqnMJctnu3+6PJ5KNbZHYcZTMi9nYkMoHRDNSFHVrA/9C05+X
         7+GGv6wI5+ah+Bw3GBwFlimeSc9jLfw/TFU+6nKqbDzVxKDijgZ8zVFYliV5nyEk9+Rx
         7jnYLr46yfLyIeL955SFne3T0H0xXGiqQVrVfOWp6q2UjFbdduM1o84Exw9pcDwj3gP3
         2hSL+9WH4AeK1cg6qBZAlVklYHh0Z9rqi6QXUWUtGihWJGkd+N1twpNBWsVySPoSSZWB
         ivFHeqSKgBcSgrD02IS7LRqw65lOrpHwrqWqKsOKcIbTalhI9jXk1Oa5BYp00X41CLtR
         x1eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680176550;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JieTrdgd7KjSCTz0uvG3ksT4LnCNnOH7vY9tsofvCls=;
        b=AkTcZObVocYnj5fiwRgdVZVp7Tf2Qj73VF/XYBcvantPONYozn0cXCTqndNddMgbk3
         jMom4e9EUx+mTJZ9Wn4AyqUPqA5n38GnDNb3EDVAeAXrlXbp4MsnCjRrVq0EPO2eXVQJ
         KzkehbVGrsOFYjnoZHWTbfgQ98LLL4W5wRGXmP5cH6dvPrWZA4SNrenIqMJuF6mpXM2B
         JU8vac/LzGFIG5OsPX4NfbxBTth2AZ7p2KHZ1iHWftCa8uWArZKCS/ZYOyzHbsZsX7GF
         fYMgcuVCksqarOKiTcf30K0Ih9Gf4aDIMv8JT7imRQ47ZsL78KPhWEqcuV+rvySCEHjM
         6j+Q==
X-Gm-Message-State: AAQBX9d/0E+B0J7kOED5eZ5bimG2Ti7gMlfge7JWgmyI6tCaP45zkCHp
        Pwwk/Rbn4BV6NxQ9vAMA1S1+PQ==
X-Google-Smtp-Source: AKy350ZQHDwhL4C6KA+gPVLErVvuzse3p7twBpwjNy63tvo3Gg6WWWMYlSqs/dGLe4WgjLW2Xr38iQ==
X-Received: by 2002:a17:906:608f:b0:877:573d:e919 with SMTP id t15-20020a170906608f00b00877573de919mr21978119ejj.20.1680176549959;
        Thu, 30 Mar 2023 04:42:29 -0700 (PDT)
Received: from [192.168.2.107] ([79.115.63.91])
        by smtp.gmail.com with ESMTPSA id be13-20020a1709070a4d00b009473bbe5f7dsm887707ejc.208.2023.03.30.04.42.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Mar 2023 04:42:29 -0700 (PDT)
Message-ID: <42739df1-8b63-dfd6-6ec5-6c59d5d41dd8@linaro.org>
Date:   Thu, 30 Mar 2023 12:42:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH RESEND][for-stable 5.10, 5.4, 4.19, 4.14] ext4: fix kernel
 BUG in 'ext4_write_inline_data_end()'
Content-Language: en-US
To:     stable@kernel.org, stable@vger.kernel.org
Cc:     tytso@mit.edu, adilger.kernel@dilger.ca, boyu.mt@taobao.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        leejones@google.com, Ye Bin <yebin10@huawei.com>,
        syzbot+4faa160fa96bfba639f8@syzkaller.appspotmail.com,
        Jun Nie <jun.nie@linaro.org>
References: <20230307103840.2603092-1-tudor.ambarus@linaro.org>
From:   Tudor Ambarus <tudor.ambarus@linaro.org>
In-Reply-To: <20230307103840.2603092-1-tudor.ambarus@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+ stable@vger.kernel.org

Hi!

Can we queue this to Linux stable, please?

Thanks,
ta

On 3/7/23 10:38, Tudor Ambarus wrote:
> From: Ye Bin <yebin10@huawei.com>
> 
> [ Upstream commit 5c099c4fdc438014d5893629e70a8ba934433ee8 ]
> 
> tudor.ambarus@linaro.org: The patch deviates from original upstream
> patch, as it had to be backported. Backport this 3 line patch instead
> of carring it's dependency:
> 'commit 6984aef59814 ("ext4: factor out write end code of inline file")'
> The dependency conflicts with
> 'commit a54c4613dac1 ("ext4: fix race writing to an inline_data file while its xattrs are changing")'
> and was fixed in:
> 'commit 11ef08c9eb52 ("Merge branch 'delalloc-buffer-write' into dev")'
> Even if backporting the dependency is straight forward (keep the
> contents of the second patch together with the changes from the first)
> choose to backport just the fix as the refactoring patch brings little
> benefit and high risk. Tested the fix with the reproducer and it no longer
> complains on linux-{5.10, 5.4, 4.19, 4.14}.y. The original upstream commit
> message follows below.
> 
> Syzbot report follow issue:
> ------------[ cut here ]------------
> kernel BUG at fs/ext4/inline.c:227!
> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> CPU: 1 PID: 3629 Comm: syz-executor212 Not tainted 6.1.0-rc5-syzkaller-00018-g59d0d52c30d4 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> RIP: 0010:ext4_write_inline_data+0x344/0x3e0 fs/ext4/inline.c:227
> RSP: 0018:ffffc90003b3f368 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffff8880704e16c0 RCX: 0000000000000000
> RDX: ffff888021763a80 RSI: ffffffff821e31a4 RDI: 0000000000000006
> RBP: 000000000006818e R08: 0000000000000006 R09: 0000000000068199
> R10: 0000000000000079 R11: 0000000000000000 R12: 000000000000000b
> R13: 0000000000068199 R14: ffffc90003b3f408 R15: ffff8880704e1c82
> FS:  000055555723e3c0(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fffe8ac9080 CR3: 0000000079f81000 CR4: 0000000000350ee0
> Call Trace:
>  <TASK>
>  ext4_write_inline_data_end+0x2a3/0x12f0 fs/ext4/inline.c:768
>  ext4_write_end+0x242/0xdd0 fs/ext4/inode.c:1313
>  ext4_da_write_end+0x3ed/0xa30 fs/ext4/inode.c:3063
>  generic_perform_write+0x316/0x570 mm/filemap.c:3764
>  ext4_buffered_write_iter+0x15b/0x460 fs/ext4/file.c:285
>  ext4_file_write_iter+0x8bc/0x16e0 fs/ext4/file.c:700
>  call_write_iter include/linux/fs.h:2191 [inline]
>  do_iter_readv_writev+0x20b/0x3b0 fs/read_write.c:735
>  do_iter_write+0x182/0x700 fs/read_write.c:861
>  vfs_iter_write+0x74/0xa0 fs/read_write.c:902
>  iter_file_splice_write+0x745/0xc90 fs/splice.c:686
>  do_splice_from fs/splice.c:764 [inline]
>  direct_splice_actor+0x114/0x180 fs/splice.c:931
>  splice_direct_to_actor+0x335/0x8a0 fs/splice.c:886
>  do_splice_direct+0x1ab/0x280 fs/splice.c:974
>  do_sendfile+0xb19/0x1270 fs/read_write.c:1255
>  __do_sys_sendfile64 fs/read_write.c:1323 [inline]
>  __se_sys_sendfile64 fs/read_write.c:1309 [inline]
>  __x64_sys_sendfile64+0x1d0/0x210 fs/read_write.c:1309
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> ---[ end trace 0000000000000000 ]---
> 
> Above issue may happens as follows:
> ext4_da_write_begin
>   ext4_da_write_inline_data_begin
>     ext4_da_convert_inline_data_to_extent
>       ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
> ext4_da_write_end
> 
> ext4_run_li_request
>   ext4_mb_prefetch
>     ext4_read_block_bitmap_nowait
>       ext4_validate_block_bitmap
>         ext4_mark_group_bitmap_corrupted(sb, block_group, EXT4_GROUP_INFO_BBITMAP_CORRUPT)
> 	 percpu_counter_sub(&sbi->s_freeclusters_counter,grp->bb_free);
> 	  -> sbi->s_freeclusters_counter become zero
> ext4_da_write_begin
>   if (ext4_nonda_switch(inode->i_sb)) -> As freeclusters_counter is zero will return true
>     *fsdata = (void *)FALL_BACK_TO_NONDELALLOC;
>     ext4_write_begin
> ext4_da_write_end
>   if (write_mode == FALL_BACK_TO_NONDELALLOC)
>     ext4_write_end
>       if (inline_data)
>         ext4_write_inline_data_end
> 	  ext4_write_inline_data
> 	    BUG_ON(pos + len > EXT4_I(inode)->i_inline_size);
>            -> As inode is already convert to extent, so 'pos + len' > inline_size
> 	   -> then trigger BUG.
> 
> To solve this issue, instead of checking ext4_has_inline_data() which
> is only cleared after data has been written back, check the
> EXT4_STATE_MAY_INLINE_DATA flag in ext4_write_end().
> 
> Fixes: f19d5870cbf7 ("ext4: add normal write support for inline data")
> Reported-by: syzbot+4faa160fa96bfba639f8@syzkaller.appspotmail.com
> Reported-by: Jun Nie <jun.nie@linaro.org>
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> Link: https://lore.kernel.org/r/20221206144134.1919987-1-yebin@huaweicloud.com
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: stable@kernel.org
> Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
> ---
> For RESEND I put stable@kernel.org in To:
> 
>  fs/ext4/inode.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 355343cf4609..7ac3fa2863c7 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1303,7 +1303,8 @@ static int ext4_write_end(struct file *file,
>  	bool verity = ext4_verity_in_progress(inode);
>  
>  	trace_ext4_write_end(inode, pos, len, copied);
> -	if (inline_data) {
> +	if (inline_data &&
> +	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
>  		ret = ext4_write_inline_data_end(inode, pos, len,
>  						 copied, page);
>  		if (ret < 0) {
