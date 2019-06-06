Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF3A36E14
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 10:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbfFFIE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 04:04:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:57392 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725769AbfFFIE6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Jun 2019 04:04:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CD3DDACD9;
        Thu,  6 Jun 2019 08:04:55 +0000 (UTC)
Subject: Re: [PATCH] btrfs: fix out-of-bounds access in property handling
To:     Naohiro Aota <naohiro.aota@wdc.com>, linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>, stable@vger.kernel.org
References: <20190606074925.12375-1-naohiro.aota@wdc.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <3d3e1b3f-c36b-88e4-7e13-6dab29404a19@suse.com>
Date:   Thu, 6 Jun 2019 11:04:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190606074925.12375-1-naohiro.aota@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 6.06.19 г. 10:49 ч., Naohiro Aota wrote:
> xattr value is not NULL-terminated string. When you specify "lz" as the
> property value, strncmp("lzo", value, 3) will try to read one byte after
> the value buffer, causing the following OOB access. Fix this out-of-bound
> by explicitly check the required length.
> 
> [ 1519.998589] ==================================================================
> [ 1520.007505] BUG: KASAN: slab-out-of-bounds in strncmp+0xab/0xc0
> [ 1520.015116] Read of size 1 at addr ffff8886daec16c2 by task btrfs/15317
> 
> [ 1520.026628] CPU: 4 PID: 15317 Comm: btrfs Not tainted 5.1.0-rc7+ #3
> [ 1520.034635] Hardware name: Supermicro X10SLL-F/X10SLL-F, BIOS 3.0 04/24/2015
> [ 1520.043416] Call Trace:
> [ 1520.047562]  dump_stack+0x71/0xa0
> [ 1520.052584]  print_address_description+0x65/0x229
> [ 1520.058997]  ? strncmp+0xab/0xc0
> [ 1520.063929]  ? strncmp+0xab/0xc0
> [ 1520.068834]  kasan_report.cold+0x1a/0x38
> [ 1520.074439]  ? strncmp+0xab/0xc0
> [ 1520.079343]  strncmp+0xab/0xc0
> [ 1520.084110]  prop_compression_validate+0x22/0x70 [btrfs]
> [ 1520.091135]  btrfs_xattr_handler_set_prop+0x6c/0x1f0 [btrfs]
> [ 1520.098452]  __vfs_setxattr+0xd8/0x130
> [ 1520.103821]  ? xattr_resolve_name+0x3e0/0x3e0
> [ 1520.109812]  __vfs_setxattr_noperm+0xeb/0x3b0
> [ 1520.115790]  vfs_setxattr+0xa3/0xd0
> [ 1520.120898]  setxattr+0x17a/0x2c0
> [ 1520.125824]  ? vfs_setxattr+0xd0/0xd0
> [ 1520.131102]  ? __pmd_alloc+0x560/0x560
> [ 1520.136452]  ? __do_sys_newfstat+0xd3/0xe0
> [ 1520.142123]  ? __ia32_sys_newfstatat+0xf0/0xf0
> [ 1520.148140]  ? __kasan_slab_free+0x141/0x170
> [ 1520.153955]  ? handle_mm_fault+0x1ae/0x640
> [ 1520.159564]  __x64_sys_fsetxattr+0x1a0/0x220
> [ 1520.165347]  do_syscall_64+0xa0/0x2e0
> [ 1520.170515]  ? page_fault+0x8/0x30
> [ 1520.175408]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [ 1520.181975] RIP: 0033:0x7f84f257ae6e
> [ 1520.187068] Code: 48 8b 0d 1d 70 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 be 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d ea 6f 0c 00 f7 d8 64 89 01 48
> [ 1520.209083] RSP: 002b:00007fff87996fa8 EFLAGS: 00000246 ORIG_RAX: 00000000000000be
> [ 1520.218336] RAX: ffffffffffffffda RBX: 000000000000000b RCX: 00007f84f257ae6e
> [ 1520.227132] RDX: 00007fff8799798b RSI: 00005561caf83270 RDI: 0000000000000003
> [ 1520.235912] RBP: 00007fff8799798b R08: 0000000000000000 R09: 00005561caf83290
> [ 1520.244691] R10: 0000000000000002 R11: 0000000000000246 R12: 00005561caf83270
> [ 1520.253462] R13: 0000000000000003 R14: 00007fff87997972 R15: 00007fff8799797f
> 
> [ 1520.265443] Allocated by task 15317:
> [ 1520.270697]  __kasan_kmalloc.constprop.0+0xc2/0xd0
> [ 1520.277677]  setxattr+0xe8/0x2c0
> [ 1520.283084]  __x64_sys_fsetxattr+0x1a0/0x220
> [ 1520.289540]  do_syscall_64+0xa0/0x2e0
> [ 1520.295379]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> [ 1520.306288] Freed by task 12227:
> [ 1520.311632]  __kasan_slab_free+0x12c/0x170
> [ 1520.317828]  kfree+0x90/0x1e0
> [ 1520.322891]  btrfs_free_block_groups+0x8a1/0xd80 [btrfs]
> [ 1520.330313]  close_ctree+0x37e/0x650 [btrfs]
> [ 1520.336627]  generic_shutdown_super+0x12e/0x320
> [ 1520.343177]  kill_anon_super+0x36/0x60
> [ 1520.348983]  btrfs_kill_super+0x3d/0x2c0 [btrfs]
> [ 1520.355636]  deactivate_locked_super+0x85/0xd0
> [ 1520.362108]  deactivate_super+0x122/0x140
> [ 1520.368166]  cleanup_mnt+0x9f/0x130
> [ 1520.373699]  task_work_run+0x131/0x1c0
> [ 1520.379490]  exit_to_usermode_loop+0x133/0x160
> [ 1520.386002]  do_syscall_64+0x259/0x2e0
> [ 1520.391796]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> [ 1520.402415] The buggy address belongs to the object at ffff8886daec16c0
>                 which belongs to the cache kmalloc-8 of size 8
> [ 1520.418769] The buggy address is located 2 bytes inside of
>                 8-byte region [ffff8886daec16c0, ffff8886daec16c8)
> [ 1520.434407] The buggy address belongs to the page:
> [ 1520.441358] page:ffffea001b6bb040 count:1 mapcount:0 mapping:ffff8886ff40fb80 index:0x0
> [ 1520.451601] flags: 0x17ffe000000200(slab)
> [ 1520.457868] raw: 0017ffe000000200 ffffea001bedcec0 0000000700000007 ffff8886ff40fb80
> [ 1520.467940] raw: 0000000000000000 0000000080aa00aa 00000001ffffffff 0000000000000000
> [ 1520.478024] page dumped because: kasan: bad access detected
> 
> [ 1520.489795] Memory state around the buggy address:
> [ 1520.496963]  ffff8886daec1580: fc 00 fc fc 00 fc fc 00 fc fc 00 fc fc 00 fc fc
> [ 1520.506621]  ffff8886daec1600: 00 fc fc 04 fc fc fb fc fc fb fc fc fb fc fc fb
> [ 1520.516277] >ffff8886daec1680: fc fc 04 fc fc 00 fc fc 02 fc fc fb fc fc 00 fc
> [ 1520.525915]                                            ^
> [ 1520.533584]  ffff8886daec1700: fc 00 fc fc 00 fc fc 00 fc fc 00 fc fc 04 fc fc
> [ 1520.543137]  ffff8886daec1780: fb fc fc 00 fc fc 00 fc fc 00 fc fc 00 fc fc 00
> [ 1520.552642] ==================================================================
> 
> Fixes: 272e5326c783 ("btrfs: prop: fix vanished compression property after failed set")
> Fixes: 50398fde997f ("btrfs: prop: fix zstd compression parameter validation")
> Cc: stable@vger.kernel.org # 4.14+: 802a5c69584a: btrfs: prop: use common helper for type to string conversion
> Cc: stable@vger.kernel.org # 4.14+: 3dcf96c7b9fe: btrfs: drop redundant forward declaration in props.c
> Cc: stable@vger.kernel.org # 4.14+
> Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>

We caught that one yesterday and were testing various fixes for it
Johannes just sent his version which IMO makes the code a bit more
maintainable.


> ---
>  fs/btrfs/props.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
> index a9e2e66152ee..428141bf545d 100644
> --- a/fs/btrfs/props.c
> +++ b/fs/btrfs/props.c
> @@ -257,11 +257,11 @@ static int prop_compression_validate(const char *value, size_t len)
>  	if (!value)
>  		return 0;
>  
> -	if (!strncmp("lzo", value, 3))
> +	if (len >= 3 && !strncmp("lzo", value, 3))
>  		return 0;
> -	else if (!strncmp("zlib", value, 4))
> +	else if (len >= 4 && !strncmp("zlib", value, 4))
>  		return 0;
> -	else if (!strncmp("zstd", value, 4))
> +	else if (len >= 4 && !strncmp("zstd", value, 4))
>  		return 0;
>  
>  	return -EINVAL;
> @@ -281,12 +281,12 @@ static int prop_compression_apply(struct inode *inode, const char *value,
>  		return 0;
>  	}
>  
> -	if (!strncmp("lzo", value, 3)) {
> +	if (len >= 3 && !strncmp("lzo", value, 3)) {
>  		type = BTRFS_COMPRESS_LZO;
>  		btrfs_set_fs_incompat(fs_info, COMPRESS_LZO);
> -	} else if (!strncmp("zlib", value, 4)) {
> +	} else if (len >= 4 && !strncmp("zlib", value, 4)) {
>  		type = BTRFS_COMPRESS_ZLIB;
> -	} else if (!strncmp("zstd", value, 4)) {
> +	} else if (len >= 4 && !strncmp("zstd", value, 4)) {
>  		type = BTRFS_COMPRESS_ZSTD;
>  		btrfs_set_fs_incompat(fs_info, COMPRESS_ZSTD);
>  	} else {

This seems redundant as ->validates is supposed to always be called
before calling ->apply.

> 
