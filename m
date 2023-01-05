Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46FFF65F23F
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 18:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235325AbjAERJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 12:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235480AbjAERHs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 12:07:48 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D38671A6
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 09:04:04 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id qk9so91303325ejc.3
        for <stable@vger.kernel.org>; Thu, 05 Jan 2023 09:04:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MR9jrp9JJ/kpbjOGjenIAr4/a8H49suMxzU51oVWeFg=;
        b=xJ1896NWCjScp1fCklVJ7wFOSURl3g6rfJqbLfGNSHxm3/ADdlvVL8TDMuA6cQQOlP
         LmMgBdSXMcwGapGPJByz+/toJ7TaIU6r7JANgi8M9xUX60PRsBWegoDkssjAcEAd7X36
         1Uo8d2kJ6s+4iULgQDrQ82oBWbPtctErv67YusC7lraJloUAgb1tS6BlXaBtz15YpK+z
         nMC3MGpCfBxd/YdERf6bFyXMXUUDtZQyJDo+P5hcUQ+P2d18G/bmdqWzFbjY4wN6NGxR
         mbDo7yKmrI/oKVBjxFuNjwQPPDApWNaeX3ZAU7vYetLjDEsBOKO98KtzA5/Tb8SHL5i3
         EGsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MR9jrp9JJ/kpbjOGjenIAr4/a8H49suMxzU51oVWeFg=;
        b=lq8C3Nm30V+g+rtDYkhENTUYJ1p2rOqN0Rn/9+2yZzCD0QoLTvZVu1FAbXoiWEANDY
         KqafdiD8Dbo700STRraYu8qcrnU9XDEmy/RyeUV9WIPMWyyWp5pqIBCFqs0aBHrRsrb3
         9k05ArTiW67r+S/3/yotSsWGmvv0CgF63y9G5H4Jb9Dm2tX7BK8DWYm+M7nTnL8sFC6K
         +S7Bd/TjkgWIR7+DaAbPP8FsiFAPumXvXnwy74u3K2egxONLFs9BT3ehAYYnL5QlbFyC
         Fuu7zzlN6MBryt6Z7D5fQwzskybzqL1GgSN6S7CKi3bn2ZH/aADpYN6FcclE9pk9Yr0X
         UcQg==
X-Gm-Message-State: AFqh2kqryBbcHRJ1SGlQfwthPjKwb457YOYtF7wlh6IdiZoaW35GiYWC
        8zTH8m4T10rBggM0gj9nKKq0zw==
X-Google-Smtp-Source: AMrXdXtnYXt0GrEq6oLrhDkj82ytyFqpzwGU7RMy6M6L+uY3iZ9U1QwsZ9ZPmTMwv5abulfqB8msJA==
X-Received: by 2002:a17:906:4349:b0:7ba:5085:869 with SMTP id z9-20020a170906434900b007ba50850869mr39630004ejm.9.1672938235518;
        Thu, 05 Jan 2023 09:03:55 -0800 (PST)
Received: from [192.168.0.104] ([82.77.81.242])
        by smtp.gmail.com with ESMTPSA id l22-20020a1709065a9600b00780982d77d1sm16641092ejq.154.2023.01.05.09.03.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Jan 2023 09:03:55 -0800 (PST)
Message-ID: <d438b004-82ed-be25-2afb-0993537587e5@linaro.org>
Date:   Thu, 5 Jan 2023 19:03:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: FAILED: patch "[PATCH] ext4: fix kernel BUG in
 'ext4_write_inline_data_end()'" failed to apply to 5.10-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org, yebin10@huawei.com, jun.nie@linaro.org,
        tytso@mit.edu
Cc:     stable@vger.kernel.org, linux-ext4@vger.kernel.org,
        joneslee@google.com
References: <16728448721370@kroah.com>
From:   Tudor Ambarus <tudor.ambarus@linaro.org>
In-Reply-To: <16728448721370@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 04.01.2023 17:07, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> Possible dependencies:
> 
> 5c099c4fdc43 ("ext4: fix kernel BUG in 'ext4_write_inline_data_end()'")
> 6984aef59814 ("ext4: factor out write end code of inline file")
> 55ce2f649b9e ("ext4: correct the error path of ext4_write_inline_data_end()")
> 4df031ff5876 ("ext4: check and update i_disksize properly")
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
>>From 5c099c4fdc438014d5893629e70a8ba934433ee8 Mon Sep 17 00:00:00 2001
> From: Ye Bin <yebin10@huawei.com>
> Date: Tue, 6 Dec 2022 22:41:34 +0800
> Subject: [PATCH] ext4: fix kernel BUG in 'ext4_write_inline_data_end()'
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
>   <TASK>
>   ext4_write_inline_data_end+0x2a3/0x12f0 fs/ext4/inline.c:768
>   ext4_write_end+0x242/0xdd0 fs/ext4/inode.c:1313
>   ext4_da_write_end+0x3ed/0xa30 fs/ext4/inode.c:3063
>   generic_perform_write+0x316/0x570 mm/filemap.c:3764
>   ext4_buffered_write_iter+0x15b/0x460 fs/ext4/file.c:285
>   ext4_file_write_iter+0x8bc/0x16e0 fs/ext4/file.c:700
>   call_write_iter include/linux/fs.h:2191 [inline]
>   do_iter_readv_writev+0x20b/0x3b0 fs/read_write.c:735
>   do_iter_write+0x182/0x700 fs/read_write.c:861
>   vfs_iter_write+0x74/0xa0 fs/read_write.c:902
>   iter_file_splice_write+0x745/0xc90 fs/splice.c:686
>   do_splice_from fs/splice.c:764 [inline]
>   direct_splice_actor+0x114/0x180 fs/splice.c:931
>   splice_direct_to_actor+0x335/0x8a0 fs/splice.c:886
>   do_splice_direct+0x1ab/0x280 fs/splice.c:974
>   do_sendfile+0xb19/0x1270 fs/read_write.c:1255
>   __do_sys_sendfile64 fs/read_write.c:1323 [inline]
>   __se_sys_sendfile64 fs/read_write.c:1309 [inline]
>   __x64_sys_sendfile64+0x1d0/0x210 fs/read_write.c:1309
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> ---[ end trace 0000000000000000 ]---
> 
> Above issue may happens as follows:
> ext4_da_write_begin
>    ext4_da_write_inline_data_begin
>      ext4_da_convert_inline_data_to_extent
>        ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
> ext4_da_write_end
> 
> ext4_run_li_request
>    ext4_mb_prefetch
>      ext4_read_block_bitmap_nowait
>        ext4_validate_block_bitmap
>          ext4_mark_group_bitmap_corrupted(sb, block_group, EXT4_GROUP_INFO_BBITMAP_CORRUPT)
> 	 percpu_counter_sub(&sbi->s_freeclusters_counter,grp->bb_free);
> 	  -> sbi->s_freeclusters_counter become zero
> ext4_da_write_begin
>    if (ext4_nonda_switch(inode->i_sb)) -> As freeclusters_counter is zero will return true
>      *fsdata = (void *)FALL_BACK_TO_NONDELALLOC;
>      ext4_write_begin
> ext4_da_write_end
>    if (write_mode == FALL_BACK_TO_NONDELALLOC)
>      ext4_write_end
>        if (inline_data)
>          ext4_write_inline_data_end
> 	  ext4_write_inline_data
> 	    BUG_ON(pos + len > EXT4_I(inode)->i_inline_size);
>             -> As inode is already convert to extent, so 'pos + len' > inline_size
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
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 181bc161b1ac..a0f4d4197a0b 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1315,7 +1315,8 @@ static int ext4_write_end(struct file *file,
>   
>   	trace_ext4_write_end(inode, pos, len, copied);
>   
> -	if (ext4_has_inline_data(inode))
> +	if (ext4_has_inline_data(inode) &&
> +	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
>   		return ext4_write_inline_data_end(inode, pos, len, copied, page);
>   
>   	copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);
> 
> 

For linux-5.10.y we may do the following:

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 192952f14a6e..d45230f6d942 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1300,7 +1300,8 @@ static int ext4_write_end(struct file *file,

         trace_android_fs_datawrite_end(inode, pos, len);
         trace_ext4_write_end(inode, pos, len, copied);
-       if (inline_data) {
+       if (inline_data &&
+           ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
                 ret = ext4_write_inline_data_end(inode, pos, len,
                                                  copied, page);
                 if (ret < 0) {

But I'll need a confirmation from Ye or Ted, as I'm not familiar with
ext4 for now. You'll notice that this change will fork from what's
currently available in mainline. If we want the same look and feel as in
mainline we should at least backport the following commit:
6984aef59814 ("ext4: factor out write end code of inline file")
But this one conflicts with:
a54c4613dac1 ext4: fix race writing to an inline_data file while its 
xattrs are changing
which seems it  was solved by Ted in a merge:
*   11ef08c9eb52 Merge branch 'delalloc-buffer-write' into dev
|\
| * cc883236b792 ext4: drop unnecessary journal handle in delalloc write
| * 6984aef59814 ext4: factor out write end code of inline file
| * 55ce2f649b9e ext4: correct the error path of 
ext4_write_inline_data_end()
| * 4df031ff5876 ext4: check and update i_disksize properly
* | 1fd95c05d8f7 ext4: add error checking to ext4_ext_replay_set_iblocks()
* | baaae979b112 ext4: make the updating inode data procedure atomic
* | 8e33fadf945a ext4: remove an unnecessary if statement in 
__ext4_get_inode_loc()
* | 0904c9ae3465 ext4: move inode eio simulation behind io completeion
* | 4a79a98c7b19 ext4: Improve scalability of ext4 orphan file handling
* | 3a6541e97c03 ext4: Orphan file documentation
* | 02f310fcf47f ext4: Speedup ext4 orphan inode handling
* | 25c6d98fc4c2 ext4: Move orphan inode handling into a separate file
* | 188c299e2a26 ext4: Support for checksumming from journal triggers
* | a54c4613dac1 ext4: fix race writing to an inline_data file while its 
xattrs are changing
|/
* b33d9f5909c8 jbd2: add sparse annotations for add_transaction_credits()
* a5fda1133818 ext4: fix sparse warnings

So I would choose the fork if we want the fix in, but let's see what you
guys think.

Thanks!
ta
